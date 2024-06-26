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
%svcF% rdpbus 3
%svcF% NdisVirtualBus 3



:: Hyper-V Devices
C:\Windows\NeptuneDir\Tools\dmv.exe /enable "Microsoft Hyper-V NT Kernel Integration VSP"
C:\Windows\NeptuneDir\Tools\dmv.exe /enable "Microsoft Hyper-V PCI Server"
C:\Windows\NeptuneDir\Tools\dmv.exe /enable "Microsoft Hyper-V Virtual Disk Server"
C:\Windows\NeptuneDir\Tools\dmv.exe /enable "Microsoft Hyper-V Virtual Machine Bus Provider"
C:\Windows\NeptuneDir\Tools\dmv.exe /enable "Microsoft Hyper-V Virtualization Infrastructure Driver"
C:\Windows\NeptuneDir\Tools\dmv.exe /enable "Microsoft Hypervisor Service"
C:\Windows\NeptuneDir\Tools\dmv.exe /enable "NDIS Virtual Network Adapter Enumerator"
C:\Windows\NeptuneDir\Tools\dmv.exe /enable "Remote Desktop Device Redirector Bus"

:: DISM
dism /Online /Enable-Feature /FeatureName:"Microsoft-Hyper-V-All" /NoRestart
dism /Online /Enable-Feature /FeatureName:"Microsoft-Hyper-V-Management-Clients" /NoRestart 
:: Disable Hyper-V Managenagement Tool
dism /Online /Enable-Feature /FeatureName:"Microsoft-Hyper-V-Tools-All" /NoRestart
:: Disable Hyper-V Module for Windows PowerShell
dism /Online /Enable-Feature /FeatureName:"Microsoft-Hyper-V-Management-PowerShell" /NoRestart

:: BCD
bcdedit /set loadoptions DISABLE-LSA-ISO,DISABLE-VBS > nul
bcdedit /deletevalue loadoptions > nul
bcdedit /set vsmlaunchtype Auto > nul
bcdedit /set hypervisorlaunchtype auto > nul
bcdedit /deletevalue vm > nul

:: REGEDIT
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "RequirePlatformSecurityFeatures" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HypervisorEnforcedCodeIntegrity" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "LsaCfgFlags" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "ConfigureSystemGuardLaunch" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequireMicrosoftSignedBootChain" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequirePlatformSecurityFeatures" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "Locked" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Locked" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /t REG_DWORD /d "1" /f



:: Echo to Log
echo %date% %time% Enabled Hyper-V >> %userlog%
:: Echo to User
echo !S_YELLOW!Enabled Hyper-V. Restart your device to apply the changes.
timeout /t 3 /nobreak >nul
exit