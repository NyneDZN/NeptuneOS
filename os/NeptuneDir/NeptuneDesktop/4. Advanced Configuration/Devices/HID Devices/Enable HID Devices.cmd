@echo off
title HID Devices

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

:: Enable Devices
%dmv% /enable "HID-compliant consumer control device"
%dmv% /enable "HID-Compliant system controller"
%dmv% /enable "HID-Compliant vendor-defined device"

:: Echo back to user
echo]
echo %S_GREEN%Enabled HID Devices%S_GREEN%
echo]
echo %S_WHITE%Press any key to exit...%S_WHITE%
pause > nul
exit /b