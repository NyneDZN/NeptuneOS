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

echo !S_YELLOW!This will disable the Hyper-V component.
choice /C YN /M "Are you sure you want to continue?"
if errorlevel 2 (
    goto Nope
) else (
    goto DisableHyperV
)


:DisableHyperV
cls & echo !S_YELLOW!Disabling Hyper-V
:: Hyper-V Services/Drivers
sc config bttflt start=disabled > nul
sc config gcs start=disabled > nul
sc config gencounter start=disabled > nul
sc config hvcrash start=disabled > nul
sc config hvhost start=disabled > nul
sc config hvservice start=disabled > nul
sc config hvsocketcontrol start=disabled > nul
sc config passthruparser start=disabled > nul
sc config pvhdparser start=disabled > nul
sc config spaceparser start=disabled > nul
sc config storflt start=disabled > nul
sc config vhdparser start=disabled > nul
sc config Vid start=disabled > nul
sc config vkrnlintvsc start=disabled > nul
sc config vkrnlintvsp start=disabled > nul
sc config vmbus start=disabled > nul
sc config vmbusr start=disabled > nul
sc config vmcompute start=disabled > nul
sc config vmgid start=disabled > nul
sc config vmicguestinterface start=disabled > nul
sc config vmicheartbeat start=disabled > nul
sc config vmickvpexchange start=disabled > nul
sc config vmicrdv start=disabled > nul
sc config vmicshutdown start=disabled > nul
sc config vmictimesync start=disabled > nul
sc config vmicvmsession start=disabled > nul
sc config vmicvss start=disabled > nul
sc config vpci start=disabled > nul

:: Hyper-V Devices
C:\Windows\NeptuneDir\Tools\dmv.exe /disable "Microsoft Hyper-V NT Kernel Integration VSP"
C:\Windows\NeptuneDir\Tools\dmv.exe /disable "Microsoft Hyper-V PCI Server"
C:\Windows\NeptuneDir\Tools\dmv.exe /disable "Microsoft Hyper-V Virtual Disk Server"
C:\Windows\NeptuneDir\Tools\dmv.exe /disable "Microsoft Hyper-V Virtual Machine Bus Provider"
C:\Windows\NeptuneDir\Tools\dmv.exe /disable "Microsoft Hyper-V Virtualization Infrastructure Driver"

:: DISM
dism /online /disable-feature:Microsoft-Hyper-V-All /quiet /norestart

:: BCD
bcdedit /set hypervisorlaunchtype off > nul
bcdedit /set vm no > nul
bcdedit /set vmslaunchtype Off > nul
bcdedit /set loadoptions DISABLE-LSA-ISO,DISABLE-VBS > nul

:: REGEDIT
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "EnableVirtualizationBasedSecurity" /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "RequirePlatformSecurityFeatures" /d "1" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HypervisorEnforcedCodeIntegrity" /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HVCIMATRequired" /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "LsaCfgFlags" /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "ConfigureSystemGuardLaunch" /d "0" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequireMicrosoftSignedBootChain" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f > nul

cls
:: Echo to Log
echo Hyper-V was disabled >> %neptlog%
:: Echo to User
echo !S_YELLOW!Hyper-V disabled. Please reboot.
timeout /t 3 >nul
exit



:Nope
exit