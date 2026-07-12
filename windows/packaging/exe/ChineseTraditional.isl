; *** Inno Setup version 6.1.0+ Chinese Traditional messages ***
;
; To download user-contributed translations of this file, go to:
;   https://jrsoftware.org/files/istrans/
;
; Note: When translating this text, do not add periods (.) to the end of
; messages that didn't have them already, because on those messages Inno
; Setup adds the periods automatically (appending a period would result in
; two periods being displayed).
;
; Maintained by Zhenghan Yang
; Email: 847320916@QQ.com
; Translation based on network resource
; The latest Translation is on https://github.com/kira-96/Inno-Setup-Chinese-Simplified-Translation
;

[LangOptions]
; The following three entries are very important. Be sure to read and 
; understand the '[LangOptions] section' topic in the help file.
LanguageName=繁體中文
; If Language Name display incorrect, uncomment next line
; LanguageName=<7B80><4F53><4E2D><6587>
; About LanguageID, to reference link:
; https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-lcid/a9eac961-e77d-41a6-90a5-ce1a8b0cdb9c
LanguageID=$0404
LanguageCodePage=950
; If the language you are translating to requires special font faces or
; sizes, uncomment any of the following entries and change them accordingly.
DialogFontName=Microsoft YaHei UI
;DialogFontSize=8
WelcomeFontName=Microsoft YaHei UI
;WelcomeFontSize=12
TitleFontName=Microsoft YaHei UI
;TitleFontSize=29
;CopyrightFontName=Arial
;CopyrightFontSize=8

[Messages]

; *** 應用程式標題
SetupAppTitle=安裝
SetupWindowTitle=安裝 - %1
UninstallAppTitle=解除安裝
UninstallAppFullTitle=%1 解除安裝

; *** Misc. common
InformationTitle=資訊
ConfirmTitle=確認
ErrorTitle=錯誤

; *** SetupLdr messages
SetupLdrStartupMessage=現在將安裝 %1。您想要繼續嗎？
LdrCannotCreateTemp=不能建立臨時檔案。安裝中斷。
LdrCannotExecTemp=不能執行臨時目錄中的檔案。安裝中斷。
HelpTextNote=

; *** 啟動錯誤訊息
LastErrorMessage=%1.%n%n錯誤 %2: %3
SetupFileMissing=安裝目錄中的檔案 %1 丟失。請修正這個問題或者獲取程式的新副本。
SetupFileCorrupt=安裝檔案已損壞。請獲取程式的新副本。
SetupFileCorruptOrWrongVer=安裝檔案已損壞，或是與這個安裝程式的版本不相容。請修正這個問題或獲取新的程式副本。
InvalidParameter=無效的命令列引數：%n%n%1
SetupAlreadyRunning=安裝程式正在執行。
WindowsVersionNotSupported=這個程式不支援當前計算機執行的 Windows 版本。
WindowsServicePackRequired=這個程式需要 %1 服務包 %2 或更高。
NotOnThisPlatform=這個程式將不能執行於 %1。
OnlyOnThisPlatform=這個程式必須執行於 %1。
OnlyOnTheseArchitectures=這個程式只能在為下列處理器架構的 Windows 版本中進行安裝：%n%n%1
WinVersionTooLowError=這個程式需要 %1 版本 %2 或更高。
WinVersionTooHighError=這個程式不能安裝於 %1 版本 %2 或更高。
AdminPrivilegesRequired=在安裝這個程式時您必須以管理員身份登入。
PowerUserPrivilegesRequired=在安裝這個程式時您必須以管理員身份或有許可權的使用者組身份登入。
SetupAppRunningError=安裝程式發現 %1 當前正在執行。%n%n請先關閉所有執行的視窗，然後點選“確定”繼續，或按“取消”退出。
UninstallAppRunningError=解除安裝程式發現 %1 當前正在執行。%n%n請先關閉所有執行的視窗，然後點選“確定”繼續，或按“取消”退出。

