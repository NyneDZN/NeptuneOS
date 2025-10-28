@echo off
call "%WinDir%\NeptuneDir\Scripts\envINIT.cmd"

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

:: Echo to user
echo %S_GREEN%Enabling IMOD could potentially cause BSODs on some systems.%S_GREEN%
echo %S_GREEN%This script has a fail safe to disable IMOD if a BSOD occurs after reboot.%S_GREEN%
echo.
echo %S_YELLOW%Proceed with caution and at your own risk.%S_YELLOW%
echo.
choice /m "Do you want to continue?"

if errorlevel 2 (
    goto :eof
) else if errorlevel 1 (
    goto :imodcheck
)

:imodcheck
if exist "C:\Program Files\RW-Everything" (
    goto :imodenable
) else (
    echo RW-Everything is not installed.
    choice /m "Would you like to install it now?"
    if errorlevel 2 (
        echo Installation canceled.
        exit /b
    ) else (
        goto :installrw
    )
)

:imodenable
schtasks /Create /TN "XHCI IMOD" /XML "%NeptDir%\Tasks\XHCI Interrupt Moderation.xml" /F
pause


:installrw
start https://rweverything.com/download/
exit /b