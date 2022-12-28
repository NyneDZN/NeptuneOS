:: UPDATED NEPTUNE OS POST INSTALL SCRIPT

:: Created by nyne.#1431
:: These tweaks are only compiled by the author.

@echo off
setlocal EnableDelayedExpansion
set version=0.3
set dev=no
title NeptuneOS Post-Install Version %version%
color f0

:: Fullscreen, Kill Explorer and Kill Mouse
wscript "%WinDir%\NEPTUNE\FullscreenCMD.vbs" >NUL 2>&1
taskkill /f /im explorer.exe >NUL 2>&1
devmanview /disable "HID-compliant mouse" >NUL 2>&1

echo.
echo.
echo  Disclaimer:
echo  Do NOT close out of this Post Install script.
echo  This script will continue to setup NeptuneOS
echo  This may take between 2-5 minutes depending on your HDD/SSD speed.
echo  Please report any errors you may encounter in the OS or with this script.
echo  If you close this, please re-run it in C:\Windows\NEPTUNE.
echo  Press any key to continue the script.
echo.
echo.
timeout /t 300 >NUL 2>&1
cls

echo.
echo.
echo  888b    888                   888                               
echo  8888b   888     enjoy         888                               
echo  88888b  888                   888                               
echo  888Y88b 888  .d88b.  88888b.  888888 888  888 88888b.   .d88b.  
echo  888 Y88b888 d8P  Y8b 888 "88b 888    888  888 888 "88b d8P  Y8b 
echo  888  Y88888 88888888 888  888 888    888  888 888  888 88888888 
echo  888   Y8888 Y8b.     888 d88P Y88b.  Y88b 888 888  888 Y8b.     
echo  888    Y888  "Y8888  88888P"   "Y888  "Y88888 888  888  "Y8888  
echo                       888                                        
echo                       888                                        
echo                       888                                        
echo.
echo.
timeout /t 3 /nobreak >NUL 2>&1
cls
goto General



:General
echo Phase 1

:: NeptuneOS
start /b /wait "%windir%\NEPTUNE\VisualCppRedist_AIO_x86_x64.exe" /ai /gm2 >NUL 2>&1
"%windir%\NEPTUNE\DirectX\DXSETUP.exe" /silent >NUL 2>&1
"%windir%\NEPTUNE\MPC.exe" /VERYSILENT /NORESTART >NUL 2>&1
"%windir%\NEPTUNE\7z.exe" /S >NUL 2>&1
"%windir%\NEPTUNE\Open Shell.exe" /qn ADDLOCAL=StartMenu >NUL 2>&
nircmd shortcut "%windir%\Memory Cleaner.exe" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" "mc" > NUL 2>&1
nircmd shortcut "C:\POST INSTALL" "%userprofile%\Desktop" "Post-Install" > NUL 2>&1
nircmd shortcut "C:\Program Files\Open-Shell\StartMenu.exe" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" "StartMenu" > NUL 2>&1

:: Delete Microcode Updates
takeown /f C:\Windows\System32\mcupdate_GenuineIntel.dll >NUL 2>&1
takeown /f C:\Windows\System32\mcupdate_AuthenticAMD.dll >NUL 2>&1
del C:\Windows\System32\mcupdate_GenuineIntel.dll /s /f /q >NUL 2>&1
del C:\Windows\System32\mcupdate_AuthenticAMD.dll /s /f /q >NUL 2>&1

:: Delete obsolete registry keys
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\HotStart" /f > NUL 2>&1
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Sidebar" /f > NUL 2>&1
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Telephony" /f > NUL 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Screensavers" /f > NUL 2>&1
reg delete "HKCU\Printers" /f > NUL 2>&1
reg delete "HKLM\SYSTEM\ControlSet001\Control\Print" /f > NUL 2>&1
reg delete "HKCU\System\GameConfigStore\Children" /f > NUL 2>&1
reg delete "HKCU\System\GameConfigStore\Parents" /f > NUL 2>&1
reg delete "HKEY_USERS\.DEFAULT\System\GameConfigStore\Children" /f > NUL 2>&1
reg delete "HKEY_USERS\.DEFAULT\System\GameConfigStore\Parents" /f > NUL 2>&1

:: Limit System Logging
wevtutil sl Security /ms:48048576 > NUL 2>&1
wevtutil sl Application /ms:48048576 > NUL 2>&1
wevtutil sl Setup /ms:48048576 > NUL 2>&1
wevtutil sl System /ms:48048576 > NUL 2>&1
wevtutil sl "Windows Powershell" /ms:24048576 > NUL 2>&1
wevtutil sl "Microsoft-Windows-PowerShell/Operational" /ms:24048576 > NUL 2>&1
wevtutil sl "Microsoft-Windows-Sysmon/Operational" /ms:24048576 > NUL 2>&1
wevtutil sl "Microsoft-Windows-TaskScheduler/Operational" /e:true > NUL 2>&1
wevtutil sl "Microsoft-Windows-DNS-Client/Operational" /e:true > NUL 2>&1

:: Explorer Settings
Reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCortanaButton" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowInfoTip" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowStatusBar" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowPreviewHandlers" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SharingWizardOn" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarGlomLevel" /t REG_DWORD /d "2" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCompColor" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapFill" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "JointResize" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapAssist" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StoreAppsOnTaskbar" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "IconsOnly" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SeparateProcess" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseOLEDTaskbarTransparency" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DontPrettyPath" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HideRecentlyAddedApps" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "ShowOrHideMostUsedApps" /t REG_DWORD /d "2" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoDataExecutionPrevention" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoHeapTerminationOnCorruption" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoNewAppAlert" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableContextMenusInStart" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoSMConfigurePrograms" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRemoteRecursiveEvents" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoLowDiskSpaceChecks" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "LinkResolveIgnoreLinkInfo" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveSearch" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveTrack" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetOpenWith" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "MemCheckBoxInRunDlg" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Context Menu
Reg.exe delete "HKCR\*\OpenWithList\Excel.exe" /f > NUL 2>&1
Reg.exe delete "HKCR\*\OpenWithList\IExplore.exe" /f > NUL 2>&1
Reg.exe delete "HKCR\*\OpenWithList\MSPaint.exe" /f > NUL 2>&1
Reg.exe delete "HKCR\*\OpenWithList\Excel.exe" /f > NUL 2>&1
Reg.exe delete "HKCR\*\OpenWithList\Winword.exe" /f > NUL 2>&1
Reg.exe delete "HKCR\*\shellex\ContextMenuHandlers\ModernSharing" /f > NUL 2>&1
Reg.exe delete "HKCR\*\shellex\ContextMenuHandlers\Sharing" /f > NUL 2>&1
Reg.exe delete "HKCR\Directory\shellex\ContextMenuHandlers\Sharing" /f > NUL 2>&1
Reg.exe delete "HKCR\*\shellex\ContextMenuHandlers\Open With EncryptionMenu" /f > NUL 2>&1
Reg.exe delete "HKCR\*\shellex\PropertySheetHandlers\CryptoSignMenu" /f > NUL 2>&1
Reg.exe delete "HKLM\SOFTWARE\Classes\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" /f > NUL 2>&1
Reg.exe delete "HKLM\SOFTWARE\Classes\AllFilesystemObjects\shellex\ContextMenuHandlers\{474C98EE-CF3D-41f5-80E3-4AAB0AB04301}" /f > NUL 2>&1
Reg.exe delete "HKLM\SOFTWARE\Classes\AllFilesystemObjects\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f > NUL 2>&1
Reg.exe delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f > NUL 2>&1
Reg.exe delete "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f > NUL 2>&1
Reg.exe delete "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\Offline Files" /f > NUL 2>&1
Reg.exe delete "HKCR\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f > NUL 2>&1
Reg.exe delete "HKCR\Drive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f > NUL 2>&1
Reg.exe delete "HKCR\Directory\shellex\ContextMenuHandlers\Offline Files" /f > NUL 2>&1
Reg.exe delete "HKCR\Directory\shellex\CopyHookHandlers\Sharing" /f > NUL 2>&1
Reg.exe delete "HKCR\Drive\shellex\ContextMenuHandlers\Sharing" /f > NUL 2>&1
Reg.exe delete "HKCR\Drive\shellex\PropertySheetHandlers\Sharing" /f > NUL 2>&1
Reg.exe delete "HKCR\Drive\shellex\PropertySheetHandlers\{55B3A0BD-4D28-42fe-8CFB-FA3EDFF969B8}" /f > NUL 2>&1
Reg.exe delete "HKCR\Drive\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f > NUL 2>&1
Reg.exe delete "HKCR\Drive\shellex\PropertySheetHandlers\{7988B573-EC89-11cf-9C00-00AA00A14F56}" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{1d27f844-3a1f-4410-85ac-14651078412d}" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe delete "HKCR\exefile\shellex\ContextMenuHandlers\PintoStartScreen" /f > NUL 2>&1
Reg.exe delete "HKCR\SystemFileAssociations\image\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\SystemFileAssociations\text\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\batfile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\cmdfile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\docfile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\fonfile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\htmlfile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\inffile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\inifile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\JSEFile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\JSFile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\MSInfo.Document\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\otffile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\pfmfile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\regfile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\rtffile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\ttcfile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\ttffile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\txtfile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\VBEFile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\VBSFile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\Wordpad.Document.1\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\WPEDoc\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\WPSDoc\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\wrifile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\WSFFile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\odtfile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\docxfile\shell\print" /f > NUL 2>&1
Reg.exe delete "HKLM\SOFTWARE\Classes\InternetShortcut\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\AcroExch.Document.7\shell\print" /f > NUL 2>&1
Reg.exe delete "HKCR\FoxitReader.Document\shell\print" /f > NUL 2>&1
Reg.exe delete "HKLM\SOFTWARE\Classes\Folder\shell\pintohome" /f > NUL 2>&1
Reg.exe delete "HKCR\Folder\shellex\ContextMenuHandlers\Offline Files" /f > NUL 2>&1
Reg.exe delete "HKCR\Folder\shellex\ContextMenuHandlers\Library Location" /f > NUL 2>&1
Reg.exe delete "HKCR\Folder\shellex\ContextMenuHandlers\PinToStartScreen" /f > NUL 2>&1
Reg.exe delete "HKCR\*\shellex\ContextMenuHandlers\{90AA3A4E-1CBA-4233-B8BB-535773D48449}" /f > NUL 2>&1
Reg.exe delete "HKCR\SystemFileAssociations\image\shell\edit" /f > NUL 2>&1
Reg.exe delete "HKCR\SystemFileAssociations\image\shell\Image Preview" /f > NUL 2>&1
Reg.exe delete "HKCR\SystemFileAssociations\.bmp\ShellEx\ContextMenuHandlers\ShellImagePreview" /f > NUL 2>&1
Reg.exe delete "HKCR\SystemFileAssociations\.gif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f > NUL 2>&1
Reg.exe delete "HKCR\SystemFileAssociations\.jpg\ShellEx\ContextMenuHandlers\ShellImagePreview" /f > NUL 2>&1
Reg.exe delete "HKCR\SystemFileAssociations\.jpeg\ShellEx\ContextMenuHandlers\ShellImagePreview" /f > NUL 2>&1
Reg.exe delete "HKCR\SystemFileAssociations\.png\ShellEx\ContextMenuHandlers\ShellImagePreview" /f > NUL 2>&1
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f > NUL 2>&1
Reg.exe delete "HKCR\*\shellex\ContextMenuHandlers\Open With" /f > NUL 2>&1