; *** 啟動問題
PrivilegesRequiredOverrideTitle=選擇安裝程式模式
PrivilegesRequiredOverrideInstruction=選擇安裝模式
PrivilegesRequiredOverrideText1=%1 可以為所有使用者安裝(需要管理員許可權)，或僅為您安裝。
PrivilegesRequiredOverrideText2=%1 只能為您安裝，或為所有使用者安裝(需要管理員許可權)。
PrivilegesRequiredOverrideAllUsers=為所有使用者安裝(&A)
PrivilegesRequiredOverrideAllUsersRecommended=為所有使用者安裝(&A) (建議選項)
PrivilegesRequiredOverrideCurrentUser=僅為我安裝(&M)
PrivilegesRequiredOverrideCurrentUserRecommended=僅為我安裝(&M) (建議選項)

; *** 其它錯誤
ErrorCreatingDir=安裝程式不能建立目錄“%1”。
ErrorTooManyFilesInDir=不能在目錄“%1”中建立檔案，因為裡面的檔案太多

; *** 安裝程式公共訊息
ExitSetupTitle=退出安裝程式
ExitSetupMessage=安裝程式尚未完成安裝。如果您現在退出，程式將不能安裝。%n%n您可以以後再執行安裝程式完成安裝。%n%n現在退出安裝程式嗎？
AboutSetupMenuItem=關於安裝程式(&A)...
AboutSetupTitle=關於安裝程式
AboutSetupMessage=%1 版本 %2%n%3%n%n%1 主頁：%n%4
AboutSetupNote=
TranslatorNote=Translated by Zhenghan Yang.

; *** 按鈕
ButtonBack=< 上一步(&B)
ButtonNext=下一步(&N) >
ButtonInstall=安裝(&I)
ButtonOK=確定
ButtonCancel=取消
ButtonYes=是(&Y)
ButtonYesToAll=全是(&A)
ButtonNo=否(&N)
ButtonNoToAll=全否(&O)
ButtonFinish=完成(&F)
ButtonBrowse=瀏覽(&B)...
ButtonWizardBrowse=瀏覽(&R)...
ButtonNewFolder=新建資料夾(&M)

; *** “選擇語言”對話方塊訊息
SelectLanguageTitle=選擇安裝語言
SelectLanguageLabel=選擇安裝時要使用的語言。

; *** 公共嚮導文字
ClickNext=點選“下一步”繼續，或點選“取消”退出安裝程式。
BeveledLabel=
BrowseDialogTitle=瀏覽資料夾
BrowseDialogLabel=在下列列表中選擇一個資料夾，然後點選“確定”。
NewFolderName=新建資料夾

; *** “歡迎”嚮導頁
WelcomeLabel1=歡迎使用 [name] 安裝嚮導
WelcomeLabel2=現在將安裝 [name/ver] 到您的電腦中。%n%n推薦您在繼續安裝前關閉所有其它應用程式。

; *** “密碼”嚮導頁
WizardPassword=密碼
PasswordLabel1=這個安裝程式有密碼保護。
PasswordLabel3=請輸入密碼，然後點選“下一步”繼續。密碼區分大小寫。
PasswordEditLabel=密碼(&P)：
IncorrectPassword=您所輸入的密碼不正確，請重試。

; *** “許可協議”嚮導頁
WizardLicense=許可協議
LicenseLabel=繼續安裝前請閱讀下列重要資訊。
LicenseLabel3=請仔細閱讀下列許可協議。您在繼續安裝前必須同意這些協議條款。
LicenseAccepted=我同意此協議(&A)
LicenseNotAccepted=我拒絕此協議(&D)

; *** “資訊”嚮導頁
WizardInfoBefore=資訊
InfoBeforeLabel=請在繼續安裝前閱讀下列重要資訊。
InfoBeforeClickLabel=如果您想繼續安裝，點選“下一步”。
WizardInfoAfter=資訊
InfoAfterLabel=請在繼續安裝前閱讀下列重要資訊。
InfoAfterClickLabel=如果您想繼續安裝，點選“下一步”。

