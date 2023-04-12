@echo off

ver | findstr /i "Windows 10" > nul
if %errorlevel% == 0 set OSVersion=Windows 10

ver | findstr /i "Windows 11" > nul
if %errorlevel% == 0 set OSVersion=Windows 11

if "%OSVersion%"=="Windows 10" (
  sc config BthAvctpSvc start=auto
  sc stop BthAvctpSvc >nul 2>nul
  for /f %%I in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /k /f CDPUserSvc ^| find /i "CDPUserSvc" ') do (
    reg add "%%I" /v "Start" /t REG_DWORD /d "2" /f
    sc stop %%~nI
    sc config CDPSvc start=auto
  )
)

if "%OSVersion%"=="Windows 11" (
  sc config BthAvctpSvc start=auto
  sc start BthAvctpSvc >nul 2>nul
)
echo Bluetooth has been enabled.
pause>nul