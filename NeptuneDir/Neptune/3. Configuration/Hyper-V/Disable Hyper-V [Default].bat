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
%svc% bttflt 4 
%svc% gcs 4 
%svc% gencounter 4 
%svc% hvcrash 4 
%svc% hvhost 4 
%svc% hvservice 4 
%svc% hvsocketcontrol 4 
%svc% passthruparser 4 
%svc% pvhdparser 4 
%svc% spaceparser 4 
%svc% storflt 4 
%svc% vhdparser 4 
%svc% Vid 4 
%svc% vkrnlintvsc 4 
%svc% vkrnlintvsp 4 
%svc% vmbus 4 
%svc% vmbusr 4 
%svc% vmcompute 4 
%svc% vmgid 4 
%svc% vmicguestinterface 4 
%svc% vmicheartbeat 4 
%svc% vmickvpexchange 4 
%svc% vmicrdv 4 
%svc% vmicshutdown 4 
%svc% vmictimesync 4 
%svc% vmicvmsession 4 
%svc% vmicvss 4 
%svc% vpci 4 

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