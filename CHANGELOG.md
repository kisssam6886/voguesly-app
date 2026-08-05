## v0.9.66

- 代理端口改为易联专属，不再与其他客户端抢占：此前沿用 Clash 生态通用的 7890，只要电脑上装了 Clash Verge / ClashX / mihomo-party / 原版 FlClash 等任意一个并先启动，易联就会绑不到端口，表现为「显示已连接却上不了网」。升级会自动搬迁（你自己改过端口的不会被覆盖）。
- 「系统代理（兼容模式）」状态改为如实显示：此前只要虚拟网卡在运行就不再校验系统代理，导致系统代理被其他代理软件接管后，易联仍显示自己接管中。
- 被其他程序接管系统代理时只提示一次并说明「上网不受影响」，不会再误断开正常工作的虚拟网卡。

## v0.9.65

- 主页大圆圈文字重新排版：连接状态与承载方式分两行显示，长文案（如「TUN + 系统代理」）不会再溢出圆形边界。
- 左侧栏「在线客服」下方新增「有新版本」入口：检查到新版时才出现，点击即可查看更新说明并下载，不必再进入「设置 → 关于」。
- 该入口独立于「自动检查更新」开关：即使关闭了更新弹窗提醒，仍然能在侧栏找到更新入口，且不会主动弹窗打扰。

## v0.9.64

- 修复虚拟网卡（设备接管）明明已经正常工作，却被客户端误判为失败、进而自动切回系统代理的问题。这是此前「连接一会儿就掉、Telegram 时好时坏」的根本原因。
- 根因：macOS 上的接管检测用「默认路由是否指向虚拟网卡」来判断，但 macOS 的接管方式并不会改写默认路由，因此健康状态也会被判成失败。
- 现在改为检测真实公网目标的实际出口，并校验该虚拟网卡确实属于易联，不会再把其他 VPN（如 Tailscale）误认成易联自己的接管。
- 误判消除后，不会再出现无谓的核心重启与自动降级。

## v0.9.63

- 修复 macOS 虚拟网卡（设备接管）打开后仍然无法生效、只能退回系统代理的问题。
- 根因：0.9.57 起「按 App 版本迁移后台服务」会在每次升级时注销并重新注册后台项目，重新注册后状态未必立刻恢复为已启用，导致版本标记始终写不回去，每次连接都重复注销一次，核心始终拿不到提权，虚拟网卡永远建立不起来。
- 现在后台项目已启用时直接沿用，不再主动注销；只有在提权真正失败（例如升级后仍是旧后台服务）时才做一次重新注册并自动重试。
- 重新注册后如果需要重新授权，会明确提示并可一键打开系统设置。

## v0.9.62

- 修复桌面端「客户端显示已连接、实际全部超时」：TUN 接管失败时不再把设备留在「TUN 与系统代理都关闭」的断网状态。
- 升级迁移不再强制关闭「系统代理（兼容模式）」。此前 v2/v3 迁移会无条件关掉它，一旦 TUN 因权限或路由问题接管失败，用户就没有任何可用通路。
- TUN 授权失败、被其他代理占用或路由持续不通时，改为自动切到兼容模式并明确提示当前不是整机接管，同时保留 TUN 偏好；断开重连或重启后会重新尝试 TUN。
- 修正「关闭其他代理后可直接重试」提示与实际行为不符的问题：第三方冲突不再把 TUN 开关永久写成关闭。
- TUN 路由探测持续失败时不再直接关停核心，改为保住核心并降级承载，避免连接被整体切断。

## v0.9.61

- 修复 macOS TUN 启动后约数秒被易联自身路由探测误判并自动关闭的问题：增加启动收敛宽限、连续失败阈值与一次受控核心/TUN 恢复。
- 修复 TUN 失败后的生命周期清理，避免残留核心进程/监听器影响下一次连接；不关闭或修改其他 VPN（包括 Tailscale）。
- 仪表盘恢复「虚拟网卡（设备接管）」与「系统代理（兼容模式）」开关；大圆圈按实际接管路径显示 TUN、系统代理或两者。
- 桌面新配置默认 TUN 优先、系统代理关闭；现有配置继续由迁移逻辑保持 TUN 优先。

## v0.9.60

- 升级迁移现有桌面配置回到 TUN 优先：旧的系统代理偏好不会再让大圆圈静默只启动兼容模式。
- 普通用户主页继续只显示 TUN（设备接管），系统代理保留在进阶设置。

## v0.9.59

- macOS 普通用户主页只保留 TUN（设备接管），系统代理移到进阶设置，避免把兼容模式误认为整机已接管。
- TUN 授权失败时回滚开关状态，避免显示「TUN 已开启」但实际仍由系统代理或直连承载。
- 从 DMG 直接运行时明确提示先拖入 Applications；TUN 授权提示可一键打开 macOS 后台项目设置。
- 发布 DMG 固定包含 Applications 快捷方式，更新后可直接拖拽覆盖旧版本。

