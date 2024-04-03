@echo off
setlocal EnableDelayedExpansion
mode 60,20
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul


echo              !S_RED!%ESC%[7mFirewall Configuration%ESC%[0m
echo]
echo]
echo            %bullet% Type 'on' to Enable Firewall
echo            %bullet% Type 'off' to Disable Firewall
echo]
echo]
echo]
echo]
echo  %ESC%[33mFirewall WILL break the following:%ESC%[0m
echo]
echo]
echo]

echo   %bullet% Microsoft Store
echo   %bullet% Third Party Apps that may require Firewall


set /p userInput=typyes > nul
if "%userinput%"=="on" goto Enable
if "%userinput%"=="off" goto Disable




:Enable
echo]
Reg.exe add "HKLM\System\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "2" /f > nul
Reg.exe add "HKLM\System\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "2" /f > nul
cls & echo  !S_YELLOW!Firewall Enabled
pause>nul
exit /b



:Disable
echo]
Reg.exe add "HKLM\System\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "4" /f > nul
Reg.exe add "HKLM\System\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "4" /f > nul
cls & echo  !S_YELLOW!Firewall Disabled
pause>nul
exit /b

