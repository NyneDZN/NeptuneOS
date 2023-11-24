@echo off
%windir%\neptunedir\tools\dmv.exe /enable "Microsoft System Management BIOS Driver"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mssmbios" /v "Start" /t REG_DWORD /d "1" /f > nul 2>&1
echo The Microsoft System Management BIOS Driver has been enabled.
pause>nul
