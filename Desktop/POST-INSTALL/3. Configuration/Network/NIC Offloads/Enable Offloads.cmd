@echo off
for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /v "*SpeedDuplex" /s ^| findstr  "HKEY"') do (
    for /f %%i in ('reg query "%%a" /v "*LsoV2IPv4" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "*LsoV2IPv4" /t REG_SZ /d "1" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*LsoV2IPv6" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "*LsoV2IPv6" /t REG_SZ /d "1" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*IPChecksumOffloadIPv4" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "*IPChecksumOffloadIPv4" /t REG_SZ /d "3" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*IPChecksumOffloadIPv6" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "*IPChecksumOffloadIPv6" /t REG_SZ /d "3" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*TCPChecksumOffloadIPv4" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "*TCPChecksumOffloadIPv4" /t REG_SZ /d "3" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*TCPChecksumOffloadIPv6" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "*TCPChecksumOffloadIPv6" /t REG_SZ /d "3" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*UDPChecksumOffloadIPv4" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "*UDPChecksumOffloadIPv4" /t REG_SZ /d "3" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*UDPChecksumOffloadIPv6" ^| findstr "HKEY"') do (
        Reg.exe add "%%i" /v "*UDPChecksumOffloadIPv6" /t REG_SZ /d "3" /f >nul 2>&1
    )
) >nul 2>&1
echo NIC Offloads have been enabled.
pause>nul