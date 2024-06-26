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

echo !S_YELLOW!This will disable Lanman Workstation (SMB).
choice /C YN /M "Are you sure you want to continue?"
if errorlevel 2 (
    goto Nope
) else (
    goto DisableWorkstation
)


:DisableWorkstation
Reg add "HKLM\System\CurrentControlSet\Services\rdbss" /v "Start" /t REG_DWORD /d "4" /f > nul
Reg add "HKLM\System\CurrentControlSet\Services\KSecPkg" /v "Start" /t REG_DWORD /d "4" /f > nul
Reg add "HKLM\System\CurrentControlSet\Services\mrxsmb20" /v "Start" /t REG_DWORD /d "4" /f > nul
Reg add "HKLM\System\CurrentControlSet\Services\mrxsmb" /v "Start" /t REG_DWORD /d "4" /f > nul
Reg add "HKLM\System\CurrentControlSet\Services\srv2" /v "Start" /t REG_DWORD /d "4" /f > nul
Reg add "HKLM\System\CurrentControlSet\Services\LanmanWorkstation" /v "Start" /t REG_DWORD /d "4" /f > nul
dism /Online /Disable-Feature /FeatureName:SmbDirect /norestart


:: Echo to Log
echo %date% %time% Disabled Lanman Workstation (SMB) >> %userlog%
:: Echo to User
echo !S_YELLOW!Disabled Lanman Workstation (SMB). Restart your device to apply the changes.
timeout /t 3 /nobreak >nul
exit



:Nope
exit