call "C:\neptune-installer\modules\variables.cmd"

start /wait "" "%prereqDir%\vcredist.exe" /ai8X239T 
start /wait "" "%prereqDir%\DirectX\DXSETUP.exe" /silent 

start /wait "" "%prereqDir%\7zip.exe" /S


endlocal
goto :eof