:: Disable wide context menu
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\FlightedFeatures" /v "ImmersiveContextMenu" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Take Ownership
Reg.exe add "HKCR\*\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f > NUL 2>&1
Reg.exe add "HKCR\*\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCR\*\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f > NUL 2>&1 \"%%1\" && icacls \"%%1\" /grant administrators:F" /f > NUL 2>&1
Reg.exe add "HKCR\*\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f > NUL 2>&1 \"%%1\" && icacls \"%%1\" /grant administrators:F" /f > NUL 2>&1
Reg.exe add "HKCR\Directory\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f > NUL 2>&1
Reg.exe add "HKCR\Directory\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCR\Directory\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f > NUL 2>&1 \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f > NUL 2>&1
Reg.exe add "HKCR\Directory\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f > NUL 2>&1 \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "MultipleInvokePromptMinimum" /t REG_DWORD /d "200" /f > NUL 2>&1

:: Import Powerplan
Reg.exe add "HKCR\.pow" /ve /t REG_SZ /d "Power Plan" /f > NUL 2>&1
Reg.exe add "HKCR\.pow" /v "FriendlyTypeName" /t REG_SZ /d "Power Plan" /f > NUL 2>&1
Reg.exe add "HKCR\.pow\DefaultIcon" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\powercfg.cpl,-202" /f > NUL 2>&1
Reg.exe add "HKCR\.pow\shell\Import\command" /ve /t REG_SZ /d "powercfg /import \"%%1\"" /f > NUL 2>&1

:: New Batch File in context menu
reg add "HKEY_LOCAL_MACHINE\Software\Classes\.bat\ShellNew" /v "NullFile" /t REG_SZ /d "" /f > NUL 2>&1
reg add "HKEY_LOCAL_MACHINE\Software\Classes\.bat\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\System32\acppage.dll,-6002" /f > NUL 2>&1

:: Remove "- Shortcut" text from shortcuts
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates" /v "ShortcutNameTemplate" /t REG_SZ /d "\"%%s.lnk\"" /f > NUL 2>&1

:: Hide Lock & sleep
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v "ShowSleepOption" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v "ShowLockOption" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Change theme to dark mode
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 0 /f > NUL 2>&1

:: Pin 0 contacts to taskbar
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v "TaskbarCapacity" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Hide Lock & sleep
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v "ShowSleepOption" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v "ShowLockOption" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Unhide icons, don't put them in the sys tray
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Pointer Scheme to 'none'
Reg.exe add "HKCU\Control Panel\Cursors" /v "AppStarting" /t REG_EXPAND_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Cursors" /v "Arrow" /t REG_EXPAND_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Cursors" /v "ContactVisualization" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Cursors" /v "Crosshair" /t REG_EXPAND_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Cursors" /v "GestureVisualization" /t REG_DWORD /d "31" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Cursors" /v "Hand" /t REG_EXPAND_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Cursors" /v "Help" /t REG_EXPAND_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Cursors" /v "IBeam" /t REG_EXPAND_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Cursors" /v "No" /t REG_EXPAND_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Cursors" /v "NWPen" /t REG_EXPAND_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Cursors" /v "Scheme Source" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Cursors" /v "SizeAll" /t REG_EXPAND_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Cursors" /v "SizeNESW" /t REG_EXPAND_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Cursors" /v "SizeNS" /t REG_EXPAND_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Cursors" /v "SizeNWSE" /t REG_EXPAND_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Cursors" /v "SizeWE" /t REG_EXPAND_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Cursors" /v "UpArrow" /t REG_EXPAND_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Cursors" /v "Wait" /t REG_EXPAND_SZ /d "" /f > NUL 2>&1

:: Color Scheme to grey
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentColorMenu" /t REG_DWORD /d "4285226065" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentPalette" /t REG_BINARY /d "9FB4D1008A9DB6006E7D9100515C6B003B445200262F3B001C232E00EF695000" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "StartColorMenu" /t REG_DWORD /d "4283581499" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "AccentColor" /t REG_DWORD /d "4285226065" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationAfterglow" /t REG_DWORD /d "3293666411" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationColor" /t REG_DWORD /d "3293666411" /f > NUL 2>&1

:: DWM
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableWindowColorization" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "Composition" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowComposition" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DWMWA_TRANSITIONS_FORCEDISABLED" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "DisableDrawListCaching" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "DisallowNonDrawListRendering" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "EnableCpuClipping" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "EnableDrawToBackbuffer" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "EnableImageProcessing" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "EnableMPCPerfCounter" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "TelemetryFramesSequenceMaximumPeriodMilliseconds" /t REG_DWORD /d "500" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "UseHWDrawListEntriesOnWARP" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d "5" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "DwmInputUsesIoCompletionPort" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "EnableDwmInputProcessing" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm\ExtendedComposition" /v "ExclusiveModeFramerateAveragingPeriodMs" /t REG_DWORD /d "1000" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm\ExtendedComposition" /v "ExclusiveModeFramerateThresholdPercent" /t REG_DWORD /d "250" /f >nul 2>&1

:: Visuals
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\AnimateMinMax" /v "DefaultApplied" /t REG_SZ /d "0" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ComboBoxAnimation" /v "DefaultApplied" /t REG_SZ /d "0" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ControlAnimations" /v "DefaultApplied" /t REG_SZ /d "0" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\CursorShadow" /v "DefaultApplied" /t REG_SZ /d "0" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\DragFullWindows" /v "DefaultApplied" /t REG_SZ /d "0" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\DropShadow" /v "DefaultApplied" /t REG_SZ /d "0" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\DWMAeroPeekEnabled" /v "DefaultApplied" /t REG_SZ /d "0" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\DWMSaveThumbnailEnabled" /v "DefaultApplied" /t REG_SZ /d "0" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\FontSmoothing" /v "DefaultApplied" /t REG_SZ /d "0" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ListBoxSmoothScrolling" /v "DefaultApplied" /t REG_SZ /d "0" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ListviewAlphaSelect" /v "DefaultApplied" /t REG_SZ /d "0" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ListviewShadow" /v "DefaultApplied" /t REG_SZ /d "0" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\MenuAnimation" /v "DefaultApplied" /t REG_SZ /d "0" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\SelectionFade" /v "DefaultApplied" /t REG_SZ /d "0" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TaskbarAnimations" /v "DefaultApplied" /t REG_SZ /d "0" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ThumbnailsOrIcon" /v "DefaultApplied" /t REG_SZ /d "0" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TooltipAnimation" /v "DefaultApplied" /t REG_SZ /d "0" /f >nul 2>&1

:: BSOD settings
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Desktop Timeouts
Reg.exe add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "8" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "1000" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Desktop" /v "LowLevelHooksTimeout" /t REG_SZ /d "1000" /f > NUL 2>&1
Reg.exe add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "100" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "5000" /f > NUL 2>&1

:: Disable Windows Insider and Build Previews
reg add "HKLM\Software\Microsoft\WindowsSelfHost\UI\Visibility" /v "HideInsiderPage" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableConfigFlighting" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableExperimentation" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable all remote terminal services logons to the server
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "WinStationsDisabled" /t REG_SZ /d "1" /f > NUL 2>&1

:: Disable Motion Data 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMotion" /t REG_DWORD /d 2 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMotion_UserInControlOfTheseApps" /t REG_MULTI_SZ /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMotion_ForceAllowTheseApps" /t REG_MULTI_SZ /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMotion_ForceDenyTheseApps" /t REG_MULTI_SZ /f > NUL 2>&1

:: Disable Driver Updates
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate" /v "value" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate" /v "value" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable USB Autorun/play
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable Windows Updates
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "UseWUServer" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "IncludeRecommendedUpdates" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DoNotConnectToWindowsUpdateInternetLocations" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "UpdateServiceUrlAlternate" /t REG_SZ /d "http://disableupdateserver.com/" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUServer" /t REG_SZ /d "http://disableupdateserver.com/" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUStatusServer" /t REG_SZ /d "http://disableupdateserver.com/" /f > NUL 2>&1
Reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgrade" /f > NUL 2>&1

