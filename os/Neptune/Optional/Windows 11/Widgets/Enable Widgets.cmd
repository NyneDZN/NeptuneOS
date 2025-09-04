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
call "%windir%\NeptuneDir\Scripts\edgeCheck.cmd"
if %errorlevel% neq 0 exit /b 1

echo]
echo !S_YELLOW!Enabling Widgets...

(
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /f
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /f
    taskkill /f /im explorer.exe
    start explorer.exe
) > nul 2>&1


echo]
echo Widgets are now enabled. You might have to restart your device.
echo %date% %time% Enabled Widgets and Installed Edge >> %userlog%
timeout /t 3 /nobreak >nul
exit