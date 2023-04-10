@echo off
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
    cls & goto menu
) else if "%option%"=="2" (
    netsh int tcp set global autotuninglevel=disabled >nul 2>&1
    echo AutoTuningLevel has been set to disabled.
    cls & goto menu
) else if "%option%"=="3" (
    netsh int tcp set global autotuninglevel=experimental >nul 2>&1
    echo AutoTuningLevel has been set to experimental.
    cls & goto menu
) else if "%option%"=="4" (
    exit
)