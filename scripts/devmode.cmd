@echo off
setlocal

:: Go up one folder from where this script is located
set "PARENT=%~dp0.."
for %%I in ("%PARENT%") do set "ROOT=%%~fI"

:: Debug - show the path being used
echo Running from: %ROOT%\master.ps1
pause

:: Run the script without elevation for now
"%ROOT%\tools\MinSudo.exe" -NoL -V -S -WD=%ROOT% C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\master.ps1" -DevMode

endlocal
pause
