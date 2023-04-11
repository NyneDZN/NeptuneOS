reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ /d "fvevol" /f
reg add "HKLM\SYSTEM\ControlSet001\Services\fvevol" /v "Start" /t REG_DWORD /d "0" /f
