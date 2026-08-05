import Foundation

/// XPC 协议:App(不可信 client)⇄ root helper(可信 server)之间的唯一接口。
///
/// 设计约束(方案 b — 持久化提权,非在 helper 内跑核心):
///   - helper **只**负责把 Voguesly 的 Application Support 外置 mihomo 核心二进制打上 setuid
///     (chown root:admin + chmod u+s)。
///   - helper **绝不**启动 / 管理 / kill 核心进程 —— 核心照旧由 App 自己用现有 setuid 路径拉起。
///   - 这样「弹密码 chmod」这步只在首次注册 helper 时发生一次,之后换核心/更新都免密码。
///
/// 两端(main.swift 的 server、Runner/TunHelperManager.swift 的 client)必须共用这份文件,
/// 故它同时被加入 App target 和 helper target(见 runbook 的 target 接入步骤)。
@objc protocol TunHelperProtocol {
    /// 给指定核心二进制打 setuid。
    /// - Parameters:
    ///   - corePath: 外置核心的绝对路径,必须落在
    ///     `/Users/<user>/Library/Application Support/com.voguesly.app/` 下的固定路径。
    ///   - reply: (成功?, 错误串)。成功时错误串为 nil;失败时 Bool=false 且带可读原因。
    func ensureCoreSetuid(_ corePath: String, withReply reply: @escaping (Bool, String?) -> Void)

    /// 连通性自检,返回 helper 版本串。App 侧用来确认 XPC 通道 + 身份校验双向成立。
    func ping(withReply reply: @escaping (String) -> Void)
}