; *** “使用者資訊”嚮導頁
WizardUserInfo=使用者資訊
UserInfoDesc=請輸入您的資訊。
UserInfoName=使用者名稱(&U)：
UserInfoOrg=組織(&O)：
UserInfoSerial=序列號(&S)：
UserInfoNameRequired=您必須輸入使用者名稱。

; *** “選擇目標目錄”嚮導頁
WizardSelectDir=選擇目標位置
SelectDirDesc=您想將 [name] 安裝在哪裡？
SelectDirLabel3=安裝程式將安裝 [name] 到下列資料夾中。
SelectDirBrowseLabel=點選“下一步”繼續。如果您想選擇其它資料夾，點選“瀏覽”。
DiskSpaceGBLabel=至少需要有 [gb] GB 的可用磁碟空間。
DiskSpaceMBLabel=至少需要有 [mb] MB 的可用磁碟空間。
CannotInstallToNetworkDrive=安裝程式無法安裝到一個網路驅動器。
CannotInstallToUNCPath=安裝程式無法安裝到一個UNC路徑。
InvalidPath=您必須輸入一個帶驅動器卷標的完整路徑，例如：%n%nC:\APP%n%n或下列形式的UNC路徑：%n%n\\server\share
InvalidDrive=您選定的驅動器或 UNC 共享不存在或不能訪問。請選選擇其它位置。
DiskSpaceWarningTitle=沒有足夠的磁碟空間
DiskSpaceWarning=安裝程式至少需要 %1 KB 的可用空間才能安裝，但選定驅動器只有 %2 KB 的可用空間。%n%n您一定要繼續嗎？
DirNameTooLong=資料夾名稱或路徑太長。
InvalidDirName=資料夾名稱無效。
BadDirName32=資料夾名稱不能包含下列任何字元：%n%n%1
DirExistsTitle=資料夾已存在
DirExists=資料夾：%n%n%1%n%n已經存在。您一定要安裝到這個資料夾中嗎？
DirDoesntExistTitle=資料夾不存在
DirDoesntExist=資料夾：%n%n%1%n%n不存在。您想要建立此資料夾嗎？

; *** “選擇元件”嚮導頁
WizardSelectComponents=選擇元件
SelectComponentsDesc=您想安裝哪些程式的元件？
SelectComponentsLabel2=選擇您想要安裝的元件；清除您不想安裝的元件。然後點選“下一步”繼續。
FullInstallation=完全安裝
; if possible don't translate 'Compact' as 'Minimal' (I mean 'Minimal' in your language)
CompactInstallation=簡潔安裝
CustomInstallation=自定義安裝
NoUninstallWarningTitle=元件已存在
NoUninstallWarning=安裝程式檢測到下列元件已在您的電腦中安裝：%n%n%1%n%n取消選定這些元件將不能解除安裝它們。%n%n您一定要繼續嗎？
ComponentSize1=%1 KB
ComponentSize2=%1 MB
ComponentsDiskSpaceGBLabel=當前選擇的元件至少需要 [gb] GB 的磁碟空間。
ComponentsDiskSpaceMBLabel=當前選擇的元件至少需要 [mb] MB 的磁碟空間。

; *** “選擇附加任務”嚮導頁
WizardSelectTasks=選擇附加任務
SelectTasksDesc=您想要安裝程式執行哪些附加任務？
SelectTasksLabel2=選擇您想要安裝程式在安裝 [name] 時執行的附加任務，然後點選“下一步”。

; *** “選擇開始選單資料夾”嚮導頁
WizardSelectProgramGroup=選擇開始選單資料夾
SelectStartMenuFolderDesc=安裝程式應該在哪裡放置程式的快捷方式？
SelectStartMenuFolderLabel3=安裝程式現在將在下列開始選單資料夾中建立程式的快捷方式。
SelectStartMenuFolderBrowseLabel=點選“下一步”繼續。如果您想選擇其它資料夾，點選“瀏覽”。
MustEnterGroupName=您必須輸入一個資料夾名。
GroupNameTooLong=資料夾名或路徑太長。
InvalidGroupName=資料夾名無效。
BadGroupName=資料夾名不能包含下列任何字元：%n%n%1
NoProgramGroupCheck2=不建立開始選單資料夾(&D)

