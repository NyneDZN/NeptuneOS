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

:: Enabling VPN
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

call "%windir%\AtlasModules\Scripts\settingsPages.cmd" /unhide network-vpn /silent

:: Echo to Log
echo %date% %time% Enabled VPN Support >> %userlog%
:: Echo to User
echo !S_YELLOW!Enabled VPN Support. Restart your device to apply the changes.
timeout /t 3 /nobreak >nul
exit