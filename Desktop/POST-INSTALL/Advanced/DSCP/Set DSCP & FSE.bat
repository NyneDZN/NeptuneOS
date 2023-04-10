@echo off
echo "Please select the game you play."

for /f "tokens=* delims=\" %%i in ('C:\Windows\NeptuneDir\Tools\filepicker.exe exe') do (
    if "%%i"=="cancelled by user" exit
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Application Name" /t REG_SZ /d "%%~ni%%~xi" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Version" /t REG_SZ /d "1.0" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Protocol" /t REG_SZ /d "*" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Local Port" /t REG_SZ /d "*" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Local IP" /t REG_SZ /d "*" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Local IP Prefix Length" /t REG_SZ /d "*" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Remote Port" /t REG_SZ /d "*" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Remote IP" /t REG_SZ /d "*" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Remote IP Prefix Length" /t REG_SZ /d "*" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "DSCP Value" /t REG_SZ /d "46" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Throttle Rate" /t REG_SZ /d "-1" /f >nul 2>&1
    Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%%i" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE HIGHDPIAWARE" /f >nul 2>&1 
)
goto finish