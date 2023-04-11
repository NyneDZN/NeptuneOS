@echo off
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "UBR" /t REG_DWORD /d "789" /f >nul 2>&1
echo Modern Warfare 2 // WZ2 should now work. Restart your PC to be sure.
pause>nul