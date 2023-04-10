@echo off
%WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 Reg.exe add "HKLM\SYSTEM\CurrentControlSet\services\hidserv" /v "Start" /t REG_DWORD /d "2" /f
sc start hidserv>nul
echo Keyboard Media Control enabled, you may have to restart your PC.
pause>nul