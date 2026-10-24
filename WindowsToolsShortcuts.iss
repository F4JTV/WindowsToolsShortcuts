; -----------------------------------------------------------------------------
; Windows tools desktop shortcuts installer (Inno Setup 7)
;
; The user picks one or both shortcuts to place on their own desktop:
;   "Son"                          -> C:\Windows\System32\control.exe mmsys.cpl
;                                     (Sound dialog: playback/recording devices)
;   "Gestionnaire de périphérique" -> C:\Windows\System32\devmgmt.msc
;                                     (Device Manager)
;
; Per-user install: no administrator rights needed.
; Keep this file UTF-8 encoded: the shortcut names contain accented characters.
; Silent install example: Setup.exe /VERYSILENT /COMPONENTS="sound,devmgr"
; -----------------------------------------------------------------------------

#define AppName      "Windows Tools Shortcuts"
#define AppVersion   "1.0.0"
#define SoundName    "Son"
#define DevMgrName   "Gestionnaire de périphérique"

[Setup]
; Unique ID used for the uninstall entry. Do not reuse it in another installer.
AppId={{3074DCB1-7E23-4733-9500-9A09EA471F73}
AppName={#AppName}
AppVersion={#AppVersion}

; Per-user install: no UAC prompt, shortcuts go to the user's own desktop.
PrivilegesRequired=lowest

; Only the uninstaller is written here: %LOCALAPPDATA%\Programs\<AppName>.
DefaultDirName={autopf}\{#AppName}
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyPage=yes

UninstallDisplayName={#AppName}

; UI language follows the Windows display language (English or French).
ShowLanguageDialog=auto
WizardStyle=modern

OutputDir=Output
OutputBaseFilename=WindowsToolsShortcuts-Setup
Compression=lzma2
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "french";  MessagesFile: "compiler:Languages\French.isl"

[CustomMessages]
english.TypeCustom=Selected shortcuts
french.TypeCustom=Raccourcis sélectionnés
english.CompSound={#SoundName} (sound devices)
french.CompSound={#SoundName} (périphériques audio)
english.CompDevMgr={#DevMgrName} (Device Manager)
french.CompDevMgr={#DevMgrName}
english.NothingSelected=Please select at least one shortcut to install.
french.NothingSelected=Veuillez sélectionner au moins un raccourci à installer.

[Types]
; Single custom type: the Select Components page shows plain checkboxes.
Name: "custom"; Description: "{cm:TypeCustom}"; Flags: iscustom

[Components]
; Both are checked by default; the user can untick either one.
Name: "sound";  Description: "{cm:CompSound}";  Types: custom
Name: "devmgr"; Description: "{cm:CompDevMgr}"; Types: custom

[Icons]
; Sound dialog, speaker icon from shell32.dll (same as the original shortcut).
Name: "{userdesktop}\{#SoundName}"; \
  Filename: "{sys}\control.exe"; \
  Parameters: "mmsys.cpl"; \
  WorkingDir: "{sys}"; \
  IconFilename: "{sys}\shell32.dll"; \
  IconIndex: 168; \
  Components: sound

; Device Manager. No IconFilename: Windows shows the icon embedded in the
; .msc console file (the Device Manager icon).
Name: "{userdesktop}\{#DevMgrName}"; \
  Filename: "{sys}\devmgmt.msc"; \
  WorkingDir: "{sys}"; \
  Components: devmgr

[InstallDelete]
; When Setup is run again with a shortcut unticked, remove that shortcut.
Type: files; Name: "{userdesktop}\{#SoundName}.lnk";  Components: not sound
Type: files; Name: "{userdesktop}\{#DevMgrName}.lnk"; Components: not devmgr

[Code]
// Refuse to continue when no shortcut is selected.
function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  if (CurPageID = wpSelectComponents) and (WizardSelectedComponents(False) = '') then
  begin
    MsgBox(CustomMessage('NothingSelected'), mbError, MB_OK);
    Result := False;
  end;
end;
