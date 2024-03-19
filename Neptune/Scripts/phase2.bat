@echo off & color f1
net stop wuauserv > nul
curl -o neptune.7z -L https://github.com/NyneDZN/NeptuneOS/archive/refs/heads/main.zip
move neptune.7z C:\NeptuneOS-installer-dev\Neptune
cd "C:\NeptuneOS-installer-dev\Neptune"
7za x neptune.7z
cd "NeptuneOS-main"
move NeptuneDir %WinDir%
move "ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\start.cmd" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
move "C:\NeptuneOS-installer-dev\Neptune\NeptuneOS-main\layout.xml" "%WinDir%"
move "C:\NeptuneOS-installer-dev\Neptune\NeptuneOS-main\regjump.exe" "%WinDir%"
move "C:\NeptuneOS-installer-dev\Neptune\NeptuneOS-main\serviwin.exe" "%WinDir%"
move "C:\NeptuneOS-installer\Neptune\NeptuneOS-releases\Desktop\Neptune.lnk" "%USERPROFILE%\Desktop"
takeown /f "C:\ProgramData\Microsoft\User Account Pictures" /r & icacls C:\ProgramData\Microsoft\User Account Pictures\ /grant administrators:F /T >nul
rmdir /s /q "C:\ProgramData\Microsoft\User Account Pictures" >nul
move "C:\NeptuneOS-installer-dev\Neptune\NeptuneOS-main\ProgramData\Microsoft\User Account Pictures" "C:\ProgramData\Microsoft" >nul
takeown /f "C:\Windows\Web" /r & icacls C:\Windows\Web\ /grant administrators:F /T >nul
rmdir /s /q "C:\Windows\Web" >nul
move "C:\NeptuneOS-installer-dev\Neptune\NeptuneOS-main\Web" "%WinDir%" >nul
cls
echo This will execute 2 command prompt windows for the installation process. Please ignore any errors you might see in both windows, as these are normal.
echo Wait until you are asked to restart your PC.
echo The script will start in 10 seconds, or you can press any key.
timeout /t 10 >nul
:: Install Neptune
PowerRun.exe /SW:1 "C:\Windows\NeptuneDir\neptune-master.bat" /postinstall /devbuild
