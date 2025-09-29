call "%~dp0\modules\variables.cmd"

:: Rename SmartScreen
taskkill /f /im smartscreen.exe
cd %WinDir%\System32 
takeown /f "smartscreen.exe" 
icacls "%WinDir%\System32\smartscreen.exe" /grant Administrators:F 
ren smartscreen.exe smartscreen.old 

:: Remove MobSync
taskkill /f /im mobsync.exe
cd %WinDir%\System32 
takeown /f "mobsync.exe" 
icacls "%WinDir%\System32\mobsync.exe" /grant Administrators:F 
ren mobsync.exe mobsync.old 