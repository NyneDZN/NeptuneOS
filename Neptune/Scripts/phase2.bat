@echo off
curl https://codeload.github.com/NyneDZN/NeptuneOS/zip/refs/heads/main --output neptune.7z
move neptune.7z C:\NeptuneOS-installer\Neptune
cd "C:\NeptuneOS-installer\Neptune"
7za x neptune.7z
cd "NeptuneOS-main"
move NeptuneDir %WinDir%
move "ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\start.cmd" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
move "C:\NeptuneOS-installer\Neptune\NeptuneOS-main\layout.xml" "%WinDir%"
move "C:\NeptuneOS-installer\Neptune\NeptuneOS-main\regjump.exe" "%WinDir%"
move "C:\NeptuneOS-installer\Neptune\NeptuneOS-main\serviwin.exe" "%WinDir%"
takeown /f "C:\ProgramData\Microsoft\User Account Pictures" /r >nul
rmdir /s /q "C:\ProgramData\Microsoft\User Account Pictures" >nul
move "C:\NeptuneOS-installer\Neptune\NeptuneOS-main\ProgramData\Microsoft\User Account Pictures" "C:\ProgramData\Microsoft" >nul
C:\NeptuneOS-installer\Neptune\nsudo\NSudoLG.exe -U:T -P:E -ShowWindowMode:Show -Wait "takeown /f "C:\Windows\Web" /r" >nul
rmdir /s /q "C:\Windows\Web" >nul
move "C:\NeptuneOS-installer\Neptune\NeptuneOS-main\Web" "%WinDir%" >nul
cls
echo This will execute 2 command prompt windows for the installation process. Please ignore any errors you might see in both windows, as these are normal.
echo Wait until you are asked to restart your PC.
echo The script will start in 10 seconds, or you can press any key.
timeout /t 10 >nul
:: The Master Script should always be infront of the Package Debloat script window.
start "First Batch" cmd /c call "%WinDir%\NeptuneDir\packages.bat"
start "Second Batch" "%WinDir%\NeptuneDir\Tools\NSudoLG.exe" -U:T -P:E "%WinDir%\NeptuneDir\neptune-master.bat" /postinstall