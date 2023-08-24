:: Start the post script
start "" "%WinDir%\NeptuneDir\Tools\NSudoLG.exe" -U:T -P:E "%WinDir%\NeptuneDir\neptune-master.cmd" /postinstall

:: Delete this batch file & exit
del /F /Q %0