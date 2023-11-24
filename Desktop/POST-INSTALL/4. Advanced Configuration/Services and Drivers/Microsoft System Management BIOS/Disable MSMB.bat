@echo off
echo Warning: Disabling the Microsoft System Management BIOS Driver will break functionality for the system and programs, such as GTAV.
echo Close the script if you do not want to continue.
pause>nul
%windir%\neptunedir\tools\dmv.exe /disable "Microsoft System Management BIOS Driver"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mssmbios" /v "Start" /t REG_DWORD /d "4" /f > nul 2>&1
echo The Microsoft System Management BIOS Driver has been disabled.
