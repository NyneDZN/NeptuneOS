@echo off
echo Deleting Brave Bloatware


taskkill /f /im "BraveUpdate.exe" >nul 2>&1
taskkill /f /im "brave_installer-x64.exe" >nul 2>&1
taskkill /f /im "BraveCrashHandler.exe" >nul 2>&1
taskkill /f /im "BraveCrashHandler64.exe" >nul 2>&1
taskkill /f /im "BraveCrashHandlerArm64.exe" >nul 2>&1
taskkill /f /im "BraveUpdateBroker.exe" >nul 2>&1
taskkill /f /im "BraveUpdateCore.exe" >nul 2>&1
taskkill /f /im "BraveUpdateOnDemand.exe" >nul 2>&1
taskkill /f /im "BraveUpdateSetup.exe" >nul 2>&1
taskkill /f /im "BraveUpdateComRegisterShell64" >nul 2>&1
taskkill /f /im "BraveUpdateComRegisterShellArm64" >nul 2>&1
sc delete brave >nul 2>&1
sc delete bravem >nul 2>&1
sc delete BraveElevationService >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\BraveSoftware\Update" >nul 2>&1

schtasks /delete /f /tn BraveSoftwareUpdateTaskMachineCore{2320C90E-9617-4C25-88E0-CC10B8F3B6BB} >nul 2>&1
schtasks /delete /f /tn BraveSoftwareUpdateTaskMachineUA{FD1FD78D-BD51-4A16-9F47-EE6518C2D038} >nul 2>&1
reg delete "HKLM\Software\Microsoft\Active Setup\Installed Components\{AFE6A462-C574-4B8A-AF43-4CC60DF4563B}" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{56CA197F-543C-40DC-953C-B9C6196C92A5}" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain\{0948A341-8E1E-479F-A667-6169E4D5CB2A}" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{0948A341-8E1E-479F-A667-6169E4D5CB2A}" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{56CA197F-543C-40DC-953C-B9C6196C92A5}" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\BraveSoftwareUpdateTaskMachineCore" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\BraveSoftwareUpdateTaskMachineUA" /f >nul 2>&1