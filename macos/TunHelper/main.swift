import Foundation
import Security
import os.log

// MARK: - 身份常量(改 id 只动这里)
//
// ⚠️ Sam 定夺点 #1(见 runbook):Release App 实际签名 identifier = "com.voguesly.app"
//    (macos/Runner/Configs/AppInfo.xcconfig 的 PRODUCT_BUNDLE_IDENTIFIER),
//    并非任务里写的 "com.follow.clash"(那是 Android/constant.dart 的 packageName)。
//    helper 校验 caller 必须用 App 的**真实**签名 identifier,否则会把真 App 拒之门外。
//    若日后把 App bundle id 改成别的,这里的 kAppRequirement 要同步改。
enum HelperID {
    /// helper 自己的 Mach service 名(= plist Label = plist 文件名去掉 .plist)。
    static let machServiceName = "com.follow.clash.tunhelper"
    /// helper 版本串,ping 用来确认通道打通。
    static let version = "tunhelper/1.0.0"
}

/// caller(App)必须满足的代码签名要求 —— 只有 Team 236T6T3629 签名、identifier 为真实 App id 的进程能调 helper。
/// 防「别的进程连上来白嫖 root 提权」。
private let kAppRequirement =
    "identifier \"com.voguesly.app\" and anchor apple generic and certificate leaf[subject.OU] = \"236T6T3629\""

/// 目标核心二进制必须满足的代码签名要求 —— 只认本 team(236T6T3629)+ Apple 锚。
/// 纵深防线:即便 corePath 被影响,也只有本家签名的核心能被抬到 setuid-root(堵 confused-deputy)。
/// 不钉 identifier:核心二进制的签名 identifier(FlClashCore 之类)可能随构建变,team 锚已足够。
private let kCoreRequirement =
    "anchor apple generic and certificate leaf[subject.OU] = \"236T6T3629\""

private let log = OSLog(subsystem: HelperID.machServiceName, category: "helper")

// MARK: - corePath 校验
//
// 只允许给「装进 /Applications 的 .app 里的核心」提权,挡任意路径提权(如 /tmp 里的恶意二进制)。
private func validateCorePath(_ raw: String) -> (URL?, String?) {
    if raw.isEmpty {
        return (nil, "empty corePath")
    }
    // 解析符号链接 + 规范化,防 ".." / symlink 绕过前缀检查。
    let url = URL(fileURLWithPath: raw).resolvingSymlinksInPath().standardizedFileURL
    let path = url.path
    if path.contains("..") {
        return (nil, "corePath contains ..")
    }
    // 必须在 /Applications/<something>.app/Contents/ 下。
    guard path.hasPrefix("/Applications/"), path.contains(".app/Contents/") else {
        return (nil, "corePath must live under /Applications/*.app/Contents/, got: \(path)")
    }
    // 必须真实存在且是普通文件(非目录/非符号链接)。
    var isDir: ObjCBool = false
    guard FileManager.default.fileExists(atPath: path, isDirectory: &isDir), !isDir.boolValue else {
        return (nil, "corePath not a regular file: \(path)")
    }
    return (url, nil)
}

// MARK: - 目标代码签名校验(confused-deputy 纵深防线)
//
// 只有本 team 签名的核心二进制才允许被抬 setuid-root。用 SecStaticCode 校验 kCoreRequirement。
private func verifyCoreSignature(_ url: URL) -> String? {
    var staticCode: SecStaticCode?
    let createStatus = SecStaticCodeCreateWithPath(url as CFURL, [], &staticCode)
    guard createStatus == errSecSuccess, let code = staticCode else {
        return "SecStaticCodeCreateWithPath failed: \(createStatus)"
    }
    var requirement: SecRequirement?
    let reqStatus = SecRequirementCreateWithString(kCoreRequirement as CFString, [], &requirement)
    guard reqStatus == errSecSuccess, let req = requirement else {
        return "SecRequirementCreateWithString failed: \(reqStatus)"
    }
    // flags = [](不做吊销联网检查,避免离线/内网卡住);只校静态签名满足 team 要求。
    let checkStatus = SecStaticCodeCheckValidityWithErrors(code, [], req, nil)
    guard checkStatus == errSecSuccess else {
        return "core signature check failed (not team 236T6T3629?): \(checkStatus)"
    }
    return nil
}

