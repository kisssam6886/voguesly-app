# TunHelper.entitlements 点解係空 dict

helper 係 root LaunchDaemon,**唔可以**加 `com.apple.security.app-sandbox`(sandbox 会挡 chown/chmod 提权)。
- hardened runtime 由签名时 `--options runtime` 施加,唔係 entitlement
- chown/chmod 靠 root 身份即可,唔需要额外 entitlement
- 空 dict = 最小权限

## ⚠️ 唔好喺 .entitlements 入面写 XML 注释
`plutil -lint` 会话 OK,但 **codesign 嘅 AMFI parser 唔食 `<!-- -->`**,会报
`Failed to parse entitlements: AMFIUnserializeXML: syntax error`,
令 helper 签唔到(TeamIdentifier=not set)→ app 整体 `a sealed resource is missing or invalid`。
2026-07-20 踩过,注释已移到呢个 README。
