@echo off
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul
setlocal EnableDelayedExpansion

whoami /user | find /i "S-1-5-18" > nul 2>&1 || (
	call RunAsTI.cmd "%~f0" "%*"
	exit /b 0
)

reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DiagLog" /v "Start" /t REG_DWORD /d "0" /f > nul 2>&1
%svcF% DPS 2
%svcF% WdiServiceHost 3
%svcF% WdiSystemHost 3

:: Echo to Logger
echo Enabled Troubleshooting. >> %userlog%
:: Echo to User
cls & echo !S_YELLOW!Troubleshooting has been enabled. Restart your device to apply the changes.
timeout /t 2 >nul
exit /b