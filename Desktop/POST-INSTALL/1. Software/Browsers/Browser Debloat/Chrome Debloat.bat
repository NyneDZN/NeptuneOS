@echo off
echo Debloating Chrome
timeout 1 > nul
net stop gupdate
sc delete gupdate
net stop googlechromeelevationservice
sc delete googlechromeelevationservice
net stop gupdatem
sc delete gupdatem
taskkill /f /im GoogleUpdate.exe
rmdir "C:\Program Files (x86)\Google\Update" /s /q
cd /d "C:\Program Files\Google\Chrome\Application\"
dir chrmstp.exe /a /b /s
del chrmstp.exe /a /s
cls
reg delete "HKLM\Software\Microsoft\Active Setup\Installed Components\{8A69D345-D564-463c-AFF1-A69D9E530F96}" /f
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{950E9395-8BFF-4D96-8731-A3BD3F3C3ABD}" /f
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain\{8EB03C8D-6422-494A-A237-B87232D89A24}" /f
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{8EB03C8D-6422-494A-A237-B87232D89A24}" /f
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{950E9395-8BFF-4D96-8731-A3BD3F3C3ABD}" /f
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\GoogleUpdateTaskMachineCore" /f
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\GoogleUpdateTaskMachineUA" /f
cls
exit /b