; *** “準備安裝”嚮導頁
WizardReady=準備安裝
ReadyLabel1=安裝程式現在準備開始安裝 [name] 到您的電腦中。
ReadyLabel2a=點選“安裝”繼續此安裝程式。如果您想要回顧或修改設定，請點選“上一步”。
ReadyLabel2b=點選“安裝”繼續此安裝程式？
ReadyMemoUserInfo=使用者資訊：
ReadyMemoDir=目標位置：
ReadyMemoType=安裝型別：
ReadyMemoComponents=選定元件：
ReadyMemoGroup=開始選單資料夾：
ReadyMemoTasks=附加任務：

; *** TDownloadWizardPage wizard page and DownloadTemporaryFile
DownloadingLabel=正在下載附加檔案...
ButtonStopDownload=停止下載(&S)
StopDownload=您確定要停止下載嗎？
ErrorDownloadAborted=下載已中止
ErrorDownloadFailed=下載失敗：%1 %2
ErrorDownloadSizeFailed=獲取下載大小失敗：%1 %2
ErrorFileHash1=校驗檔案雜湊失敗：%1
ErrorFileHash2=無效的檔案雜湊：預期為 %1，實際為 %2
ErrorProgress=無效的進度：%1，總共%2
ErrorFileSize=檔案大小錯誤：預期為 %1，實際為 %2

; *** “正在準備安裝”嚮導頁
WizardPreparing=正在準備安裝
PreparingDesc=安裝程式正在準備安裝 [name] 到您的電腦中。
PreviousInstallNotCompleted=先前程式的安裝/解除安裝未完成。您需要重新啟動您的電腦才能完成安裝。%n%n在重新啟動電腦後，再執行安裝完成 [name] 的安裝。
CannotContinue=安裝程式不能繼續。請點選“取消”退出。
ApplicationsFound=下列應用程式正在使用的檔案需要更新設定。它是建議您允許安裝程式自動關閉這些應用程式。
ApplicationsFound2=下列應用程式正在使用的檔案需要更新設定。它是建議您允許安裝程式自動關閉這些應用程式。安裝完成後，安裝程式將嘗試重新啟動應用程式。
CloseApplications=自動關閉該應用程式(&A)
DontCloseApplications=不要關閉該應用程式(&D)
ErrorCloseApplications=安裝程式無法自動關閉所有應用程式。在繼續之前，我們建議您關閉所有使用需要更新的安裝程式檔案。
PrepareToInstallNeedsRestart=安裝程式必須重新啟動計算機。重新啟動計算機後，請再次執行安裝程式以完成 [name] 的安裝。%n%n是否立即重新啟動？

; *** “正在安裝”嚮導頁
WizardInstalling=正在安裝
InstallingLabel=安裝程式正在安裝 [name] 到您的電腦中，請稍等。

; *** “安裝完成”嚮導頁
FinishedHeadingLabel=[name] 安裝完成
FinishedLabelNoIcons=安裝程式已在您的電腦中安裝了 [name]。
FinishedLabel=安裝程式已在您的電腦中安裝了 [name]。此應用程式可以透過選擇安裝的快捷方式執行。
ClickFinish=點選“完成”退出安裝程式。
FinishedRestartLabel=要完成 [name] 的安裝，安裝程式必須重新啟動您的電腦。您想要立即重新啟動嗎？
FinishedRestartMessage=要完成 [name] 的安裝，安裝程式必須重新啟動您的電腦。%n%n您想要立即重新啟動嗎？
ShowReadmeCheck=是，我想查閱自述檔案
YesRadio=是，立即重新啟動電腦(&Y)
NoRadio=否，稍後重新啟動電腦(&N)
; used for example as 'Run MyProg.exe'
RunEntryExec=執行 %1
; used for example as 'View Readme.txt'
RunEntryShellExec=查閱 %1

