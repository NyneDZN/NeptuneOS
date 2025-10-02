@echo off
setlocal EnableDelayedExpansion && cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul

taskkill /f /im explorer.exe >nul
title NeptuneOS Finalization
mode 60,30
echo !S_YELLOW!Doing some cleanup before final use, this won't take long.
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticecaption" /t REG_SZ /d "" /f >nul
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticetext" /t REG_SZ /d "" /f >nul
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f >nul
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f >nul

:: Cleanup script
%PowerShell% "%WinDir%\NeptuneDir\Scripts\postClean.ps1"

cls & echo !S_YELLOW!Finished.
echo !S_YELLOW!Enjoy NeptuneOS.
timeout /t 3 /nobreak >nul
start explorer.exe
del "%~f0"