@echo off
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

:: Enable Mitigations
Reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions" /f >nul 2>&1
Reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /f >nul 2>&1
echo Enabled Mitigations, you will have to restart your PC for changes to apply.
pause>nul


