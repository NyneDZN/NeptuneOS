@echo off
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul
setlocal EnableDelayedExpansion

PowerShell -ExecutionPolicy Unrestricted Disable-TpmAutoProvisioning
sc config tpm start=disabled
C:\Windows\NeptuneDir\Tools\dmv.exe /disable "AMD PSP 10.0 Device"
C:\Windows\NeptuneDir\Tools\dmv.exe /disable "Trusted Platform Module 2.0"
cls
:: Echo to Log
cls
echo %date% %time% Disabled TPM >> %userlog%
:: Echo to User
echo !S_YELLOW!TPM has been disabled. Please restart your device.
timeout /t 3 /nobreak >nul
exit