:: Disable Diagnostic Tracing
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Diagnostics\Performance" /v "DisableDiagnosticTracing" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable Events
reg add "HKLM\SOFTWARE\Microsoft\Wbem\CIMOM" /v "EnableEvents" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Motion Data 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMotion" /t REG_DWORD /d 2 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMotion_UserInControlOfTheseApps" /t REG_MULTI_SZ /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMotion_ForceAllowTheseApps" /t REG_MULTI_SZ /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMotion_ForceDenyTheseApps" /t REG_MULTI_SZ /f > NUL 2>&1

:: Disable OLE Logging
Reg.exe add "HKLM\SOFTWARE\Microsoft\Ole" /v "ActivationFailureLoggingLevel" /t REG_DWORD /d "2" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Ole" /v "CallFailureLoggingLevel" /t REG_DWORD /d "2" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Ole" /v "ActivationFailureLoggingLevel" /t REG_DWORD /d "2" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Ole" /v "CallFailureLoggingLevel" /t REG_DWORD /d "2" /f > NUL 2>&1

:: Disable Internet Addons
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF90-7B36-11D2-B20E-00C04F983E60}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF90-7B36-11D2-B20E-00C04F983E60}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF91-7B36-11D2-B20E-00C04F983E60}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF91-7B36-11D2-B20E-00C04F983E60}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF94-7B36-11D2-B20E-00C04F983E60}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF94-7B36-11D2-B20E-00C04F983E60}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{3050F819-98B5-11CF-BB82-00AA00BDCE0B}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{3050F819-98B5-11CF-BB82-00AA00BDCE0B}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{333C7BC4-460F-11D0-BC04-0080C7055A83}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{333C7BC4-460F-11D0-BC04-0080C7055A83}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{373984C9-B845-449B-91E7-45AC83036ADE}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{373984C9-B845-449B-91E7-45AC83036ADE}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{64AB4BB7-111E-11D1-8F79-00C04FC2FBE1}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{64AB4BB7-111E-11D1-8F79-00C04FC2FBE1}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{6BF52A52-394A-11D3-B153-00C04F79FAA6}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{6BF52A52-394A-11D3-B153-00C04F79FAA6}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{884E2049-217D-11DA-B2A4-000E7BBB2B09}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{884E2049-217D-11DA-B2A4-000E7BBB2B09}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{884E2051-217D-11DA-B2A4-000E7BBB2B09}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{884E2051-217D-11DA-B2A4-000E7BBB2B09}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A05-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A05-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A06-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A06-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A07-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A07-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A08-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A08-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A0A-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A0A-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{8E4062D9-FE1B-4B9E-AA16-5E8EEF68F48E}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{8E4062D9-FE1B-4B9E-AA16-5E8EEF68F48E}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{D2517915-48CE-4286-970F-921E881B8C5C}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{D2517915-48CE-4286-970F-921E881B8C5C}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{EE09B103-97E0-11CF-978F-00A02463E06F}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{EE09B103-97E0-11CF-978F-00A02463E06F}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F32-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F32-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F33-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F33-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F34-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F34-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F35-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F35-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F36-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F36-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F39-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F39-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F6D90F12-9C73-11D3-B32E-00C04F990BB4}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F6D90F12-9C73-11D3-B32E-00C04F990BB4}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F6D90F14-9C73-11D3-B32E-00C04F990BB4}" /v "Version" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F6D90F14-9C73-11D3-B32E-00C04F990BB4}" /v "Flags" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{2933BF90-7B36-11D2-B20E-00C04F983E60}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{2933BF91-7B36-11D2-B20E-00C04F983E60}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{2933BF94-7B36-11D2-B20E-00C04F983E60}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{3050F819-98B5-11CF-BB82-00AA00BDCE0B}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{333C7BC4-460F-11D0-BC04-0080C7055A83}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{373984C9-B845-449B-91E7-45AC83036ADE}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{64AB4BB7-111E-11D1-8F79-00C04FC2FBE1}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{6BF52A52-394A-11D3-B153-00C04F79FAA6}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{884E2049-217D-11DA-B2A4-000E7BBB2B09}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{884E2051-217D-11DA-B2A4-000E7BBB2B09}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A05-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A06-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A07-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A08-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A0A-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{8E4062D9-FE1B-4B9E-AA16-5E8EEF68F48E}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{D2517915-48CE-4286-970F-921E881B8C5C}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{EE09B103-97E0-11CF-978F-00A02463E06F}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F32-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F33-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F34-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F35-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F36-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F39-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F6D90F12-9C73-11D3-B32E-00C04F990BB4}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F6D90F14-9C73-11D3-B32E-00C04F990BB4}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f > NUL 2>&1

:: Disable Metadata Retrieval
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d 1 /f > NUL 2>&1

:: Disable Background Apps
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d "2" /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable Suggested Content
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /d "0" /t REG_DWORD /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /d "0" /t REG_DWORD /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /d "0" /t REG_DWORD /f > NUL 2>&1

:: Disable Lockscreen Content
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338387Enabled" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-314563Enabled" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d "0" /f >NUL 2>&1

:: Disable Silent Apps
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f

:: Disable Settings Header
reg add "HKLM\System\CurrentControlSet\Control\FeatureManagement\Overrides\4\2674077835" /v "EnabledState" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\System\CurrentControlSet\Control\FeatureManagement\Overrides\4\2674077835" /v "EnabledStateOptions" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\System\CurrentControlSet\Control\FeatureManagement\Overrides\4\4095660171" /v "EnabledState" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\System\CurrentControlSet\Control\FeatureManagement\Overrides\4\4095660171" /v "EnabledStateOptions" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable Reserved Storage
DISM /Online /Set-ReservedStorageState /State:Disabled > NUL 2>&1

:: Disable OneDrive Sync
Reg add "HKLM\Software\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable Settings Sync
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /v "DisableSyncOnPaidNetwork" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t REG_DWORD /d "5" /f > NUL 2>&1

:: Disable Remote Font Boot Cache
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\GRE_Initialize" /v "DisableRemoteFontBootCache" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\GRE_Initialize" /v "DisableRemoteFontBootCache" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\MUI\StringCacheSettings" /v "StringCacheGeneration" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable Component Based Servicing Logs & DCOM
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing" /v "EnableLog" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing" /v "EnableDpxLog" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Component Based Servicing" /v "EnableLog" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Component Based Servicing" /v "EnableDpxLog" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Ole" /v "EnableDCOM" /t REG_SZ /d "N" /f > NUL 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Ole" /v "EnableDCOM" /t REG_SZ /d "N" /f > NUL 2>&1

:: Disable Firewall
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "DisableNotifications" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "DoNotAllowExceptions" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v "DisableNotifications" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v "DoNotAllowExceptions" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "DisableNotifications" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "DoNotAllowExceptions" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable Notifications
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "DatabaseMigrationCompleted" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "LockScreenToastEnabled" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable Telemetry 
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /d "0" /t REG_DWORD /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowClipboardHistory" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowCrossDeviceClipboard" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Cortana
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /t REG_DWORD /d "0" /f >nul 2>&1 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Experience\AllowCortana" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortanaAboveLock" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Speech_OneCore\Preferences" /v "VoiceActivationOn" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Speech_OneCore\Preferences" /v "VoiceActivationDefaultOn" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Speech_OneCore\Preferences" /v "VoiceActivationEnableAboveLockscreen" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CanCortanaBeEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Power Logging
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "DisableTaggedEnergyLogging" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxApplication" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxTagPerApplication" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable live tiles
reg add "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable Error Reporting
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t "REG_DWORD" /d "1" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Defender 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpynetReporting" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable Storage Sense
reg add "HKLM\Software\Policies\Microsoft\Windows\StorageSense" /v "AllowStorageSenseGlobal" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable Troubleshooting
Reg.exe add "HKLM\SOFTWARE\Microsoft\WindowsMitigation" /v "UserPreference" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable Voice Activation 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /v "AgentActivationEnabled" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /v "AgentActivationLastUsed" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable automatic map updates
Reg.exe add "HKLM\SYSTEM\Maps" /v "AutoUpdateEnabled" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable share across devices 
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\CDP" /v "CdpSessionUserAuthzPolicy" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\CDP" /v "NearShareChannelUserAuthzPolicy" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\CDP" /v "RomeSdkChannelUserAuthzPolicy" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable 'delete temporary files that my apps aren't using'
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "04" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "01" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "2048" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "08" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "256" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "32" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable Web in Search
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable Remote Assistance
reg add "HKLM\System\CurrentControlSet\Control\Remote Assistance" /v "fEnableChatControl" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Remote Assistance" /v "fAllowFullControl" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable Windows Feedback
reg del "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Focus Assist 
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$$windows.data.notifications.quiethourssettings\Current" /v "Data" /t REG_BINARY /d "02000000B4672B68F00BD8010000000043420100C20A01D214284D006900630072006F0073006F00660074002E005100750069006500740048006F00750072007300500072006F00660069006C0065002E0055006E007200650073007400720069006300740065006400CA28D014020000" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$quietmomentfullscreen$windows.data.notifications.quietmoment\Current" /v "Data" /t REG_BINARY /d "02000000971D2D68F00BD8010000000043420100C20A01D21E264D006900630072006F0073006F00660074002E005100750069006500740048006F00750072007300500072006F00660069006C0065002E0041006C00610072006D0073004F006E006C007900C22801CA500000" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$quietmomentgame$windows.data.notifications.quietmoment\Current" /v "Data" /t REG_BINARY /d "020000006C392D68F00BD8010000000043420100C20A01D21E284D006900630072006F0073006F00660074002E005100750069006500740048006F00750072007300500072006F00660069006C0065002E005000720069006F0072006900740079004F006E006C007900C22801CA500000" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$quietmomentpostoobe$windows.data.notifications.quietmoment\Current" /v "Data" /t REG_BINARY /d "0200000006542D68F00BD8010000000043420100C20A01D21E284D006900630072006F0073006F00660074002E005100750069006500740048006F00750072007300500072006F00660069006C0065002E005000720069006F0072006900740079004F006E006C007900C22801CA500000" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$quietmomentpresentation$windows.data.notifications.quietmoment\Current" /v "Data" /t REG_BINARY /d "02000000836E2D68F00BD8010000000043420100C20A01D21E264D006900630072006F0073006F00660074002E005100750069006500740048006F00750072007300500072006F00660069006C0065002E0041006C00610072006D0073004F006E006C007900C22801CA500000" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$quietmomentscheduled$windows.data.notifications.quietmoment\Current" /v "Data" /t REG_BINARY /d "020000002E8A2D68F00BD8010000000043420100C20A01D21E284D006900630072006F0073006F00660074002E005100750069006500740048006F00750072007300500072006F00660069006C0065002E005000720069006F0072006900740079004F006E006C007900C22801D13280E0AA8A9930D13C80E0F6C5D50ECA500000" /f > NUL 2>&1

