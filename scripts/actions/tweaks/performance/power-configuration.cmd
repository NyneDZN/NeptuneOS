:: Unhide Hidden Power Configuration
:: source: https://gist.github.com/Velocet/7ded4cd2f7e8c5fa475b8043b76561b5#file-unlock-powercfg-ps1
:: PowerShell -ExecutionPolicy Unrestricted -Command  "$PowerCfg = (Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings' -Recurse).Name -notmatch '\bDefaultPowerSchemeValues|(\\[0-9]|\b255)$';foreach ($item in $PowerCfg) { Set-ItemProperty -Path $item.Replace('HKEY_LOCAL_MACHINE','HKLM:') -Name 'Attributes' -Value 0 -Force}" 

:: Import Ultimate Powerplan and Rename
powercfg -import "%WinDir%\NeptuneDir\Prerequisites\power.pow" 11111111-1111-1111-1111-111111111111 
powercfg -setactive 11111111-1111-1111-1111-111111111111 
powercfg -changename 11111111-1111-1111-1111-111111111111 "NeptuneOS Powerplan 4.0." "A powerplan created to achieve low latency and high 0.01% lows." 
:: Remove Stock Powerplans
powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a 
powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e 
powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 
powercfg -delete e9a42b02-d5df-448d-aa00-03f14749eb61 

:: -  Hard Disk & NVMe Settings
:: Turn off hard disk after 0 seconds
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0 
:: Turn off secondary NVMe idle timeout
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 0012ee47-9041-4b5d-9b77-535fba8b1442 d3d55efd-c1ff-424e-9dc3-441be7833010 0 
:: Turn off primary NVMe idle timeout
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 0012ee47-9041-4b5d-9b77-535fba8b1442 d639518a-e56d-4345-8af2-b9f32fb26109 0 
:: Turn off NVMe noppme
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 0012ee47-9041-4b5d-9b77-535fba8b1442 fc7372b6-ab2d-43ee-8797-15e9841f2cca 0 

:: -  USB and Sleep Settings
:: Disable hub selective suspend timeout
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 2a737441-1930-4402-8d77-b2bebba308a3 0853a681-27c8-4100-a2fd-82013e970683 0 
:: Disable USB selective suspend setting
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 
:: Set USB 3 link power management to maximum performance
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0 
:: Disable deep sleep
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 2e601130-5351-4d9d-8e04-252966bad054 d502f7ee-1dc7-4efd-a55d-f04b6f5c0545 0 
:: Disable away mode policy
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 0 
powercfg -setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 0 
:: Disable idle states
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0 
powercfg -setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0 
:: Disable hybrid sleep
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0 
powercfg -setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0 
:: Turn off system unattended sleep timeout
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 0 
:: Disable allow wake timers
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0 

:: -  Display and Battery Settings
:: Turn off display after 0 seconds
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0 
:: Disable critical battery notification
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 e73a048d-bf27-4f12-9731-8b2076e8891f 5dbb7c9f-38e9-40d2-9749-4f8a0e9f640f 0 
:: Disable critical battery action
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 e73a048d-bf27-4f12-9731-8b2076e8891f 637ea02f-bbcb-4015-8e2c-a1c7b9c0b546 0 
:: Set low battery level to 0
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 e73a048d-bf27-4f12-9731-8b2076e8891f 8183ba9a-e910-48da-8769-14ae6dc1170a 0 
:: Set critical battery level to 0
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 e73a048d-bf27-4f12-9731-8b2076e8891f 9a66d8d7-4ff7-4ef9-b5a2-5a326ca2a469 0 
:: Disable low battery notification
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 e73a048d-bf27-4f12-9731-8b2076e8891f bcded951-187b-4d05-bccc-f7e51960c258 0 
:: Set reserve battery level to 0
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 e73a048d-bf27-4f12-9731-8b2076e8891f f3c5027d-cd16-4930-aa6b-90db844a8f00 0 

