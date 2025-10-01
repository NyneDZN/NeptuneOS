set DevMan="%WinDir%\NeptuneDir\Tools\dmv.exe"

:: Device Manager
:: - > System Devices
%DevMan% /disable "ACPI Wake Alarm" 
%DevMan% /disable "Composite Bus Enumerator" 
%DevMan% /disable "Direct memory access controller" 
%DevMan% /disable "High precision event timer" 
%DevMan% /disable "Legacy device" 
%DevMan% /disable "Microsoft GS Wavetable Synth" 
%DevMan% /disable "Microsoft Kernel Debug Network Adapter" 
%DevMan% /disable "Motherboard resources" 
%DevMan% /disable "Numeric data processor" 
%DevMan% /disable "PCI Data Acquisition and Signal Processing Controller" 
%DevMan% /disable "PCI Device" 
%DevMan% /disable "PCI Memory Controller" 
%DevMan% /disable "PCI Simple Communications Controller" 
%DevMan% /disable "PCI Simple Communications Controller" 
%DevMan% /disable "PCI standard RAM Controller" 
%DevMan% /disable "Programmable interrupt controller" 
%DevMan% /disable "SM Bus Controller"
%DevMan% /disable "System board" 
%DevMan% /disable "System CMOS/real time clock" 
%DevMan% /disable "System Speaker" 
%DevMan% /disable "System Timer" 
%DevMan% /disable "UMBus Root Bus Enumerator" 
%DevMan% /disable "Unknown device" 

:: Hyper-V
%DevMan% /disable "Microsoft Hyper-V Virtualization Infrastructure Driver" 
%DevMan% /disable "Remote Desktop Device Redirector Bus" 

:: VPN Devices
%DevMan% /disable "Microsoft RRAS Root Enumerator" 
%DevMan% /disable "NDIS Virtual Network Adapter Enumerator" 
%DevMan% /disable "WAN Miniport (IKEv2)" 
%DevMan% /disable "WAN Miniport (IP)" 
%DevMan% /disable "WAN Miniport (IPv6)" 
%DevMan% /disable "WAN Miniport (L2TP)" 
%DevMan% /disable "WAN Miniport (Network Monitor)" 
%DevMan% /disable "WAN Miniport (PPPOE)" 
%DevMan% /disable "WAN Miniport (PPTP)" 
%DevMan% /disable "WAN Miniport (SSTP)"

:: Enable MSI mode on USB, GPU, Audio, SATA controllers, disk drives and network adapters
:: Deleting DevicePriority sets the priority to undefined
for %%a in ("CIM_NetworkAdapter", "CIM_USBController", "CIM_VideoController", "Win32_IDEController", "Win32_PnPEntity", "Win32_SoundDevice") do (
    if "%%~a" == "Win32_PnPEntity" (
        for /f "tokens=*" %%b in ('PowerShell -NoP -C "Get-WmiObject -Class Win32_PnPEntity | Where-Object {($_.PNPClass -eq 'SCSIAdapter') -or ($_.Caption -like '*High Definition Audio*')} | Where-Object { $_.PNPDeviceID -like 'PCI\VEN_*' } | Select-Object -ExpandProperty DeviceID"') do (
            reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%b\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f 
            reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%b\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f 
        )
    ) else (
        :: for /f %%b in ('wmic path %%a get PNPDeviceID ^| findstr /l "PCI\VEN_"') do (
        for /f "usebackq delims=" %%b in (`powershell -NoProfile -Command "Get-CimInstance -ClassName %%~a | Where-Object { $_.PNPDeviceID -like 'PCI\\VEN_*' } | Select-Object -ExpandProperty PNPDeviceID"`) do (
            reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%b\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f 
            reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%b\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f 
        )
    )
)

:: If a virtual machine is used, set network adapter to normal priority as Undefined may break internet connection
for %%a in ("hvm", "hyper", "innotek", "kvm", "parallel", "qemu", "virtual", "xen", "vmware") do (
    :: wmic computersystem get manufacturer /format:value | findstr /i /c:%%~a && (
    powershell -NoProfile -Command "(Get-CimInstance Win32_ComputerSystem).Manufacturer" | findstr /i /c:%%~a >nul && (
        :: for /f %%b in ('wmic path CIM_NetworkAdapter get PNPDeviceID ^| findstr /l "PCI\VEN_"') do (
        for /f "usebackq delims=" %%b in (`powershell -NoProfile -Command "Get-CimInstance -ClassName CIM_NetworkAdapter | Where-Object { $_.PNPDeviceID -like 'PCI\\VEN_*' } | Select-Object -ExpandProperty PNPDeviceID"`) do (
            reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%b\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "2" /f 
        )
    )
)