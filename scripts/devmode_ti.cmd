@echo off
setlocal

:: Go up one folder from where this script is located
set "PARENT=%~dp0.."
for %%I in ("%PARENT%") do set "ROOT=%%~fI"

:: Debug - show the path being used
echo Running master.ps1 from: %ROOT%
pause

:: Launch master.ps1 as TrustedInstaller using PowerRun
"%ROOT%\tools\PowerRun.exe" Powershell.exe -File -NoProfile"%ROOT%\master.ps1" -DevMode

endlocal
pause
