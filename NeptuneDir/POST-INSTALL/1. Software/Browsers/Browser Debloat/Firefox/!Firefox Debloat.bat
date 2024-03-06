@echo off
echo Debloating Firefox

del "C:\Program Files\Mozilla Firefox\crashreporter.exe" /f /q >nul 2>&1
del "C:\Program Files\Mozilla Firefox\crashreporter.ini" /f /q >nul 2>&1
del "C:\Program Files\Mozilla Firefox\maintenanceservice.exe" /f /q >nul 2>&1
del "C:\Program Files\Mozilla Firefox\maintenanceservice_installer.exe" /f /q >nul 2>&1
del "C:\Program Files\Mozilla Firefox\minidump-analyzer.exe" /f /q >nul 2>&1
del "C:\Program Files\Mozilla Firefox\pingsender.exe" /f /q >nul 2>&1
del "C:\Program Files\Mozilla Firefox\updater.exe" /f /q >nul 2>&1

schtasks /delete /f /tn "Mozilla\Firefox Background Update 308046B0AF4A39CB" >nul 2>&1
schtasks /delete /f /tn "Mozilla\Firefox Default Browser Agent 308046B0AF4A39CB" >nul 2>&1
schtasks /delete /f /tn Mozilla >nul 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain\{88088F95-5F8F-4603-8303-B2881ED6D9FD}" /f >nul 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain\{8F3A56F1-410F-41E7-B9CE-4F12A1417CF1}" /f >nul 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{88088F95-5F8F-4603-8303-B2881ED6D9FD}" /f >nul 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{8F3A56F1-410F-41E7-B9CE-4F12A1417CF1}" /f >nul 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Mozilla\Firefox Background Update 308046B0AF4A39CB" /f >nul 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Mozilla\Firefox Default Browser Agent 308046B0AF4A39CB" /f >nul 2>&1

start "" "C:\Program Files (x86)\Mozilla Maintenance Service\Uninstall.exe" >nul 2>&1
:: wmic product where name="Mozilla Maintenance Service" call uninstall /nointeractive >nul 2>&1

cd /d "C:\Program Files\Mozilla Firefox">nul 2>&1
del /f crash*.* >nul 2>&1
del /f maintenance*.* >nul 2>&1
del /f install.log >nul 2>&1
del /f minidump*.* >nul 2>&1