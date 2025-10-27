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

:: Disable IMOD
schtasks /Change /TN "XHCI IMOD" /Disable

:: Echo to user
echo %S_GREEN%XHCI IMOD Disabled.%S_GREEN%
pause