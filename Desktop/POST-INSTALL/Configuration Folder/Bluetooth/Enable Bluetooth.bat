@echo off
sc config BthAvctpSvc start=auto
for /f %%I in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /k /f CDPUserSvc ^| find /i "CDPUserSvc" ') do (
  reg add "%%I" /v "Start" /t REG_DWORD /d "2" /f
  sc start %%~nI
)
sc config CDPSvc start=auto
sc start BthAvctpSvc >nul 2>nul
echo Bluetooth has been enabled.
pause>nul