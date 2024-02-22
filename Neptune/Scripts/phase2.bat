@echo off
net stop wuauserv > nul
curl -o neptune.7z -L https://github.com/NyneDZN/NeptuneOS/archive/refs/tags/releases.zip
move neptune.7z C:\NeptuneOS-installer\Neptune
cd "C:\NeptuneOS-installer\Neptune"
7za x neptune.7z
cd "NeptuneOS-releases"
move NeptuneDir %WinDir%
move "ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\start.cmd" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
move "C:\NeptuneOS-installer\Neptune\NeptuneOS-releases\layout.xml" "%WinDir%"
move "C:\NeptuneOS-installer\Neptune\NeptuneOS-releases\regjump.exe" "%WinDir%"
move "C:\NeptuneOS-installer\Neptune\NeptuneOS-releases\serviwin.exe" "%WinDir%"
takeown /f "C:\ProgramData\Microsoft\User Account Pictures" /r >nul
icacls C:\ProgramData\Microsoft\User Account Pictures\ /grant administrators:F /T >nul
rmdir /s /q "C:\ProgramData\Microsoft\User Account Pictures" >nul
move "C:\NeptuneOS-installer\Neptune\NeptuneOS-releases\ProgramData\Microsoft\User Account Pictures" "C:\ProgramData\Microsoft" >nul
takeown /f "C:\Windows\Web" /r >nul
icacls C:\Windows\Web\ /grant administrators:F /T >nul
rmdir /s /q "C:\Windows\Web" >nul
move "C:\NeptuneOS-installer\Neptune\NeptuneOS-releases\Web" "%WinDir%" >nul
cls
echo This will execute 2 command prompt windows for the installation process. Please ignore any errors you might see in both windows, as these are normal.
echo Wait until you are asked to restart your PC.
echo The script will start in 10 seconds, or you can press any key.
timeout /t 10 >nul
:: The Master Script should always be infront of the Package Debloat script window.
start "First Batch" cmd /c call "%WinDir%\NeptuneDir\packages.bat"
start "Second Batch" "%WinDir%\NeptuneDir\Tools\NSudoLG.exe" -U:T -P:E "%WinDir%\NeptuneDir\neptune-master.bat" /postinstall