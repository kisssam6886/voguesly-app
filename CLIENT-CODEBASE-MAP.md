# 易联 Voguesly 客户端 · Codebase Map（接手即用）

> 目的：任何 session/agent 要碰呢个客户端,**先读呢份**,唔使重新调查 nav/支付/版本/订阅 各处。
> 配合记忆(recall 指针):`project_voguesly_app_shop_tab_qr_version` / `reference_voguesly_app_cross_platform_ci` / `project_voguesly_app_batch_fixes_pending` / `feedback_voguesly_app_batch_build_dont_per_change` / `reference_voguesly_oracle_mtu_1500_fix`。
> **最后更新:2026-07-10 (v0.9.47)**。改咗大嘢就更新呢份 + 对应记忆。

## 0. 一句话
FlClash(chen08209)fork,单一 Flutter codebase 出 **Android + macOS(universal) + Windows**;登录 XBoard 账号→自动拉订阅→连,内置检测/购买/分流。品牌色 `#7C5CF6` 紫罗兰,默认深色主题。bundle=`com.voguesly.app`。

## 1. 仓库 / 分支 / 版本
- 本地:`~/voguesly-android/voguesly-app`;remote `github.com/kisssam6886/voguesly-app`(分支 main);core/flutter_distributor/tray 等系 git submodule(`submodules: recursive`)。
- 版本号:`pubspec.yaml` `version: 0.9.47+2026071002`(每批 bump)。当前 cert SHA-256 `2716a73f...`(alias voguesly, `android/app/keystore.jks`, gitignored)。

## 2. Build + 发版流程(⚠️ 攒一批一次 build,别逐个——见 feedback 记忆)
| 平台 | 命令 / 路径 | 签名 |
|---|---|---|
| **Android** | `ANDROID_NDK=/opt/homebrew/share/android-commandlinetools/ndk/28.2.13676358 dart setup.dart android --arch arm64` → `dist/FlClash-<v>-android-arm64-v8a.apk` | keystore.jks(local.properties);in-place 更新要同 cert |
| **macOS** | `~/yl-devid/rebuild-sign-notarize.sh` → `build/macos/Build/Products/Release/Voguesly.app`(**已 universal x86_64+arm64**,63/63 二进制) | Developer ID YONGKUN SHI(team 236T6T3629), notary profile `ylink-notary`。⚠️Apple 公证偶发 degraded 会卡钟头级→出签名版畀 Sam `xattr -cr` 测,恢复自动 staple |
| **Windows** | CI:`gh workflow run build.yaml -R kisssam6886/voguesly-app --ref main` → artifact `artifact-windows-amd64`(setup.exe + zip) | 未签名(SmartScreen);去警告=买 Azure Trusted Signing ~$10/mo |
- **CI** = `.github/workflows/build.yaml`(4 平台;push tag `v*` 或 workflow_dispatch;Android secrets 已配;`upload` job 已禁)。Mac Intel 唔使靠 CI(本地 universal 已覆盖;Intel 测试机=iMac 10.10.10.115,只测不 build)。
- **发布**:APK/zip/exe scp 上 SG 下载站(`scp -i ~/.ssh/oracle_arm_sg ... ubuntu@161.118.219.50:/var/www/dl/voguesly-<v>.<ext>`)+ 改 HK manifest `/var/www/cp-downloads/version.json`(platforms 分层)+ 下载页 `voguesly-ops/dl/index.html`。下载站 = https://dl.ylink.im/。

## 3. 关键文件地图(feature → 位置)
- **导航/tab**:`lib/common/navigation.dart`(NavigationItem list,modes=desktop/mobile);`lib/enum/enum.dart` `PageLabel`(dashboard/**shop**/detection/proxies/tools);tab 标签 i18n=`Intl.message(label.name)` 靠 `lib/l10n/intl/messages_<locale>.dart`(⚠️**手加非 arb**,repo 唔 regen);手机底栏=`lib/pages/home.dart`,桌面侧栏=`lib/manager/app_manager.dart`(nav rows + 服务链接 ContentOverlay:用户中心/邀请/公告/流量/客服)。
- **商城/购买**:`lib/voguesly/voguesly_shop.dart`(plan/fetch→下单);支付=`lib/voguesly/voguesly_payment.dart`(桌面+手机内嵌 QR `QrImageView`+「打开支付」);**我的订单**=`VogueslyOrdersPage`(在 `voguesly_user_center.dart`,`.open(context)`)。API=`lib/voguesly/voguesly_api.dart`(order/save·checkout·check·fetch,全原生无 webview)。
- **检查更新**:`lib/common/request.dart` `checkForUpdate`(按平台+`Abi.current()`分 arm64/intel 读 manifest `platforms`;网络/非200 返 `{'__net_error__':true}`);处理=`lib/providers/action.dart` `checkUpdateResultHandle`;manifest URL=`lib/common/constant.dart:vogueslyVersionCheckUrl`。
- **订阅/profile**:初次导入=`lib/voguesly/voguesly_subscription.dart`(用 `api.fetchSubscribeBytes` 带 clash UA);profile 更新=`lib/models/profile.dart` `update()`→`request.getFileResponseForUrl`(⚠️已补 clash UA,否则面板返 base64→只剩 GLOBAL);诊断 log 在 `saveFile`。
- **检测页**:`lib/voguesly/voguesly_detection.dart`(B站/YT/Netflix/fast.com,限并发3;跨平台,desktop nav 已接)。
- **登录**:`lib/voguesly/voguesly_login_page.dart`(邮箱/验证码/Google OAuth 走 ylink.im);auth=`voguesly_auth.dart`。
- **品牌**:主色 `lib/common/constant.dart:defaultPrimaryColor=0XFF7C5CF6`;图标 `assets/images/icon.png`(D-v 深色发光);adaptive bg `#0B0B12`。

## 4. 分流 Moat(Model A)——客户端只是消费端
真源在 XBoard 后端(HK)`overrides/`,非客户端。客户端只认拉到嘅订阅。改分流看记忆 `reference_voguesly_residential_rules_model_a` + `reference_voguesly_shadowrocket_rules`。

## 5. 近期改动
- **0.9.47**(batch):我的订单入口、网络误报修、macOS grid 只剩 GLOBAL 修(clash UA)。
- **0.9.46**:购买套餐升顶层 tab、手机内嵌支付 QR、版本检测分平台架构。

## 6. 待办 / 已知(见 `project_voguesly_app_batch_fixes_pending` 记忆)
- macOS「线路只剩 GLOBAL」修咗待 Sam 验(仍坏→grep `profile.saveFile` 睇 bytes/validate)。
- Windows 代码签名(Azure Trusted Signing)未做。
- 有新小改→记入 batch 清单,攒够一次 build。

## 7. 血泪坑(唔好再踩)
- i18n tab 标签**手加 messages_*.dart**(zh_CN/zh_Hant/en),arb 无效。
- Android in-place 更新 APK **必须同 keystore**(cert `2716a73f`)。
- 唔好 commit keystore/local.properties(已 gitignored);monorepo 巨大暂存区→单文件用 `git commit --only`。
- macOS 已 universal,**唔使**为 Intel 另 build。
- 公证 Apple 侧偶发卡→别死等,出签名版。
