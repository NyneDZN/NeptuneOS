call "C:\neptune-installer\variables.cmd"
pause

:: Explorer Quickness
:: - > Turn down application launch delays
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shutdown\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f 
:: - > Turn down login delays
:: https://james-rankin.com/features/the-ultimate-guide-to-windows-logon-optimizations-part-6/
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DelayedDesktopSwitchTimeout" /t REG_DWORD /d "0" /f 
:: - > Automatically close any apps and continue to restart, shut down, or sign out of windows
reg add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f 
:: - > Reduce menu show delay time
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f 
:: - > Configure app timeout 
reg add "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f 

:: Explorer Colors
:: - > Set windows color scheme to 'storm gray'
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentColorMenu" /t REG_DWORD /d "4290756543" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "StartColorMenu" /t REG_DWORD /d "4289901234" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentPalette" /t REG_BINARY /d "9b9a9900848381006d6b6a004c4a4800363533002625240019191900107c1000" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationColor" /t REG_DWORD /d "3293334088" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationAfterglow" /t REG_DWORD /d "3293334088" /f 
:: - > Set operating system color scheme to 'dark'
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d "0" /f 
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d "0" /f 
:: - > Set tooltips to blue
reg add "HKCU\Control Panel\Colors" /v "InfoWindow" /t REG_SZ /d "246 253 255" /f 

:: Set NeptuneOS Wallpaper
reg add "HKCU\Control Panel\Desktop" /v "Wallpaper" /t REG_SZ /d "C:\Windows\Web\Wallpaper\Windows\NeptuneOS.png" /f 
:: - > Increase JPEG Wallpaper Quality
reg add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d "100" /f 

:: Disable Explorer Animations and Shadows
reg add "HKCU\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "1" /f 
reg add "HKCU\Control Panel\Desktop" /v "FontSmoothing" /t REG_SZ /d "2" /f 
reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9012038010000000" /f 
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisablePreviewDesktop" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "IconsOnly" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f 
:: - > Taskbar / UWP Transprency
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseOLEDTaskbarTransparency" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "DisableAcrylicBackgroundOnLogon" /t REG_DWORD /d "1" /f 
:: - > DWM Shadows and Animations
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "ListviewShadow" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableWindowColorization" /t REG_DWORD /d "1" /f 
:: - > DWM Composition
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "Composition" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowComposition" /t REG_DWORD /d "1" /f 

