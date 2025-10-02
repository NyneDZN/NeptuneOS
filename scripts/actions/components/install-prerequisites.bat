call "C:\neptune-installer\modules\variables.cmd"

cls & echo !S_YELLOW!Installing Visual C++... [15/18]
start /wait "" "%prereqDir%\vcredist.exe" /ai8X239T 

cls & echo !S_YELLOW!Installing DirectX... [16/18]
start /wait "" "%prereqDir%\DirectX\DXSETUP.exe" /silent 

:: start /wait "" "%prereqDir%\7z.exe" /S
:: reg import "C:\neptune-installer\scripts\actions\7z.reg"


endlocal
goto :eof