## v0.9.58

- 仪表盘同时显示 TUN（设备接管）与系统代理（兼容模式），连接状态明确标记实际接管方式
- macOS 自动 DNS 只在 TUN 运行期间临时加入，停止或退出时只撤销易联自己加入的 DNS，不覆盖用户后续修改
- TUN 接管失败提示改为可执行指引，明确关闭其他 VPN 或使用仪表盘系统代理备用入口
- 修正 Android 平台 VPN 系统代理文案不应套用桌面兼容模式说明
- 串行化 macOS 自动 DNS 的加入/恢复操作，避免快速开关 TUN 时发生竞态

## v0.9.57

- 修复 macOS 升级后旧版 root TUN helper 仍驻留内存、导致 0.9.56 新路径修复未生效的问题
- helper 注册现在按 App 版本迁移：检测到旧 daemon 时安全卸载并重新注册当前版本，避免用户手工敲 launchctl 命令
- Telegram 等不遵循 macOS 系统代理的应用可在 TUN 真正建立后随系统流量接管

## v0.9.56

- 修复 macOS TUN helper 仍只允许旧 App Bundle 核心路径，导致外置核心无法提权、TUN 被降级为关闭的问题
- macOS helper 现在只接受 Voguesly 固定的 Application Support 外置核心路径，并继续执行真实路径、文件类型与代码签名校验
- 修复后重新验证核心 setuid、TUN 路由与系统代理连接态

## v0.8.93

- Support custom overwrite

- Support run on demand

- Optimize windows ipc

- Optimize windows arm64

- Optimize build

- Optimize some details

- Update core

## v0.8.92

- Add sqlite store

- Optimize android quick action

- Optimize backup and restore

- Optimize more details

## v0.8.91

- Fix windows some issues

- Optimize overwrite handle

- Optimize access control page

- Optimize some details

## v0.8.90

- Fix android tile service

- Support append system DNS

- Fix some issues

- Update changelog

## v0.8.89

- Fix some issues

- Optimize Windows service mode

- Update core

- Update changelog

## v0.8.88

- Add android separates the core process

- Support core status check and force restart

- Optimize proxies page and access page

- Update flutter and pub dependencies

- Update go version

- Optimize more details

- Update changelog

## v0.8.87

- Optimize desktop view

- Optimize logs, requests, connection pages

- Optimize windows tray auto hide

- Optimize some details

- Update core

- Update changelog

## v0.8.86

- Fix windows tun issues

- Optimize android get system dns

- Optimize more details

- Update changelog

## v0.8.85

- Support override script

- Support proxies search

- Support svg display

- Optimize config persistence

- Add some scenes auto close connections

- Update core

- Optimize more details

## v0.8.84

- Fix windows service verify issues

- Update changelog

## v0.8.83

- Add windows server mode start process verify

- Add linux deb dependencies

- Add backup recovery strategy select

- Support custom text scaling

- Optimize the display of different text scale

- Optimize windows setup experience

- Optimize startTun performance

- Optimize android tv experience

- Optimize default option

- Optimize computed text size

- Optimize hyperOS freeform window

- Add developer mode

- Update core

- Optimize more details

- Add issues template

- Update changelog

## v0.8.82

- Optimize android vpn performance

- Add custom primary color and color scheme

- Add linux nad windows arm release

- Optimize requests and logs page

- Fix map input page delete issues

- Update changelog

## v0.8.81

- Add rule override

- Update core

- Optimize more details

- Update changelog

## v0.8.80

- Optimize dashboard performance

- Fix some issues

- Fix unselected proxy group delay issues

- Fix asn url issues

- Update changelog

## v0.8.79

- Fix tab delay view issues

- Fix tray action issues

- Fix get profile redirect client ua issues

- Fix proxy card delay view issues

- Add Russian, Japanese adaptation

- Fix some issues

- Update changelog

## v0.8.78

- Fix list form input view issues

- Fix traffic view issues

- Update changelog

## v0.8.77

- Optimize performance

- Update core

- Optimize core stability

- Fix linux tun authority check error

- Fix some issues

- Fix scroll physics error

- Update changelog

## v0.8.75

- Add windows storage corruption detection

- Fix core crash caused by windows resource manager restart

- Optimize logs, requests, access to pages

- Fix macos bypass domain issues

- Update changelog

## v0.8.74

- Fix some issues

- Update changelog

## v0.8.73

- Update popup menu

- Add file editor

- Fix android service issues

- Optimize desktop background performance

- Optimize android main process performance

- Optimize delay test

