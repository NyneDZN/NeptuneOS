:: Forked from AtlasOS, adapted to Neptune by NYN9

@echo off
set "script=%WinDir%\NeptuneDir\Scripts\ScriptWrappers\InstallSoftware.ps1"
if not exist "%script%" (
	echo Script not found.
	echo "%script%"
	pause
	exit /b 1
)
powershell -EP Bypass -NoP ^& """$env:script""" %*
pause