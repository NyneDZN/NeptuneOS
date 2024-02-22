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


echo NeptuneOS Installer
echo Welcome to the NeptuneOS Installer. Please report any issues you encounter with the script in the Discord or GitHub.
echo Press any key to let the script initialize and restart your PC, or wait 10 seconds.
net stop wuauserv >nul 2>&1
del "%temp%\installer.zip"
taskkill /f /im powershell.exe >nul 2>&1
timeout /t 10 >nul
call C:\NeptuneOS-installer\Neptune\Scripts\phase1.bat