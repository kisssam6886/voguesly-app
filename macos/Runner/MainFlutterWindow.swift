import Cocoa
import FlutterMacOS
import window_manager
import LaunchAtLogin
import ServiceManagement
import os.log

class MainFlutterWindow: NSWindow {
    override func awakeFromNib() {
        let flutterViewController = FlutterViewController()
        let windowFrame = self.frame
        self.contentViewController = flutterViewController
        self.setFrame(windowFrame, display: true)

        FlutterMethodChannel(
            name: "launch_at_startup", binaryMessenger: flutterViewController.engine.binaryMessenger
        )
        .setMethodCallHandler { (_ call: FlutterMethodCall, result: @escaping FlutterResult) in
            switch call.method {
            case "launchAtStartupIsEnabled":
                result(LaunchAtLogin.isEnabled)
            case "launchAtStartupSetEnabled":
                if let arguments = call.arguments as? [String: Any] {
                    LaunchAtLogin.isEnabled = arguments["setEnabledValue"] as! Bool
                }
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        // TUN 提权 helper channel(voguesly/tunhelper)。TunHelperManager + TunHelperProtocol
        // 内联在本文件末尾(避开新增 Xcode target 的 pbxproj 改动),故此处可直接启用。
        // macOS < 13 时 channel 内部返回 unsupported,system.dart 自动回退旧 osascript。
        TunHelperManager.register(with: flutterViewController.engine.binaryMessenger)

        RegisterGeneratedPlugins(registry: flutterViewController)
        super.awakeFromNib()
    }
    override public func order(_ place: NSWindow.OrderingMode, relativeTo otherWin: Int) {
        super.order(place, relativeTo: otherWin)
        hiddenWindowAtLaunch()
    }
}

// MARK: - TUN 提权 helper(App 侧)——内联自 TunHelper/TunHelperProtocol.swift + Runner/TunHelperManager.swift
//
// XPC 协议:App(不可信 client)⇄ root helper(可信 server)之间的唯一接口。
// helper 只负责给核心二进制打 setuid(chown root:admin + chmod u+s),绝不启动/管理核心进程。
@objc protocol TunHelperProtocol {
    func ensureCoreSetuid(_ corePath: String, withReply reply: @escaping (Bool, String?) -> Void)
    func ping(withReply reply: @escaping (String) -> Void)
}

/// App 侧 TUN 提权 helper 管理器:SMAppService 注册 daemon(macOS 13+)+ XPC 调 ensureCoreSetuid。
final class TunHelperManager {
    private static let plistName = "com.follow.clash.tunhelper.plist"
    private static let machServiceName = "com.follow.clash.tunhelper"
    // SMAppService.Status == .enabled 只说明“同名 daemon 已注册”，不说明
    // launchd 内存里运行的是当前 App 携带的 helper。升级覆盖 App 后，旧 helper
    // 可能继续驻留；用当前 App 版本做迁移标记，避免 0.9.55 的旧路径校验继续生效。
    private static let registrationVersionKey = "com.voguesly.tunhelper.registrationVersion"
    private static let helperRequirement =
        "identifier \"com.follow.clash.tunhelper\" and anchor apple generic and certificate leaf[subject.OU] = \"236T6T3629\""
    private static let channelName = "voguesly/tunhelper"
    private static let log = OSLog(subsystem: "com.follow.clash.tunhelper", category: "manager")

    @available(macOS 13.0, *)
    private static var daemonService: SMAppService {
        SMAppService.daemon(plistName: plistName)
    }

    static func register(with messenger: FlutterBinaryMessenger) {
        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        channel.setMethodCallHandler { call, result in
            guard #available(macOS 13.0, *) else {
                switch call.method {
                case "register", "status", "unregister", "migrate":
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
            case "migrate":
                result(handleMigrate())
            case "ensureSetuid":
                guard let args = call.arguments as? [String: Any],
                      let corePath = args["corePath"] as? String, !corePath.isEmpty else {
                    result(["ok": false, "msg": "missing corePath"])
                    return
                }
                ensureSetuid(corePath: corePath) { ok, msg in
                    DispatchQueue.main.async {
                        result(["ok": ok, "msg": msg ?? ""])
                    }
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    @available(macOS 13.0, *)
    private static func handleRegister() -> String {
        let current = daemonService.status
        let shortVersion = Bundle.main.object(
            forInfoDictionaryKey: "CFBundleShortVersionString"
        ) as? String ?? "unknown"
        let buildVersion = Bundle.main.object(
            forInfoDictionaryKey: "CFBundleVersion"
        ) as? String ?? "unknown"
        let expectedRegistrationVersion = "\(shortVersion)+\(buildVersion)"
        let registeredVersion = UserDefaults.standard.string(forKey: registrationVersionKey)

        // ⚠️ 2026-08-05 根因:唔可以再「一见版本唔同就 unregister + register」。
        //
        // 0.9.57 加呢段係想解决「升级后旧 helper 仲驻留」。但实测(Sam 本机 0.9.62)
        // 副作用致命:re-register 之后 daemonService.status **唔一定即刻返 .enabled**
        // (macOS 要用户重新批准),于是下面「只有 .enabled 先写 registrationVersion」
        // 永远写唔入 → 每次连接都重新拆一次 daemon → ensureSetuid 永远调唔到 →
        // 核心永远攞唔到 setuid-root(实测 stat = sam:staff 无 rws)→ **TUN 永远起唔到**。
        // 现场证据:registrationVersion 卡死喺 0.9.60,而 App 已经係 0.9.62。
        //
        // 改为:daemon 已经 enabled 就直接用,顺手补写版本标记(唔好再空转)。
        // 真正嘅「旧 helper 唔认新核心路径」由 ensureSetuid 失败时反应式迁移处理
        // (Dart 侧收到失败会调 migrate 再重试一次),唔再喺每次升级主动破坏注册。
        if current == .enabled {
            if registeredVersion != expectedRegistrationVersion {
                UserDefaults.standard.set(
                    expectedRegistrationVersion,
                    forKey: registrationVersionKey
                )
                os_log(
                    "daemon already enabled; recorded version %{public}@ without re-registering",
                    log: log,
                    type: .info,
                    expectedRegistrationVersion
                )
            }
            return "enabled"
        }
        do {
            try daemonService.register()
            let after = daemonService.status
            if after == .enabled {
                UserDefaults.standard.set(expectedRegistrationVersion, forKey: registrationVersionKey)
            }
            os_log("daemon register() called, status=%{public}@",
                   log: log, type: .info, statusString(after))
            return statusString(after)
        } catch {
            os_log("daemon register() failed: %{public}@",
                   log: log, type: .error, String(describing: error))
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

    /// 反应式迁移:只喺 ensureSetuid 真係失败(例如旧 helper 唔认新核心路径)先至拆
    /// daemon 重注册。取代 0.9.57 嗰种「一见版本唔同就主动拆」——嗰种做法会喺每次
    /// 升级都令 daemon 掉出 .enabled,反而令 TUN 永久起唔到。
    @available(macOS 13.0, *)
    private static func handleMigrate() -> String {
        let before = daemonService.status
        if before == .enabled {
            do {
                try daemonService.unregister()
                os_log("daemon unregistered for reactive migration", log: log, type: .info)
            } catch {
                os_log("reactive migration unregister failed: %{public}@",
                       log: log, type: .error, String(describing: error))
                return "error"
            }
        }
        do {
            try daemonService.register()
            let after = daemonService.status
            if after == .enabled {
                let shortVersion = Bundle.main.object(
                    forInfoDictionaryKey: "CFBundleShortVersionString"
                ) as? String ?? "unknown"
                let buildVersion = Bundle.main.object(
                    forInfoDictionaryKey: "CFBundleVersion"
                ) as? String ?? "unknown"
                UserDefaults.standard.set(
                    "\(shortVersion)+\(buildVersion)",
                    forKey: registrationVersionKey
                )
            }
            os_log("reactive migration register() status=%{public}@",
                   log: log, type: .info, statusString(after))
            return statusString(after)
        } catch {
            os_log("reactive migration register() failed: %{public}@",
                   log: log, type: .error, String(describing: error))
            return statusString(daemonService.status)
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

    private static func ensureSetuid(corePath: String, completion: @escaping (Bool, String?) -> Void) {
        let conn = NSXPCConnection(machServiceName: machServiceName, options: .privileged)
        conn.remoteObjectInterface = NSXPCInterface(with: TunHelperProtocol.self)
        if #available(macOS 13.0, *) {
            conn.setCodeSigningRequirement(helperRequirement)
        }
        conn.resume()

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
