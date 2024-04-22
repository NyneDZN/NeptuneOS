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

%svcF% KSecPkg 0
%svcF% LanmanWorkstation 2
%svcF% mrxsmb 3
%svcF% mrxsmb20 3
%svcF% rdbss 1
%svcF% srv2 3
%svcF% QwaveDrv 3
%svcF% Qwave 3
%svcF% FontCache 2

:: Echo to Log
echo %date% %time% Enabled Oculus VR >> %userlog%
:: Echo to User
echo !S_YELLOW!Enabled Oculus VR. Restart your device to apply the changes.
timeout /t 3 /nobreak >nul
exit