:: Disable Spotlight
Reg.exe add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "ConfigureWindowsSpotlight" /t REG_DWORD /d "2" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "IncludeEnterpriseSpotlight" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightFeatures" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightWindowsWelcomeExperience" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightOnActionCenter" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightOnSettings" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableThirdPartySuggestions" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableTailoredExperiencesWithDiagnosticData" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable Maintenance
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\ScheduledDiagnostics" /v "EnabledExecution" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\ScheduledDiagnostics" /v "EnabledExecution" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable startup delay for RunOnce and Run keys
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DelayedDesktopSwitchTimeout" /t reg_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t reg_DWORD /d "0" /f > NUL 2>&1

:: Disable CEIP
reg add "HKCU\Software\Policies\Microsoft\Messenger\Client" /v "CEIP" /t REG_DWORD /d "2" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\AppV\CEIP" /v "CEIPEnable" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable Location
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /d "0" /t REG_DWORD /f > NUL 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "Value" /t REG_SZ /d "Deny" /f > NUL 2>&1

:: Disable FTH
reg add "HKLM\Software\Microsoft\FTH" /v "Enabled" /t reg_DWORD /d "0" /f > NUL 2>&1

:: Disable Smartscreen 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d 0 /f > NUL 2>&1

:: Disable Speech Model Updates
reg add "HKLM\Software\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable Tips
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable Camera Access when locked
reg add "HKLM\Software\Policies\Microsoft\Windows\Personalization" /v "NoLockScreenCamera" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable Steps Recorder
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d 1 /f > NUL 2>&1

:: Disable tablet mode
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "TabletMode" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable 'use my sign-in info after restart'
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableAutomaticRestartSignOn" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable 'let windows improve start and search results'
Reg.exe add "HKCU\Software\Policies\Microsoft\Windows\EdgeUI" /v "DisableMFUTracking" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\EdgeUI" /v "DisableMFUTracking" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable personal inking and typing dictionary
Reg.exe add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable cloud content search 
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsAADCloudSearchEnabled" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsMSACloudSearchEnabled" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable magnifier settings
Reg.exe add "HKCU\SOFTWARE\Microsoft\ScreenMagnifier" /v "FollowCaret" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\ScreenMagnifier" /v "FollowNarrator" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\ScreenMagnifier" /v "FollowMouse" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\ScreenMagnifier" /v "FollowFocus" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable narrator settings
Reg.exe add "HKCU\SOFTWARE\Microsoft\Narrator" /v "IntonationPause" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Narrator" /v "ReadHints" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Narrator" /v "ErrorNotificationType" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Narrator" /v "EchoChars" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Narrator" /v "EchoWords" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Narrator\NarratorHome" /v "MinimizeType" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Narrator\NarratorHome" /v "AutoStart" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Narrator\NoRoam" /v "EchoToggleKeys" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable 'store my activity history'
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable look for app in the store
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable Action Center
Reg.exe add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable Web Search in taskbar 
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable Search History
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsDeviceSearchHistoryEnabled" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable timeline
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable automatic folder type discovery
Reg.exe delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v "FolderType" /t REG_SZ /d "NotSpecified" /f > NUL 2>&1

:: Disable Printer Management
Reg.exe add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v "LegacyDefaultPrinterMode" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable USB prompts
Reg.exe add "HKCU\SOFTWARE\Microsoft\Shell\USB" /v "NotifyOnUsbErrors" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Shell\USB" /v "NotifyOnWeakCharger" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable startup sound
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" /v "DisableStartupSound" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable 'you have new apps that can open this type of file'
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoNewAppAlert" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable people bar
Reg.exe add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "HidePeopleBar" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Disable virtual desktop hover
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "HoverSelectDesktops" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable null cipher
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\NULL" /f /v Enabled /t REG_DWORD /d 0x00000000 > NUL 2>&1

:: Disable visual feedback
Reg.exe add "HKCU\Control Panel\Cursors" /v "ContactVisualization" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Cursors" /v "GestureVisualization" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable null cipher
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\NULL" /f /v Enabled /t REG_DWORD /d 0x00000000

:: Disable connect now wizard
reg add "HKLM\Software\Policies\Microsoft\Windows\WCN\UI" /v "DisableWcnUi" /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars" /v "DisableFlashConfigRegistrar" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars" /v "DisableInBand802DOT11Registrar" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars" /v "DisableUPnPRegistrar" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars" /v "DisableWPDRegistrar" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars" /v "EnableRegistrars" /t REG_DWORD /d 0 /f > NUL 2>&1

:: Disable AutoLoggers
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AppModel" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Cellcore" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Circular Kernel Context Logger" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\CloudExperienceHostOobe" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DataMarket" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DefenderApiLogger" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DefenderAuditLogger" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DiagLog" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\HolographicDevice" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\iclsClient" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\iclsProxy" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\LwtNetLog" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Mellanox-Kernel" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Microsoft-Windows-AssignedAccess-Trace" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Microsoft-Windows-Setup" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\NBSMBLOGGER" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\PEAuthLog" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\RdrLog" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\ReadyBoot" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SetupPlatform" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SetupPlatformTel" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SocketHeciServer" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SpoolerLogger" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SQMLogger" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\TCPIPLOGGER" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\TileStore" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Tpm" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\TPMProvisioningService" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\UBPM" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WdiContextLog" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WFP-IPsec Trace" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WiFiDriverIHVSession" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WiFiDriverIHVSessionRepro" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WiFiSession" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WinPhoneCritical" /v "Start" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Tweak login times
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DelayedDesktopSwitchTimeout" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Enable reset base in DISM component store
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Configuration" /v "DisableResetbase" /t "REG_DWORD" /d "0" /f > NUL 2>&1

:: Legacy volume control
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" /v "EnableMtcUvc" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Legact alt-tab 
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "AltTabSettings" /t REG_DWORD /d "1" /f > NUL 2>&1

:: No Language Bar
Reg.exe add "HKCU\Software\Microsoft\CTF\LangBar" /v "ShowStatus" /t REG_DWORD /d "3" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\CTF\LangBar" /v "ExtraIconsOnMinimized" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\CTF\LangBar" /v "Transparency" /t REG_DWORD /d "255" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\CTF\LangBar" /v "Label" /t REG_DWORD /d "0" /f > NUL 2>&1

:: No Firewall Rules
Reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /f > NUL 2>&1

:: System UAC
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableVirtualization" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableInstallerDetection" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableSecureUIAPaths" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "ValidateAdminCodeSignatures" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableUIADesktopToggle" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorUser" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "FilterAdministratorToken" /t REG_DWORD /d "0" /f >NUL 2>&1

:: Always unload DLL
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "AlwaysUnloadDLL" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AlwaysUnloadDLL" /v "Default" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Audio Panel
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" /v "EnableMtcUvc" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d "3" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowHiddenDevices" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowDisconnectedDevices" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Multimedia\Audio\DeviceCpl" /v "VolumeUnits" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore" /f > NUL 2>&1

:: Application Compatibility
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableEngine" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Harden LSASS
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe" /v "AuditLevel" /t REG_DWORD /d "8" /f > NUL 2>&1
Reg add "HKLM\Software\Policies\Microsoft\Windows\CredentialsDelegation" /v "AllowProtectedCreds" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdminOutboundCreds" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdmin" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "RunAsPPL" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\SecurityProviders\WDigest" /v "Negotiate" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\SecurityProviders\WDigest" /v "UseLogonCredential" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disallow App Permissions
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /v "Value" /t REG_SZ /d "Deny" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /v "Value" /t REG_SZ /d "Deny" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /v "Value" /t REG_SZ /d "Deny" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t REG_SZ /d "Deny" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /v "Value" /t REG_SZ /d "Deny" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /v "Value" /t REG_SZ /d "Deny" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /v "Value" /t REG_SZ /d "Allow" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /v "Value" /t REG_SZ /d "Deny" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /v "Value" /t REG_SZ /d "Deny" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t REG_SZ /d "Deny" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /v "Value" /t REG_SZ /d "Deny" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /v "Value" /t REG_SZ /d "Deny" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /v "Value" /t REG_SZ /d "Allow" /f > NUL 2>&1

