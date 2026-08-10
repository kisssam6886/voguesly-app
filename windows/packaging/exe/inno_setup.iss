[Setup]
AppId={{APP_ID}}
AppVersion={{APP_VERSION}}
AppName={{DISPLAY_NAME}}
AppPublisher={{PUBLISHER_NAME}}
AppPublisherURL={{PUBLISHER_URL}}
AppSupportURL={{PUBLISHER_URL}}
AppUpdatesURL={{PUBLISHER_URL}}
DefaultDirName={autopf}\Voguesly
DisableProgramGroupPage=yes
OutputDir=.
OutputBaseFilename={{OUTPUT_BASE_FILENAME}}
Compression=lzma
SolidCompression=yes
SetupIconFile={{SETUP_ICON_FILE}}
WizardStyle=modern
PrivilegesRequired={{PRIVILEGES_REQUIRED}}
ArchitecturesAllowed={{ARCH}}
ArchitecturesInstallIn64BitMode={{ARCH}}

[Code]
// ⚠️ 升级要「干净落场」,唔係净係 taskkill(2026-08-10 实测根因):
//   旧写法直接 `taskkill /f` 强杀 FlClashHelperService.exe,但**冇 sc stop / sc delete**,
//   服务注册留喺 SCM 度、状态係脏嘅。App 启动时 registerService() 见到服务仲喺(presence)
//   就行 `sc delete` → `sc create`;而强杀之后 `sc delete` 会令服务变成
//   **"marked for deletion"**,跟住同名 `sc create` 直接失败(error 1072),要等 SCM 释放晒
//   句柄先得。App 嗰边只重试 5 次 × 1 秒,远远唔够 → helper 起唔到 → TUN 建唔起 →
//   **用户装完新版有 4-7 分钟完全连唔上**,以为新版坏咗就退版(付费用户 uid=239 实测踩过)。
// 修法:装之前先 `sc stop` 畀佢自己干净收场,再 `sc delete` 清走注册,最后先 taskkill 兜底。
//   咁装完之后系统度冇残留服务记录,App 一开就 `sc create` 得,唔使等 SCM。
procedure StopAndRemoveHelperService;
var
  ResultCode: Integer;
begin
  // 1) 优雅停:畀服务自己收尾(释放 Wintun 适配器等资源),避免脏状态
  Exec('sc', 'stop FlClashHelperService', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Sleep(1500);
  // 2) 清走注册:此时进程已停,delete 唔会卡 "marked for deletion"
  Exec('sc', 'delete FlClashHelperService', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Sleep(500);
end;

procedure KillProcesses;
var
  Processes: TArrayOfString;
  i: Integer;
  ResultCode: Integer;
begin
  // ⚠️ 次序:先停+删服务,再强杀残留进程。倒转次序 = 又变返旧 bug。
  StopAndRemoveHelperService;

  Processes := ['Voguesly.exe', 'FlClash.exe', 'FlClashCore.exe', 'FlClashHelperService.exe'];

  for i := 0 to GetArrayLength(Processes)-1 do
  begin
    Exec('taskkill', '/f /im ' + Processes[i], '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  end;
end;

function InitializeSetup(): Boolean;
begin
  KillProcesses;
  Result := True;
end;

[Languages]
; ⚠️ Inno Setup 6 默认安装(含 CI 的 choco 安装)NOT bundle 中文 isl —— 用 compiler:Languages\Chinese*.isl 会
; 令 ISCC "Can't open file" 编译失败(只出 -setup_exe 暂存夹冇 installer)。故繁/简 isl 随仓库 vendor,
; 用相对路径引(与 SETUP_ICON_FILE 的 ..\windows\ 同基准,.iss 在 dist/ 编译)。英文 Default.isl 是内置故照用。
Name: "chineseSimplified"; MessagesFile: "..\windows\packaging\exe\ChineseSimplified.isl"
Name: "chineseTraditional"; MessagesFile: "..\windows\packaging\exe\ChineseTraditional.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: {% if CREATE_DESKTOP_ICON != true %}unchecked{% else %}checkedonce{% endif %}
[Files]
Source: "{{SOURCE_DIR}}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{{DISPLAY_NAME}}"; Filename: "{app}\{{EXECUTABLE_NAME}}"
Name: "{autodesktop}\{{DISPLAY_NAME}}"; Filename: "{app}\{{EXECUTABLE_NAME}}"; Tasks: desktopicon
[Run]
Filename: "{app}\{{EXECUTABLE_NAME}}"; Description: "{cm:LaunchProgram,{{DISPLAY_NAME}}}"; Flags: {% if PRIVILEGES_REQUIRED == 'admin' %}runascurrentuser{% endif %} nowait postinstall skipifsilent