:: Context Menu Configuration
:: - > Disable wide Context Menus
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\FlightedFeatures" /v "ImmersiveContextMenu" /t REG_DWORD /d "0" /f 
:: - > Remove 'restore previous versions' from Context Menus and File Properties
reg delete "HKCR\AllFilesystemObjects\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f  
reg delete "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f  
reg delete "HKCR\Directory\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f  
reg delete "HKCR\Drive\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f  
reg delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f  
reg delete "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f  
reg delete "HKCR\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f  
reg delete "HKCR\Drive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f  
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "NoPreviousVersionsPage" /f  
reg delete "HKCU\SOFTWARE\Policies\Microsoft\PreviousVersions" /v "DisableLocalPage" /f  
:: - Restore 'new text file' in Context Menus
reg delete "HKCR\.txt\ShellNew" /f  
reg add "HKCR\.txt\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@%%SystemRoot%%\system32\notepad.exe,-470" /f 
reg add "HKCR\.txt\ShellNew" /v "NullFile" /t REG_SZ /d "" /f 
reg delete "HKCR\.txt" /f  
reg add "HKCR\.txt" /ve /t REG_SZ /d "txtfile" /f 
reg add "HKCR\.txt" /v "Content Type" /t REG_SZ /d "text/plain" /f 
reg add "HKCR\.txt" /v "PerceivedType" /t REG_SZ /d "text" /f 
reg add "HKCR\.txt\PersistentHandler" /ve /t REG_SZ /d "{5e941d80-bf96-11cd-b579-08002b30bfeb}" /f 
reg add "HKCR\.txt\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@%%SystemRoot%%\system32\notepad.exe,-470" /f 
reg add "HKCR\.txt\ShellNew" /v "NullFile" /t REG_SZ /d "" /f 
reg delete "HKCR\SystemFileAssociations\.txt" /f  
reg add "HKCR\SystemFileAssociations\.txt" /v "PerceivedType" /t REG_SZ /d "document" /f 
reg delete "HKCR\txtfile" /f  
reg add "HKCR\txtfile" /ve /t REG_SZ /d "Text Document" /f 
reg add "HKCR\txtfile" /v "EditFlags" /t REG_DWORD /d "2162688" /f 
reg add "HKCR\txtfile" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%SystemRoot%%\system32\notepad.exe,-469" /f 
reg add "HKCR\txtfile\DefaultIcon" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\imageres.dll,-102" /f 
reg add "HKCR\txtfile\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\NOTEPAD.EXE %%1" /f 
reg add "HKCR\txtfile\shell\print\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\NOTEPAD.EXE /p %%1" /f 
reg add "HKCR\txtfile\shell\printto\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\notepad.exe /pt \"%%1\" \"%%2\" \"%%3\" \"%%4\"" /f 
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.txt" /f  
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.txt\OpenWithList" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.txt\OpenWithProgids" /v "txtfile" /t REG_NONE /d "" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.txt\UserChoice" /v "Hash" /t REG_SZ /d "hyXk/CpboWw=" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.txt\UserChoice" /v "ProgId" /t REG_SZ /d "txtfile" /f 
reg delete "HKCU\SOFTWARE\Microsoft\Windows\Roaming\OpenWith\FileExts\.txt" /f  
reg add "HKCU\SOFTWARE\Microsoft\Windows\Roaming\OpenWith\FileExts\.txt\UserChoice" /v "Hash" /t REG_SZ /d "FvJcqeZpmOE=" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\Roaming\OpenWith\FileExts\.txt\UserChoice" /v "ProgId" /t REG_SZ /d "txtfile" /f 
:: - > Remove 'edit with Paint 3D' from Context Menus
reg delete "HKCR\SystemFileAssociations\.3mf\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.bmp\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.fbx\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.gif\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.jfif\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.jpe\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.jpeg\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.jpg\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.png\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.tif\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.tiff\Shell\3D Edit" /f  
:: - > Remove 'give access to' from Context Menus
reg delete "HKCR\*\shellex\ContextMenuHandlers\Sharing" /f  
reg delete "HKCR\Directory\Background\shellex\ContextMenuHandlers\Sharing" /f  
reg delete "HKCR\Directory\shellex\ContextMenuHandlers\Sharing" /f  
reg delete "HKCR\Drive\shellex\ContextMenuHandlers\Sharing" /f  
reg delete "HKCR\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing" /f  
reg delete "HKCR\UserLibraryFolder\shellex\ContextMenuHandlers\Sharing" /f 
:: - > Remove 'cast to device' from Context Menus
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" /t REG_SZ /d "" /f  
:: - > Remove 'share' in Context Menus
reg delete "HKCR\*\shellex\ContextMenuHandlers\ModernSharing" /f  
reg delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\ModernSharing" /f  
:: - > Remove 'bitmap image' from the 'new' Context Menus
reg delete "HKCR\.bmp\ShellNew" /f  
:: - > Remove 'rich text document' from 'new' Context Menus
reg delete "HKCR\.rtf\ShellNew" /f  
:: - > Remove 'send to' from Context Menus
reg delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" /f  
reg delete "HKCR\UserLibraryFolder\shellex\ContextMenuHandlers\SendTo" /f  
:: - > Remove 'add to favorites' from Context Menus
reg delete "HKCR\*\shell\pintohomefile" /f  
:: - > Remove 'rotate left' and 'rotate right' from Context Menus
reg delete "HKCR\SystemFileAssociations\.avci\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.avif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.bmp\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.dds\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.dib\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.gif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.heic\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.heif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.hif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.ico\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.jfif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.jpe\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.jpeg\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.jpg\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.jxr\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.png\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.rle\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.tif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.tiff\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.wdp\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.webp\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
:: - > Remove 'Scan with Defender' from Context Menus
reg delete "HKLM\SOFTWARE\Classes\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}\InprocServer32" /va /f  
reg delete "HKCR\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}" /v "InprocServer32" /f  
reg delete "HKCR\*\shellex\ContextMenuHandlers" /v "EPP" /f  
reg delete "HKCR\Directory\shellex\ContextMenuHandlers" /v "EPP" /f  
reg delete "HKCR\Drive\shellex\ContextMenuHandlers" /v "EPP" /f  
:: - > Remove 'print' from Context Menus
reg add "HKCR\SystemFileAssociations\image\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f  & for %%a in ("batfile" "cmdfile" "docxfile" "fonfile" "htmlfile" "inffile" "inifile" "JSEFile" "otffile" "pfmfile" "regfile" "rtffile" "ttcfile" "ttffile" "txtfile" "VBEFile" "VBSFile" "WSFFile") do (reg add "HKCR\%%~a\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f )
:: - > Remove 'include in library' from Context Menus
reg delete "HKCR\Folder\ShellEx\ContextMenuHandlers\Library Location" /f  
reg delete "HKLM\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location" /f  
:: - > Remove 'troubleshooting compatibility' from Context Menus
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{1d27f844-3a1f-4410-85ac-14651078412d}" /t REG_SZ /d "" /f 
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{1d27f844-3a1f-4410-85ac-14651078412d}" /t REG_SZ /d "" /f 
:: - > Add 'copy to' and 'move to' to Context Menus
reg add "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\Copy To" /ve /t REG_SZ /d "{C2FBB630-2971-11D1-A18C-00C04FD75D13}" /f 
reg add "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\Move To" /ve /t REG_SZ /d "{C2FBB631-2971-11D1-A18C-00C04FD75D13}" /f 
:: - > Add '.bat' to 'new' Context Menus
reg add "HKLM\SOFTWARE\Classes\.bat\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\System32\acppage.dll,-6002" /f 
reg add "HKLM\SOFTWARE\Classes\.bat\ShellNew" /v "NullFile" /t REG_SZ /d "" /f 
:: - > Add '.cmd' to 'new' Context Menus
reg add "HKLM\SOFTWARE\Classes\.cmd\ShellNew" /v "NullFile" /t REG_SZ /d "" /f 
reg add "HKLM\SOFTWARE\Classes\.cmd\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\System32\acppage.dll,-6003" /f 
:: - > Add '.ps1' to 'new' Context Menus
reg add "HKLM\SOFTWARE\Classes\.ps1\ShellNew" /v "NullFile" /t REG_SZ /d "" /f 
reg add "HKLM\SOFTWARE\Classes\.ps1\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "New file" /f 
if "%os%"=="Windows 11" (Reg add "HKCR\.ps1" /ve /t REG_SZ /d "ps1legacy" /f & Reg add "HKCR\.ps1\ShellNew" /v "NullFile" /t REG_SZ /d "" /f & Reg add "HKCR\ps1legacy" /ve /t REG_SZ /d "Windows PowerShell Script" /f & Reg add "HKCR\ps1legacy" /v "FriendlyTypeName" /t REG_SZ /d "Windows PowerShell Script" /f) 
:: - > Add '.reg' to 'new' Context Menus
reg add "HKLM\SOFTWARE\Classes\.reg\ShellNew" /v "NullFile" /t REG_SZ /d "" /f 
reg add "HKLM\SOFTWARE\Classes\.reg\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\regedit.exe,-309" /f 
:: - > Add 'take ownership' to Context Menus
reg add "HKCR\*\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f 
reg add "HKCR\*\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f 
reg add "HKCR\*\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f 
reg add "HKCR\*\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f 
reg add "HKCR\Directory\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f 
reg add "HKCR\Directory\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f 
reg add "HKCR\Directory\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f 
reg add "HKCR\Directory\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "MultipleInvokePromptMinimum" /t REG_DWORD /d "200" /f 
:: - > Add "merge as trusted installer" to .reg Context Menus
reg add "HKCR\regfile\Shell\RunAs" /ve /t REG_SZ /d "Merge As TrustedInstaller" /f 
reg add "HKCR\regfile\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "1" /f 
reg add "HKCR\regfile\Shell\RunAs\Command" /ve /t REG_SZ /d "NSudo.exe -U:T -P:E Reg import "%1"" /f 
:: - > Add 'install' to .cab Context Menus
reg delete "HKCR\CABFolder\Shell\RunAs" /f  
reg add "HKCR\CABFolder\Shell\RunAs" /ve /t REG_SZ /d "Install" /f 
reg add "HKCR\CABFolder\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "" /f 
reg add "HKCR\CABFolder\Shell\RunAs\Command" /ve /t REG_SZ /d "cmd /k DISM /online /add-package /packagepath:\"%1\"" /f 
:: - > Debloat 'Send To' context menu, hidden files do not show up in the 'Send To' context menu
:: attrib +h "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\SendTo\Bluetooth File Transfer.LNK" 
:: attrib +h "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\SendTo\Mail Recipient.MAPIMail" 
:: attrib +h "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\SendTo\Documents.mydocs" 

