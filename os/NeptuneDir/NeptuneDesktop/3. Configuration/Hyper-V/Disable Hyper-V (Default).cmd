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

:: Disable Hyper-V Services/Drivers
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
cls

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
@echo off
set /p answer=Do you want to remove Hyper-V components aswell? They can be re-enabled manually. (yes/no):

if /i "%answer%"=="yes" (
    echo Uninstalling Hyper-V features
    dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-All" /NoRestart
    dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Management-Clients" /NoRestart
    :: Disable Hyper-V Management Tool
    dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Tools-All" /NoRestart
    :: Disable Hyper-V Module for Windows PowerShell
    dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Management-PowerShell" /NoRestart
    goto :bcd

) else (
    goto :bcd
)

:bcd
cls & bcdedit /set hypervisorlaunchtype off > nul

:: Echo back to user
echo]
echo %S_GREEN%Disabled Hyper-V%S_GREEN%
echo]
echo %S_WHITE%Press any key to exit...%S_WHITE%
pause > nul
exit /b