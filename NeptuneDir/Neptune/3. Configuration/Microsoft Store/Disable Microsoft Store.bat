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

echo !S_YELLOW!Disabling the store will also break Xbox app functionality, press any key if you still want to continue.
pause>nul
:: Enable Microsoft Store
%svcF% AppXSvc 4
%svcF% ClipSVC 4
%svcF% FileCrypt 4
%svcF% FileInfo 4
%svcF% InstallService 4
%svcF% LicenseManager 4
%svcF% TokenBroker 4
%svcF% usosvc 4
%svcF% WinHttpAutoProxySvc 4
%svcF% wlidsvc 4
%svcF% wuauserv 4
cls

:: Echo to Log
Echo Microsoft Store was disabled >> %neptlog%
:: Echo to User
echo The Microsoft Store has been disabled. Please restart.
timeout /t 3 /nobreak >nul
exit