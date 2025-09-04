@echo off
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\services\ahcache" /v "Start" /t REG_DWORD /d "1" /f >nul 2>&1
echo Immersive Control Panel should now be working. Restart your PC to be sure.
pause>nul