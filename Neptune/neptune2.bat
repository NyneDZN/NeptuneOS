@echo off & color f1
echo Downloading NeptuneOS...
curl -o neptune.7z -L -s https://github.com/NyneDZN/NeptuneOS/archive/refs/heads/main.zip
cls
echo Initializing Installer...
move neptune.7z C:\NeptuneOS-installer-dev\Neptune >nul
cd "C:\NeptuneOS-installer-dev\Neptune" >nul
7za x neptune.7z >nul
del neptune.7z >nul
cd "NeptuneOS-main" >nul
move NeptuneDir %WinDir% >nul
move "ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\start.cmd" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup" >nul
move "C:\NeptuneOS-installer-dev\Neptune\NeptuneOS-main\layout.xml" "%WinDir%" >nul
move "C:\NeptuneOS-installer-dev\Neptune\NeptuneOS-main\regjump.exe" "%WinDir%" >nul
move "C:\NeptuneOS-installer-dev\Neptune\NeptuneOS-main\serviwin.exe" "%WinDir%" >nul
move "C:\NeptuneOS-installer-dev\Neptune\NeptuneOS-main\Desktop\Neptune.lnk" "C:\Users\%USERNAME%\Desktop"
takeown /f "C:\ProgramData\Microsoft\User Account Pictures" /r && icacls C:\ProgramData\Microsoft\User Account Pictures\ /grant administrators:F /T >nul
rmdir /s /q "C:\ProgramData\Microsoft\User Account Pictures" >nul
move "C:\NeptuneOS-installer-dev\Neptune\NeptuneOS-main\ProgramData\Microsoft\User Account Pictures" "C:\ProgramData\Microsoft" >nul
takeown /f "C:\Windows\Web" /r && icacls C:\Windows\Web\ /grant administrators:F /T >nul
rmdir /s /q "C:\Windows\Web" >nul
move "C:\NeptuneOS-installer-dev\Neptune\NeptuneOS-main\Web" "%WinDir%" >nul
del /q /f "C:\Users\%USERNAME%\Desktop\neptune_dev.bat" >nul
cls
:: Install Neptune
echo Opening Installer...
timeout /t 2 >nul
start "" "C:\Windows\NeptuneDir\neptune-master.bat" /postinstall /devbuild