// MARK: - setuid 落地(fd-based 原子化,消除 TOCTOU/symlink)
//
// 关键:校验与落地都钉在同一个 inode-pinned fd 上,攻击者即便在 check→use 之间换文件/换 symlink,
// 也改不到我们已 open 的 inode。
private func applySetuid(_ url: URL) -> String? {
    let path = url.path
    // ① O_NOFOLLOW 拒末段 symlink;O_CLOEXEC 防 fd 泄漏。open 成功即把 inode 钉死。
    let fd = open(path, O_RDONLY | O_NOFOLLOW | O_CLOEXEC)
    if fd < 0 {
        return "open(O_NOFOLLOW) failed: \(String(cString: strerror(errno)))"
    }
    defer { close(fd) }
    // ② fstat 校验必须是普通文件(非目录/设备/socket 等)。
    var st = stat()
    if fstat(fd, &st) != 0 {
        return "fstat failed: \(String(cString: strerror(errno)))"
    }
    if (st.st_mode & mode_t(S_IFMT)) != mode_t(S_IFREG) {
        return "not a regular file"
    }
    let pinnedDev = st.st_dev
    let pinnedIno = st.st_ino
    // ③ 目标签名校验(team 236T6T3629)——只有本家核心可被提权。
    if let sigErr = verifyCoreSignature(url) {
        return sigErr
    }
    // ④ 复核 path 仍指向被钉死的 inode(收窄「签名校验用路径 vs fd」之间的 TOCTOU 窗口);
    //    fchown/fchmod 作用于 fd,即便此刻 path 被换,提权也只落在我们校验过的 inode 上。
    var lst = stat()
    if lstat(path, &lst) != 0 {
        return "lstat recheck failed: \(String(cString: strerror(errno)))"
    }
    if lst.st_dev != pinnedDev || lst.st_ino != pinnedIno {
        return "path inode changed between check and use"
    }
    // ⑤ 对 inode-pinned fd 做 fchown + fchmod(TOCTOU-free)。
    let adminGid: gid_t = getgrnam("admin")?.pointee.gr_gid ?? 80
    if fchown(fd, 0, adminGid) != 0 {
        return "fchown failed: \(String(cString: strerror(errno)))"
    }
    // 04755 = rwsr-xr-x:owner setuid + 全体可执行。与旧 osascript `chmod +sx` 行为一致,
    // 且满足 Dart 侧 checkIsAdmin 对 "root:admin" + "rws" 的判定。
    let mode: mode_t = mode_t(S_ISUID) | mode_t(0o755)
    if fchmod(fd, mode) != 0 {
        return "fchmod failed: \(String(cString: strerror(errno)))"
    }
    return nil
}

// MARK: - XPC service 实现
final class TunHelper: NSObject, TunHelperProtocol {
    func ensureCoreSetuid(_ corePath: String, withReply reply: @escaping (Bool, String?) -> Void) {
        let (url, err) = validateCorePath(corePath)
        guard let url = url else {
            os_log("ensureCoreSetuid rejected: %{public}@", log: log, type: .error, err ?? "unknown")
            reply(false, err)
            return
        }
        if let applyErr = applySetuid(url) {
            os_log("ensureCoreSetuid apply failed: %{public}@", log: log, type: .error, applyErr)
            reply(false, applyErr)
            return
        }
        os_log("ensureCoreSetuid ok: %{public}@", log: log, type: .info, url.path)
        reply(true, nil)
    }

    func ping(withReply reply: @escaping (String) -> Void) {
        reply(HelperID.version)
    }
}

// MARK: - XPC listener delegate
final class HelperDelegate: NSObject, NSXPCListenerDelegate {
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection conn: NSXPCConnection) -> Bool {
        // ① 校验 caller 代码签名要求。setCodeSigningRequirement 非 throwing(void,macOS 13+):
        //    它把要求挂到连接上,之后**任何不满足要求的 peer 发来的消息都会被系统丢弃 + 连接 invalidate**,
        //    消息永远到不了 exportedObject。故只需设好要求再接受连接即可。
        if #available(macOS 13.0, *) {
            conn.setCodeSigningRequirement(kAppRequirement)
        } else {
            // 部署目标 = macOS 13+,理论到不了这里;保守拒绝。
            os_log("reject connection: pre-macOS13 unsupported", log: log, type: .error)
            return false
        }
        // ② 绑定协议与实现对象。
        conn.exportedInterface = NSXPCInterface(with: TunHelperProtocol.self)
        conn.exportedObject = TunHelper()
        conn.resume()
        os_log("accepted connection", log: log, type: .info)
        return true
    }
}

// MARK: - 入口
let delegate = HelperDelegate()
let listener = NSXPCListener(machServiceName: HelperID.machServiceName)
listener.delegate = delegate
os_log("tunhelper starting on %{public}@", log: log, type: .info, HelperID.machServiceName)
listener.resume()
// LaunchDaemon 常驻;RunLoop 保活直到 launchd 回收。
RunLoop.current.run()
