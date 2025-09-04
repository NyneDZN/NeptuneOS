@echo off
setlocal EnableDelayedExpansion
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul

:: Call Administrator
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select 'Run as administrator'.
        pause & exit 1
    )
    exit 0
)

:: Disabling VPN
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

%svcF% IKEEXT 4 
%svcF% WinHttpAutoProxySv 4 
%svcF% RasMan 4 
%svcF% SstpSvc 4 
%svcF% iphlpsvc 4 
%svcF% NdisVirtualBus 4 
%svcF% Eaphost 4 

call "%windir%\NeptuneDir\Scripts\settingsPages.cmd" /hide network-vpn /silent

:: Echo to Log
echo %date% %time% Disabled VPN Support >> %userlog%
:: Echo to User
echo !S_YELLOW!Disabled VPN Support. Restart your device to apply the changes.
timeout /t 3 /nobreak >nul
exit