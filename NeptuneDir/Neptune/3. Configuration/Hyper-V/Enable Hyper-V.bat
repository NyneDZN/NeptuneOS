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
%svcF% bttflt 0
%svcF% gcs 3
%svcF% gencounter 3
%svcF% hvcrash 4
%svcF% hvhost 3
%svcF% hvservice 3
%svcF% hvsocketcontrol 3
%svcF% passthruparser 3
%svcF% pvhdparser 3
%svcF% spaceparser 3
%svcF% storflt 0
%svcF% vhdparser 3
%svcF% Vid 1
%svcF% vmbus 0 
%svcF% vmbusr 3
%svcF% vmcompute 3 
%svcF% vmgid 3
%svcF% vmicguestinterface 3 
%svcF% vmicheartbeat 3
%svcF% vmickvpexchange 3 
%svcF% vmicrdv 3 
%svcF% vmicshutdown 4 
%svcF% vmictimesync 3 
%svcF% vmicvmsession 3 
%svcF% vmicvss 3 
%svcF% vpci 1

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