:: Keyboard & Mouse configuration
Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatDelay" /t REG_SZ /d "200" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatRate" /t REG_SZ /d "6" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "BounceTime" /t REG_SZ /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "DelayBeforeAcceptance" /t REG_SZ /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_SZ /d "59" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last BounceKey Setting" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last Valid Delay" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last Valid Repeat" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last Valid Wait" /t REG_DWORD /d "1000" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "506" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_SZ /d "58" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Accessibility\MouseKeys" /v "Flags" /t REG_SZ /d "38" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Keyboard" /v "KeyboardDelay" /t REG_SZ /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Control Panel\Keyboard" /v "KeyboardSpeed" /t REG_SZ /d "31" /f > NUL 2>&1
Reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d "0000000000000000156e000000000000004001000000000029dc0300000000000000280000000000" /f > NUL 2>&1
Reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d "0000000000000000fd11010000000000002404000000000000fc12000000000000c0bb0100000000" /f > NUL 2>&1
Reg add "HKEY_USERS\.DEFAULT\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f > NUL 2>&1
Reg add "HKEY_USERS\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f > NUL 2>&1
Reg add "HKEY_USERS\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f > NUL 2>&1
Reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f > NUL 2>&1
Reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d > NUL 2>&1

:: Windows Media Player
reg add "HKLM\Software\Policies\Microsoft\WMDRM" /v "DisableOnline" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\WindowsMediaPlayer" /v "GroupPrivacyAcceptance" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v "AcceptedEULA" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v "FirstTime" /t REG_DWORD /d "1" /f > NUL 2>&1

:: Internet Explorer 
reg add "HKLM\Software\Microsoft\Internet Explorer\Main" /v "NoUpdateCheck" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\Software\Microsoft\Internet Explorer\Main" /v "Enable Browser Extensions" /t REG_SZ /d "no" /f > NUL 2>&1
reg add "HKLM\Software\Microsoft\Internet Explorer\Main" /v "Isolation" /t REG_SZ /d "PMEM" /f > NUL 2>&1
reg add "HKLM\Software\Microsoft\Internet Explorer\Main" /v "Isolation64Bit" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\BrowserEmulation" /v "IntranetCompatibilityMode" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer" /v "DisableFlashInIE" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\SQM" /v "DisableCustomerImprovementProgram" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\DomainSuggestion" /v "Enabled" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Security" /v "DisableSecuritySettingsCheck" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Security" /v "DisableFixSecuritySettings" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Privacy" /v "EnableInPrivateBrowsing" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Privacy" /v "ClearBrowsingHistoryOnExit" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Main" /v "EnableAutoUpgrade" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Main" /v "DisableFirstRunCustomize" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Main" /v "HideNewEdgeButton" /t REG_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Feed Discovery" /v "Enabled" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Feeds" /v "BackgroundSyncStatus" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\FlipAhead" /v "Enabled" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Suggested Sites" /v "Enabled" /t REG_DWORD /d "0" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\TabbedBrowsing" /v "NewTabPageShow" /t REG_DWORD /d "1" /f > NUL 2>&1
timeout /t 3 /nobreak >NUL 2>&1
cls
goto Tweaks



:Tweaks
echo Phase 2

:: Disable Scheduled Tasks
for %%i in (
      "\Microsoft\Windows\WaaSMedic\PerformRemediation"
      "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance"
      "\Microsoft\Windows\Device Setup\Metadata Refresh"
      "\Microsoft\Windows\PushToInstall\LoginCheck"
      "\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask"
      "\Microsoft\Windows\Printing\EduPrintProv"
      "\Microsoft\Windows\Multimedia\Microsoft\Windows\Multimedia"
      "\Microsoft\Windows\InstallService\ScanForUpdates"
      "\Microsoft\Windows\InstallService\ScanForUpdatesAsUser"
      "\Microsoft\Windows\InstallService\SmartRetry"
      "\Microsoft\Windows\International\Synchronize Language Settings"
      "\Microsoft\Windows\Shell\FamilySafetyMonitor"
      "\Microsoft\Windows\RetailDemo\CleanupOfflineContent"
      "\Microsoft\Windows\StateRepository\MaintenanceTasks"
      "\Microsoft\Windows\SOFTWAREProtectionPlatform\SvcRestartTaskLogon"
      "\Microsoft\Windows\SOFTWAREProtectionPlatform\SvcRestartTaskNetwork"
      "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
      "\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask"
      "\MicrosoftEdgeUpdateTaskMachineCore"
      "\MicrosoftEdgeUpdateTaskMachineUA"
      "\MicrosoftEdgeUpdateBrowserReplacementTask"
      "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
      "\Microsoft\Windows\Diagnosis\Scheduled"
      "\Microsoft\Windows\Ras\MobilityManager"
      "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSYSTEM"
      "\Microsoft\Windows\NetTrace\GatherNetworkInfo"
      "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
      "\Microsoft\Windows\Application Experience\AitAgent"
      "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
      "\Microsoft\Windows\Application Experience\StartupAppTask"
      "\Microsoft\Windows\Application Experience\PcaPatchDbTask"
      "\Microsoft\Windows\Autochk\Proxy"
      "\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask"
      "\Microsoft\Windows\Chkdsk\ProactiveScan"
      "\Microsoft\Windows\Chkdsk\SyspartRepair"
      "\Microsoft\Windows\Data Integrity Scan\Data Integrity Scan"
      "\Microsoft\Windows\Data Integrity Scan\Data Integrity Scan for Crash Recovery"
      "\Microsoft\Windows\Defrag\ScheduledDefrag"
      "\Microsoft\Windows\Diagnosis\Scheduled"
      "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
      "\Microsoft\Windows\DiskCleanup\SilentCleanup"
      "\Microsoft\Windows\DiskFootPrint\Diagnostics"
      "\Microsoft\Windows\DiskFootPrint\StorageSense"
      "\Microsoft\Windows\LanguageComponentsInstaller\Uninstallation"
      "\Microsoft\Windows\MemoryDiagnostic\DecompressionFailureDetector"
      "\Microsoft\Windows\MemoryDiagnostic\CorruptionDetector"
      "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents"
      "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic"
      "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"
      "\Microsoft\Windows\Registry\RegIdleBackup"
      "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime"
      "\Microsoft\Windows\Time Synchronization\SynchronizeTime"
      "\Microsoft\Windows\Time Zone\SynchronizeTimeZone"
      "\Microsoft\Windows\UpdateOrchestrator\Reboot"
      "\Microsoft\Windows\WindowsUpdate\Scheduled Start"
      "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan"
      "\Microsoft\Windows\UpdateOrchestrator\Schedule Work"
      "\Microsoft\Windows\UpdateOrchestrator\UpdateModelTask"
      "\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker"
      "\Microsoft\Windows\UpdateOrchestrator\Report policies"
      "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task"
      "\Microsoft\Windows\UpdateOrchestrator\USO_Broker_Display"
      "\Microsoft\Windows\UPnP\UPnPHostConfig"
      "\Microsoft\Windows\User Profile Service\HiveUploadTask"
      "\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange"
      "\Microsoft\Windows\WindowsUpdate\Scheduled Start"
      "\Microsoft\Windows\WindowsUpdate\sih"
      "\Microsoft\Windows\Wininet\CacheTask"
      "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
      "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
      "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver"
      "\Microsoft\Windows\Location\Notifications"
      "\Microsoft\Windows\USB\Usb-Notifications"
      "\Microsoft\Windows\Location\WindowsActionDialog"
      "\Microsoft\Windows\Offline Files\Background Synchronization"
      "\Microsoft\Windows\Offline Files\Logon Synchronization"
      "\Microsoft\Windows\WDI\ResolutionHost"
      "\Microsoft\Windows\Workplace Join\Automatic-Device-Join"
      "Microsoft\Windows\Workplace Join\Recovery-Check"
) do (
      schtasks.exe /change /disable /tn %%i >nul 2>&1
      powerrun.exe /sw:0 schtasks.exe /change /disable /tn %%i >nul 2>&1
)

:: Disable Autoruns
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Active Setup\Installed Components\{8A69D345-D564-463c-AFF1-A69D9E530F96}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Active Setup\Installed Components\{AFE6A462-C574-4B8A-AF43-4CC60DF4563B}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{29D03007-F8B1-4E12-ACAF-5C16C640D894}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{834F4B4B-2375-46D7-AB12-546EF47FC46F}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{8B76D8B3-FDFD-4A7D-B89A-C0787A05BE76}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{CFDB528C-406A-4C14-9533-64C65AA183BB}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain\{06C2AEAE-A87D-43BA-B84E-AE7E4A11C897}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{06C2AEAE-A87D-43BA-B84E-AE7E4A11C897}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{29D03007-F8B1-4E12-ACAF-5C16C640D894}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{834F4B4B-2375-46D7-AB12-546EF47FC46F}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{8B76D8B3-FDFD-4A7D-B89A-C0787A05BE76}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{CFDB528C-406A-4C14-9533-64C65AA183BB}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\AMDInstallUEP" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\GoogleUpdateTaskMachineCore" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\GoogleUpdateTaskMachineUA" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\StartCN" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\StartDVR" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\System\CurrentControlSet\Control\Terminal Server\Wds\rdpwd" /v "StartupPrograms" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Services\AMD External Events Utility" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Services\AMD External Events Utility" /v "DeleteFlag" /t REG_DWORD /d "1" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Active Setup\Installed Components\{89B4C1CD-B018-4511-B0A1-5476DBF70820}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "Open-Shell Start Menu" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\WOW6432Node\Microsoft\Active Setup\Installed Components\{89B4C1CD-B018-4511-B0A1-5476DBF70820}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain\{0E76D7E3-DA81-46BD-A750-C06B6B660CB4}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{0E76D7E3-DA81-46BD-A750-C06B6B660CB4}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Mozilla\Firefox Background Update 308046B0AF4A39CB" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\System\CurrentControlSet\Control\Session Manager\KnownDLLs" /v "_wow64win" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\System\CurrentControlSet\Control\Session Manager\KnownDLLs" /v "_wowarmhw" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\System\CurrentControlSet\Control\Session Manager\KnownDLLs" /v "_wow64" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\System\CurrentControlSet\Control\Session Manager\KnownDLLs" /v "_wow64cpu" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\FontCache3.0.0.0" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1

