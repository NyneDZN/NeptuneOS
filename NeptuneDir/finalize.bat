@echo off
echo Doing some cleanup before final use, this won't take long.
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticecaption" /f >nul
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticetext" /f >nul
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /f >nul
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f >nul
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f >nul
del /f /q "%WinDir%\NeptuneDir\packages.bat" >nul 2>&1
del /f /q "%WinDir%\NeptuneDir\neptune-master.bat" >nul 2>&1
del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
del /s /f /q %USERPROFILE%\appdata\local\temp\*.* >nul 2>&1
cd %systemroot% & del *.log /s /f /q /a >nul 2>&1
cd %homepath% & del *.log /s /f /q /a >nul 2>&1
:: dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
cls & echo Finished.
echo Enjoy NeptuneOS.
timeout /t 2 /nobreak >nul
del "%~f0"