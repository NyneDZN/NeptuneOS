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
echo !S_YELLOW!Enabling the Microsoft Store will also enable the Windows Firewall.
pause
:: Enable Microsoft Store
%svcF% AppXSvc 3
%svcF% BFE 2
%svcF% ClipSVC 3
%svcF% FileCrypt 1
%svcF% FileInfo 0
%svcF% InstallService 3
%svcF% LicenseManager 3
%svcF% mpsdrv 3
%svcF% mpssvc 2
%svcF% TokenBroker 3
%svcF% usosvc 2
%svcF% WinHttpAutoProxySvc 2
%svcF% wlidsvc 3
%svcF% wuauserv 3
cls


:: Echo to Log
Echo Microsoft Store and Firewall were enabled >> %userlog%
:: Echo to User
echo The Microsoft Store and Firewall have been enabled. Please restart your device.
timeout /t 3 /nobreak >nul
exit