@echo off
setlocal EnableDelayedExpansion
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul

:: Call Administrator
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select 'Run as administrator'.
        pause & exit 1
    )
    exit 0
)

%svcF% Schedule 2
:: Echo to Log
cls
echo %date% %time% Enabled Task Scheduler >> %userlog%
:: Echo to User
echo !S_YELLOW!Task Scheduler has been enabled. Please restart your device.
timeout /t 3 /nobreak >nul
exit