:: IMPORT POWERPLAN
powercfg -import "C:\Windows\NEPTUNE\power.pow" 11111111-1111-1111-1111-111111111111 > NUL 2>&1
powercfg -h off > NUL 2>&1
powercfg -changename 11111111-1111-1111-1111-111111111111 "NeptuneOS Powerplan" "A powerplan created to achieve low latency and high 0.01% lows." > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\0012ee47-9041-4b5d-9b77-535fba8b1442\d3d55efd-c1ff-424e-9dc3-441be7833010" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\0012ee47-9041-4b5d-9b77-535fba8b1442\d639518a-e56d-4345-8af2-b9f32fb26109" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\0853a681-27c8-4100-a2fd-82013e970683" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\06cadf0e-64ed-448a-8927-ce7bf90eb35d" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\12a0ab44-fe28-4fa9-b3bd-4b64f44960a6" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\4b92d758-5a24-4851-a470-815d78aee119" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\5d76a2ca-e8c0-402f-a133-2158492d58ad" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\7b224883-b3cc-4d79-819f-8374152cbe7c" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\0012ee47-9041-4b5d-9b77-535fba8b1442\6738e2c4-e8a5-4a42-b16a-e040e769756e" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\0012ee47-9041-4b5d-9b77-535fba8b1442\6738e2c4-e8a5-4a42-b16a-e040e769756e" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\0012ee47-9041-4b5d-9b77-535fba8b1442\d3d55efd-c1ff-424e-9dc3-441be7833010" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\0012ee47-9041-4b5d-9b77-535fba8b1442\d3d55efd-c1ff-424e-9dc3-441be7833010" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\0012ee47-9041-4b5d-9b77-535fba8b1442\d639518a-e56d-4345-8af2-b9f32fb26109" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\0012ee47-9041-4b5d-9b77-535fba8b1442\d639518a-e56d-4345-8af2-b9f32fb26109" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\0d7dbae2-4294-402a-ba8e-26777e8488cd\309dce9b-bef4-4119-9921-a851fb12f0f4" /v "ACSettingIndex" /t REG_DWORD /d "1" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\0d7dbae2-4294-402a-ba8e-26777e8488cd\309dce9b-bef4-4119-9921-a851fb12f0f4" /v "DCSettingIndex" /t REG_DWORD /d "1" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\19cbb8fa-5279-450e-9fac-8a3d5fedd0c1\12bbebe6-58d6-4636-95bb-3217ef867c1a" /v "ACSettingIndex" /t REG_BINARY /d "00000000" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\19cbb8fa-5279-450e-9fac-8a3d5fedd0c1\12bbebe6-58d6-4636-95bb-3217ef867c1a" /v "DCSettingIndex" /t REG_BINARY /d "00000000" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\238c9fa8-0aad-41ed-83f4-97be242c8f20\bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\238c9fa8-0aad-41ed-83f4-97be242c8f20\bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\2a737441-1930-4402-8d77-b2bebba308a3\0853a681-27c8-4100-a2fd-82013e970683" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\2a737441-1930-4402-8d77-b2bebba308a3\0853a681-27c8-4100-a2fd-82013e970683" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\2a737441-1930-4402-8d77-b2bebba308a3\48e6b7a6-50f5-4782-a5d4-53bb8f07e226" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\2a737441-1930-4402-8d77-b2bebba308a3\48e6b7a6-50f5-4782-a5d4-53bb8f07e226" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\4f971e89-eebd-4455-a8de-9e59040e7347\7648efa3-dd9c-4e3e-b566-50f929386280" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\4f971e89-eebd-4455-a8de-9e59040e7347\7648efa3-dd9c-4e3e-b566-50f929386280" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1	
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\4f971e89-eebd-4455-a8de-9e59040e7347\96996bc0-ad50-47ec-923b-6f41874dd9eb" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\4f971e89-eebd-4455-a8de-9e59040e7347\96996bc0-ad50-47ec-923b-6f41874dd9eb" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\501a4d13-42af-4429-9fd1-a8218c268e20\ee12f906-d277-404b-b6da-e5fa1a576df5" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\501a4d13-42af-4429-9fd1-a8218c268e20\ee12f906-d277-404b-b6da-e5fa1a576df5" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\06cadf0e-64ed-448a-8927-ce7bf90eb35d" /v "ACSettingIndex" /t REG_DWORD /d "2" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\06cadf0e-64ed-448a-8927-ce7bf90eb35d" /v "DCSettingIndex" /t REG_DWORD /d "2" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\12a0ab44-fe28-4fa9-b3bd-4b64f44960a6" /v "ACSettingIndex" /t REG_DWORD /d "1" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\12a0ab44-fe28-4fa9-b3bd-4b64f44960a6" /v "DCSettingIndex" /t REG_DWORD /d "1" /f > NUL 2>&1 
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\4b92d758-5a24-4851-a470-815d78aee119" /v "ACSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\4b92d758-5a24-4851-a470-815d78aee119" /v "DCSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\5d76a2ca-e8c0-402f-a133-2158492d58ad" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\5d76a2ca-e8c0-402f-a133-2158492d58ad" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\7b224883-b3cc-4d79-819f-8374152cbe7c" /v "ACSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\7b224883-b3cc-4d79-819f-8374152cbe7c" /v "DCSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c" /v "ACSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c" /v "DCSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\94d3a615-a899-4ac5-ae2b-e4d8f634367f" /v "ACSettingIndex" /t REG_DWORD /d "1" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\94d3a615-a899-4ac5-ae2b-e4d8f634367f" /v "DCSettingIndex" /t REG_DWORD /d "1" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\bc5038f7-23e0-4960-96da-33abaf5935ec" /v "ACSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\bc5038f7-23e0-4960-96da-33abaf5935ec" /v "DCSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\7516b95f-f776-4464-8c53-06167f40cc99\3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\7516b95f-f776-4464-8c53-06167f40cc99\3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1	
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\7516b95f-f776-4464-8c53-06167f40cc99\aded5e82-b909-4619-9949-f5d71dac0bcb" /v "ACSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\7516b95f-f776-4464-8c53-06167f40cc99\aded5e82-b909-4619-9949-f5d71dac0bcb" /v "DCSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\7516b95f-f776-4464-8c53-06167f40cc99\f1fbfde2-a960-4165-9f88-50667911ce96" /v "ACSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\7516b95f-f776-4464-8c53-06167f40cc99\f1fbfde2-a960-4165-9f88-50667911ce96" /v "DCSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\7516b95f-f776-4464-8c53-06167f40cc99\fbd9aa66-9553-4097-ba44-ed6e9d65eab8" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\7516b95f-f776-4464-8c53-06167f40cc99\fbd9aa66-9553-4097-ba44-ed6e9d65eab8" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
powercfg -setactive 11111111-1111-1111-1111-111111111111
powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a > NUL 2>&1
powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e > NUL 2>&1
powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c > NUL 2>&1
powercfg -delete e9a42b02-d5df-448d-aa00-03f14749eb61 > NUL 2>&1

:: Disable Powersaving Features
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMin" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PerfCalculateActualUtilization" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "SleepReliabilityDetailedDiagnostics" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "QosManagesIdleProcessors" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableVsyncLatencyUpdate" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableSensorWatchdog" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "MfBufferingThreshold" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "InterruptSteeringDisabled" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "TimerRebaseThresholdOnDripsExit" /t REG_DWORD /d "30" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoreParkingDisabled" /t REG_DWORD /d 0"" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager\Executive" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\ModernSleep" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >NUL 2>&1

:: MMCSS
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "AlwaysOn" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "a" /f >NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "a" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Affinity" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Background Only" /t REG_SZ /d "True" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "BackgroundPriority" /t REG_DWORD /d "8" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Clock Rate" /t REG_DWORD /d "10000" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "GPU Priority" /t REG_DWORD /d "8" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Priority" /t REG_DWORD /d "8" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Scheduling Category" /t REG_SZ /d "High" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "SFIO Priority" /t REG_SZ /d "High" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Latency Sensitive" /t REG_SZ /d "True" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Affinity" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d "False" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t REG_DWORD /d "10000" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d "18" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d "6" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Affinity" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Background Only" /t REG_SZ /d "True" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Clock Rate" /t REG_DWORD /d "10000" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "GPU Priority" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Priority" /t REG_DWORD /d "2" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Scheduling Category" /t REG_SZ /d "Medium" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "SFIO Priority" /t REG_SZ /d "Normal" /f >NUL 2>&1

:: DirectX 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "DisableAGPSupport" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "UseNonLocalVidMem" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "UseNonLocalVidMem" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "DisableDDSCAPSInDDSD" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "EmulationOnly" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectMusic" /v "DisableHWAcceleration" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "EmulatePointSprites" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "ForceRgbRasterizer" /t reg_DWORD /d "0" /f/f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "EmulateStateBlocks" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "EnableDebugging" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "FullDebug" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "DisableDM" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "EnableMultimonDebugging" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "LoadDebugRuntime" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumReference" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumSeparateMMX" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumRamp" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumNullDevice" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "FewVertices" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "DisableMMX" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "DisableMMX" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "MMX Fast Path" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "MMXFastPath" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "UseMMXForRGB" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "UseMMXForRGB" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumSeparateMMX" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "ForceNoSysLock" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorLatencyTolerance" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "VRROptimizeEnable=0;" /f >NUL 2>&1

