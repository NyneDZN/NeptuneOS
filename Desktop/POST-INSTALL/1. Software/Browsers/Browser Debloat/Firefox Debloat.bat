cd /d "C:\Program Files\Mozilla Firefox"
del /f crash*.*
del /f maintenance*.*
del /f install.log
del /f minidump*.*
del "C:\Program Files\Mozilla Firefox\crashreporter.exe" /f /q
del "C:\Program Files\Mozilla Firefox\crashreporter.ini" /f /q
del "C:\Program Files\Mozilla Firefox\maintenanceservice.exe" /f /q
del "C:\Program Files\Mozilla Firefox\maintenanceservice_installer.exe" /f /q
del "C:\Program Files\Mozilla Firefox\minidump-analyzer.exe" /f /q
del "C:\Program Files\Mozilla Firefox\pingsender.exe" /f /q
del "C:\Program Files\Mozilla Firefox\updater.exe" /f /q

Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain\{88088F95-5F8F-4603-8303-B2881ED6D9FD}" /f
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain\{8F3A56F1-410F-41E7-B9CE-4F12A1417CF1}" /f
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{88088F95-5F8F-4603-8303-B2881ED6D9FD}" /f
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{8F3A56F1-410F-41E7-B9CE-4F12A1417CF1}" /f
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Mozilla\Firefox Background Update 308046B0AF4A39CB" /f
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Mozilla\Firefox Default Browser Agent 308046B0AF4A39CB" /f

wmic product where name="Mozilla Maintenance Service" call uninstall /nointeractive
