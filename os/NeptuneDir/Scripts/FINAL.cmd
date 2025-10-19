@echo off
setlocal EnableDelayedExpansion 
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul

taskkill /f /im explorer.exe >nul
title NeptuneOS Finalization
mode 60,30
echo !S_YELLOW!Doing some cleanup before final use, this won't take long.
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticecaption" /t REG_SZ /d "" /f >nul
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticetext" /t REG_SZ /d "" /f >nul
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f >nul
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f >nul

:: Disable 'Show files from Office.com' in File Explorer
:: This sometimes gets left enabled somehow
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowCloudFilesInQuickAccess" /t REG_DWORD /d "0" /f >nul

:: Cleanup start menu
del /s /f /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools\Character Map.lnk"
del /s /f /q "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Accessibility"

:: Cleanup script
powershell -NoProfile -ExecutionPolicy Bypass -File "%WinDir%\NeptuneDir\Scripts\postClean.ps1"

:: Remove rounded corners by default
"%WinDir%\NeptuneDir%\Tools\rounded_corners.exe"

cls & echo !S_YELLOW!Finished.
echo !S_YELLOW!Enjoy NeptuneOS.
timeout /t 3 /nobreak >nul
start explorer.exe
del "%~f0"