:: - Processor and Performance Settings
:: Set processor states
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor PROCTHROTTLEMIN 100 
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor PROCTHROTTLEMAX 100 
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor 06cadf0e-64ed-448a-8927-ce7bf90eb35d 1 
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 1 
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor 7b224883-b3cc-4d79-819f-8374152cbe7c 100 
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor 4b92d758-5a24-4851-a470-815d78aee119 100 
:: Enable Turbo Boost
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor PERFBOOSTMODE 2 
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor PERFBOOSTPOL 100 
:: Prefer Performant Processors
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor SHORTSCHEDPOLICY 2 
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor SCHEDPOLICY 2 
:: Processor performance time check interval - 200 miliseconds
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 54533251-82be-4824-96c1-47b60b740d00 4d2b0152-7d5c-498b-88e2-34345392a2c5 200 
:: Allow Throttle States to Off
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 54533251-82be-4824-96c1-47b60b740d00 3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb 0 

:: - Miscellaneous
:: Set slideshow to paused
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 0d7dbae2-4294-402a-ba8e-26777e8488cd 309dce9b-bef4-4119-9921-a851fb12f0f4 1 
:: Disable hibernation
powercfg -h off 

:: Set NeptuneOS Scheme as Current
powercfg -setactive scheme_current 

:: Disable Sleep Study
wevtutil set-log "Microsoft-Windows-SleepStudy/Diagnostic" /e:false 
wevtutil set-log "Microsoft-Windows-Kernel-Processor-Power/Diagnostic" /e:false 
wevtutil set-log "Microsoft-Windows-UserModePowerService/Diagnostic" /e:false 


cls & echo !S_YELLOW!Disabling PowerSaving [3/18]
:: Most of this section is forked from AtlasOS

	PowerShell -NoP -C "$usb_devices = @('Win32_USBController', 'Win32_USBControllerDevice', 'Win32_USBHub'); $power_device_enable = Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi; foreach ($power_device in $power_device_enable){$instance_name = $power_device.InstanceName.ToUpper(); foreach ($device in $usb_devices){foreach ($hub in Get-WmiObject $device){$pnp_id = $hub.PNPDeviceID; if ($instance_name -like \"*$pnp_id*\"){$power_device.enable = $False; $power_device.psbase.put()}}}}" 

    for %%a in (
        "AllowIdleIrpInD3"
        "D3ColdSupported"
        "DeviceSelectiveSuspended"
        "EnableIdlePowerManagement"
        "EnableSelectiveSuspend"
        "EnhancedPowerManagementEnabled"
        "IdleInWorkingState"
        "SelectiveSuspendEnabled"
        "SelectiveSuspendOn"
        "WaitWakeEnabled"
        "WakeEnabled"
        "WdfDirectedPowerTransitionEnable"
    ) do (
        for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "%%~a" ^| findstr "HKEY"') do (
            reg add "%%b" /v "%%~a" /t REG_DWORD /d "0" /f 
        )
    )

:: Disable Storage Powersaving
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Storage" /v "StorageD3InModernStandby" /t REG_DWORD /d "0" /f 

:: Disable IdlePowerMode for stornvme.sys 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters\Device" /v "IdlePowerMode" /t REG_DWORD /d "0" /f 

	:: - > Disable Energy Estimation
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f 

:: - > Disable Connected Standby
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f 

:: Disable power throttling
:: https://blogs.windows.com/windows-insider/2017/04/18/introducing-power-throttling
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f 

:: Disable Timer Coalescing
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 

:: Disable ACPI C-States
:: https://learn.microsoft.com/sl-SI/troubleshoot/windows-server/virtualization/virtual-machines-slow-startup-shutdown
reg add "HKLM\System\CurrentControlSet\Control\Processor" /v "Capabilities" /t REG_DWORD /d "0x0007e066" /f 
 

:: Disable Advanced Configuration Power Interfaces
%DevMan% /disable "ACPI Processor Aggregator" 
%DevMan% /disable "Microsoft Windows Management Interface for ACPI" 


:: Disable Powersaving on Network Adapter
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" /v "DefaultPnPCapabilities" /t REG_DWORD /d "24" /f 