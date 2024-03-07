@echo off
echo Warning: Disabling the Microsoft System Management BIOS Driver will disable functionality for some applications, such as GTA5 and FiveM.
echo Please close this script if you do not want to continue.
pause>nul
%windir%\neptunedir\tools\dmv.exe /disable "Microsoft System Management BIOS Driver"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mssmbios" /v "Start" /t REG_DWORD /d "4" /f > nul 2>&1
echo The Microsoft System Management BIOS Driver has been disabled.
timeout /t 2 >nul