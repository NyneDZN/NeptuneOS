@echo off
%windir%\NeptuneDir\Tools\PowerRun.exe /SW:0 "Reg.exe" add "HKLM\System\CurrentControlSet\services\pcw" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe" /v "Debugger" /t REG_SZ /d "C:\Windows\NeptuneDir\Apps\proexp.exe" /f >nul 2>&1
echo Reverted Task Manager, you may have to restart your PC.
pause>nul