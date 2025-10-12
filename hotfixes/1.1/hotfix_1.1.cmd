:: ==========================================================
::           NeptuneOS V1.1 Hotfix - Release Notes
:: ==========================================================
::  Fixes Included:
::    • NVIDIA app error on launch
::    • Clicking on time/date won't open calendar
::    • Random explorer.exe crashes
::    • Disable Mouse Throttling
::    • Disable USB Sleep States
::    • Network Improvements
::    • Neptune Desktop folder enhancements
:: ==========================================================


@echo off
cls

:: Call Administrator
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select 'Run as administrator'.
        pause & exit 1
    )
    exit 0
)

:: Init enviornment
setlocal EnableDelayedExpansion
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul
call "%WinDir%\NeptuneDir\Updates\updater_variables.cmd" >nul

:: Fullscreen script
"%WinDir%\NeptuneDir\Updates\hotfixes\1.1\FullscreenCMD.vbs" >nul


:: Echo to user
echo !S_GREEN!NeptuneOS V1.1!S_GREEN! !S_WHITE!Hotfix!S_WHITE!
echo.
echo !S_WHITE!This hotfix addresses the following issues:!S_WHITE!
echo  !S_WHITE!•!S_WHITE! !S_GREEN!NVIDIA app error on launch!S_GREEN!
echo  !S_WHITE!•!S_WHITE! !S_GREEN!Clicking on time/date won't open calendar!S_GREEN!
echo  !S_WHITE!•!S_WHITE! !S_GREEN!Random explorer.exe crashes!S_GREEN!
echo  !S_WHITE!•!S_WHITE! !S_GREEN!Disable Mouse Throttling!S_GREEN!
echo  !S_WHITE!•!S_WHITE! !S_GREEN!Disable USB Sleep States!S_GREEN!
echo  !S_WHITE!•!S_WHITE! !S_GREEN!Network Improvements!S_GREEN!
echo.
echo !S_WHITE!This hotfix also adds these improvements:!S_WHITE!
echo  !S_WHITE!•!S_WHITE! !S_GREEN!Neptune Desktop folder enhancements!S_GREEN!
echo.
timeout /t 5 /nobreak>nul
echo Press any key to continue updating.
pause>nul

:: Init neptune reg for future hotfixes
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\NeptuneOS" /v HotfixVersion /t REG_SZ /d "1.1" /f 
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\NeptuneOS" /v NeptuneVersion /t REG_SZ /d "1.0" /f

:: ----------------------------------------------------------
::                  Begin Hotfixes
cls
::
:: ----------------------------------------------------------

:: Enable notification services to fix calendar and explorer crashes
echo !S_WHITE!Enabling notification services!S_WHITE!
%svcF% WpnService 2
%svcF% WpnUserService 2

:: Enable display enhancement service to fix NVIDIA app error
echo !S_WHITE!Enabling display enhancement service for NVIDIA app!S_WHITE!
%svcF% DisplayEnhancementService 2

:: Enable Programmable interrupt controller
echo !S_WHITE!Enabling Programmable interrupt controller!S_WHITE!
%DevMan% /enable "Programmable interrupt controller"

:: Enable system timer
echo !S_WHITE!Enabling System timer!S_WHITE!
%DevMan% /enable "System timer"

:: Enable CMOS / RTC
echo !S_WHITE!Enabling CMOS / RTC!S_WHITE!
%DevMan% /enable "System CMOS/real time clock"

:: Disbale Host Controller Sleep State 0 in USB Flags
echo !S_WHITE!Disabling USB HCS0 in USB Flags!S_WHITE!
reg add "HKLM\SYSTEM\CurrentControlSet\Control\usbflags" /v "DisableHCS0Idle" /t REG_DWORD /d "1" /f >nul

:: Disable Mouse Throttle
echo !S_WHITE!Enable mouse throttling for non-foreground apps!S_WHITE!
reg add "HKCU\Control Panel\Mouse" /v "RawMouseThrottleDuration" /t REG_DWORD /d "0x14" /f >nul



::         Update Neptune desktop folder
:: ===================================================
::
:: New Features:
:: • Removed deprecated open-shell scripts
:: • Added new QoS Script in Network Configuration
:: • Moved NVIDIA Display Container LS to proper location
:: • Updated Neptune Default Services.reg
:: • Added FullscreenCMD.vbs to Scripts folder
::
:: ===================================================
:: hi there, i'm aware this entire project is a mess.
:: ---------------------------------
::       Tweaking existing files
:: ---------------------------------


:: Move NVIDIA Display Container LS folder from "Advanced Configuration" to "Driver Maintenance"
move "%WinDir%\NeptuneDir\Neptune\4. Advanced Configuration\NVIDIA Display Container LS" "%WinDir%\NeptuneDir\Neptune\2. Driver Maintenance\GPU\NVIDIA\Configuration" >nul

:: Remove Open-Shell configuration scripts, these will be kept in the future once Windows 10 is re-supported
del "%WinDir%\NeptuneDir\Neptune\3. Configuration\Start Menu" /s /q >nul



:: ----------------------------------
::          New additions
:: ----------------------------------


:: Move Updated QoS DSCP script to Network Configuration
move "%WinDir%\NeptuneDir\Updates\hotfixes\1.1\Set QoS.cmd" "%WinDir%\NeptuneDir\Neptune\2. Driver Maintenance\Network\Network Configuration" >nul
del "%WinDir%\NeptuneDir\Neptune\4. Advanced Configuration\Add Game to DSCP Policy.cmd" /s /q >nul
copy /y "%WinDir%\NeptuneDir\Updates\hotfixes\1.1\FullscreenCMD.vbs" "%WinDir%\NeptuneDir\Scripts\FullscreenCMD.vbs" >nul

