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


if not "%~1"=="/silent" call "%windir%\NeptuneDir\Scripts\serviceWarning.cmd" %*

:main
setlocal EnableDelayedExpansion

:: Disable SysMain (Prefetch, Memory Management features)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SysMain" /v "Start" /t REG_DWORD /d "4" /f > nul 
if "%~1"=="/silent" exit /b

echo Finished, please reboot your device for changes to apply.
pause
exit /b