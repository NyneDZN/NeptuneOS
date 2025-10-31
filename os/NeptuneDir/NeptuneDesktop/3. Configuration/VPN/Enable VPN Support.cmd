@echo off
title Configuration

:: Init
call "%WinDir%\NeptuneDir\Scripts\envINIT.cmd"

:: Run as administrator
set "___args="%~f0" %*"
fltmc > nul 2>&1 || (
    echo Administrator privileges are required.
    powershell -c "Start-Process -Verb RunAs -FilePath 'cmd' -ArgumentList """/c $env:___args"""" 2> nul || (
        echo You must run this script as admin.
        if "%*"=="" pause
        exit /b 1
    )
    exit /b
)

:: Enabling vpn services/drivers
%svcF% Eaphost 3
%svcF% IKEEXT 3
%svcF% iphlpsvc 3
%svcF% NdisVirtualBus 3
%svcF% RasAcd 3
%svcF% RasAgileVpn 3
%svcF% Rasl2tp 3
%svcF% Rasl2tp 3
%svcF% RasMan 2
%svcF% RasPppoe 3
%svcF% RasSstp 3
%svcF% SstpSvc 3
%svcF% WinHttpAutoProxySvc 3

:: Enabling vpn devices
%dmv% /enable "WAN Miniport (IKEv2)"
%dmv% /enable "WAN Miniport (IP)"
%dmv% /enable "WAN Miniport (IPv6)"
%dmv% /enable "WAN Miniport (L2TP)"
%dmv% /enable "WAN Miniport (Network Monitor)"
%dmv% /enable "WAN Miniport (PPPOE)"
%dmv% /enable "WAN Miniport (PPTP)"
%dmv% /enable "WAN Miniport (SSTP)"
%dmv% /enable "NDIS Virtual Network Adapter Enumerator"
%dmv% /enable "Microsoft RRAS Root Enumerator"

:: Unhide page
call "%windir%\NeptuneDir\Scripts\settingsPages.cmd" /unhide network-vpn /silent

:: Exit script if called with /silent argument
if "%~1"=="/silent" exit /b

:: Echo back to user
echo]
echo %S_GREEN%Enabled Wi-Fi%S_GREEN%
echo]
echo %S_WHITE%Press any key to exit...%S_WHITE%
pause > nul
exit /b