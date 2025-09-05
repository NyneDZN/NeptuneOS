@echo off
REM Go 3 folders up to root
cd /d "%~dp0..\..\.."

set "jsonFile=systeminfo.json"
set "cacheFile=%temp%\sysvars.env"

REM Call PowerShell subscript to parse JSON into batch-ready variables
powershell -NoProfile -ExecutionPolicy Bypass -File "%cd%\parse-json.ps1" "%jsonFile%" "%cacheFile%"

REM Import them
call "%cacheFile%"

del "%cacheFile%" >nul 2>&1

:: One-liner for sub-scripts
:: call "%~dp0variables.cmd"
