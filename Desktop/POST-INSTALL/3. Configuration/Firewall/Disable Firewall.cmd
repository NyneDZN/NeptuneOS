@echo off
echo Beware that disabling firewall WILL break some UWP apps, including the store and xbox apps.
echo Please close the script if you don't want to continue.
echo Press any key if you want to disable firewall.
pause>nul
Reg.exe add "HKLM\System\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "4" /f > nul
Reg.exe add "HKLM\System\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "4" /f > nul
echo Firewall has been disabled.
pause>nul