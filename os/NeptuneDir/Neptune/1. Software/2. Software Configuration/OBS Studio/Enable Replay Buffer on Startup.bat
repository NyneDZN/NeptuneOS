@echo off
title Configuration

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

:: (Configuration snippet here)
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "obs64" /t REG_SZ /d "cmd.exe /c start \"\" /d \"%programfiles%\obs-studio\bin\64bit\" obs64.exe --disable-shutdown-check --startreplaybuffer --disable-missing-files-check --minimize-to-tray" /f

:: Exit script if called with /silent argument
if "%~1"=="/silent" exit /b

:: Echo back to user
echo]
echo %S_GREEN%OBS replay buffer startup enabled%S_GREEN%
echo]
echo %S_WHITE%Press any key to exit...%S_WHITE%
pause > nul
exit /b