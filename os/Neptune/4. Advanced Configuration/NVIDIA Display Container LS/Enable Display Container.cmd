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


reg add "HKLM\System\CurrentControlSet\Services\NVDisplay.ContainerLocalSystem" /v "Start" /t REG_DWORD /d "2" /f
sc start NVDisplay.ContainerLocalSystem
:: Echo to Logger
echo The NVIDIA Container Service has been enabled. >> %userlog%
:: Echo to User
cls & echo !S_YELLOw!The container service has been enabled.
timeout /t 2 >nul
exit /b
