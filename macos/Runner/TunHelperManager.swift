import Foundation
import FlutterMacOS
import ServiceManagement
import os.log

/// App 侧 TUN 提权 helper 管理器。
///
/// 职责:
///   - 用 SMAppService.daemon 注册 / 反注册 / 查询那个 root LaunchDaemon(macOS 13+)。
///   - 经 NSXPCConnection 连 helper 的 Mach service,调 `ensureCoreSetuid` 给核心打 setuid。
///   - 对连接设 remote code-signing requirement,确保只跟**正版 helper**通话(防中间人/伪冒 Mach service)。
///   - 暴露 MethodChannel `voguesly/tunhelper` 给 Dart 侧(register / status / ensureSetuid / unregister)。
///
/// 与现有 `launch_at_startup`(MainFlutterWindow.swift)一致:由 window controller 在 awakeFromNib 里
/// 调 `TunHelperManager.register(with:)` 挂载 channel。
final class TunHelperManager {

    // MARK: - 常量
    /// SMAppService.daemon 用的 plist 文件名(位于 App 的 Contents/Library/LaunchDaemons/)。
    private static let plistName = "com.follow.clash.tunhelper.plist"
    /// helper 的 Mach service 名(= plist Label)。
    private static let machServiceName = "com.follow.clash.tunhelper"
    /// 校验**对端 helper**身份的代码签名要求 —— 只认 Team 236T6T3629 签名、identifier 为 helper id 的进程。
    private static let helperRequirement =
        "identifier \"com.follow.clash.tunhelper\" and anchor apple generic and certificate leaf[subject.OU] = \"236T6T3629\""

    private static let channelName = "voguesly/tunhelper"
    private static let log = OSLog(subsystem: "com.follow.clash.tunhelper", category: "manager")

    @available(macOS 13.0, *)
    private static var daemonService: SMAppService {
        SMAppService.daemon(plistName: plistName)
    }

    // MARK: - MethodChannel 挂载
    static func register(with messenger: FlutterBinaryMessenger) {
        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        channel.setMethodCallHandler { call, result in
            // SMAppService 是 macOS 13+;App 部署目标 = 11.0,故所有 SMAppService 路径都锁在 @available 内。
            // macOS < 13:统一返回 "unsupported" / ok:false,让 system.dart 回退旧 osascript,别抬高 App min target。
            guard #available(macOS 13.0, *) else {
                switch call.method {
                case "register", "status", "unregister":
                    result("unsupported")
                case "ensureSetuid":
                    result(["ok": false, "msg": "unsupported: requires macOS 13+"])
                default:
                    result(FlutterMethodNotImplemented)
                }
                return
            }
            switch call.method {
            case "register":
                result(handleRegister())
            case "status":
                result(statusString(daemonService.status))
            case "unregister":
                result(handleUnregister())
            case "ensureSetuid":
                guard let args = call.arguments as? [String: Any],
                      let corePath = args["corePath"] as? String, !corePath.isEmpty else {
                    result(["ok": false, "msg": "missing corePath"])
                    return
                }
                ensureSetuid(corePath: corePath) { ok, msg in
                    // XPC reply 在后台队列回来;FlutterResult 必须回主线程发。
                    DispatchQueue.main.async {
                        result(["ok": ok, "msg": msg ?? ""])
                    }
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    // MARK: - SMAppService 注册
    @available(macOS 13.0, *)
    private static func handleRegister() -> String {
        // 已启用就别重复 register(重复注册同一 identity 会 throw)。
        let current = daemonService.status
        if current == .enabled {
            return "enabled"
        }
        do {
            try daemonService.register()
            os_log("daemon register() called, status=%{public}@",
                   log: log, type: .info, statusString(daemonService.status))
            return statusString(daemonService.status)
        } catch {
            os_log("daemon register() failed: %{public}@",
                   log: log, type: .error, String(describing: error))
            // register 抛错通常 = 需用户在系统设置批准;回读一次状态给出更准的判词。
            let after = daemonService.status
            if after == .requiresApproval {
                return "requiresApproval"
            }
            return "error"
        }
    }

    @available(macOS 13.0, *)
    private static func handleUnregister() -> String {
        do {
            try daemonService.unregister()
            return "ok"
        } catch {
            os_log("daemon unregister() failed: %{public}@",
                   log: log, type: .error, String(describing: error))
            return "error"
        }
    }

    @available(macOS 13.0, *)
    private static func statusString(_ status: SMAppService.Status) -> String {
        switch status {
        case .enabled: return "enabled"
        case .requiresApproval: return "requiresApproval"
        case .notRegistered: return "notRegistered"
        case .notFound: return "notFound"
        @unknown default: return "unknown"
        }
    }

    // MARK: - XPC:ensureCoreSetuid
    private static func ensureSetuid(corePath: String, completion: @escaping (Bool, String?) -> Void) {
        let conn = NSXPCConnection(machServiceName: machServiceName, options: .privileged)
        conn.remoteObjectInterface = NSXPCInterface(with: TunHelperProtocol.self)
        // 校验对端 helper 身份:setCodeSigningRequirement 非 throwing(void,macOS 13+)。
        // 不是正版 helper 时,后续消息会被系统丢弃,调用走下面的 errorHandler。
        if #available(macOS 13.0, *) {
            conn.setCodeSigningRequirement(helperRequirement)
        }
        conn.resume()

        // result / completion 只能触发一次;用一次性守卫避免 reply 与 errorHandler 双触发。
        var finished = false
        let finishLock = NSLock()
        func finishOnce(_ ok: Bool, _ msg: String?) {
            finishLock.lock()
            let already = finished
            finished = true
            finishLock.unlock()
            if already { return }
            conn.invalidate()
            completion(ok, msg)
        }

        let proxy = conn.remoteObjectProxyWithErrorHandler { err in
            os_log("xpc error: %{public}@", log: log, type: .error, String(describing: err))
            finishOnce(false, "xpc error: \(err.localizedDescription)")
        }
        guard let helper = proxy as? TunHelperProtocol else {
            finishOnce(false, "cannot cast remote proxy")
            return
        }
        helper.ensureCoreSetuid(corePath) { ok, msg in
            finishOnce(ok, msg)
        }
    }
}
