@echo off
setlocal EnableDelayedExpansion
title NeptuneOS Finalization
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul
mode 60,30
echo !S_YELLOW!Doing some cleanup before final use, this won't take long.
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticecaption" /t REG_SZ /d "" /f >nul
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticetext" /t REG_SZ /d "" /f >nul
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f >nul
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f >nul

del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
del /s /f /q %USERPROFILE%\appdata\local\temp\*.* >nul 2>&1
cd %systemroot% & del *.log /s /f /q /a >nul 2>&1
cd %homepath% & del *.log /s /f /q /a >nul 2>&1
cls & echo !S_YELLOW!Finished.
echo !S_YELLOW!Enjoy NeptuneOS.
timeout /t 3 /nobreak >nul
del "%~f0"