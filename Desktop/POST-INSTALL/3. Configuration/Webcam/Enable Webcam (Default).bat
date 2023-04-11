@echo off
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\services\swenum" /v "Start" /t REG_DWORD /d "3" /f
DevManView /enable "Plug and Play Software Device Enumerator"
DevManView /enable "USB Video Device"
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4D36E96C-E325-11CE-BFC1-08002BE10318}" /v "UpperFilters" /t REG_MULTI_SZ /d "ksthunk" /f
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{6BDD1FC6-810F-11D0-BEC7-08002BE2092F}" /v "UpperFilters" /t REG_MULTI_SZ /d "ksthunk" /f
Reg.exe add "HKLM\System\CurrentControlSet\services\ksthunk" /v "Start" /t REG_DWORD /d "3" /f
echo Webcam is now enabled.