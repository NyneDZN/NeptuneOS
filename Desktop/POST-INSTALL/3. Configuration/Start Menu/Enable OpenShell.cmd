echo Enabling Open-Shell and disabling the Windows Start Menu
ren "C:\Program Files\OpenShellOld" Open-Shell >nul 2>&1
start "C:\Program Files\Open-Shell\StartMenu.exe" >nul 2>&1
taskkill /f /im StartMenuExperienceHost.exe >nul 2>&1
ren "C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\StartMenuExperienceHost.exe" ShitStartMenu.exe >nul 2>&1

pause>nul