:: ==========================================================
::
::      This just contains the script snippets for the batch 
::      file that was sent to testers / early accesss 
::      members to apply the hotfix and initiate the updater 
::      enviornment when neptune was still in beta phase 
::      and the ISO was not public. This was not present
::      in the V1.0 ISO and was a late addition hence the mess. 
::                          
::                            - NYN9
::                            
:: ==========================================================
::
::           NeptuneOS V1.1 Hotfix - Release Notes
::
:: ==========================================================
::  Fixes Included:
::    • NVIDIA app error on launch
::    • Clicking on time/date won't open calendar
::    • Random explorer.exe crashes
::    • Neptune Desktop folder enhancements
:: ==========================================================

@echo off
title NeptuneOS v1.1 Hotfix
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

:: Echo to user
echo !S_RED!This script will require you to restart your computer!S_RED!
echo !S_RED!It's recommended to save and close any programs before proceeding.!S_RED!
echo !S_RED!The script will pause for 10 seconds to prevent you from accidentally continuing while you close your applications.!S_RED!
timeout /t 10 /nobreak>nul
echo.
echo !S_WHITE!Press any key to continue the script once you're ready.!S_WHITE!
pause>nul


:: Download the updater
cls & echo !S_WHITE!Downloading hotfix!S_WHITE!
timeout /t 1 /nobreak>nul
curl -L -o %temp%\updater.zip https://github.com/NyneDZN/NeptuneOS/archive/refs/heads/updater.zip >nul

:: Create updates directory
mkdir "%WinDir%\NeptuneDir\Updates" >nul

:: Extract the updater
"%WinDir%\NeptuneDir\Tools\7za.exe" x "%TEMP%\updater.zip" -o"%temp%\update_files" -y

:: Move the updater files to the updates directory
move "%temp%\update_files\NeptuneOS-updater\hotfixes" "%WinDir%\NeptuneDir\Updates" >nul
move "%temp%\update_files\NeptuneOS-updater\updater.ps1" "%WinDir%\NeptuneDir\Updates" >nul
move "%temp%\update_files\NeptuneOS-updater\updater_variables.cmd" "%WinDir%\NeptuneDir\Updates" >nul

:: Execute the hotfix script
echo !S_WHITE!Running hotfix master script!S_WHITE!
timeout /t 1 /nobreak>nul
powershell -ExecutionPolicy Bypass -File "%WinDir%\NeptuneDir\Updates\updater.ps1" -hotfix "1.1"