:: File Explorer Configuration
:: - > Disable 'Network Navigation' in the File Explorer Side Panel
reg add "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2962489444" /f 
:: - > Disable OneDrive in the File Explorer Side Panel
reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /d "0" /t REG_DWORD /f 
reg add "HKCR\Wow6432Node\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /d "0" /t REG_DWORD /f 
:: - > Remove Duplicate Removable Drives in the File Explorer Side Panel
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f  
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f  
:: - > Disable 'Quick Access' in the File Explorer Side Panel
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "HubMode" /t REG_DWORD /d "1" /f 
:: - > Disable '3D Objects' in the File Explorer Side Panel
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f  
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f  
:: - > Hide frequently used files/folders in the 'Quick Access' File Explorer Side Panel
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d "0" /f 
:: - > Hide recently used files/folders in the 'Quick Access' File Explorer Side Panel
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d "0" /f 
:: - > Show the full path in the File Explorer Search Bar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v "Settings" /t REG_BINARY /d "0c0002000b01000060000000" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v "FullPath" /t REG_DWORD /d "1" /f 
:: - > Show hidden files in File Explorer
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d "0" /f 
:: - > Show file extensions in File Explorer
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f 
:: - > Disable Sharing Wizard
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SharingWizardOn" /t REG_DWORD /d "0" /f 
:: - > Disable Sync Provider Notifications
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "0" /f 
:: - > Disable 'Show files from Office.com'
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCloudFilesInQuickAccess" /t REG_DWORD /d "0" /f 
:: - > Disable automatic folder type discovery in File Explorer
:: This might improve explorer performance, but will also make all folders autosort by 'details'
reg delete "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f  
reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v "FolderType" /t REG_SZ /d "NotSpecified" /f 
:: - > Show encrypted NTFS files in color in File Explorer
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowEncryptCompressedColor" /t REG_DWORD /d "1" /f 
:: - > Don't show the status bar in File Explorer
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowStatusBar" /t REG_DWORD /d "0" /f 
:: - > Open File Explorer to 'This PC'
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d "1" /f 
:: - > Revert to classic File Explorer search
reg add "HKLM\SOFTWARE\Classes\CLSID\{1d64637d-31e9-4b06-9124-e83fb178ac6e}\TreatAs" /v "" /t REG_SZ /d "{64bc32b5-4eec-4de7-972d-bd8bd0324537}" /f 
reg add "HKLM\SOFTWARE\Classes\WOW6432Node\CLSID\{1d64637d-31e9-4b06-9124-e83fb178ac6e}\TreatAs" /v "" /t REG_SZ /d "{64bc32b5-4eec-4de7-972d-bd8bd0324537}" /f 
reg add "HKLM\SOFTWARE\WOW6432Node\Classes\CLSID\{1d64637d-31e9-4b06-9124-e83fb178ac6e}\TreatAs" /v "" /t REG_SZ /d "{64bc32b5-4eec-4de7-972d-bd8bd0324537}" /f 
:: - > Always show more details for File Explorer transfers
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" /v "EnthusiastMode" /t REG_DWORD /d "1" /f 

