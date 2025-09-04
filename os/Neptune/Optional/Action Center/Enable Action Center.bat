@echo off
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "0" /f >nul 2>&1
echo %date% %time% Enabled Action Center >> %userlog%
taskkill /f /im explorer.exe & start explorer.exe