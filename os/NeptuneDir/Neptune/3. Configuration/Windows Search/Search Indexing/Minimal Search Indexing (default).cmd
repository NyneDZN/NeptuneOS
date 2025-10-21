@echo off
setlocal EnableDelayedExpansion
set indexConfPath="%windir%\NeptuneDir\Scripts\indexConf.cmd"
if not exist %indexConfPath% (
	echo The 'indexConf.cmd' script wasn't found in AtlasModules.
	if "%~1"=="" pause
	exit /b 1
)
set "indexConf=call %indexConfPath%"

if "%~1" neq "" goto main
:: TI required for RespectPowerModes
whoami /user | find /i "S-1-5-18" > nul 2>&1 || (
	call RunAsTI.cmd "%~f0" %*
	exit /b
)

:main
echo ===================================
echo Making search indexing minimal...
echo This means no user folder indexing.
echo ===================================
echo]

%indexConf% /stop

%indexConf% /cleanpolicies
:: Add only the Start Menu and Neptune Desktop paths by default
:: Neptune Folder
%indexConf% /include "%programdata%\Microsoft\Windows\Start Menu\Programs"
%indexConf% /include "%windir%\NeptuneDir\Neptune"
%indexConf% /exclude "%systemdrive%\Users"

:: Respect Power Settings when Search Indexing to prevent performance loss during gaming or battery drain
reg add "HKLM\Software\Microsoft\Windows Search\Gather\Windows\SystemIndex" /v "RespectPowerModes" /t REG_DWORD /d 1 /f > nul

%indexConf% /start
reg add "HKLM\SOFTWARE\Microsoft\Windows Search" /v SetupCompletedSuccessfully /t REG_DWORD /d 0 /f > nul

echo]
echo Finished, there might be some CPU usage for a very small period while indexing.
if "%~1" neq "/silent" pause
exit /b