:: Configure Taskbar
:: - > Hide meet now on the Taskbar
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f 
:: - > Hide people button on the Taskbar
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HidePeopleBar" /t REG_DWORD /d "1" /f 
:: - > Hide task view button on the Taskbar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /D "0" /f 
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MultiTaskingView\AllUpView" /v "Enabled" /f  
:: - > Hide search from the Taskbar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f 
:: - > Don't pin the store to the Taskbar
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoPinningStoreToTaskbar" /t REG_DWORD /d "1" /f 
:: - > Disable News and Interests on the Taskbar
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d "2" /f 
:: - > Hide notification badges on the Taskbar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarBadges" /t REG_DWORD /d "0" /f 
:: - > Show command prompt in the WIN+X menu
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DontUsePowerShellOnWinX" /t REG_DWORD /d "1" /f 
:: - > Disable Start Menu Recommendations
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_AccountNotifications" /t REG_DWORD /d "0" /f 
:: - > Clear Default TileGrid
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount" /v "start.tilegrid" /f  
:: - > Disable Start Menu Pins
:: currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "StartMenu_Start_Time" /t REG_BINARY /d "889f04f10c79da01" /f 
:: reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "Start_JumpListModernTime" /t REG_BINARY /d "29210bf10c79da01" /f 
:: reg add "HKU\%SID%\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "StartMenu_Start_Time" /t REG_BINARY /d "889f04f10c79da01" /f 
:: reg add "HKU\%SID%\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "Start_JumpListModernTime" /t REG_BINARY /d "29210bf10c79da01" /f 
:: - > Remove Advertisements and Stubs from Start Menu
if "%os%"=="Windows 11" (reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Start" /v "Config" /f)  
:: -> Hide Recommended Start Menu Apps
if "%os%"=="Windows 11" (reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Start" /v "ShowRecentList" /t REG_DWORD /d "0" /f) 
:: - > Hide Recently Added Apps in the Start Menu
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HideRecentlyAddedApps" /t REG_DWORD /d "1" /f 
:: - > Hide Recently Opened Items in Start Menu
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f
:: - > Hide files from Office
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowCloudFilesInQuickAccess" /t REG_DWORD /d 1 /f
:: - > Set the Start Menu layout.xml for Windows 10
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_EXPAND_SZ /d "%WinDir%\layout.xml" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "LockedStartLayout" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy Objects\{2F5183E9-4A32-40DD-9639-F9FAF80C79F4}Machine\Software\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_EXPAND_SZ /d "%WinDir%\layout.xml" /f 

:: - > Disable action center on the Taskbar
if "%os%"=="Windows 10" (
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f 
)
:: - > Disable notifications
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /t REG_DWORD /d "1" /f 
:: ^ - > Lock Screen Notifications
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "LockScreenToastEnabled" /t REG_DWORD /d "0" /f 
:: - > Disable cloud optimized taskbars
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableCloudOptimizedContent" /t Reg_DWORD /d "1" /f 
:: - > Disable CoPilot on Windows 11
if "%os%"=="Windows 11" (reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d "1" /f) 
if "%os%"=="Windows 11" (reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCopilotButton" /t REG_DWORD /d "0" /f) 

:: Fix Default Account Icon
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "UseDefaultTile" /t REG_DWORD /d "1" /f 

:: Enable the legacy photo viewer from windows 7 era
for %%a in (tif tiff bmp dib gif jfif jpe jpeg jpg jxr png) do (
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".%%~a" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f 
)
for %%a in (tif tiff bmp dib gif jfif jpe jpeg jpg jxr png) do (
reg add "HKCU\SOFTWARE\Classes\.%%~a" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f 
)

:: Hide pages in UWP settings
if "%os%"=="Windows 10" (
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "hide:recovery;autoplay;usb;maps;maps-downloadmaps;findmydevice;privacy;privacy-speechtyping;privacy-speech;privacy-feedback;privacy-activityhistory;search-permissions;privacy-location;privacy-general;sync;printers;cortana-windowssearch;mobile-devices;mobile-devices-addphone;backup;" /f 
)
:: - >  Hide unneeded control panel applets
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "RestrictCpl" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "1" /t REG_SZ /d "Administrative Tools" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "2" /t REG_SZ /d "Color Management" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "3" /t REG_SZ /d "Date and Time" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "4" /t REG_SZ /d "Device Manager" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "5" /t REG_SZ /d "File Explorer Options" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "6" /t REG_SZ /d "Internet Options" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "7" /t REG_SZ /d "Keyboard" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "8" /t REG_SZ /d "Mouse" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "9" /t REG_SZ /d "Network and Sharing Center" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "10" /t REG_SZ /d "Power Options" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "11" /t REG_SZ /d "Programs and Features" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "12" /t REG_SZ /d "Region" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "13" /t REG_SZ /d "Sound" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "14" /t REG_SZ /d "Windows Defender Firewall" /f 

:: Configure Windows Search
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsAADCloudSearchEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsMSACloudSearchEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsDeviceSearchHistoryEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "SafeSearchMode" /t REG_DWORD /d "0" /f 
:: - > Explorer Search
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "AutoWildCard" /t REG_DWORD /d "1" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "EnableNaturalQuerySyntax" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "WholeFileSystem" /t REG_DWORD /d "1" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "SystemFolders" /t REG_DWORD /d "1" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "ArchivedFiles" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "SearchOnly" /t REG_DWORD /d "1" /f 

:: Disable AutoRun and AutoPlay
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v "DisableAutoplay" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d "255" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoAutoplayfornonVolume" /t REG_DWORD /d "1" /f 

:: Fix misbehaving icons when using 2 different resolution monitors
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "IconSpacing" /t REG_SZ /d "-1125" /f 
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "IconVerticalSpacing" /t REG_SZ /d "-1125" /f 

:: Disable 'desktop.ini' file creation
:: https://www.makeuseof.com/desktop-ini-files-guide/#:~:text=these%20files%20important%3F-,The%20desktop.,configuring%20specific%20file%2Dsharing%20settings.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "UseDesktopIniCache" /t REG_DWORD /d "0" /f 

:: Legacy Notepad
:: This removes the banner telling you to install the new NotePad
reg add "HKU\%SID%\Software\Microsoft\Notepad" /v "ShowStoreBanner" /t REG_DWORD /d "0" /f 
reg add "HKU\%SID%\Software\Microsoft\Notepad" /v "fWrap" /t REG_DWORD /d "1" /f 
reg add "HKU\%SID%\Software\Microsoft\Notepad" /v "StatusBar" /t REG_DWORD /d "1" /f 

:: Set icon cache to 51.2MB
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "Max Cached Icons" /t REG_SZ /d "51200" /f 

:: Turn off Internet File Association Service
:: https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.InternetCommunicationManagement::ShellNoUseInternetOpenWith_2
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetOpenWith" /t REG_DWORD /d 1 /f 

:: Turn on Verbose Mode
:: https://www.thewindowsclub.com/enable-verbose-status-message-windows
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "VerboseStatus" /t REG_DWORD /d "1" /f 

:: Show drive letters before drive name in File Explorer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowDriveLettersFirst" /t REG_DWORD /d "4" /f 

:: Disable USB Errors
reg add "HKCU\SOFTWARE\Microsoft\Shell\USB" /v "NotifyOnUsbErrors" /t REG_DWORD /d "0" /f 

:: Disable 'Open File - Security Warning' message
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f 
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f 
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Security" /v "DisableSecuritySettingsCheck" /t REG_DWORD /d "1" /f 

:: Disable ShellBags
reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /v "BagMRU Size" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /v "BagMRU Size" /t REG_DWORD /d "1" /f 
reg add "HKCU\Software\Microsoft\Windows\Shell\BagMRU" /f 
reg add "HKCU\Software\Microsoft\Windows\Shell\Bags" /f 
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f  
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f  
reg delete "HKCU\Software\Microsoft\Windows\Shell\BagMRU" /f  
reg delete "HKCU\Software\Microsoft\Windows\Shell\Bags" /f  
reg delete "HKCU\Software\Microsoft\Windows\ShellNoRoam\BagMRU" /f  
reg delete "HKCU\Software\Microsoft\Windows\ShellNoRoam\Bags" /f  

:: Storage Sense Configuration
:: - > Clean files once a month
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "01" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "1024" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "2048" /t REG_DWORD /d "30" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "04" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "32" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "02" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "128" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "08" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "256" /t REG_DWORD /d "30" /f 

:: BSoD QoL
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "LogEvent" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl\StorageTelemetry" /v "DeviceDumpEnabled" /t REG_DWORD /d "0" /f 

:: Disable System Protection (by default)
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SPP\Clients" /v "{09F7EDC5-294E-4180-AF6A-FB0E6A0E9513}" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SPP\Clients" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "RPSessionInterval" /t REG_DWORD /d "0" /f 

:: Edge QoL
reg add "HKLM\Software\Policies\Microsoft\Edge" /f 
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "BackgroundModeEnabled" /t REG_DWORD /d 0 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenPuaEnabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "PreventSmartScreenPromptOverride" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "StartupBoostEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "AddressBarMicrosoftSearchInBingProviderEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "AlternateErrorPagesEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "AutofillAddressEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "AutofillCreditCardEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "ConfigureDoNotTrack" /t REG_DWORD /d "1" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "EdgeShoppingAssistantEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "LocalProvidersEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "MetricsReportingEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "NetworkPredictionOptions" /t REG_DWORD /d "2" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "PaymentMethodQueryEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "PersonalizationReportingEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "ResolveNavigationErrorsUseWebService" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "SearchSuggestEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "SendSiteInfoToImproveServices" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "SmartScreenEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "UserFeedbackAllowed" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Browser" /v "AllowAddressBarDropdown" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "AutofillCreditCardEnabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "UserFeedbackAllowed" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Policies\Microsoft\MicrosoftEdge\TabPreloader" /v "AllowTabPreloading" /t REG_DWORD /d "0" /f 

:: Explorer Audio Configuration
:: - > Fix volume mixer
reg add "HKCU\Software\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore" /f 
:: - > Don't show disconnected/disabled devices in mmsys.cpl
reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowDisconnectedDevices" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowHiddenDevices" /t REG_DWORD /d "0" /f 
:: - > Set audio scheme to none
PowerShell -ExecutionPolicy Unrestricted -Command  "New-ItemProperty -Path 'HKCU:\AppEvents\Schemes' -Name '(Default)' -Value '.None' -Force | Out-Null" 
PowerShell -ExecutionPolicy Unrestricted -Command  "Get-ChildItem -Path 'HKCU:\AppEvents\Schemes\Apps' | Get-ChildItem | Get-ChildItem | Where-Object {$_.PSChildName -eq '.Current'} | Set-ItemProperty -Name '(Default)' -Value ''" 
:: - > Don't reduce sounds while in a call
reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d "3" /f 

:: Configure Windows 11 File Explorer
if "%os%"=="Windows 11" (
:: - > Restore default context menu
reg add "HKCU\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /ve /t REG_SZ /d "" /f 
reg add "HKCU\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /t REG_SZ /d "" /f 
:: - > Disable Start Menu Recommendations
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_IrisRecommendations" /t REG_DWORD /d "0" /f 
:: - > Disable Widgets
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d "0" /f 
:: - > Disable Dynamic Lighting
Reg add "HKCU\Software\Microsoft\Lighting" /v "AmbientLightingEnabled" /t REG_DWORD /d "0" /f 
:: - > Allign the taskbar to the left
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAl" /t REG_DWORD /d "0" /f 
:: - > Use compact view mode in File Explorer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseCompactMode" /t REG_DWORD /d "1" /f 
:: - > Hide UWP settings pages
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "hide:home;recovery;autoplay;usb;maps;maps-downloadmaps;findmydevice;privacy;privacy-speechtyping;privacy-speech;privacy-feedback;privacy-activityhistory;search-permissions;privacy-location;privacy-general;sync;printers;cortana-windowssearch;mobile-devices;mobile-devices-addphone;backup;" /f 
:: - > Hide gallery in File Explorer
reg add "HKCU\SOFTWARE\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f 
:: - > Show more pins in start menu
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_Layout" /t REG_DWORD /d "1" /f 
)

:: Configuring ease of access settings in Windows
:: Disable Sticky keys, Mouse Keys, Toggle Keys, and other Keyboard Features
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_DWORD /d "0" /f 
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_DWORD /d "0" /f 
reg add "HKCU\Control Panel\Accessibility\MouseKeys" /v "Flags" /t REG_DWORD /d "0" /f 
reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_DWORD /d "0" /f 

:: Disable Pointer Precision
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f 
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f 
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f 

:: Lower Keyboard Repeat Delay / Cursor Blink Rate
reg add "HKCU\Control Panel\Keyboard" /v "KeyboardDelay" /t REG_SZ /d "0" /f 
reg add "HKCU\Control Panel\Keyboard" /v "KeyboardSpeed" /t REG_SZ /d "31" /f 
reg add "HKCU\Control Panel\Desktop" /v "CursorBlinkRate" /t REG_SZ /d "-1" /f 

:: MarkC 1:1
:: reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d 0000000000000000C0CC0C0000000000809919000000000040662600000000000033330000000000 /f 
:: reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d 0000000000000000000038000000000000007000000000000000A800000000000000E00000000000 /f