; *** “安裝程式需要下一張磁碟”提示
ChangeDiskTitle=安裝程式需要下一張磁碟
SelectDiskLabel2=請插入磁碟 %1 並點選“確定”。%n%n如果這個磁碟中的檔案可以在下列資料夾之外的資料夾中找到，請輸入正確的路徑或點選“瀏覽”。
PathLabel=路徑(&P)：
FileNotInDir2=檔案“%1”不能在“%2”定位。請插入正確的磁碟或選擇其它資料夾。
SelectDirectoryLabel=請指定下一張磁碟的位置。

; *** 安裝狀態訊息
SetupAborted=安裝程式未完成安裝。%n%n請修正這個問題並重新執行安裝程式。
AbortRetryIgnoreSelectAction=選擇操作
AbortRetryIgnoreRetry=重試(&T)
AbortRetryIgnoreIgnore=忽略錯誤並繼續(&I)
AbortRetryIgnoreCancel=關閉安裝程式

; *** 安裝狀態訊息
StatusClosingApplications=正在關閉應用程式...
StatusCreateDirs=正在建立目錄...
StatusExtractFiles=正在解壓縮檔案...
StatusCreateIcons=正在建立快捷方式...
StatusCreateIniEntries=正在建立 INI 條目...
StatusCreateRegistryEntries=正在建立登錄檔條目...
StatusRegisterFiles=正在註冊檔案...
StatusSavingUninstall=正在儲存解除安裝資訊...
StatusRunProgram=正在完成安裝...
StatusRestartingApplications=正在重啟應用程式...
StatusRollback=正在撤銷更改...

; *** 其它錯誤
ErrorInternal2=內部錯誤：%1
ErrorFunctionFailedNoCode=%1 失敗
ErrorFunctionFailed=%1 失敗；錯誤程式碼 %2
ErrorFunctionFailedWithMessage=%1 失敗；錯誤程式碼 %2.%n%3
ErrorExecutingProgram=不能執行檔案：%n%1

; *** 登錄檔錯誤
ErrorRegOpenKey=開啟登錄檔項時出錯：%n%1\%2
ErrorRegCreateKey=建立登錄檔項時出錯：%n%1\%2
ErrorRegWriteKey=寫入登錄檔項時出錯：%n%1\%2

; *** INI 錯誤
ErrorIniEntry=在檔案“%1”中建立INI條目時出錯。

; *** 檔案複製錯誤
FileAbortRetryIgnoreSkipNotRecommended=跳過這個檔案(&S) (不推薦)
FileAbortRetryIgnoreIgnoreNotRecommended=忽略錯誤並繼續(&I) (不推薦)
SourceIsCorrupted=原始檔已損壞
SourceDoesntExist=原始檔“%1”不存在
ExistingFileReadOnly2=無法替換現有檔案，因為它是隻讀的。
ExistingFileReadOnlyRetry=移除只讀屬性並重試(&R)
ExistingFileReadOnlyKeepExisting=保留現有檔案(&K)
ErrorReadingExistingDest=嘗試讀取現有檔案時出錯：
FileExistsSelectAction=選擇操作
FileExists2=檔案已經存在。
FileExistsOverwriteExisting=覆蓋已經存在的檔案(&O)
FileExistsKeepExisting=保留現有的檔案(&K)
FileExistsOverwriteOrKeepAll=為所有的衝突檔案執行此操作(&D)
ExistingFileNewerSelectAction=選擇操作
ExistingFileNewer2=現有的檔案比安裝程式將要安裝的檔案更新。
ExistingFileNewerOverwriteExisting=覆蓋已經存在的檔案(&O)
ExistingFileNewerKeepExisting=保留現有的檔案(&K) (推薦)
ExistingFileNewerOverwriteOrKeepAll=為所有的衝突檔案執行此操作(&D)
ErrorChangingAttr=嘗試改變下列現有的檔案的屬性時出錯：
ErrorCreatingTemp=嘗試在目標目錄建立檔案時出錯：
ErrorReadingSource=嘗試讀取下列原始檔時出錯：
ErrorCopying=嘗試複製下列檔案時出錯：
ErrorReplacingExistingFile=嘗試替換現有的檔案時出錯：
ErrorRestartReplace=重新啟動替換失敗：
ErrorRenamingTemp=嘗試重新命名以下目標目錄中的一個檔案時出錯：
ErrorRegisterServer=無法註冊 DLL/OCX：%1
ErrorRegSvr32Failed=RegSvr32 失敗；退出程式碼 %1
ErrorRegisterTypeLib=無法註冊型別庫：%1