- Optimize vpn protect

- Update changelog

## v0.8.72

- Update core

- Fix some issues

- Update changelog

## v0.8.71

- Remake dashboard

- Optimize theme

- Optimize more details

- Update flutter version

- Update changelog

## v0.8.70

- Support better window position memory

- Add windows arm64 and linux arm64 build script

- Optimize some details

## v0.8.69

- Remake desktop

- Optimize change proxy

- Optimize network check

- Fix fallback issues

- Optimize lots of details

- Update change.yaml

- Fix android tile issues

- Fix windows tray issues

- Support setting bypassDomain

- Update flutter version

- Fix android service issues

- Fix macos dock exit button issues

- Add route address setting

- Optimize provider view

- Update changelog

- Update CHANGELOG.md

## v0.8.67

- Add android shortcuts

- Fix init params issues

- Fix dynamic color issues

- Optimize navigator animate

- Optimize window init

- Optimize fab

- Optimize save

## v0.8.66

- Fix the collapse issues

- Add fontFamily options

## v0.8.65

- Update core version

- Update flutter version

- Optimize ip check

- Optimize url-test

## v0.8.64

- Update release message

- Init auto gen changelog

- Fix windows tray issues

- Fix urltest issues

- Add auto changelog

- Fix windows admin auto launch issues

- Add android vpn options

- Support proxies icon configuration

- Optimize android immersion display

- Fix some issues

- Optimize ip detection

- Support android vpn ipv6 inbound switch

- Support log export

- Optimize more details

- Fix android system dns issues

- Optimize dns default option

- Fix some issues

- Update readme

## v0.8.60

- Fix build error2

- Fix build error

- Support desktop hotkey

- Support android ipv6 inbound

- Support android system dns

- fix some bugs

## v0.8.59

- Fix delete profile error

## v0.8.58

- Fix submit error 2

- Fix submit error

- Optimize DNS strategy

- Fix the problem that the tray is not displayed in some cases

- Optimize tray

- Update core

- Fix some error

## v0.8.57

- Fix tun update issues

- Add DNS override
- Fixed some bugs
- Optimize more detail

- Add Hosts override

## v0.8.56

- fix android tip error
- fix windows auto launch error

## v0.8.55

- Fix windows tray issues

- Optimize windows logic

- Optimize app logic

- Support windows administrator auto launch

- Support android close vpn

## v0.8.53

- Change flutter version

- Support profiles sort

- Support windows country flags display

- Optimize proxies page and profiles page columns

## v0.8.52

- Update flutter version

- Update version

- Update timeout time

- Update access control page

- Fix bug

## v0.8.51

- Optimize provider page

- Optimize delay test

- Support local backup and recovery

- Fix android tile service issues

## v0.8.49

- Fix linux core build error

- Add proxy-only traffic statistics

- Update core

- Optimize more details

- Merge pull request #140 from txyyh/main

- 添加自建 F-Droid 仓库相关 workflow
- Rename readme fingerprint

- Rename workflow deploy repo name

- Add download guide to README

- Add push release files to fdroid-repo

## v0.8.48

- Optimize proxies page

- Fix ua issues

- Optimize more details

## v0.8.47

- Fix windows build error

## v0.8.46

- Update app icon

- Fix desktop backup error

- Optimize request ua

- Change android icon

- Optimize dashboard

## v0.8.44

- Remove request validate certificate

- Sync core

## v0.8.43

- Fix windows error

## v0.8.42

- Fix setup.dart error

- Fix android system proxy not effective

- Add macos arm64

## v0.8.41

- Optimize proxies page

- Support mouse drag scroll

- Adjust desktop ui

- Revert "Fix android vpn issues"

- This reverts commit 891977408e6938e2acd74e9b9adb959c48c79988.

## v0.8.40

- Fix android vpn issues

- Fix android vpn issues

- Rollback partial modification

## v0.8.39

- Fix the problem that ui can't be synchronized when android vpn is occupied by an external

- Override default socksPort,port

## v0.8.38

- Fix fab issues

## v0.8.37

- Update version

- Fix the problem that vpn cannot be started in some cases

- Fix the problem that geodata url does not take effect

## v0.8.36

- Update ua

- Fix change outbound mode without check ip issues

- Separate android ui and vpn

- Fix url validate issues 2

- Add android hidden from the recent task

- Add geoip file

- Support modify geoData URL

## v0.8.35

- Fix url validate issues

- Fix check ip performance problem

- Optimize resources page

## v0.8.34

- Add ua selector

- Support modify test url

- Optimize android proxy

- Fix the error that async proxy provider could not selected the proxy

## v0.8.33

- Fix android proxy error

- Fix submit error

- Add windows tun

- Optimize android proxy

- Optimize change profile

- Update application ua

