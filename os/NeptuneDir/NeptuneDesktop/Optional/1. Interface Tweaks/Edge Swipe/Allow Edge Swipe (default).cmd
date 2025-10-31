@echo off
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

reg delete "HKLM\Software\Policies\Microsoft\Windows\EdgeUI" /v "AllowEdgeSwipe" /f > nul
if "%~1"=="/silent" exit /b

echo Changes applied successfully.
echo Press any key to exit...
pause > nul
exit /b