; *** 解除安裝顯示名字標記
; used for example as 'My Program (32-bit)'
UninstallDisplayNameMark=%1 (%2)
; used for example as 'My Program (32-bit, All users)'
UninstallDisplayNameMarks=%1 (%2, %3)
UninstallDisplayNameMark32Bit=32位
UninstallDisplayNameMark64Bit=64位
UninstallDisplayNameMarkAllUsers=所有使用者
UninstallDisplayNameMarkCurrentUser=當前使用者

; *** 安裝後錯誤
ErrorOpeningReadme=嘗試開啟自述檔案時出錯。
ErrorRestartingComputer=安裝程式不能重新啟動電腦，請手動重啟。

; *** 解除安裝訊息
UninstallNotFound=檔案“%1”不存在。無法解除安裝。
UninstallOpenError=檔案“%1”不能開啟。無法解除安裝。
UninstallUnsupportedVer=此版本的解除安裝程式無法識別解除安裝日誌檔案“%1”的格式。無法解除安裝
UninstallUnknownEntry=在解除安裝日誌中遇到一個未知的條目 (%1)
ConfirmUninstall=您確認想要完全刪除 %1 及它的所有元件嗎？
UninstallOnlyOnWin64=這個安裝程式只能在64位Windows中進行解除安裝。
OnlyAdminCanUninstall=這個安裝的程式需要有管理員許可權的使用者才能解除安裝。
UninstallStatusLabel=正在從您的電腦中刪除 %1，請稍等。
UninstalledAll=%1 已順利地從您的電腦中刪除。
UninstalledMost=%1 解除安裝完成。%n%n有一些內容無法被刪除。您可以手動刪除它們。
UninstalledAndNeedsRestart=要完成 %1 的解除安裝，您的電腦必須重新啟動。%n%n您想立即重新啟動電腦嗎？
UninstallDataCorrupted=檔案“%1”已損壞，無法解除安裝

; *** 解除安裝狀態訊息
ConfirmDeleteSharedFileTitle=刪除共享檔案嗎？
ConfirmDeleteSharedFile2=系統中包含的下列共享檔案已經不再被其它程式使用。您想要解除安裝程式刪除這些共享檔案嗎？%n%n如果這些檔案被刪除，但還有程式正在使用這些檔案，這些程式可能不能正確執行。如果您不能確定，選擇“否”。把這些檔案保留在系統中以免引起問題。
SharedFileNameLabel=檔名：
SharedFileLocationLabel=位置：
WizardUninstalling=解除安裝狀態
StatusUninstalling=正在解除安裝 %1...

; *** Shutdown block reasons
ShutdownBlockReasonInstallingApp=正在安裝 %1。
ShutdownBlockReasonUninstallingApp=正在解除安裝 %1。

; The custom messages below aren't used by Setup itself, but if you make
; use of them in your scripts, you'll want to translate them.

[CustomMessages]

NameAndVersion=%1 版本 %2
AdditionalIcons=附加快捷方式：
CreateDesktopIcon=建立桌面快捷方式(&D)
CreateQuickLaunchIcon=建立快速執行欄快捷方式(&Q)
ProgramOnTheWeb=%1 網站
UninstallProgram=解除安裝 %1
LaunchProgram=執行 %1
AssocFileExtension=將 %2 副檔名與 %1 建立關聯(&A)
AssocingFileExtension=正在將 %2 副檔名與 %1 建立關聯...
AutoStartProgramGroupDescription=啟動組：
AutoStartProgram=自動啟動 %1
AddonHostProgramNotFound=%1無法找到您所選擇的資料夾。%n%n您想要繼續嗎？
