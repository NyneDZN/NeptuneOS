@echo off
setlocal EnableDelayedExpansion
mode 60,20
cd /d "%~dp0"
for /f %%a in ('forfiles /m "%~nx0" /c "cmd /c echo 0x1B"') do set "ESC=%%a"
set "right=%ESC%[<x>C"
set "bullet= %ESC%[34m-%ESC%[0m"
set "CMDLINE=RED=[31m,S_GRAY=[90m,S_RED=[91m,S_GREEN=[92m,S_YELLOW=[93m,S_MAGENTA=[95m,S_WHITE=[97m,B_BLACK=[40m,B_YELLOW=[43m,UNDERLINE=[4m,_UNDERLINE=[24m"
set "%CMDLINE:,=" & set "%"


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

