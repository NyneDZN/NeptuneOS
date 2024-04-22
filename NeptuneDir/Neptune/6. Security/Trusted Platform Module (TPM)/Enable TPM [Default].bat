@echo off
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul
setlocal EnableDelayedExpansion

powershell Enable-TpmAutoProvisioning
sc config tpm start=demand
C:\Windows\NeptuneDir\Tools\dmv.exe /enable "AMD PSP 10.0 Device"
C:\Windows\NeptuneDir\Tools\dmv.exe /enable "Trusted Platform Module 2.0"
cls
:: Echo to Log
cls
echo %date% %time% Enabled TPM >> %userlog%
:: Echo to User
echo !S_YELLOW!TPM has been enabled. Please restart your device.
timeout /t 3 /nobreak >nul
exit