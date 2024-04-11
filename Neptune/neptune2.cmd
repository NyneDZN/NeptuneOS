@echo off && color f1
mode con: cols=40 lines=20
echo Downloading NeptuneOS...
curl -o C:\NeptuneOS-installer-dev\Neptune\neptune.7z -L -s https://github.com/NyneDZN/NeptuneOS/archive/refs/heads/main.zip
cls & echo Initializing Installer...
:: Extract and Delete .7z
cd "C:\NeptuneOS-installer-dev\Neptune" > nul
7za x neptune.7z > nul
del neptune.7z > nul
:: Change Directory into repository folder
cd "C:\NeptuneOS-installer-dev\Neptune\NeptuneOS-main" > nul
:: Move Neptune Modules to WinDir
move NeptuneDir %WinDir% > nul
:: Move Desktop Shortcut to USERS Desktop
move "C:\NeptuneOS-installer-dev\Neptune\NeptuneOS-main\Desktop\Neptune.lnk" "C:\Users\%USERNAME%\Desktop" > nul
:: Move Neptune Utilities to WinDir
for %%a in (layout.xml, regjump.exe, serviwin.exe) do (move "%%a" "%WinDir%")
:: Move Neptune Wallpapers
takeown /f "C:\Windows\Web" /r && icacls C:\Windows\Web\ /grant administrators:F /T && rmdir /s /q "C:\Windows\Web" && move "C:\NeptuneOS-installer-dev\Neptune\NeptuneOS-main\Web" "%WinDir%" > nul
:: Move Neptune Account Icons
takeown /f "C:\ProgramData\Microsoft\User Account Pictures" /r && icacls "C:\ProgramData\Microsoft\User Account Pictures" /grant administrators:F /T && rmdir /s /q "C:\ProgramData\Microsoft\User Account Pictures" && move "C:\NeptuneOS-installer-dev\Neptune\NeptuneOS-main\ProgramData\Microsoft\User Account Pictures" "C:\ProgramData\Microsoft" > nul
:: Delete the initial batch file
del /q /f "C:\Users\%USERNAME%\Desktop\neptune_dev.cmd" > nul
:: Install Neptune
cls & echo Opening Installer...
timeout /t 2 > nul
start "" "C:\Windows\NeptuneDir\neptune-master.cmd" /postinstall /devbuild