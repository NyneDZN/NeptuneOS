@echo off
title Disable VPN

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

:: Disable vpn devices
%dmv% /disable "WAN Miniport (IKEv2)"
%dmv% /disable "WAN Miniport (IP)"
%dmv% /disable "WAN Miniport (IPv6)"
%dmv% /disable "WAN Miniport (L2TP)"
%dmv% /disable "WAN Miniport (Network Monitor)"
%dmv% /disable "WAN Miniport (PPPOE)"
%dmv% /disable "WAN Miniport (PPTP)"
%dmv% /disable "WAN Miniport (SSTP)"
%dmv% /disable "NDIS Virtual Network Adapter Enumerator"
%dmv% /disable "Microsoft RRAS Root Enumerator"

:: Disable vpn services/drivers
%svcF% IKEEXT 4
%svcF% WinHttpAutoProxySv 4
%svcF% RasMan 4
%svcF% SstpSvc 4
%svcF% iphlpsvc 4
%svcF% NdisVirtualBus 4
%svcF% Eaphost 4

:: Hide settings page
call "%windir%\NeptuneDir\Scripts\settingsPages.cmd" /hide network-vpn /silent

:: Exit script if called with /silent argument
if "%~1"=="/silent" exit /b

:: Echo back to user
echo]
echo %S_GREEN%Disabled VPN Support%S_GREEN%
echo]
echo %S_WHITE%Press any key to exit...%S_WHITE%
pause > nul
exit /b