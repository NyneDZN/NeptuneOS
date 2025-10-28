@echo off
call "%WinDir%\NeptuneDir\Scripts\envINIT.cmd"

set "script=%windir%\NeptuneDir\Scripts\ScriptWrappers\DisableFileSharing.ps1"

if not exist "%script%" (
    echo Script not found.
    echo "%script%"
    pause
    exit /b 1
)

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
powershell -EP Bypass -NoP -File "%script%"
if "%~1"=="/silent" exit /b

choice /c:yn /n /m "Finished, would you like to restart now to apply the changes? [Y/N] "
if %ERRORLEVEL% == 1 shutdown /r /t 0
echo Finished, File Sharing is now disabled.
pause > nul
exit /b
