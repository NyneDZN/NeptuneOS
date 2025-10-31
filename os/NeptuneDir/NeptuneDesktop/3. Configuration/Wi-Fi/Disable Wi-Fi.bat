@echo off
title Disable Wi-Fi

:: Init
call "%WinDir%\NeptuneDir\Scripts\envINIT.cmd"

:: Run as administrator
set "___args="%~f0" %*"
fltmc > nul 2>&1 || (
    echo Administrator privileges are required.
    powershell -c "Start-Process -Verb RunAs -FilePath 'cmd' -ArgumentList """/c $env:___args"""" 2> nul || (
        echo You must run this script as admin.
        if "%*"=="" pause
        exit /b 1
    )
    exit /b
)

:: Disable wi-fi services
%svcF% WlanSvc 4
%svcF% vwififlt 4

:: Exit script if called with /silent argument
if "%~1"=="/silent" exit /b

:: Echo back to user
echo]
echo %S_GREEN%Disabled Wi-Fi.%S_GREEN%
echo]
echo %S_WHITE%Press any key to exit...%S_WHITE%
pause > nul
exit /b