:: Credit AtlasOS
:: Modified a tad by Nyne
:: To call this script:
:: cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul
@echo off
cd /d "%~dp0"
for /f %%a in ('forfiles /m "%~nx0" /c "cmd /c echo 0x1B"') do set "ESC=%%a"
set "right=%ESC%[<x>C"
set "bullet= %ESC%[34m-%ESC%[0m"
set "CMDLINE=RED=[31m,S_GRAY=[90m,S_RED=[91m,S_GREEN=[92m,S_YELLOW=[93m,S_MAGENTA=[95m,S_WHITE=[97m,B_BLACK=[40m,B_YELLOW=[43m,UNDERLINE=[4m,_UNDERLINE=[24m"
set "%CMDLINE:,=" & set "%"
set neptlog=%WinDir%\NeptuneDir\neptune.txt
set DevMan="%WinDir%\NeptuneDir\Tools\dmv.exe"
set svc=call %WinDir%\NeptuneDir\setSvc.cmd
set delf=del /f /s /q















:setSvc
:: %svc% (service name) (0-4)
if "%1"=="" (
echo You need to run this with a service to disable.
echo You need to run this with an argument ^(1-4^) to configure the service's startup.
exit /b 1
)
if "%2"=="" (
echo You need to run this with an argument ^(1-4^) to configure the service's startup.
exit /b 1 )
if %2 LSS 0 (
echo Invalid configuration.
exit /b 1 )
if %2 GTR 4 (
echo Invalid configuration.
exit /b 1 )
Reg query "HKLM\System\CurrentControlSet\Services\%1" >nul 2>&1 || (
echo The specified service/driver %1 is not found. >> %neptlog%
exit /b 1 )
%system% Reg add "HKLM\System\CurrentControlSet\Services\%1" /v "Start" /t Reg_DWORD /d "%2" /f > nul
echo Service/Driver %1 was configured
