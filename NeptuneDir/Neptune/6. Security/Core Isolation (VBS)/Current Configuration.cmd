@echo off
echo This script is forked from the AtlasOS repository.
timeout /t 2 /nobreak >nul
set "script=%windir%\NeptuneDir\Scripts\ConfigVBS.ps1"
if not exist "%script%" (
	echo Script not found.
	echo "%script%"
	pause
	exit /b 1
)
powershell -EP Bypass -NoP ^& """$env:script""" %*