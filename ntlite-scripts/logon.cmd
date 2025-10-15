@echo off

:: Variables
set neptver=1.1

:: Fullscreen Script
"%WinDir%\System32\cscript.exe" //nologo "%WinDir%\FullScreenCMD.vbs"

:: Pass to user
echo Welcome to NeptuneOS %neptver%, %USERNAME%
echo Deployment will begin in a moment.
timeout /t 3 /nobreak>nul

:: Launch script
powershell -ExecutionPolicy Bypass -File "%WinDir%\deploy_neptune.ps1"


