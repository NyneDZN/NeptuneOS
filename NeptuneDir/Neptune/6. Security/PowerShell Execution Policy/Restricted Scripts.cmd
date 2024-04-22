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

powershell set-executionpolicy restricted
echo Scripts are now disabled on this system.

:: Echo to Log
cls
echo %date% %time% Disabled PowerShell Execution Policy >> %userlog%
:: Echo to User
echo !S_YELLOW!Powershell Execution Policy has been enabled.
timeout /t 3 /nobreak >nul
exit