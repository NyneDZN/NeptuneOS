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
%svcF% BthPan 3
%svcF% BTHPORT 3
%svcF% BTHUSB 3
Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t Reg_SZ /d "Allow" /f >nul

%DevMan% /enable "Generic Bluetooth Adapter"
%DevMan% /enable "Bluetooth Device (RFCOMM Protocol TDI)"
%DevMan% /enable "Microsoft Bluetooth Enumerator"
%DevMan% /enable "Microsoft Bluetooth LE Enumerator"

:: Echo to Log
echo %date% %time% Enabled Bluetooth >> %userlog%
:: Echo to User
echo !S_YELLOW!Enabled Bluetooth. Restart your device to apply the changes.
timeout /t 3 /nobreak >nul
exit