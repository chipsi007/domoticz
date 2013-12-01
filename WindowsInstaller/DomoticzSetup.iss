; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Domoticz"
#define MyAppPublisher "Domoticz.com"
#define MyAppURL "http://www.domoticz.com/"
#define MyAppExeName "domoticz.exe"
#define NSSM "nssm.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{EC4A5746-2655-43CD-AC5F-73F4B2C12F46}
AppName={#MyAppName}
AppVersion=1.0
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
LicenseFile=..\domoticz\License.txt
OutputDir=.
OutputBaseFilename=DomoticzSetup
SetupIconFile=install.ico
Compression=lzma2
PrivilegesRequired=admin
SolidCompression=yes
UsePreviousAppDir=yes
DirExistsWarning=no
WizardImageFile=compiler:WizModernImage-IS.bmp
WizardSmallImageFile=compiler:WizModernSmallImage-IS.bmp

[Tasks]
Name: RunAsApp; Description: "Run as application "; Flags: exclusive;
Name: RunAsApp\desktopicon; Description: {cm:CreateDesktopIcon}; GroupDescription: {cm:AdditionalIcons}; 
Name: RunAsApp\quicklaunchicon; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked;
Name: RunAsApp\startupicon; Description: "Create a Startup Shortcut"; GroupDescription: "{cm:AdditionalIcons}"; 
Name: RunAsService; Description: "Run as service"; Flags: exclusive unchecked

[Files]
Source: "..\Release\domoticz.exe"; DestDir: {app}; Flags: ignoreversion;
Source: "..\domoticz\www\*"; DestDir: {app}\www; Flags: recursesubdirs createallsubdirs;
Source: "..\domoticz\Config\*"; DestDir: {app}\www; Flags: recursesubdirs createallsubdirs;
Source: "..\domoticz\scripts\*"; DestDir: {app}\scripts; Flags: recursesubdirs createallsubdirs;
Source: "..\Debug\sqlite3.dll"; DestDir: {app}; Flags: ignoreversion;
Source: "..\Debug\libcurl.dll"; DestDir: {app}; Flags: ignoreversion;
Source: "..\Manual\DomoticzManual.pdf"; DestDir: {app}; Flags: ignoreversion;
Source: "..\domoticz\History.txt"; DestDir: {app}; Flags: ignoreversion;
Source: "..\domoticz\svnversion.h"; DestDir: {app}; Flags: ignoreversion;
Source: "..\Release\nssm.exe"; DestDir: {app}; Flags: ignoreversion;

[Icons]
Name: "{group}\Domoticz"; Filename: "{app}\{#MyAppExeName}"; Parameters: "-www {code:GetParams}"; Tasks: RunAsApp; 
;Name: "{group}\Start Domoticz service"; Filename: "sc"; Parameters: "start {#MyAppName}"; Tasks: RunAsService; 
;Name: "{group}\Stop Domoticz service"; Filename: "sc"; Parameters: "stop {#MyAppName}"; Tasks: RunAsService; 
Name: "{group}\DomoticzManual.pdf"; Filename: "{app}\DomoticzManual.pdf"; 
Name: "{group}\{cm:ProgramOnTheWeb,Domoticz}"; Filename: "{#MyAppURL}";
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; 
Name: "{commonstartup}\Domoticz"; Filename: "{app}\{#MyAppExeName}"; Parameters: "-startupdelay 10 -www {code:GetParams}" ; Tasks: RunAsApp\startupicon
Name: "{commondesktop}\Domoticz"; Filename: "{app}\{#MyAppExeName}"; Parameters: "-www {code:GetParams}" ; Tasks: RunAsApp\desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\Domoticz"; Filename: "{app}\{#MyAppExeName}"; Tasks: RunAsApp\quicklaunchicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, "&", "&&")}}"; Flags: nowait postinstall skipifsilent runascurrentuser; Tasks: RunAsApp
Filename: "{app}\{#NSSM}"; Parameters: "install {#MyAppName} ""{app}\{#MyAppExeName}"" ""-www {code:GetParams}"""; Flags: runhidden; Tasks: RunAsService
Filename: "{sys}\net.exe"; Parameters: "start {#MyAppName}"; Flags: runhidden; Tasks: RunAsService


[PostCompile]
Name: "makedist.bat"

[Code]
var
  ConfigPage: TInputQueryWizardPage;

function GetParams(Value: string): string;
begin
  Result := ConfigPage.Values[0];
end;

procedure InitializeWizard;
begin
  // Create the page
  ConfigPage := CreateInputQueryPage(wpSelectComponents,
  'User settings', 'Port number', 'Please specify the port on which Domoticz will run');
  // Add items (False means it's not a password edit)
  ConfigPage.Add('Port number:', False);
  // Set initial values (optional)
  ConfigPage.Values[0] := ExpandConstant('8080');
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
begin
  if(CurStep = ssInstall) then begin
    Exec('sc',ExpandConstant('stop "{#MyAppName}"'),'', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    Exec('sc',ExpandConstant('delete "{#MyAppName}"'),'', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  ResultCode: Integer;
begin
  if CurUninstallStep = usUninstall then begin
    Exec('sc',ExpandConstant('stop "{#MyAppName}"'),'', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    Exec('sc',ExpandConstant('delete "{#MyAppName}"'),'', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    sleep(4000); //allow service to stop before deleting files
  end;
end;
