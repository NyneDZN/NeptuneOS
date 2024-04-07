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
%svc% bttflt 0
%svc% gcs 3
%svc% gencounter 3
%svc% hvcrash 4
%svc% hvhost 3
%svc% hvservice 3
%svc% hvsocketcontrol 3
%svc% passthruparser 3
%svc% pvhdparser 3
%svc% spaceparser 3
%svc% storflt 0
%svc% vhdparser 3
%svc% Vid 1
%svc% vmbus 0 
%svc% vmbusr 3
%svc% vmcompute 3 
%svc% vmgid 3
%svc% vmicguestinterface 3 
%svc% vmicheartbeat 3
%svc% vmickvpexchange 3 
%svc% vmicrdv 3 
%svc% vmicshutdown 4 
%svc% vmictimesync 3 
%svc% vmicvmsession 3 
%svc% vmicvss 3 
%svc% vpci 1

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

