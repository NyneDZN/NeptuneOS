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
%windir%\NeptuneDir\Tools\PowerRun.exe /SW:0 "Reg.exe" add "HKLM\System\CurrentControlSet\services\pcw" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe" /v "Debugger" /f >nul 2>&1
choco uninstall procexp
:: Echo to Logger
cls & echo %date% %time% Reverted Back to Default Task Manager. >> %neptlog%
:: Echo to User
cls & echo !S_YELLOw!Replaced Task Manager with Process Explorer.
timeout /t 3 >nul
exit /b