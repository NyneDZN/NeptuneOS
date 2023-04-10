reg delete "HKLM\System\ControlSet001\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /f
reg add "HKLM\SYSTEM\ControlSet001\Services\fvevol" /v "Start" /t REG_DWORD /d "4" /f
