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

:: Warning
echo %S_YELLOW%This will break things such as Razer Synapse, Brightness & Media Control, and other special keyboard functionality.
echo]
echo %S_YELLOW%Close this script if you don't want to continue, otherwise press any key to Disable HID devices.
echo]
timeout /t 2 /nobreak>nul
pause

:: Disable Devices
%dmv% /disable "HID-compliant consumer control device"
%dmv% /disable "HID-Compliant system controller"
%dmv% /disable "HID-Compliant vendor-defined device"

:: Echo back to user
echo]
echo %S_GREEN%DisableD HID Devices%S_GREEN%
echo]
echo %S_WHITE%Press any key to exit...%S_WHITE%
pause > nul
exit /b