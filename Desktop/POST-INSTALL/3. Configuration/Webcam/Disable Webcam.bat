@echo off
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\services\swenum" /v "Start" /t REG_DWORD /d "4" /f
%WinDir%\NeptuneDir\Tools\DevManView.exe /disable "Plug and Play Software Device Enumerator"
%WinDir%\NeptuneDir\Tools\DevManView.exe /disable "USB Video Device"
Reg.exe delete "HKLM\System\CurrentControlSet\Control\Class\{4D36E96C-E325-11CE-BFC1-08002BE10318}" /v "UpperFilters" /f
Reg.exe delete "HKLM\System\CurrentControlSet\Control\Class\{6BDD1FC6-810F-11D0-BEC7-08002BE2092F}" /v "UpperFilters" /f
Reg.exe add "HKLM\System\CurrentControlSet\services\ksthunk" /v "Start" /t REG_DWORD /d "4" /f
echo Webcam is now disabled.
pause>nul