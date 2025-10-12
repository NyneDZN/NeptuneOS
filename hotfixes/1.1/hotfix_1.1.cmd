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


@echo off & cls

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
call "%WinDir%\NeptuneDir\Updates\updater_variables.cmd"
call "%WinDir%\NeptuneDir\Scripts\ANSI.cmd"

:: Fullscreen script
"%WinDir%\NeptuneDir\Scripts\FullscreenCMD.vbs"


:: Echo to user
echo !S_GREEN!NeptuneOS V1.1!S_GREEN! !S_RED!Hotfix!S_RED!
echo.
echo !S_WHITE!This hotfix addresses the following issues:!S_WHITE!
echo  !S_RED!•!S_RED! !S_GREEN!NVIDIA app error on launch!S_GREEN!
echo  !S_RED!•!S_RED! !S_GREEN!Clicking on time/date won't open calendar!S_GREEN
echo  !S_RED!•!S_RED! !S_GREEN!Random explorer.exe crashes!S_GREEN!
echo  !S_RED!•!S_RED! !S_GREEN!Disable Mouse Throttling!S_GREEN!
echo  !S_RED!•!S_RED! !S_GREEN!Disable USB Sleep States!S_GREEN!
echo  !S_RED!•!S_RED! !S_GREEN!Network Improvements!S_GREEN!
echo.
echo !S_WHITE!This hotfix also adds these improvements:!S_WHITE!
echo  !S_RED!•!S_RED! !S_GREEN!Neptune Desktop folder enhancements!S_GREEN!
echo.
timeout /t 5 /nobreak>nul
echo Press any key to continue updating.
pause>nul

:: Init neptune reg for future hotfixes
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\NeptuneOS" /v HotfixVersion /t REG_SZ /d "1.1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\NeptuneOS" /v NeptuneVersion /t REG_SZ /d "1.0" /f

:: ----------------------------------------------------------
::                  Begin Hotfixes
:: ----------------------------------------------------------

:: Enable notification services to fix calendar and explorer crashes
%svcF% WpnService 2
%svcF% WpnUserService 2

:: Enable display enhancement service to fix NVIDIA app error
%svcF% DisplayEnhancementService 2

:: Enable Programmable interrupt controller
%DevMan% /enable "Programmable interrupt controller"

:: Enable system timer
%DevMan% /enable "System timer"

:: Enable CMOS / RTC
%DevMan% /enable "System CMOS/real time clock"

:: Disbale Host Controller Sleep State 0 in USB Flags
reg add "HKLM\SYSTEM\CurrentControlSet\Control\usbflags" /v "DisableHCS0Idle" /t REG_DWORD /d "1" /f

:: Disable Mouse Throttle
reg add "HKCU\Control Panel\Mouse" /v "RawMouseThrottleDuration" /t REG_DWORD /d "0" /f



:: ---------------------------------------------------------------------------
:: Update Neptune desktop folder
call "%WinDir%\NeptuneDir\Updates\hotfixes\1.1\move_to_directories.cmd"

:: Fix default services reg
powershell -file "%WinDir%\NeptuneDir\Updates\hotfixes\1.1\hotfix_reg_1.1.ps1

pause>nul