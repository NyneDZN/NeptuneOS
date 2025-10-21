@echo off
set "themes=%WinDir%\NeptuneDir\Themes"
set "localthemes=%LOCALAPPDATA%\Microsoft\Windows\Themes"

move "%themes%\*.theme" "%localthemes%"
