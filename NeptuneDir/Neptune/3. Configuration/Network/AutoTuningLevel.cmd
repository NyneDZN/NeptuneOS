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

:menu
echo.
echo.
echo AutoTuningLevel Configuration for NeptuneOS
echo =======================
echo.
echo 1. AutoTuningLevel Normal
echo 2. AutoTuningLevel Disabled
echo 2. AutoTuningLevel Experimental
echo 4. exit
echo.
set /p "option=Option (1-4): "

if "%option%"=="1" (
    netsh int tcp set global autotuninglevel=normal >nul 2>&1
    echo AutoTuningLevel has been set to normal.
    echo %date% %time% AutoTuningLevel set to Normal >> %userlog%
    cls & goto menu
) else if "%option%"=="2" (
    netsh int tcp set global autotuninglevel=disabled >nul 2>&1
    echo AutoTuningLevel has been set to disabled.
    echo %date% %time% AutoTuningLevel disabled >> %userlog%
    cls & goto menu
) else if "%option%"=="3" (
    netsh int tcp set global autotuninglevel=experimental >nul 2>&1
    echo AutoTuningLevel has been set to experimental.
    echo %date% %time% AutoTuningLevel set to Experimental >> %userlog%
    cls & goto menu
) else if "%option%"=="4" (
    exit
)