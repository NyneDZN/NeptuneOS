@echo off
PowerRun.exe /SW:0 "Reg.exe" add "HKLM\SYSTEM\CurrentControlSet\Services\mssmbios" /v "Start" /t REG_DWORD /d "2" /f >nul 2>&1
%WinDir%\NeptuneDir\Tools\dmv.exe /enable "Microsoft System Management BIOS Driver"
echo GTA V should now work without issues.
pause