:: Disable V-Sync Control & GPU Preemption
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "VsyncIdleTimeout" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Global Exclusive Fullscreen 
Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f >NUL 2>&1
Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f >NUL 2>&1
Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_DSEBehavior" /t REG_DWORD /d "2" /f >NUL 2>&1
Reg.exe delete "HKCU\System\GameConfigStore\Children" /f >NUL 2>&1
Reg.exe delete "HKCU\System\GameConfigStore\Parents" /f >NUL 2>&1

:: Process Priorities
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WmiPrvSE.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WmiPrvSE.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\winlogon.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "2" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\winlogon.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "2" /f >NUL 2>&1
for %%i in (OriginWebHelperService.exe ShareX.exe EpicWebHelper.exe SocialClubHelper.exe steamwebhelper.exe) do (
  reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "5" /f >NUL 2>&1
)

:: Disable Devices
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (IKEv2)" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (IP)" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (IPv6)" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (L2TP)" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (Network Monitor)" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (PPPOE)" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (PPTP)" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (SSTP)" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Motherboard resources" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "System board" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "System Speaker" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "System Timer" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Microsoft Virtual Drive Enumerator" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Microsoft Hyper-V Virtualization Infrastructure Driver" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Microsoft GS Wavetable Synth" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Microsoft Device Association Root Enumerator" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Microsoft Kernel Debug Network Adapter" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Microsoft RRAS Root Enumerator" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "PCI Data Acquisition and Signal Processing Controller" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "PCI Simple Communications Controller" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "PCI Device" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "PCI Simple Communications Controller" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "PCI Memory Controller" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "PCI standard RAM Controller" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "ACPI Processor Aggregator" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "ACPI Wake Alarm" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "UMBus Root Bus Enumerator" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Root Print Queue" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "NDIS Virtual Network Adapter Enumerator" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Direct memory access controller" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Unknown Device" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "SM Bus Controller" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Programmable interrupt controller" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Numeric data processor" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "High precision event timer" >NUL 2>&1

:: Boot Configuration
BCDEDIT /set disabledynamictick yes >NUL 2>&1
BCDEDIT /set useplatformtick Yes >NUL 2>&1
BCDEDIT /set nx AlwaysOff >NUL 2>&1
BCDEDIT /set ems No >NUL 2>&1
BCDEDIT /set bootems No >NUL 2>&1
BCDEDIT /set tpmbootentropy ForceDisable >NUL 2>&1
BCDEDIT /set bootmenupolicy Legacy >NUL 2>&1
BCDEDIT /set debug No >NUL 2>&1
BCDEDIT /set hypervisorlaunchtype Off >NUL 2>&1
BCDEDIT /set vm No >NUL 2>&1
BCDEDIT /set vsmlaunchtype Off >NUL 2>&1
BCDEDIT /set quietboot Yes >NUL 2>&1
BCDEDIT /set bootux Disabled >NUL 2>&1
BCDEDIT /set allowedinmemorysettings 0x0
BCDEDIT /set {current} description "NeptuneOS %version%"
BCDEDIT /set firstmegabytepolicy UseAll >NUL 2>&1
BCDEDIT /set avoidlowmemory 0x8000000 >NUL 2>&1
BCDEDIT /set nolowmem Yes >NUL 2>&1
bcdedit /set {current} recoveryenabled no >NUL 2>&1
BCDEDIT /timeout 5 >NUL 2>&1
BCDEDIT /deletevalue useplatformclock >NUL 2>&1

:: File System
FSUTIL behavior set allowextchar 0 >NUL 2>&1
FSUTIL behavior set Bugcheckoncorrupt 0 >NUL 2>&1
FSUTIL behavior set disable8dot3 1 >NUL 2>&1
FSUTIL behavior set disablecompression 1 >NUL 2>&1
FSUTIL behavior set disableencryption 1 >NUL 2>&1
FSUTIL behavior set disablelastaccess 1 >NUL 2>&1
FSUTIL behavior set disablespotcorruptionhandling 1 >NUL 2>&1
FSUTIL behavior set encryptpagingfile 0 >NUL 2>&1
FSUTIL behavior set quotanotify 86400 >NUL 2>&1
FSUTIL behavior set symlinkevaluation L2L:1 >NUL 2>&1
FSUTIL behavior set disabledeletenotify 0 >NUL 2>&1
FSUTIL repair set C: 0 >NUL 2>&1
label C: NeptuneOS %version% >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsMftZoneReservation" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NTFSDisable8dot3NameCreation" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "DontVerifyRandomDrivers" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NTFSDisableLastAccessUpdate" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "ContigFileAllocSize" /t REG_DWORD /d "64" /f > NUL 2>&1

:: Disable Performance Counters
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\PerfOS\Performance" /v "Collect Supports Metadata" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\PerfOS\Performance" /v "Collect Timeout" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\PerfDisk\Performance" /v "Collect Supports Metadata" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\PerfDisk\Performance" /v "Collect Timeout" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\PerfProc\Performance" /v "Collect Supports Metadata" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\PerfProc\Performance" /v "Collect Timeout" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable DMA Remapping
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\DmaGuard\DeviceEnumerationPolicy" /v "value" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\System\ControlSet001\Services\pci\Parameters" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\System\ControlSet001\Services\storahci\Parameters" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\System\ControlSet001\Services\stornvme\Parameters" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\System\ControlSet001\Services\USBXHCI\Parameters" /v "DmaRemappingCompatibleSelfhost" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\System\ControlSet001\Services\USBXHCI\Parameters" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f >nul 2>&1

:: Spectre, Meltdown, CFG, ASLR Mitigations
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "MoveImages" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DontVerifyRandomDrivers" /t REG_DWORD /d "1" /f >nul 2>&1

:: Reliable Timestamp
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Reliability" /v "TimeStampInterval" /t Reg_DWORD /d "1" /f >NUL 2>&1
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Reliability" /v "IoPriority" /t Reg_DWORD /d "3" /f >NUL 2>&1

:: Win32PrioritySeperation
Reg add "HKLM\System\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f >NUL 2>&1

:: Splitting Audio Services
copy /y "%windir%\System32\svchost.exe" "%windir%\System32\audiosvchost.exe" > NUL 2>&1
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv" /v "ImagePath" /t REG_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalServiceNetworkRestricted -p" /f >NUL 2>&1
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\AudioEndpointBuilder" /v "ImagePath" /t REG_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalSystemNetworkRestricted -p" /f >NUL 2>&1

:: IOLATENCYCAP 0
FOR /F "eol=E" %%a in ('REG QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "IoLatencyCap"^| FINDSTR /V "IoLatencyCap"') DO (
	REG ADD "%%a" /F /V "IoLatencyCap" /T REG_DWORD /d 0 >NUL 2>&1

	FOR /F "tokens=*" %%z IN ("%%a") DO (
		SET STR=%%z
		SET STR=!STR:HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\=!
		SET STR=!STR:\Parameters=!
		ECHO Setting IoLatencyCap to 0 in !STR!
	)
)

:: Disable HIPM DIPM and HDD parking
FOR /F "eol=E" %%a in ('REG QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "EnableHIPM"^| FINDSTR /V "EnableHIPM"') DO (
	REG ADD "%%a" /F /V "EnableHIPM" /T REG_DWORD /d 0 >NUL 2>&1
	REG ADD "%%a" /F /V "EnableDIPM" /T REG_DWORD /d 0 >NUL 2>&1
	REG ADD "%%a" /F /V "EnableHDDParking" /T REG_DWORD /d 0 >NUL 2>&1

	FOR /F "tokens=*" %%z IN ("%%a") DO (
		SET STR=%%z
		SET STR=!STR:HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\=!
		ECHO Disabling HIPM and DIPM in !STR!
	)
)

:: Disable Powersaving on devices
for %%a in (
	EnhancedPowerManagementEnabled
	AllowIdleIrpInD3
	EnableSelectiveSuspend
	DeviceSelectiveSuspended
	SelectiveSuspendEnabled
	SelectiveSuspendOn
	WaitWakeEnabled
	D3ColdSupported
	WdfDirectedPowerTransitionEnable
	EnableIdlePowerManagement
	IdleInWorkingState
) do (
	for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "%%a" ^| findstr "HKEY"') do (
		Reg.exe add "%%b" /v "%%a" /t REG_DWORD /d "0" /f >nul 2>&1
	)
) >nul 2>&1
for %%a in (WakeEnabled WdkSelectiveSuspendEnable) do (
	for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class" /s /f "%%a" ^| findstr "HKEY"') do (
		Reg.exe add "%%b" /v "%%a" /t REG_DWORD /d "0" /f >nul 2>&1
	)
) >nul 2>&1
powershell "%WinDir%\NEPTUNE\pnp-powersaving.ps1" >nul 2>&1

:: Disable Write Cache buffer
	for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI"^| findstr "HKEY"') do (
		for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do Reg.exe add "%%a\Device Parameters\Disk" /v "CacheIsPowerProtected" /t REG_DWORD /d "1" /f >nul 2>&1
	)
	for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI"^| findstr "HKEY"') do (
		for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do Reg.exe add "%%a\Device Parameters\Disk" /v "UserWriteCacheSetting" /t REG_DWORD /d "1" /f >nul 2>&1
	)
)

:: Disable Storport Idle
for /f "tokens=*" %%s in ('reg query "HKLM\System\CurrentControlSet\Enum" /S /F "StorPort" ^| findstr /e "StorPort"') do Reg add "%%s" /v "EnableIdlePowerManagement" /t REG_DWORD /d "0" /f >nul 2>&1

:: NTFS Mitigations
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable SEHOP Mitigation
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Drivers and Services
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\services\Beep" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\luafv" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\FileCrypt" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\vwififlt" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\cdrom" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\UsoSvc" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\TrkWks" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\lmhosts" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Themes" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\CDPSvc" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1

