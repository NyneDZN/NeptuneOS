@echo off && color f1
mode con: cols=40 lines=20
echo Downloading NeptuneOS...
"%WinDir%\System32\WindowsPowerShell\v1.0\powershell.exe" -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/NyneDZN/NeptuneOS/archive/refs/heads/main.zip', 'C:\NeptuneOS-installer-dev\Neptune\neptune.7z');"
cls & echo Initializing Installer...
:: Extract and Delete .7z
7za x neptune.7z >nul
del neptune.7z >nul
:: Change Directory into repository folder
cd "NeptuneOS-main" >nul
:: Move Neptune Modules to WinDir
move NeptuneDir %WinDir% >nul
:: Move Desktop Shortcut to USERS Desktop
move "C:\NeptuneOS-installer-dev\Neptune\NeptuneOS-main\Desktop\Neptune.lnk" "C:\Users\%USERNAME%\Desktop" > nul
:: Move Neptune Utilities to WinDir
for %%a in (layout.xml, regjump.exe, serviwin.exe) do (move "%%a" "%WinDir%")
:: Move Neptune Wallpapers
takeown /f "C:\Windows\Web" /r && icacls C:\Windows\Web\ /grant administrators:F /T && rmdir /s /q "C:\Windows\Web" && move "C:\NeptuneOS-installer-dev\Neptune\NeptuneOS-main\Web" "%WinDir%" >nul
:: Delete the initial batch file
del /q /f "C:\Users\%USERNAME%\Desktop\neptune_dev.bat" >nul
:: Install Neptune
cls & echo Opening Installer...
timeout /t 2 >nul
start "" "C:\Windows\NeptuneDir\neptune-master.bat" /postinstall /devbuild