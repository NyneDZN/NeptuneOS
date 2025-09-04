@echo off
setlocal EnableDelayedExpansion
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
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul
echo !S_YELLOW!Installing Epic Games Launcher
timeout /t 2 >nul
choco install epicgameslauncher -y --ignore-checksums


:: Echo to Logger
echo Installed Epic Games Launcher through Chocolatey. >> %neptlog%
:: Echo to User
cls & echo !S_YELLOW!Installed Epic Games Launcher.
timeout /2 >nul
exit
