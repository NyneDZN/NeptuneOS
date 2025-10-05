:: ==========================================================
::           NeptuneOS V1.1 Hotfix - Release Notes
:: ==========================================================
::  Fixes Included:
::    • NVIDIA app error on launch
::    • Clicking on time/date won't open calendar
::    • Random explorer.exe crashes
::    • Neptune Desktop folder enhancements
:: ==========================================================


@echo off

:: Init enviornment
setlocal EnableDelayedExpansion
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul

:: Fullscreen script
"%WinDir%\NeptuneDir\Scripts\FullscreenCMD.vbs"


:: Echo to user
echo !S_GREEN!NeptuneOS V1.1!S_GREEN! !S_RED!Hotfix!S_RED!
echo.
echo !S_WHITE!This hotfix addresses the following issues:!S_WHITE!
echo  !S_RED!•!S_RED! !S_GREEN!NVIDIA app error on launch!S_GREEN!
echo  !S_RED!•!S_RED! !S_GREEN!Clicking on time/date won't open calendar!S_GREEN
echo  !S_RED!•!S_RED! !S_GREEN!Random explorer.exe crashes!S_GREEN!
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

:: Begin actual hotfix process
%svcF% WpnService 2
%svcF% WpnUserService 2
%svcF% DisplayEnhancementService 2