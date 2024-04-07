@echo off
setlocal EnableDelayedExpansion
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul
:: Check if script is escelated
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if %errorlevel% neq 0 (
    echo You are about to be prompted with the UAC. Please click yes when prompted.
) ELSE (
    goto admin
)

:prompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\prompt.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\prompt.vbs"
    "%temp%\prompt.vbs"
    exit /B

:admin

:: Delete prompt script
if exist "%temp%\prompt.vbs" ( del "%temp%\prompt.vbs" )

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