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

%svcF% RFCOMM 4
%svcF% BthEnum 4
%svcF% bthleenum 4
%svcF% BTHMODEM 4
%svcF% BthA2dp 4
%svcF% microsoft_bluetooth_avrcptransport 4
%svcF% BthHFEnum 4
%svcF% BTAGService 4
%svcF% bthserv 4
%svcF% BluetoothUserService 4
%svcF% BthAvctpSvc 4
Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t Reg_SZ /d "Deny" /f >nul

:: Echo to Log
echo %date% %time% Disabled Bluetooth >> %userlog%
:: Echo to User
echo !S_YELLOW!Disabled Bluetooth. Restart your device to apply the changes.
timeout /t 3 /nobreak >nul
exit
