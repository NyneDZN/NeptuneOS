@echo off
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f >nul 2>&1
echo %date% %time% Disabled Action Center >> %userlog%
taskkill /f /im explorer.exe & start explorer.exe