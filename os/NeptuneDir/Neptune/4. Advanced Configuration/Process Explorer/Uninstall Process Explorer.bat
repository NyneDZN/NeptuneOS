@echo off
setlocal EnableDelayedExpansion

:: Call Administrator
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select 'Run as administrator'.
        pause & exit 1
    )
    exit 0
)

%windir%\NeptuneDir\Tools\PowerRun.exe /SW:0 "Reg.exe" add "HKLM\System\CurrentControlSet\services\pcw" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe" /v "Debugger" /f >nul 2>&1
choco uninstall procexp
:: Echo to Logger
cls & echo %date% %time% Reverted Back to Default Task Manager. >> %userlog%
:: Echo to User
cls & echo !S_YELLOw!Replaced Task Manager with Process Explorer.
timeout /t 3 >nul
exit /b