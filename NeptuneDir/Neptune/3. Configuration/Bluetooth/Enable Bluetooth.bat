@echo off
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul
setlocal EnableDelayedExpansion

:: Call Administrator
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select 'Run as administrator'.
        pause & exit 1
    )
    exit 0
)

%svcF% RFCOMM 3
%svcF% BthEnum 3
%svcF% bthleenum 3
%svcF% BTHMODEM 3
%svcF% BthA2dp 3
%svcF% microsoft_bluetooth_avrcptransport 3
%svcF% BthHFEnum 3
%svcF% BTAGService 3
%svcF% bthserv 3
%svcF% BluetoothUserService 3
%svcF% BthAvctpSvc 3
Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t Reg_SZ /d "Allow" /f >nul

cls & echo !S_YELLOW!Bluetooth has been enabled. Restart your device to apply the changes.
timeout /t 3 /nobreak >nul
exit