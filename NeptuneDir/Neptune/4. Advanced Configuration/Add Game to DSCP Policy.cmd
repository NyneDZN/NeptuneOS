@echo off
setlocal EnableDelayedExpansion

:: Call Administrator
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select 'Run as administrator'.
        pause & exit 1
    )
    exit 0
)

for /f "tokens=* delims=\" %%i in ('%WinDir%\NeptuneDir\Tools\filepicker.exe') do (
    if "%%i"=="cancelled by user" exit /b 1
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Application Name" /t REG_SZ /d "%%~ni%%~xi" /f > nul 2>&1
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Version" /t REG_SZ /d "1.0" /f > nul 2>&1
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Protocol" /t REG_SZ /d "*" /f > nul 2>&1
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Local Port" /t REG_SZ /d "*" /f > nul 2>&1
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Local IP" /t REG_SZ /d "*" /f > nul 2>&1
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Local IP Prefix Length" /t REG_SZ /d "*" /f > nul 2>&1
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Remote Port" /t REG_SZ /d "*" /f > nul 2>&1
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Remote IP" /t REG_SZ /d "*" /f > nul 2>&1
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Remote IP Prefix Length" /t REG_SZ /d "*" /f > nul 2>&1
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "DSCP Value" /t REG_SZ /d "46" /f > nul 2>&1
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Throttle Rate" /t REG_SZ /d "-1" /f > nul 2>&1
    echo %date% %time% Added %%~ni%%~xi to the DSCP policy  >> %userlog%
)

echo Finished, please reboot your device for changes to apply.
pause
exit /b