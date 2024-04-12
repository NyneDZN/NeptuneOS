@echo off
setlocal EnableDelayedExpansion
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul
echo]
echo !S_YELLOW!DISCLAIMER:
echo]
echo !S_RED!Setting a global timer resolution may increase power consumption and may lead to stuttering.
echo !S_RED!Games will handle timer resolution on their own[0m
echo]
echo]
echo %bullet% 1. Disable TimerResolution
echo %bullet% 2. Enable  0.5ms TimerResolution
echo %bullet% 3. Set custom TimerResolution
echo]
set /p menu2=Enter an option:
if %menu2% EQU 1 goto d
if %menu2% EQU 2 goto e
if %menu2% EQU 3 goto c
goto home

:d
powershell.exe Stop-Process -Name SetTimerResolution.exe >nul 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "ForceResolution" /f
timeout /t 2 /nobreak >nul 2>&1
exit

:e
powershell.exe Stop-Process -Name SetTimerResolution.exe >nul 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "ForceResolution" /t REG_SZ /d ""C:\Windows\NeptuneDir\Tools\SetTimerResolution.exe" --resolution 5000 --no-console" /f
start "" "C:\Windows\NeptuneDir\Tools\SetTimerResolution.exe" --resolution 5000 --no-console
timeout /t 2 /nobreak >nul 2>&1
exit

:c
cls && echo Example: 5000 for 0.5, 5100 for 0.51
set /p value=Enter custom value (integers):
powershell.exe Stop-Process -Name SetTimerResolution.exe >nul 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "ForceResolution" /t REG_SZ /d ""C:\Windows\NeptuneDir\Tools\SetTimerResolution.exe" --resolution %value% --no-console" /f
start "" "C:\Windows\NeptuneDir\Tools\SetTimerResolution.exe" --resolution %value% --no-console
timeout /t 2 /nobreak >nul 2>&1
exit
