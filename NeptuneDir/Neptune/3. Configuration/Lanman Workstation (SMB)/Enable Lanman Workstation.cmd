@echo off
setlocal EnableDelayedExpansion
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul

:: Call Administrator
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select 'Run as administrator'.
        pause & exit 1
    )
    exit 0
)

echo !S_YELLOW!Enabling Lanman Workstation (SMB)
reg add "HKLM\System\CurrentControlSet\Services\rdbss" /v "Start" /t REG_DWORD /d "3" /f > nul
reg add "HKLM\System\CurrentControlSet\Services\KSecPkg" /v "Start" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\System\CurrentControlSet\Services\mrxsmb20" /v "Start" /t REG_DWORD /d "3" /f > nul
reg add "HKLM\System\CurrentControlSet\Services\mrxsmb" /v "Start" /t REG_DWORD /d "3" /f > nul
reg add "HKLM\System\CurrentControlSet\Services\srv2" /v "Start" /t REG_DWORD /d "3" /f > nul
reg add "HKLM\System\CurrentControlSet\Services\LanmanWorkstation" /v "Start" /t REG_DWORD /d "2" /f > nul
dism /Online /Enable-Feature /FeatureName:SmbDirect /norestart


:: Echo to Log
echo %date% %time% Enabled Lanman Workstation (SMB) >> %userlog%
:: Echo to User
echo !S_YELLOW!Enabled Lanman Workstation (SMB). Restart your device to apply the changes.
timeout /t 3 /nobreak >nul
exit




:Nope
exit