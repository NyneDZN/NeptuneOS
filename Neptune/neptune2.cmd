@echo off && color f1
mode con: cols=40 lines=20

:: Path Variables
set neptunemain=C:\NeptuneOS-installer\Neptune\
set neptunedev=C:\NeptuneOS-installer-dev\Neptune\

echo Downloading NeptuneOS...
timeout /t 5 /nobreak > nul
curl -o %neptunemain%neptune.7z -L -s https://github.com/NyneDZN/NeptuneOS/archive/refs/heads/main.zip
cls & echo Initializing Installer...
:: Extract and Delete .7z
cd "%neptunemain%" > nul
7za x neptune.7z > nul
del neptune.7z > nul
:: Change Directory into repository folder
cd "%neptunemain%NeptuneOS-main" > nul
:: Move Neptune Modules to WinDir
move NeptuneDir %WinDir% > nul
:: Move Desktop Shortcut to USERS Desktop
move "%neptunemain%NeptuneOS-main\Desktop\Neptune.lnk" "C:\Users\%USERNAME%\Desktop" > nul
:: Move Neptune Utilities to WinDir
for %%a in (layout.xml, regjump.exe, serviwin.exe) do (move "%%a" "%WinDir%")
:: Move Neptune Wallpapers
takeown /f "C:\Windows\Web" /r && icacls C:\Windows\Web\ /grant administrators:F /T && rmdir /s /q "C:\Windows\Web" && move "%neptunemain%NeptuneOS-main\Web" "%WinDir%" > nul
:: Move Neptune Account Icons
takeown /f "C:\ProgramData\Microsoft\User Account Pictures" /r && icacls "C:\ProgramData\Microsoft\User Account Pictures" /grant administrators:F /T && rmdir /s /q "C:\ProgramData\Microsoft\User Account Pictures" && move "%neptunemain%NeptuneOS-main\ProgramData\Microsoft\User Account Pictures" "C:\ProgramData\Microsoft" > nul
:: Delete the initial batch file
del /q /f "%USERPROFILE%Desktop\neptune_dev.cmd" > nul
:: Install Neptune
cls & echo Opening Installer...
timeout /t 2 > nul
start "" "%WinDir%\NeptuneDir\neptune-master.cmd" /postinstall