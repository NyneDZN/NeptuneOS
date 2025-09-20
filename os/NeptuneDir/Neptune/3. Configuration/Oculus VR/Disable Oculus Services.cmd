@echo off
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul
setlocal EnableDelayedExpansion

fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select 'Run as administrator'.
        pause & exit 1
    )
    exit 0
)


%svcF% QwaveDrv 4
%svcF% Qwave 4
%svcF% FontCache 4

:: Echo to Log
echo %date% %time% Disabled Oculus VR >> %userlog%
:: Echo to User
echo !S_YELLOW!Disabled Oculus VR. Restart your device to apply the changes.
timeout /t 3 /nobreak >nul
exit