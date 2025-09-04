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
%svcF% bttflt 4 
%svcF% gcs 4 
%svcF% gencounter 4 
%svcF% hvcrash 4 
%svcF% hvhost 4 
%svcF% hvservice 4 
%svcF% hvsocketcontrol 4 
%svcF% passthruparser 4 
%svcF% pvhdparser 4 
%svcF% spaceparser 4 
%svcF% storflt 4 
%svcF% vhdparser 4 
%svcF% Vid 4 
%svcF% vkrnlintvsc 4 
%svcF% vkrnlintvsp 4 
%svcF% vmbus 4 
%svcF% vmbusr 4 
%svcF% vmcompute 4 
%svcF% vmgid 4 
%svcF% vmicguestinterface 4 
%svcF% vmicheartbeat 4 
%svcF% vmickvpexchange 4 
%svcF% vmicrdv 4 
%svcF% vmicshutdown 4 
%svcF% vmictimesync 4 
%svcF% vmicvmsession 4 
%svcF% vmicvss 4 
%svcF% vpci 4
%svcF% rdpbus 4
%svcF% NdisVirtualBus 4

:: Hyper-V Devices
C:\Windows\NeptuneDir\Tools\dmv.exe /disable "Microsoft Hyper-V NT Kernel Integration VSP"
C:\Windows\NeptuneDir\Tools\dmv.exe /disable "Microsoft Hyper-V PCI Server"
C:\Windows\NeptuneDir\Tools\dmv.exe /disable "Microsoft Hyper-V Virtual Disk Server"
C:\Windows\NeptuneDir\Tools\dmv.exe /disable "Microsoft Hyper-V Virtual Machine Bus Provider"
C:\Windows\NeptuneDir\Tools\dmv.exe /disable "Microsoft Hyper-V Virtualization Infrastructure Driver"
C:\Windows\NeptuneDir\Tools\dmv.exe /disable "Microsoft Hypervisor Service"
C:\Windows\NeptuneDir\Tools\dmv.exe /disable "NDIS Virtual Network Adapter Enumerator"
C:\Windows\NeptuneDir\Tools\dmv.exe /disable "Remote Desktop Device Redirector Bus"



:: DISM
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-All" /NoRestart
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Management-Clients" /NoRestart 
:: Disable Hyper-V Management Tool
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Tools-All" /NoRestart
:: Disable Hyper-V Module for Windows PowerShell
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Management-PowerShell" /NoRestart

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

:: Echo to Log
echo %date% %time% Disabled Hyper-V >> %userlog%
:: Echo to User
echo !S_YELLOW!Disabled Hyper-V. Restart your device to apply the changes.
timeout /t 3 /nobreak >nul
exit



:Nope
exit