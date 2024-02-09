@echo off
echo Please disable defender, then press any key to continue.
echo.
echo If defender is not disabled, then you will be prompted with an NSUDO error, and you will have to re-run neptune.cmd.
pause>nul
cls
curl https://codeload.github.com/NyneDZN/NeptuneOS/zip/refs/heads/main --output neptune.7z
7za x neptune.7z
cd "NeptuneOS-main"
move NeptuneDir %WinDir%
move "ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\start.cmd" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
move "C:\Neptune\NeptuneOS-main\layout.xml" "%WinDir%"
move "C:\Neptune\NeptuneOS-main\regjump.exe" "%WinDir%"
takeown /f "C:\ProgramData\Microsoft\User Account Pictures" /r >nul
rmdir /s /q "C:\ProgramData\Microsoft\User Account Pictures" >nul
move "C:\Neptune\NeptuneOS-main\ProgramData\Microsoft\User Account Pictures" "C:\ProgramData\Microsoft" >nul
takeown /f "C:\Windows\Web" /r >nul
rmdir /s /q "C:\Windows\Web" >nul
move "C:\Neptune\NeptuneOS-main\Web" "%WinDir%" >nul
cls
echo This will execute 2 command prompt windows for the installation process. Please ignore any errors you might see in both windows, as these are normal.
echo The first window will finish early, and the second one will continue for a moment before asking you to restart.
echo All of this code is open-source and available to you in these locations. "C:\Neptune\Scripts" and "C:\Windows\NeptuneDir"
echo Press any key to start the script.
:: The Master Script should always be infront of the Package Debloat script window.
:: This is to show
start "First Batch" cmd /c call "%WinDir%\NeptuneDir\packages.bat"
start "Second Batch" cmd /c call "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\start.cmd"