::Turn Core Isolation Memory Integrity OFF
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable TSX to mitigate zombieload
reg add "HKLM\SYSTEM\currentcontrolset\control\session manager\Kernel" /v "DisableTsx" /t REG_DWORD /d "1" /f > NUL 2>&1

:: System Mitigations
Powershell -Command "Set-ProcessMitigation -System -Disable DEP, EmulateAtlThunks, SEHOP, ForceRelocateImages, RequireInfo, BottomUp, HighEntropy, StrictHandle, DisableWin32kSystemCalls, AuditSystemCall, DisableExtensionPoints, BlockDynamicCode, AllowThreadsToOptOut, AuditDynamicCode, CFG, SuppressExports, StrictCFG, MicrosoftSignedOnly, AllowStoreSignedBinaries, AuditMicrosoftSigned, AuditStoreSigned, EnforceModuleDependencySigning, DisableNonSystemFonts, AuditFont, BlockRemoteImageLoads, BlockLowLabelImageLoads, PreferSystem32, AuditRemoteImageLoads, AuditLowLabelImageLoads, AuditPreferSystem32, EnableExportAddressFilter, AuditEnableExportAddressFilter, EnableExportAddressFilterPlus, AuditEnableExportAddressFilterPlus, EnableImportAddressFilter, AuditEnableImportAddressFilter, EnableRopStackPivot, AuditEnableRopStackPivot, EnableRopCallerCheck, AuditEnableRopCallerCheck, EnableRopSimExec, AuditEnableRopSimExec, SEHOP, AuditSEHOP, SEHOPTelemetry, TerminateOnError, DisallowChildProcessCreation, AuditChildProcess" > NUL 2>&1

:: VALORANT Mitigation Patch
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vgc.exe" /v "MitigationOptions" /t REG_BINARY /d "00000000000100000000000000000000" /f > NUL 2>&1

:: Disable Exclusive Audio Mode 
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d 0 /f >NUL 2>&1
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d 0 /f >NUL 2>&1
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d 0 /f >NUL 2>&1
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d 0 /f >NUL 2>&1

:: Disable Memory Compression
PowerShell "Disable-MMAgent -MemoryCompression" >NUL 2>&1

:: Reliable Timestamp
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Reliability" /v "TimeStampInterval" /t Reg_DWORD /d "1" /f >NUL 2>&1
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Reliability" /v "IoPriority" /t Reg_DWORD /d "3" /f >NUL 2>&1

:: Disable Superfetch
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableBootTrace" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "SfTracingState" /t REG_DWORD /d "0" /f >nul 2>&1

:: Paging File 
Reg.exe add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Memory Management" /v "PagingFiles" /t REG_MULTI_SZ /d "?:\pagefile.sys 2048 2048" /f >nul 2>&1

:: Split Threshold
Reg.exe add "HKLM\SYSTEM\ControlSet001\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "4294967295" /f >nul 2>&1

:: Large System Cache to improve microstuttering
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disallow drivers to get paged into virtual memory
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Page Combining
Reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePageCombining" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\currentcontrolset\control\session manager\Memory Management" /v "DisablePagingCombining" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Swapfile
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SwapfileControl" /t REG_DWORD /d "0" /f >nul 2>&1

:: Free unused ram
Reg add "HKLM\System\CurrentControlSet\Control\Session Manager" /v "HeapDeCommitFreeBlockThreshold" /t REG_DWORD /d "262144" /f >nul 2>&1
timeout /t 3 /nobreak > NUL 2>&1
cls
goto Network



:Network
echo Phase 3

:: NIC
netsh int tcp set global autotuninglevel=normal > NUL 2>&1
netsh int tcp set global chimney=disabled > NUL 2>&1
netsh int tcp set global dca=enabled > NUL 2>&1
netsh int tcp set global netdma=disabled > NUL 2>&1
netsh int tcp set global timestamps=enabled > NUL 2>&1
netsh int tcp set global congestionprovider=ctcp > NUL 2>&1
netsh int tcp set global ecncapability=disabled > NUL 2>&1
netsh int tcp set global ecncapability=disabled > NUL 2>&1
netsh int tcp set heuristics enabled > NUL 2>&1
netsh int tcp set global rss=enabled > NUL 2>&1
netsh int tcp set global fastopen=enabled > NUL 2>&1
netsh int tcp set global nonsackrttresiliency=disabled > NUL 2>&1
netsh int tcp set global rsc=disabled > NUL 2>&1
netsh int tcp set global maxsynretransmissions=2 > NUL 2>&1
netsh int tcp set global initialRto=2000 > NUL 2>&1
netsh int tcp set supplemental Internet congestionprovider=ctcp > NUL 2>&1
netsh int tcp set supplemental template=custom icw=10 > NUL 2>&1
netsh int ip set glob defaultcurhoplimit=255 > NUL 2>&1
netsh int ip set interface "Ethernet" metric=60 > NUL 2>&1
netsh int ipv4 set subinterface "Ethernet" mtu=1500 store=persistent > NUL 2>&1

:: Disable Bandwith Reservation
reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t reg_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t reg_DWORD /d "00000000" /f > NUL 2>&1
reg add "HKLM\Software\WOW6432Node\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t reg_DWORD /d "0" /f > NUL 2>&1

:: Disable Network Level Authentication
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_SZ /d "1" /f > NUL 2>&1

:: Set max port to 65535
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "65534" /f > NUL 2>&1

:: Reduce TIME_WAIT
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d "30" /f > NUL 2>&1

:: Reduce Time To Live
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d "64" /f > NUL 2>&1

:: Duplicate ACKs
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t REG_DWORD /d "2" /f >nul 2>&1

:: Disable SACKS
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Multicast
reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t reg_DWORD /d "0" /f > NUL 2>&1

:: Enable TCP Extensions for High Performance
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t reg_DWORD /d "00000001" /f > NUL 2>&1

:: Enable DNS over HTTPS
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableAutoDoh" /t REG_DWORD /d "2" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t REG_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeSOACacheTime" /t REG_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NetFailureCacheTime" /t REG_DWORD /d "0" /f >NUL 2>&1

:: Disable LLMNR
Reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Disable administrative shares
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "AutoShareWks" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Enable The Network Adapter Onboard Processor
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableTaskOffload" /t reg_DWORD /d "0" /f >NUL 2>&1

:: Disable the TCP autotuning diagnostic tool
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableWsd" /t reg_DWORD /d "00000000" /f >NUL 2>&1

:: Disable Network Features
PowerShell -NoLogo -NoProfile -NonInteractive -Command "Enable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip,ms_pacer ; Disable-NetAdapterBinding -Name "*" -ComponentID ms_lldp,ms_lltdio,ms_implat,ms_rspndr,ms_tcpip6,ms_server,ms_msclient" > NUL 2>&1

:: Host Resolution Priority
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t REG_DWORD /d "6" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t REG_DWORD /d "5" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t REG_DWORD /d "7" /f > NUL 2>&1

:: TCP Congestion Control/Avoidance Algorithm
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "0200" /t reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f > NUL 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "1700" /t reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f > NUL 2>&1

:: Detect congestion fail to receive acknowledgement for a packet within the estimated timeout
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPCongestionControl" /t reg_DWORD /d "00000001" /f > NUL 2>&1

:: Disable Nagle's Algorithm
Reg add "HKLM\Software\Microsoft\MSMQ\Parameters" /v "TCPNoDelay" /t REG_DWORD /d "1" /f >nul 2>&1  
for /f %%s in ('Reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\NetworkCards" /f "ServiceName" /s') do set "str=%%i" & if "!str:ServiceName_=!" neq "!str!" (
		Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TCPNoDelay" /t REG_DWORD /d "1" /f
		Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f
		Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpDelAckTicks" /t REG_DWORD /d "0" /f
		Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpInitialRTT" /d "300" /t REG_DWORD /f
        Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "UseZeroBroadcast" /d "0" /t REG_DWORD /f
        Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "DeadGWDetectDefault" /d "1" /t REG_DWORD /f
) >nul 2>&1  


:: QoS Priority 
for %%i in (csgo VALORANT-Win64-Shipping javaw FortniteClient-Win64-Shipping ModernWarfare r5apex Overwatch) do (
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Application Name" /t REG_SZ /d "%%i.exe" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Version" /t REG_SZ /d "1.0" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Protocol" /t REG_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Local Port" /t REG_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Local IP" /t REG_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Local IP Prefix Length" /t REG_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Remote Port" /t REG_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Remote IP" /t REG_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Remote IP Prefix Length" /t REG_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "DSCP Value" /t REG_SZ /d "46" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Throttle Rate" /t REG_SZ /d "-1" /f
)
timeout /t 3 /nobreak > NUL 2>&1
cls
goto Finish




:Finish
echo Finishing up installation and restarting. Enjoy NeptuneOS.
echo Please report any bugs you may find to the discord, or to the github. Thank you for your support.
Reg.exe delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "POST INSTALL" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "POST INSTALL" /t REG_SZ /d "explorer \"C:\POST INSTALL\"" /f > NUL 2>&1
devmanview /enable "HID-compliant mouse" >nul 2>&1
del /f /q "%windir%\NEPTUNE\DevManView.exe" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\Open-Shell.exe" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\FullscreenCMD.vbs" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\7z.exe" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\power.pow" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\Open Shell.exe" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\pnp-powersaving.ps1" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\MPC.exe" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\VisualCppRedist_AIO_x86_x64.exe" > NUL 2>&1
rmdir /s /q "%windir%\NEPTUNE\DirectX" > NUL 2>&1

shutdown /r /f -t 5 /c "Setup Complete: Enjoy NeptuneOS"
del "%~f0"