- Optimize delay test

## v0.8.32

- Fix android repeated request notification issues

## v0.8.31

- Fix memory overflow issues

## v0.8.30

- Optimize proxies expansion panel 2

- Fix android scan qrcode error

## v0.8.29

- Optimize proxies expansion panel

- Fix text error

## v0.8.28

- Optimize proxy

- Optimize delayed sorting performance

- Add expansion panel proxies page

- Support to adjust the proxy card size

- Support to adjust proxies columns number

- Fix autoRun show issues

- Fix Android 10 issues

- Optimize ip show

## v0.8.26

- Add intranet IP display

- Add connections page

- Add search in connections, requests

- Add keyword search in connections, requests, logs

- Add basic viewing editing capabilities

- Optimize update profile

## v0.8.25

- Update version

- Fix the problem of excessive memory usage in traffic usage.

- Add lightBlue theme color

- Fix start unable to update profile issues

- Fix flashback caused by process

## v0.8.23

- Add build version

- Optimize quick start

- Update system default option

## v0.8.22

- Update build.yml

- Fix android vpn close issues

- Add requests page

- Fix checkUpdate dark mode style error

- Fix quickStart error open app

- Add memory proxies tab index

- Support hidden group

- Optimize logs

- Fix externalController hot load error

## v0.8.21

- Add tcp concurrent switch

- Add system proxy switch

- Add geodata loader switch

- Add external controller switch

- Add auto gc on trim memory

- Fix android notification error

## v0.8.20

- Fix ipv6 error

- Fix android udp direct error

- Add ipv6 switch

- Add access all selected button

- Remove android low version splash

## v0.8.19

- Update version

- Add allowBypass

- Fix Android only pick .text file issues

## v0.8.18

- Fix search issues

## v0.8.17

- Fix LoadBalance, Relay load error

- Fix build.yml4

- Fix build.yml3

- Fix build.yml2

- Fix build.yml

- Add search function at access control

- Fix the issues with the profile add button to cover the edit button

- Adapt LoadBalance and Relay

- Add arm

- Fix android notification icon error

## v0.8.16

- Add one-click update all profiles
- Add expire show

## v0.8.15

- Temp remove tun mode

- Remove macos in workflow

- Change go version

## v0.8.14

- Update Version

- Fix tun unable to open

## v0.8.13

- Optimize delay test2

- Optimize delay test

- Add check ip

- add check ip request

## v0.8.12

- Fix the problem that the download of remote resources failed after GeodataMode was turned on, which caused the
  application to flash back.

- Fix edit profile error

- Fix quickStart change proxy error

- Fix core version

## v0.8.10

- Fix core version

## v0.8.9

- Update file_picker

- Add resources page

- Optimize more detail

- Add access selected sorted

- Fix notification duplicate creation issue

- Fix AccessControl click issue

## v0.8.7

- Fix Workflow

- Fix Linux unable to open

- Update README.md 3

- Create LICENSE
- Update README.md 2

- Update README.md

- Optimize workFlow

## v0.8.6

- optimize checkUpdate

## v0.8.5

- Fix submit error

## v0.8.4

- add WebDAV

- add Auto check updates

- Optimize more details

- optimize delayTest

## v0.8.2

- upgrade flutter version

## v0.8.1

- Update kernel
- Add import profile via QR code image

## v0.8.0

- Add compatibility mode and adapt clash scheme.

## v0.7.14

- update Version

- Reconstruction application proxy logic

## v0.7.13

- Fix Tab destroy error

## v0.7.12

- Optimize repeat healthcheck

## v0.7.11

- Optimize Direct mode ui

## v0.7.10

- Optimize Healthcheck

- Remove proxies position animation, improve performance
- Add Telegram Link

- Update healthcheck policy

- New Check URLTest

- Fix the problem of invalid auto-selection

## v0.7.8

- New Async UpdateConfig

- add changeProfileDebounce

- Update Workflow

- Fix ChangeProfile block

- Fix Release Message Error

## v0.7.7

- Update Selector 2

## v0.7.6

- Update Version

- Fix Proxies Select Error

## v0.7.5

- Fix the problem that the proxy group is empty in global mode.

- Fix the problem that the proxy group is empty in global mode.

## v0.7.4

- Add ProxyProvider2

## v0.7.3

- Add ProxyProvider

- Update Version

- Update ProxyGroup Sort

- Fix Android quickStart VpnService some problems

## v0.7.1

- Update version

- Set Android notification low importance

- Fix the issue that VpnService can't be closed correctly in special cases

- Fix the problem that TileService is not destroyed correctly in some cases

- Adjust tab animation defaults

- Add Telegram in README_zh_CN.md

- Add Telegram

## v0.7.0

- update mobile_scanner

- Initial commit
