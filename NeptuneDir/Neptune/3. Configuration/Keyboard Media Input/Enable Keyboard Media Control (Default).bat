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
%svcF% hidserv 2

:: Echo to Log
echo Keyboard Media Control was enabled >> %neptlog%
:: Echo to User
echo !S_YELLOW!Keyboard Media Control has been enabled, you may have to restart your PC for changes to apply.
timeout /t 3 /nobreak >nul
exit