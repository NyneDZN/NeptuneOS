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


echo !S_RED!WARNING:
echo !S_YELLOW!Disabling the NVIDIA Display Container LS service will stop the NVIDIA Control Panel from working.
echo]
choice /C YN /M "Are you sure you want to continue?"
if errorlevel 2 (
    goto Nope
) else (
    goto Yes
)

:Yes
reg add "HKLM\System\CurrentControlSet\Services\NVDisplay.ContainerLocalSystem" /v "Start" /t REG_DWORD /d "4" /f
sc stop NVDisplay.ContainerLocalSystem
:: Echo to Logger
echo The NVIDIA Container Service has been disabled. >> %neptlog%
:: Echo to User
cls & echo !S_YELLOw!The container service has been disabled.
timeout /t 2 >nul
exit /b

:Nope
exit /b