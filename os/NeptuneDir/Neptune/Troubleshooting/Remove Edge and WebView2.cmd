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

:: Remove Edge
%currentuser% Powershell -ExecutionPolicy Unrestricted "%WinDir%\NeptuneDir\Scripts\RemoveEdge.ps1" -UninstallEdge -RemoveEdgeData -KeepAppX -NonInteractive >> %userlog%

:: Echo to Log
echo Removed Edge and WebView2 >> %userlog%
:: Echo to User
echo !S_YELLOW!Removed Microsoft Edge and WebView2.
timeout /t 3 /nobreak >nul
exit
