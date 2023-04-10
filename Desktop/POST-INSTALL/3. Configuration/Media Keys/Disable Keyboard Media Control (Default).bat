@echo off
%WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 Reg.exe add "HKLM\SYSTEM\CurrentControlSet\services\hidserv" /v "Start" /t REG_DWORD /d "4" /f
sc stop hidserv>nul
echo Keyboard Media Control has been disabled.
pause>nul