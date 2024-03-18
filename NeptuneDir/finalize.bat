@echo off
echo Doing some cleanup before final use, this won't take long.
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticecaption" /f >nul
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticetext" /f >nul
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /f >nul
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f >nul
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f >nul
PowerShell -ExecutionPolicy Unrestricted -Command "$shortcuts = @(; @{ Revert = $True;  Path = "^""$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk"^""; }; @{ Revert = $True;  Path = "^""$env:AppData\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge.lnk"^""; }; @{ Revert = $True;  Path = "^""$env:AppData\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Microsoft Edge.lnk"^""; }; @{ Revert = $True;  Path = "^""$env:Public\Desktop\Microsoft Edge.lnk"^""; }; @{ Revert = $True;  Path = "^""$env:SystemRoot\System32\config\systemprofile\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge.lnk"^""; }; @{ Revert = $False; Path = "^""$env:UserProfile\Desktop\Microsoft Edge.lnk"^""; }; ); foreach ($shortcut in $shortcuts) {; if (-Not (Test-Path $shortcut.Path)) {; Write-Host "^""Skipping, shortcut does not exist: `"^""$($shortcut.Path)`"^""."^""; continue; }; try {; Remove-Item -Path $shortcut.Path -Force -ErrorAction Stop; Write-Output "^""Successfully removed shortcut: `"^""$($shortcut.Path)`"^""."^""; } catch {; Write-Error "^""Encountered an issue while attempting to remove shortcut at: `"^""$($shortcut.Path)`"^""."^""; }; }" >nul
rmdir /s /q "C:\NeptuneOS-installer" >nul 2>&1
del /f /q "%WinDir%\NeptuneDir\packages.bat" >nul 2>&1
del /f /q "%WinDir%\NeptuneDir\neptune-master.cmd" >nul 2>&1
del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
del /s /f /q %USERPROFILE%\appdata\local\temp\*.* >nul 2>&1
cd %systemroot% & del *.log /s /f /q /a >nul 2>&1
cd %homepath% & del *.log /s /f /q /a >nul 2>&1
:: dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
cls & echo Finished.
echo Enjoy NeptuneOS.
timeout /t 2 /nobreak >nul
del "%~f0"