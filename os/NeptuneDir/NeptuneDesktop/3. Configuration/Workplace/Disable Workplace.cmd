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

if not "%~1"=="/silent" call "%windir%\NeptuneDir\Scripts\serviceWarning.cmd" %*

call "%windir%\NeptuneDir\Scripts\settingsPages.cmd" /hide workplace /silent

if "%~1"=="/silent" exit /b

echo.
echo Workplace settings page has been hidden.
pause
exit /b
