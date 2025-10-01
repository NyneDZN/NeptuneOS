@echo off
DevManView /uninstall "NVIDIA Virtual Audio Device (Wave Extensible) (WDM)" >nul 2>&1
DevManView /uninstall "NvModuleTracker Device" >nul 2>&1

reg add "HKCU\SOFTWARE\NVIDIA Corporation\NVControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /d "0" /f >nul 2>&1
for %%i in (NvTmMon NvTmRep NvProfile NvNodeLauncher NvDriverUpdateCheckDaily NvBatteryBoostCheckOnLogon "NVIDIA GeForce Experience SelfUpdate") do for /f "tokens=1 delims=," %%a in ('schtasks /query /fo csv^| findstr /v "TaskName"^| findstr "%%~i"') do schtasks /change /tn "%%a" /disable >nul 2>&1