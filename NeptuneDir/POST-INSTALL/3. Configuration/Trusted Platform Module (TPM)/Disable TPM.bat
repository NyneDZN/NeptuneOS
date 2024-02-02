@echo off
powershell Disable-TpmAutoProvisioning
sc config tpm start=disabled
C:\Windows\NeptuneDir\Tools\dmv.exe /disable "AMD PSP 10.0 Device"
C:\Windows\NeptuneDir\Tools\dmv.exe /disable "Trusted Platform Module 2.0"
cls
echo TPM disabled. Please reboot.
pause>nul