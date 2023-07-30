echo Disabling Open-Shell and enabling the Windows Start Menu
taskkill /f /im StartMenu.exe >nul 2>&1
ren "C:\Program Files\Open-Shell" OpenShellOld >nul 2>&1
ren "C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\ShitStartMenu.exe" StartMenuExperienceHost.exe >nul 2>&1
pause>nul