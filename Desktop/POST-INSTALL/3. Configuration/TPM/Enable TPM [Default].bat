@echo off
powershell Enable-TpmAutoProvisioning
sc config tpm start=demand
C:\Windows\NeptuneDir\Tools\DevManView.exe /enable "AMD PSP 10.0 Device"
C:\Windows\NeptuneDir\Tools\DevManView.exe /enable "Trusted Platform Module 2.0"
cls
echo TPM enabled. Please reboot.
pause>nul