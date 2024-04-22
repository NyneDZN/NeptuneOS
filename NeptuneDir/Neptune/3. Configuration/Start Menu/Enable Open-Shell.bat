@echo off
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul
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

:: Enable Open-Shell
taskkill /f /im StartMenuExperienceHost.exe
taskkill /f /im explorer.exe
rename "C:\Program Files\OpenShellStart" "Open-Shell"
cd C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy >nul 2>&1
ren StartMenuExperienceHost.exe StartMenuExperienceHost.old >nul 2>&1
cd "C:\Program Files\Open-Shell"
start StartMenu.exe
cd %windir%
start explorer.exe

:: Echo to Log
echo %date% %time% Enabled OpenShell >> %userlog%
:: Echo to User
echo !S_YELLOW!Open-Shell has been enabled.
timeout /t 3 /nobreak >nul
exit