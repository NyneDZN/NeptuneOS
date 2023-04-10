@echo off
sc config BthAvctpSvc start=disabled
sc stop BthAvctpSvc >nul 2>nul
for /f %%I in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /k /f CDPUserSvc ^| find /i "CDPUserSvc" ') do (
  reg add "%%I" /v "Start" /t REG_DWORD /d "4" /f
  sc stop %%~nI
)
sc config CDPSvc start=disabled
echo Bluetooth has been disabled.
pause>nul