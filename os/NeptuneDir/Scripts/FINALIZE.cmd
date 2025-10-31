:: We reboot once more because certain components like winget aren't initialized until a second reboot. Unknown as to why.
:: Will fix this in the future to make installs quicker.

@echo off
title NeptuneOS Finalization
call %WinDir%\NeptuneDir\Scripts\envINIT.cmd

:: Kill Explorer
taskkill /f /im explorer.exe >nul

:: Fullsceen Script
"%WinDir%\System32\cscript.exe" //nologo "%WinDir%\NeptuneDir\Scripts\VBS\FullScreenCMD.vbs"

echo %S_YELLOW%Completing a few more tasks, then 1 last reboot.
timeout /t 2 /nobreak >nul

:: Removing startup texts & resetting RunOnce
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticecaption" /t REG_SZ /d "" /f >nul
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticetext" /t REG_SZ /d "" /f >nul
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f >nul
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f >nul

:: Disable 'Show files from Office.com' in File Explorer
:: This sometimes gets left enabled somehow
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowCloudFilesInQuickAccess" /t REG_DWORD /d "0" /f >nul

:: Cleanup start menu
:: del /s /f /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools\Character Map.lnk" >nul
del /s /f /q "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Accessibility" >nul

:: Cleanup script
powershell -NoProfile -ExecutionPolicy Bypass -File "%WinDir%\NeptuneDir\Scripts\postClean.ps1"

:: Remove rounded corners by default
"%WinDir%\NeptuneDir%\Tools\rounded_corners.exe"

shutdown /f /r /t 2 /c "Last reboot for NeptuneOS"
del "%~f0"