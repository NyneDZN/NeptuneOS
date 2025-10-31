@echo off
title Hyper-V

:: Init
call "%WinDir%\NeptuneDir\Scripts\envINIT.cmd"

:: Run as administrator
set "___args="%~f0" %*"
fltmc > nul 2>&1 || (
    echo Administrator privileges are required.
    powershell -c "Start-Process -Verb RunAs -FilePath 'cmd' -ArgumentList """/c $env:___args"""" 2> nul || (
        echo You must run this script as admin.
        if "%*"=="" pause
        exit /b 1
    )
    exit /b
)

:: DISM
dism /Online /Enable-Feature /FeatureName:"Microsoft-Hyper-V-All" /NoRestart
dism /Online /Enable-Feature /FeatureName:"Microsoft-Hyper-V-Management-Clients" /NoRestart
:: Disable Hyper-V Managenagement Tool
dism /Online /Enable-Feature /FeatureName:"Microsoft-Hyper-V-Tools-All" /NoRestart
:: Disable Hyper-V Module for Windows PowerShell
dism /Online /Enable-Feature /FeatureName:"Microsoft-Hyper-V-Management-PowerShell" /NoRestart

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

:: BCD
bcdedit /set hypervisorlaunchtype auto > nul

:: Echo back to user
echo]
echo %S_GREEN%Enabled Hyper-V%S_GREEN%
echo]
echo %S_WHITE%Press any key to exit...%S_WHITE%
pause > nul
exit /b