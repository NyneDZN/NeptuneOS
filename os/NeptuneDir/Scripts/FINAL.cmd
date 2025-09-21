@echo off & kill explorer.exe
setlocal EnableDelayedExpansion
title NeptuneOS Finalization
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul
mode 60,30
echo !S_YELLOW!Doing some cleanup before final use, this won't take long.
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticecaption" /t REG_SZ /d "" /f >nul
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticetext" /t REG_SZ /d "" /f >nul
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f >nul
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f >nul

:: Cleanup script
powershell.exe -ExecutionPolicy Bypass -File "%WinDir%\NeptuneDir\Scripts\cleanup.ps1"

:: Debloat UWP apps during finalization
:: call "C:\Windows\NeptuneDir\Scripts\debloat.cmd"
cls & echo !S_YELLOW!Finished.
echo !S_YELLOW!Enjoy NeptuneOS.
timeout /t 3 /nobreak >nul
start explorer.exe
:: "C:\Windows\NeptuneDir\Tools\RemoveEdge.exe"
del "%~f0"