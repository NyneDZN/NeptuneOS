@echo off
reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ /d "fvevol" /f >nul 2>&1
reg add "HKLM\SYSTEM\ControlSet001\Services\fvevol" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
echo MSConfig should now be working.
pause>nul