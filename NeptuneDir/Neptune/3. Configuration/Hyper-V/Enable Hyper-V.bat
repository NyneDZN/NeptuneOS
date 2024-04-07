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

echo !S_YELLOW!Enabling Hyper-V
:: Hyper-V Services/Drivers
sc config hvcrash start=disabled > nul
sc config hvservice start=manual > nul
sc config vhdparser start=manual > nul
sc config vmbus start=boot > nul
sc config Vid start=system > nul
sc config bttflt start=boot > nul
sc config gencounter start=manual > nul
sc config hvsocketcontrol start=manual > nul
sc config passthruparser start=manual > nul
sc config pvhdparser start=manual > nul
sc config spaceparser start=manual > nul
sc config storflt start=boot > nul
sc config vmgid start=manual > nul
sc config vmbusr start=manual > nul
sc config vpci start=boot > nul
sc config gcs start=manual > nul
sc config hvhost start=manual > nul
sc config vmcompute start=manual > nul
sc config vmicguestinterface start=manual > nul
sc config vmicheartbeat start=manual > nul
sc config vmickvpexchange start=manual > nul
sc config vmicrdv start=manual > nul
sc config vmicshutdown start=manual > nul
sc config vmictimesync start=manual > nul
sc config vmicvmsession start=manual > nul
sc config vmicvss start=manual > nul

:: Hyper-V Devices
C:\Windows\NeptuneDir\Tools\dmv.exe /enable "Microsoft Hyper-V NT Kernel Integration VSP"
C:\Windows\NeptuneDir\Tools\dmv.exe /enable "Microsoft Hyper-V PCI Server"
C:\Windows\NeptuneDir\Tools\dmv.exe /enable "Microsoft Hyper-V Virtual Disk Server"
C:\Windows\NeptuneDir\Tools\dmv.exe /enable "Microsoft Hyper-V Virtual Machine Bus Provider"
C:\Windows\NeptuneDir\Tools\dmv.exe /enable "Microsoft Hyper-V Virtualization Infrastructure Driver"

:: DISM
dism /online /disable-feature:Microsoft-Hyper-V-All /quiet /norestart

:: BCD
bcdedit /set loadoptions DISABLE-LSA-ISO,DISABLE-VBS > nul
bcdedit /deletevalue loadoptions > nul
bcdedit /set vsmlaunchtype Auto > nul
bcdedit /set hypervisorlaunchtype auto > nul
bcdedit /deletevalue vm > nul

:: REGEDIT
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /f > nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "RequirePlatformSecurityFeatures" /f > nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HypervisorEnforcedCodeIntegrity" /f > nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /f > nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "LsaCfgFlags" /f > nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "ConfigureSystemGuardLaunch" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequireMicrosoftSignedBootChain" /t REG_DWORD /d "1" /f > nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /f > nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /f > nul



cls
:: Echo to Log
echo Hyper-V was enabled >> %neptlog%
:: Echo to User
echo !S_YELLOW!Hyper-V enabled. Please reboot.
timeout /t 3 >nul
exit

