call "C:\neptune-installer\modules\variables.cmd"

start /wait "" "%prereqDir%\vcredist.exe" /ai8X239T 
start /wait "" "%prereqDir%\DirectX\DXSETUP.exe" /silent 

:: start /wait "" "%prereqDir%\7z.exe" /S
:: reg import "C:\neptune-installer\scripts\actions\7z.reg"


endlocal
goto :eof
