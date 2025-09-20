:: Created for NeptuneOS by NYN9 (https://twitter.com/nyn9pm)
:: https://github.com/NyneDZN/NeptuneOS

:: A majority of the code in this script was forked from open-sourced binaries
:: Credits, in no particular order:
:: - Amit
:: - Artanis
:: - AtlasOS
:: - Ancel
:: - CatGamerOP
:: - CoutX
:: - DuckISO
:: - echnobas
:: - he3als
:: - HeavenOS
:: - imribiy
:: - Melody
:: - nohopestage
:: - Phlegm
:: - privacy.sexy
:: - ReviOS
:: - Timecard
:: - Winaero
:: - Zusier
:: - Yoshii64

@echo off

:: Enable delayed expansion
setlocal EnableDelayedExpansion

:: NeptuneOS Variables
set version=0.5

:: Window Title
title "NeptuneOS Installation %version% | By NYN9"

:: Check if this is a development build or not
if /i "%~2"=="/devbuild"   set "devbuild=yes"

:: Set log variable
:: If the log file does not exist, create it
if not exist "%WinDir%\NeptuneDir\neptune.txt" (
	echo. > "%WinDir%\NeptuneDir\neptune.txt"
)
:: Set the log file path
set "neptlog=%WinDir%\NeptuneDir\neptune.txt"
:: Variable-based logging: use %logcmd% before any command to log it
set "logcmd=echo [!time!] Running: >>"%neptlog%" & echo [!time!] Running: ""
:: Usage example:
::   %logcmd% <your command here> >>"%neptlog%" 2>&1

:: Batch Variables
set "PowerShell=%WinDir%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProf -NonI -NoL -EP Bypass -C"
set currentuser=%WinDir%\NeptuneDir\Tools\NSudoLG.exe -U:C -P:E -ShowWindowMode:Hide -Wait
set system=%WinDir%\NeptuneDir\Tools\NSudoLG.exe -U:T -P:E -ShowWindowMode:Hide -Wait
set DevMan="%WinDir%\NeptuneDir\Tools\dmv.exe"
set svc=call :setSvc
set delf=del /f /s /q
set delF=del /f /s /q

:: Fetch ANSI
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul

:: Fullsceen Script
"%WinDir%\System32\cscript.exe" //nologo "%WinDir%\NeptuneDir\Scripts\FullScreenCMD.vbs"

:: Fetch PC Type
:: for /f "delims=:{}" %%a in ('wmic path Win32_SystemEnclosure get ChassisTypes ^| findstr [0-9]') do set "CHASSIS=%%a"
:: Use DEVICE_TYPE variable to determine if the device is a laptop or PC
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "($chassis = Get-CimInstance -ClassName Win32_SystemEnclosure | Select-Object -ExpandProperty ChassisTypes) -join ','; Write-Output $chassis"`) do set "CHASSIS=%%a"
set "DEVICE_TYPE=PC"
for %%a in (8 9 10 11 12 13 14 18 21 30 31 32) do if "%CHASSIS%" == "%%a" (set "DEVICE_TYPE=LAPTOP")

:: Fetch User SID
:: for /f "tokens=2 delims==" %%A in ('wmic useraccount where "name='%username%'" get sid /value') do (set "SID=%%A")
for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "(Get-CimInstance Win32_UserAccount | Where-Object { $_.Name -eq $env:USERNAME -and $_.LocalAccount }) | Select-Object -ExpandProperty SID"`) do set "SID=%%A"

:: Fetch RAM amount
:: for /f "skip=1" %%i in ('wmic os get TotalVisibleMemorySize') do if not defined TOTAL_MEMORY set "TOTAL_MEMORY=%%i"
for /f "usebackq delims=" %%i in (`powershell -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize"`) do if not defined TOTAL_MEMORY set "TOTAL_MEMORY=%%i"

:: Fetch GPU
:: for /f "tokens=2 delims==" %%a in ('wmic path Win32_VideoController get VideoProcessor /value ^| findstr /i "GeForce NVIDIA RTX GTX Radeon AMD"') do (echo %%a | findstr /i "GeForce NVIDIA RTX GTX" >nul && set GPU=NVIDIA || set GPU=RADEON)
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty VideoProcessor) -join ';'"`) do (
    echo %%a | findstr /i "GeForce NVIDIA RTX GTX" >nul && set GPU=NVIDIA || set GPU=RADEON
)

:: Configure variables for determining winver
:: - %os% - Windows 10 or 11
:: - %releaseid% - release ID (21H2, 22H2)
:: - %build% - current build of Windows (like 10.0.19044.1889)
for /f "tokens=6 delims=[.] " %%a in ('ver') do (set "win_version=%%a")
if %win_version% lss 22000 (set os=Windows 10) else (set os=Windows 11)
for /f "tokens=3" %%a in ('Reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "DisplayVersion"') do (set releaseid=%%a)
for /f "tokens=4-7 delims=[.] " %%a in ('ver') do (set "build=%%a.%%b.%%c.%%d")

:: Check if the user is on Windows Server
if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Server Manager.lnk" (set "server=yes") else (set "server=no")


:: Script index
:: Scripts must be run through a shortcut with the proper arguments

:: Post-install
if /i "%~1"=="/postinstall"   goto postinstall
:: if /i "%~1"=="/PowerConfiguration"   goto PowerConfiguration
:: if /i "%~1"=="/NTFSConfiguration"   goto NTFSConfiguration
:: if /i "%~1"=="/TaskConfiguration"   goto TaskConfiguration
:: if /i "%~1"=="/BCDConfiguration"   goto BCDConfiguration
:: if /i "%~1"=="/DevConfiguration"   goto DevConfiguration
:: if /i "%~1"=="/NetworkConfiguration"   goto NetworkConfiguration
:: if /i "%~1"=="/ServiceConfiguration"   goto ServiceConfiguration
:: if /i "%~1"=="/SecurityConfiguration"   goto SecurityConfiguration
:: if /i "%~1"=="/RegistryConfiguration"   goto RegistryConfiguration
:: if /i "%~1"=="/PerformanceCounters"   goto PerformanceCounters
:: if /i "%~1"=="/TaskConfiguration"   goto TaskConfiguration
:: if /i "%~1"=="/DebloatWindows"   goto DebloatWindows
:: if /i "%~1"=="/ConfigureFeatures"   goto ConfigureFeatures

if /i "%~1"=="/testPrompt"    goto testPrompt

:argumentFAIL
echo The master script had no arguments passed to it. You're either launching the script directly, or "%~nx0" is broken/corrupted.
pause & exit /b

:TestPrompt
set /p c="Test with echo on?"
if %c% equ Y echo on
set /p argPrompt="Which script would you like to test? e.g. (:testScript)"
goto %argPrompt%
echo You should not reach this message!
pause
exit

:postinstall
:: killing explorer
taskkill /f /im explorer.exe 

:: echo to user
echo !S_YELLOW!Beginning NeptuneOS !S_RED!%version% !S_YELLOW!Installation.
echo]
echo !S_YELLOW!Please report any errors you may see in this script, and report any issues to our Discord Server, or GitHub.
timeout /t 7 /nobreak >nul

:: ngen, from atlas
:: Powershell -ExecutionPolicy Unrestricted "C:\Windows\NeptuneDir\Scripts\NGEN.ps1"

cls & echo !S_YELLOW!Configuring NTP Server [1/18]
:: change ntp server from windows server to pool.ntp.org
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org" 

:: resync time to pool.ntp.org
sc config w32time start=auto 
%svc% W32Time 2 
net start w32time 
w32tm /config /update 
w32tm /resync 
%svc% W32Time 4 
goto PowerConfiguration


:PowerConfiguration
cls & echo !S_YELLOW!Configuring Powerplan [2/18]
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
if "!DEVICE_TYPE!"=="PC" (
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
)


:: Disable Powersaving on Network Adapter
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" /v "DefaultPnPCapabilities" /t REG_DWORD /d "24" /f 
goto NTFSConfiguration


:NTFSConfiguration
cls & echo !S_YELLOW!Configuring NTFS [4/18]
:: Configuring the NTFS file system in Windows

:: Adjust MFT (master file table) and paged pool memory cache levels according to ram size
:: if !TOTAL_MEMORY! LSS 8000000 (
:: FSUTIL behavior set memoryusage 1 
:: FSUTIL behavior set mftzone 1 
:: ) else if !TOTAL_MEMORY! LSS 16000000 (
:: FSUTIL behavior set memoryusage 1 
:: FSUTIL behavior set mftzone 2 
:: ) else (
:: FSUTIL behavior set memoryusage 2 
:: FSUTIL behavior set mftzone 2 
:: )

:: Disallows characters from the extended character set to be used in 8.3 character-length short file names
FSUTIL behavior set allowextchar 0 
:: Disallow generation of a bug check
FSUTIL behavior set bugcheckoncorrupt 0 
:: Disable 8.3 File Creation
:: https://ttcshelbyville.wordpress.com/2018/12/02/should-you-disable-8dot3-for-performance-and-security
FSUTIL behavior set disable8dot3 1 
:: Disable NTFS File Compression
FSUTIL behavior set disablecompression 1 
:: Disable NTFS File Encryption
:: Commented out because this disables XBOX downloads
:: FSUTIL behavior set disableencryption 1 
:: Disable Last Accessed Timestamp
FSUTIL behavior set disablelastaccess 1 
FSUTIL behavior set disablespotcorruptionhandling 1 
:: Enable Trimming for SSD's
FSUTIL behavior set disabledeletenotify 0 
:: Disable paging file encryption
FSUTIL behavior set encryptpagingfile 0 
FSUTIL behavior set quotanotify 86400 
FSUTIL behavior set symlinkevaluation L2L:1 
:: Disable self repair on boot drive
FSUTIL repair set C: 0 

:: Disable Write Cache Buffer
for /f "tokens=*" %%i in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI" 2^>nul ^| findstr "HKEY"') do (
for /f "tokens=*" %%a in ('Reg query "%%i" 2^>nul ^| findstr "HKEY"') do reg add "%%a\Device Parameters\Disk" /v "CacheIsPowerProtected" /t Reg_DWORD /d "1" /f 
)
for /f "tokens=*" %%i in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI" 2^>nul ^| findstr "HKEY"') do (
for /f "tokens=*" %%a in ('Reg query "%%i" 2^>nul ^| findstr "HKEY"') do reg add "%%a\Device Parameters\Disk" /v "UserWriteCacheSetting" /t Reg_DWORD /d "1" /f 
)

:: Disable HIPM, DIPM, and HDD parking
FOR /F "eol=E" %%a in ('Reg QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "EnableHIPM"^| FINDSTR /V "EnableHIPM"') DO (
reg add "%%a" /F /V "EnableHIPM" /T Reg_DWORD /d 0 
reg add "%%a" /F /V "EnableDIPM" /T Reg_DWORD /d 0 
reg add "%%a" /F /V "EnableHDDParking" /T Reg_DWORD /d 0 
)

:: IOLATENCYCAP to 0
FOR /F "eol=E" %%a in ('Reg QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "IoLatencyCap"^| FINDSTR /V "IoLatencyCap"') DO (
reg add "%%a" /F /V "IoLatencyCap" /T Reg_DWORD /d 0 
)

:: Set Drive Label
label C: NeptuneOS 

goto TaskConfiguration


:: Configuring the task scheduler in Windows
:TaskConfiguration
cls & echo !S_YELLOW!Configuring Scheduled Tasks [5/18]

for %%a in (
	""
"\Microsoft\Windows\Windows Error Reporting\QueueReporting"
"\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319"
"\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64"
"\Microsoft\Windows\Application Experience\PcaPatchDbTask"
"\Microsoft\Windows\Application Experience\StartupAppTask"
"\Microsoft\Windows\ApplicationData\appuriverifierdaily"
"\Microsoft\Windows\ApplicationData\appuriverifierinstall"
"\Microsoft\Windows\ApplicationData\DsSvcCleanup"
"\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask"
"\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
"\Microsoft\Windows\Defrag\ScheduledDefrag"
"\Microsoft\Windows\Device Setup\Metadata Refresh"
"\Microsoft\Windows\Diagnosis\Scheduled"
"\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
"\Microsoft\Windows\DiskFootprint\Diagnostics"
"\Microsoft\Windows\InstallService\ScanForUpdates"
"\Microsoft\Windows\InstallService\ScanForUpdatesAsUser"
"\Microsoft\Windows\InstallService\SmartRetry"
"\Microsoft\Windows\International\Synchronize Language Settings"
"\Microsoft\Windows\Maintenance\WinSAT"
"\Microsoft\Windows\Management\Provisioning\Cellular"
"\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic"
"\Microsoft\Windows\MUI\LPRemove"
"\Microsoft\Windows\PI\Sqm-Tasks"
"\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"
"\Microsoft\Windows\Printing\EduPrintProv"
"\Microsoft\Windows\PushToInstall\LoginCheck"
"\Microsoft\Windows\Ras\MobilityManager"
"\Microsoft\Windows\Registry\RegIdleBackup"
"\Microsoft\Windows\RetailDemo\CleanupOfflineContent"
"\Microsoft\Windows\Shell\FamilySafetyMonitor"
"\Microsoft\Windows\Shell\FamilySafetyRefresh"
"\Microsoft\Windows\Shell\IndexerAutomaticMaintenance"
"\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskNetwork"
"\Microsoft\Windows\StateRepository\MaintenanceTasks"
"\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime"
"\Microsoft\Windows\Time Synchronization\SynchronizeTime"
"\Microsoft\Windows\Time Zone\SynchronizeTimeZone"
"\Microsoft\Windows\UpdateOrchestrator\Report policies"
"\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task"
"\Microsoft\Windows\UpdateOrchestrator\Schedule Scan"
"\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker"
"\Microsoft\Windows\UPnP\UPnPHostConfig"
"\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange"
"\Microsoft\Windows\WindowsUpdate\Scheduled Start"
"\Microsoft\Windows\Wininet\CacheTask"
"\Microsoft\XblGameSave\XblGameSaveTask"
"\Microsoft\Windows\ExploitGuard\ExploitGuard MDM policy Refresh"
"\MicrosoftEdgeUpdateTaskMachineUA"
"\MicrosoftEdgeUpdateTaskMachineCore"
) do (
schtasks.exe /change /disable /TN %%a 
)

:: Enable Storage Sense
schtasks /change /enable /TN "\Microsoft\Windows\DiskCleanup\SilentCleanup" 

:: Disable OneDrive Tasks
PowerShell -ExecutionPolicy Unrestricted -Command "$taskPathPattern='\'; $taskNamePattern='OneDrive Reporting Task-*'; Write-Output "^""Disabling tasks matching pattern `"^""$taskNamePattern`"^""."^""; $tasks = @(Get-ScheduledTask -TaskPath $taskPathPattern -TaskName $taskNamePattern -ErrorAction Ignore); if (-Not $tasks) {; Write-Output "^""Skipping, no tasks matching pattern `"^""$taskNamePattern`"^"" found, no action needed."^""; exit 0; }; $operationFailed = $false; foreach ($task in $tasks) {; $taskName = $task.TaskName; if ($task.State -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.ScheduledTask.StateEnum]::Disabled) {; Write-Output "^""Skipping, task `"^""$taskName`"^"" is already disabled, no action needed."^""; continue; }; try {; $task | Disable-ScheduledTask -ErrorAction Stop | Out-Null; Write-Output "^""Successfully disabled task `"^""$taskName`"^""."^""; } catch {; Write-Error "^""Failed to disable task `"^""$taskName`"^"": $($_.Exception.Message)"^""; $operationFailed = $true; }; }; if ($operationFailed) {; Write-Output 'Failed to disable some tasks. Check error messages above.'; exit 1; }" 
PowerShell -ExecutionPolicy Unrestricted -Command "$taskPathPattern='\'; $taskNamePattern='OneDrive Standalone Update Task-*'; Write-Output "^""Disabling tasks matching pattern `"^""$taskNamePattern`"^""."^""; $tasks = @(Get-ScheduledTask -TaskPath $taskPathPattern -TaskName $taskNamePattern -ErrorAction Ignore); if (-Not $tasks) {; Write-Output "^""Skipping, no tasks matching pattern `"^""$taskNamePattern`"^"" found, no action needed."^""; exit 0; }; $operationFailed = $false; foreach ($task in $tasks) {; $taskName = $task.TaskName; if ($task.State -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.ScheduledTask.StateEnum]::Disabled) {; Write-Output "^""Skipping, task `"^""$taskName`"^"" is already disabled, no action needed."^""; continue; }; try {; $task | Disable-ScheduledTask -ErrorAction Stop | Out-Null; Write-Output "^""Successfully disabled task `"^""$taskName`"^""."^""; } catch {; Write-Error "^""Failed to disable task `"^""$taskName`"^"": $($_.Exception.Message)"^""; $operationFailed = $true; }; }; if ($operationFailed) {; Write-Output 'Failed to disable some tasks. Check error messages above.'; exit 1; }" 
PowerShell -ExecutionPolicy Unrestricted -Command "$taskPathPattern='\'; $taskNamePattern='OneDrive Per-Machine Standalone Update'; Write-Output "^""Disabling tasks matching pattern `"^""$taskNamePattern`"^""."^""; $tasks = @(Get-ScheduledTask -TaskPath $taskPathPattern -TaskName $taskNamePattern -ErrorAction Ignore); if (-Not $tasks) {; Write-Output "^""Skipping, no tasks matching pattern `"^""$taskNamePattern`"^"" found, no action needed."^""; exit 0; }; $operationFailed = $false; foreach ($task in $tasks) {; $taskName = $task.TaskName; if ($task.State -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.ScheduledTask.StateEnum]::Disabled) {; Write-Output "^""Skipping, task `"^""$taskName`"^"" is already disabled, no action needed."^""; continue; }; try {; $task | Disable-ScheduledTask -ErrorAction Stop | Out-Null; Write-Output "^""Successfully disabled task `"^""$taskName`"^""."^""; } catch {; Write-Error "^""Failed to disable task `"^""$taskName`"^"": $($_.Exception.Message)"^""; $operationFailed = $true; }; }; if ($operationFailed) {; Write-Output 'Failed to disable some tasks. Check error messages above.'; exit 1; }" 
goto BCDConfiguration


:: Configuring the Boot Configuration Data in Windows
:BCDConfiguration
cls & echo !S_YELLOW!Configuring BCDEdit [6/16]

:: Enable the Legacy Boot Menu
bcdedit /set bootmenupolicy legacy 
:: Disable Hyper-V
bcdedit /set hypervisorlaunchtype off 
:: Disable Automatic Drive Repair
bcdedit /set {current} recoveryenabled no 
:: Set Boot Label
bcdedit /set {current} description "NeptuneOS %version%" 
:: Disable Laptop Powersaving
bcdedit /set disabledynamictick yes 
:: Use Synthetic Timers
bcdedit /set useplatformtick yes 
:: Disable HPET
:: This isn't even set by default in windows, commented out.
:: bcdedit /deletevalue useplatformclock 
:: 15 Second Timeout
bcdedit /timeout 15 
:: Disable Emergency Management Services
:: bcdedit /set ems no 
:: bcdedit /set bootems no 
:: Disable Kernel Debugging
:: Unable to disable with secure boot enabled
:: bcdedit /set debug no 
:: Stop using uncontiguous portions of low-memory
:: https://sites.google.com/view/melodystweaks/basictweaks
:: bcdedit /set firstmegabytepolicy useall 
:: bcdedit /set avoidlowmemory 0x8000000 
:: bcdedit /set nolowmem yes 
:: Enable X2Apic
bcdedit /set x2apicpolicy enable 
bcdedit /set uselegacyapicmode no 
:: Enable Legacy TSCSyncPolicy
:: bcdedit /set tscsyncpolicy enhanced 
:: Linear Address 57
:: https://en.wikipedia.org/wiki/Intel_5-level_paging
bcdedit /set linearaddress57 OptOut 
bcdedit /set increaseuserva 268435328 
goto DevConfiguration


:: Configuring devices in Windows
:DevConfiguration
cls & echo !S_YELLOW!Configuring Devices and MSI Mode [7/18]

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

:: TPM Devices
if "%os%"=="Windows 10" (%DevMan% /disable "AMD PSP 10.0 Device" & %DevMan% /disable "Trusted Platform Module 2.0")

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

goto NetworkConfiguration


:: Configuring network settings and the NIC adapter in Windows
:NetworkConfiguration
cls & echo !S_YELLOW!Configuring Network Settings [8/18]

:: Network Shell
:: Reset the Network Configuration
ipconfig /release 
ipconfig /renew 
ipconfig /flushdns 
netsh int ip reset 
netsh int ipv4 reset 
netsh int ipv6 reset 
netsh int tcp reset 
netsh winsock reset 
netsh advfirewall reset 
netsh branchcache reset 
netsh http flush logbuffer 
:: - > Disable IPV6
:: IPV6 is disabled through regedit, so I'm commenting this out so it doesn't cause unforseen issues.
:: netsh int 6to4 set state disabled 
:: netsh int IPV6 set global randomizeidentifier=disabled 
:: netsh int IPV6 set privacy state=disable 
:: netsh int IPV6 6to4 set state state=disabled 
:: netsh int IPV6 isatap set state state=disabled 
:: netsh int IPV6 set teredo disable
:: - > Increase TTL (Time to Live)
:: https://packetpushers.net/ip-time-to-live-and-hop-limit-basics/
netsh int ip set global defaultcurhoplimit=255 
:: - > Disable Media Sense
netsh int ip set global dhcpmediasense=disabled 
netsh int ip set global neighborcachelimit=4096 
:: - > Enable Task Offloading
netsh int ip set global taskoffload=enabled 
:: netsh int ip set interface "Ethernet" metric=60 
:: - > Set MTU (maximum transmission unit)
netsh int ipv4 set subinterface "Ethernet" mtu=1500 store=persistent 
netsh int ipv4 set subinterface "Wi-Fi" mtu=1500 store=persistent 
:: - > Set AutoTuningLevel
:: https://www.majorgeeks.com/content/page/what_is_windows_auto_tuning.html
netsh int tcp set global autotuninglevel=normal 
netsh int tcp set global chimney=disabled 
:: - > Set Congestion Provider to CTCP (Client to Client Protocol)
:: - > CTCP Provides better throughput and latency for gaming
:: https://www.speedguide.net/articles/tcp-congestion-control-algorithms-comparison-7423
netsh int tcp set global congestionprovider=ctcp 
:: - > Set Congestion Provider to BBR2 on Windows 11
if "%os%"=="Windows 11" (
netsh int tcp set supplemental Template=Internet CongestionProvider=bbr2 
netsh int tcp set supplemental Template=Datacenter CongestionProvider=bbr2 
netsh int tcp set supplemental Template=Compat CongestionProvider=bbr2 
netsh int tcp set supplemental Template=DatacenterCustom CongestionProvider=bbr2 
netsh int tcp set supplemental Template=InternetCustom CongestionProvider=bbr2 
)
:: - > Enable Direct Cache Access
:: - > This will have a bigger impact on older CPU's
netsh int tcp set global dca=enabled 
:: - > Disable Explicit Congestion Notification
:: https://en.wikipedia.org/wiki/Explicit_Congestion_Notification
:: https://www.bufferbloat.net/projects/cerowrt/wiki/Enable_ECN/#:~:text=Enabling%20ECN%20does%20not%20much,already%2C%20but%20few%20clients%20do.
netsh int tcp set global ecncapability=disabled 
:: - > Enable TCP Fast Open
:: https://en.wikipedia.org/wiki/TCP_Fast_Open
netsh int tcp set global fastopen=enabled 
:: - > Set the TCP Retransmission Timer
:: https://www.speedguide.net/faq/how-does-tcpinitialrtt-or-initialrto-affect-tcp-498
netsh int tcp set global initialRto=3000 
:: - > Set Max SYN Retransmissions to the lowest value
:: https://medium.com/@avocadi/tcp-syn-retries-f30756ec7c55
netsh int tcp set global maxsynretransmissions=2 
netsh int tcp set global netdma=enabled 
:: - > Disable Non Sack RTT Resiliency
:: - > If you have fluctuating ping and packet loss, enabling this might benefit
:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
netsh int tcp set global nonsackrttresiliency=disabled 
:: - > Disable Receive Segment Coalescing State
:: - > Enabling this may provide higher throughput when lower CPU utilization is important
:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
netsh int tcp set global rsc=disabled 
:: - > Enable Receive Side Scaling
:: - > This allows multiple cores to process incoming packets, improving network performance
:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
netsh int tcp set global rss=enabled 
:: - > Disable TCP 1323 Timestamps
:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
netsh int tcp set global timestamps=disabled 
:: - > Disable Scaling Heuristics
netsh int tcp set heuristics disabled 
:: - > Set Max Port Ranges
netsh int ipv4 set dynamicport udp start=1025 num=64511 
netsh int ipv4 set dynamicport tcp start=1025 num=64511 
:: - > Disable Memory Pressure Protection
:: - > This is a network security feature that will kill malicious TCP connections and SYN requests with no sort of performance or stability loss.
:: https://support.microsoft.com/en-us/topic/description-of-the-new-memory-pressure-protection-feature-for-tcp-stack-749c1746-ba10-ec18-d61a-bbdabbc403fc
:: netsh int tcp set security mpp=disabled 
:: netsh int tcp set security profiles=disabled 
netsh int tcp set supplemental Internet congestionprovider=ctcp 
netsh int tcp set supplemental template=custom icw=10 
:: - > Disable Teredo
netsh int teredo set state disabled 


:: Disable Bandwith Preservation
reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t Reg_DWORD /d "1" /f 
reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t Reg_DWORD /d "00000000" /f 

:: Disable Network Level Authentication
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t Reg_SZ /d "1" /f 

:: Disable DHCP MediaSense
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v " DisableDHCPMediaSense" /t REG_DWORD /d "1" /f 

:: No TCP Connection Limit
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxConnectionsPerServer" /t Reg_DWORD /d "0" /f 

:: Set Max Port to 65534
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t Reg_DWORD /d "65534" /f 

:: Reduce Time_Wait
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t Reg_DWORD /d "32" /f 

:: Reduce TTL (Time to Live)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t Reg_DWORD /d "64" /f 

:: Duplicate ACKS
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t Reg_DWORD /d "2" /f 

:: Disable Sacks
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t Reg_DWORD /d "0" /f 

:: Disable Multicast
reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t Reg_DWORD /d "0" /f 

:: Disable TCP Extensions
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t Reg_DWORD /d "0" /f 

:: Disable Smart Name Resolution
:: This may cause DNS leaks
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "DisableParallelAandAAAA" /t REG_DWORD /d 1 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v "DisableSmartNameResolution" /t REG_DWORD /d 1 /f 

:: Allow ICMP redirects to override OSPF generated routes
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableICMPRedirect" /t Reg_DWORD /d "1" /f 

:: TCP Window Size
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t Reg_DWORD /d "8760" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpWindowSize" /t Reg_DWORD /d "8760" /f 

:: Disable Network Discovery
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" /f 

:: Enable DNS > HTTPS
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableAutoDoh" /t Reg_DWORD /d "2" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t Reg_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeSOACacheTime" /t Reg_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NetFailureCacheTime" /t Reg_DWORD /d "0" /f 

:: Disable LLMNR
reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t Reg_DWORD /d "0" /f 

:: Disable Administrative Shares
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "AutoShareWks" /t Reg_DWORD /d "0" /f 

:: Enable Network Offloading
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableTaskOffload" /t Reg_DWORD /d "0" /f 

:: Disable the TCP Autotuning Diagnostic Tool
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableWsd" /t Reg_DWORD /d "0" /f 

:: Host Resolution Priority
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t Reg_DWORD /d "6" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t Reg_DWORD /d "5" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t Reg_DWORD /d "4" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t Reg_DWORD /d "7" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "Class" /t Reg_DWORD /d "8" /f 

:: TCP Congestion Control/Avoidance Algorithm
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "0200" /t Reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f 
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "1700" /t Reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f 

:: Detect Congestion Failure
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPCongestionControl" /t Reg_DWORD /d "00000001" /f 

:: Disable SYN-DOS Protection
:: reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SynAttackProtect" /t Reg_DWORD /d "0" /f 
:: reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock" /v "UseDelayedAcceptance" /t Reg_DWORD /d "0" /f 

:: Prevent NIC Resets
reg add "HKLM\SYSTEM\CurrentControlSet\services\NDIS\Parameters" /v "DisableNDISWatchDog" /t Reg_DWORD /d "1" /f 

:: Disable Nagle's Algorithm
:: https://en.wikipedia.org/wiki/Nagle%27s_algorithm
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "Get-CimInstance Win32_NetworkAdapter | Where-Object { $_.GUID -ne $null } | Select-Object -ExpandProperty GUID"`) do (
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%a" /v "TcpAckFrequency" /t Reg_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%a" /v "TcpDelAckTicks" /t Reg_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%a" /v "TCPNoDelay" /t Reg_DWORD /d "1" /f 
)

:: Disable NetBIOS over TCP
for /f "delims=" %%a in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces" /s /f "NetbiosOptions" ^| findstr "HKEY"') do (
reg add "%%a" /v "NetbiosOptions" /t Reg_DWORD /d "2" /f 
)

:: Disable Network Protocols
:: This includes IPV6, File and Printer Sharing for Microsoft Networks, Client for Microsoft Networks, etc
PowerShell -ExecutionPolicy Unrestricted -Command  "Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6, ms_msclient, ms_server, ms_lldp, ms_lltdio, ms_rspndr" 

:: Disable IPV6 through TCPIP
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v "DisabledComponents" /t REG_DWORD /d "32" /f 

:: Disable Telemetry IP's
cd %SystemRoot%\System32\drivers\etc
if not exist hosts.bak ren hosts hosts.bak 
curl -l -s https://winhelp2002.mvps.org/hosts.txt -o hosts
if not exist hosts ren hosts.bak hosts 
goto ServiceConfiguration



:ServiceConfiguration
cls & echo !S_YELLOW!Disabling Drivers and Services [9/18]
:: Configuring the services and drivers in Windows

:: Configuring Driver Dependencies
:: - > DHCP, allows for TDX to be disabled
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dhcp" /v "DependOnService" /t Reg_MULTI_SZ /d "NSI\0Afd" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache" /v "DependOnService" /t Reg_MULTI_SZ /d "nsi" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc" /v "DependOnService" /t Reg_MULTI_SZ /d "NSI\0RpcSs\0TcpIp" /f 

:: Configure Driver Filters
:: - > ReadyBoost
if "%server%"=="no" (
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t Reg_MULTI_SZ /d "fvevol\0iorate" /f 
)

:: Split Audio Services
:: This will prevent audio dropouts when setting svchost.exe to low priority
copy /y "%windir%\System32\svchost.exe" "%windir%\System32\audiosvchost.exe" 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv" /v "ImagePath" /t Reg_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalServiceNetworkRestricted -p" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AudioEndpointBuilder" /v "ImagePath" /t Reg_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalSystemNetworkRestricted -p" /f 

:: Backing up default Windows services and drivers
set BACKUP="%WINDIR%\NeptuneDir\Neptune\Troubleshooting\Default Services and Drivers\Windows Default.reg"
echo Windows Registry Editor Version 5.00 >>%BACKUP%
for /f "delims=" %%a in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Services"') do (
for /f "tokens=3" %%b in ('Reg query "%%~a" /v "Start" 2^>nul') do (
for /l %%c in (0,1,4) do (
if "%%b"=="0x%%c" (
echo. >>%BACKUP%
echo [%%~a] >>%BACKUP%
echo "Start"=dword:0000000%%c >>%BACKUP%
)
)
)
) >nul

:: Configure Drivers and Services
:: Guide:  4 = Disabled, 3 = Manual, 2 = Automatic, 1 = System, 0 = Boot

:: Drivers
%svc% 3ware 4
%svc% ADP80XX 4
%svc% AmdK8 4
%svc% Beep 4
%svc% BthA2dp 4
%svc% BthAvctpSvc 4
%svc% BthEnum 4
%svc% BthHFEnum 4
%svc% bthleenum 4
%svc% BTHMODEM 4
%svc% cdrom 4
%svc% flpydisk 4
%svc% GpuEnergyDrv 4
%svc% lltdio 4
:: - > Driver related to UAC UI, it gets disabled when UAC is disabled
:: %svc% luafv 4
%svc% mrxsmb 4
%svc% mrxsmb20 4
%svc% MsLldp 4
%svc% NdisCap 4
%svc% NdisTapi 4
%svc% NdisWan 4
%svc% ndiswanlegacy 4
%svc% Ndu 4
%svc% NetBIOS 4
%svc% NetBT 4
%svc% PptpMiniport 4
:: - > Oculus needs this driver to function
:: %svc% QWAVEdrv 4
%svc% RasAgileVpn 4
%svc% Rasl2tp 4
%svc% RasPppoe 4
%svc% RasSstp 4
%svc% rspndr 4
%svc% srv2 4
%svc% srvnet 4
%svc% tcpipReg 4
%svc% Telemetry 4
%svc% uhssvc 4
%svc% wanarp 4
%svc% wanarpv6 4

:: New
%svc% dam 4
%svc% CSC 4
%svc% bam 4
%svc% KSecPkg 4
%svc% NetworkPrivacyPolicy 4
%svc% storqosflt 4


:: Services
:: - > Audio is disabled on Server by default
%svc% Audiosrv 2
%svc% AudioEndpointBuilder 2
%svc% BTAGService 4
%svc% BDESVC 4
%svc% BluetoothUserService 4
%svc% bthserv 4
%svc% diagsvc 4
%svc% DiagTrack 4
:: Needs to be on for 11; causes display settings to reset
%svc% DispBrokerDesktopSvc 2
%svc% DisplayEnhancementService 4
%svc% DPS 4
%svc% DusmSvc 4
%svc% edgeupdate 4
%svc% edgeupdatem 4
%svc% FontCache 4
%svc% FontCache3.0.0.0 4
%svc% HvHost 4
%svc% IKEEXT 4
%svc% iphlpsvc 4
%svc% lfsvc 4
%svc% LanManServer 4
%svc% LanmanWorkstation 4
%svc% lmhosts 4
%svc% microsoft_bluetooth_avrcptransport 4
%svc% MapsBroker 4
%svc% MSDTC 4
%svc% PrintNotify 4
%svc% RasMan 4
%svc% rdyboost 4
%svc% RFCOMM 4
%svc% RmSvc 4
%svc% TrkWks 4
%svc% ShellHWDetection 4
%svc% Spooler 4
%svc% SgrmBroker 4
%svc% SysMain 4
:: Hyper-V
:: Don't disable these by defauit so Neptune in HPV works properly
:: %svc% vmicguestinterface 4
:: %svc% vmicheartbeat 4
:: %svc% vmickvpexchange 4
:: %svc% vmicrdv 4
:: %svc% vmicshutdown 4
:: %svc% vmictimesync 4
:: %svc% vmicvmsession 4
:: %svc% vmicvss 4
%svc% W32Time 4
%svc% WaaSMedicSvc 4
%svc% WarpJITSvc 4
%svc% WdiServiceHost 4
%svc% webthreatdefusersvc 4
%svc% WinHttpAutoProxySvc 4
%svc% WPDBusEnum 4
%svc% webthreatdefsvc 4
%svc% WerSvc 4
%svc% WSearch 4
:: Notification services will break the calendar on Windows 11
:: %svc% WpnService 4
:: %svc% WpnUserService 4

:: New
%svc% whesvc 4
%svc% edgeupdate 4
%svc% PcsSvc 4
%svc% TrkWks 4
%svc% MDCoreSvc 4
%svc% CDPSvc 4 
%svc% CDPUserSvc 4
%svc% WpnUserService 4
%svc% WpnService 4
 

:: Backup default NeptuneOS drivers and services
set BACKUP="%WINDIR%\NeptuneDir\Neptune\Troubleshooting\Default Services and Drivers\Neptune Default.reg"
echo Windows Registry Editor Version 5.00 >>%BACKUP%

for /f "delims=" %%a in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Services"') do (
for /f "tokens=3" %%b in ('Reg query "%%~a" /v "Start" 2^>nul') do (
for /l %%c in (0,1,4) do (
if "%%b"=="0x%%c" (
echo. >>%BACKUP%
echo [%%~a] >>%BACKUP%
echo "Start"=dword:0000000%%c >>%BACKUP%
)
)
)
) >nul
goto SecurityConfiguration



:: Configuring security vulnerabilities and hardening Windows
:SecurityConfiguration
cls & echo !S_YELLOW!Security and Hardening [10/18]

:: Mitigations
:: - > Spectre & Meltdown
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f 
::  - > Disable ASLR Mitigations
::  - > This might break TestMem5
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "MoveImages" /t REG_DWORD /d "0" /f 
::  - > Disable Control Flow Guard
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f 
::  - > NTFS/ReFS Mitigations
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f 
::  - > System Mitigations
PowerShell -ExecutionPolicy Unrestricted -Command  "Set-ProcessMitigation -System -Disable DEP, EmulateAtlThunks, SEHOP, ForceRelocateImages, RequireInfo, BottomUp, HighEntropy, StrictHandle, DisableWin32kSystemCalls, AuditSystemCall, DisableExtensionPoints, BlockDynamicCode, AllowThreadsToOptOut, AuditDynamicCode, CFG, SuppressExports, StrictCFG, MicrosoftSignedOnly, AllowStoreSignedBinaries, AuditMicrosoftSigned, AuditStoreSigned, EnforceModuleDependencySigning, DisableNonSystemFonts, AuditFont, BlockRemoteImageLoads, BlockLowLabelImageLoads, PreferSystem32, AuditRemoteImageLoads, AuditLowLabelImageLoads, AuditPreferSystem32, EnableExportAddressFilter, AuditEnableExportAddressFilter, EnableExportAddressFilterPlus, AuditEnableExportAddressFilterPlus, EnableImportAddressFilter, AuditEnableImportAddressFilter, EnableRopStackPivot, AuditEnableRopStackPivot, EnableRopCallerCheck, AuditEnableRopCallerCheck, EnableRopSimExec, AuditEnableRopSimExec, SEHOP, AuditSEHOP, SEHOPTelemetry, TerminateOnError, DisallowChildProcessCreation, AuditChildProcess" 
::  - > Disable Process Mitigations (credit: xos)
for /f "tokens=3 skip=2" %%a in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions"') do set mitigation_mask=%%a
for /L %%a in (0,1,9) do (
set "mitigation_mask=!mitigation_mask:%%a=2!
)
for %%a in (
fontdrvhost.exe
dwm.exe
lsass.exe
svchost.exe
WmiPrvSE.exe
winlogon.exe
csrss.exe
audiodg.exe
ntoskrnl.exe
services.exe
) do (
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%a" /v "MitigationOptions" /t Reg_BINARY /d "!mitigation_mask!" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%a" /v "MitigationAuditOptions" /t Reg_BINARY /d "!mitigation_mask!" /f 
)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t Reg_BINARY /d "!mitigation_mask!" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions" /t Reg_BINARY /d "!mitigation_mask!" /f 
::  - > Disable SEHOP
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f 

:: Mitigate HiveNightmare aka SeriousSAM (CVE-2021-36934)
icacls %WinDir%\system32\config\*.* /inheritance:e 

:: Harden LSASS
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe" /v "AuditLevel" /t REG_DWORD /d "8" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation" /v "AllowProtectedCreds" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdminOutboundCreds" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdmin" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RunAsPPL" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" /v "Negotiate" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" /v "UseLogonCredential" /t REG_DWORD /d "0" /f 

:: Harden WinRM
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" /v "AllowUnencryptedTraffic" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client" /v "AllowDigest" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule" /v "DisableRpcOverTcp" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "DisableRemoteScmEndpoints" /t REG_DWORD /d "1" /f 

:: Block enumeration of anonymous SAM accounts
:: https://www.stigviewer.com/stig/windows_10/2021-03-10/finding/V-220929
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RestrictAnonymousSAM" /t REG_DWORD /d "1" /f 

:: Enable UAC
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "5" /f 

:: Mitigation for CVE-2021-40444 and other future activex related attacks
:: https://msrc.microsoft.com/update-guide/vulnerability/CVE-2021-40444
:: https://www.huntress.com/blog/cybersecurity-advisory-hackers-are-exploiting-cve-2021-40444
:: https://nitter.unixfox.eu/wdormann/status/1437530613536501765
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v "1001" /t REG_DWORD /d 00000003 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1001" /t REG_DWORD /d 00000003 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1001" /t REG_DWORD /d 00000003 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1001" /t REG_DWORD /d 00000003 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v "1004" /t REG_DWORD /d 00000003 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1004" /t REG_DWORD /d 00000003 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1004" /t REG_DWORD /d 00000003 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1004" /t REG_DWORD /d 00000003 /f 

:: Prevent Kerberos from using DES or RC4
:: https://gist.github.com/mackwage/08604751462126599d7e52f233490efe?permalink_comment_id=3310398
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters" /v SupportedEncryptionTypes /t REG_DWORD /d 2147483640 /f 

:: Mitigate ClickOnce
reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v "MyComputer" /t Reg_SZ /d "Disabled" /f 
reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v "LocalIntranet" /t Reg_SZ /d "Disabled" /f 
reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v "Internet" /t Reg_SZ /d "Disabled" /f 
reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v "TrustedSites" /t Reg_SZ /d "Disabled" /f 
reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v "UntrustedSites" /t Reg_SZ /d "Disabled" /f 

:: Set strong cryptography on 64 bit and 32 bit .net framework
:: https://github.com/ScoopInstaller/Scoop/issues/2040#issuecomment-369686748
reg add "HKLM\SOFTWARE\Microsoft\.NetFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "1" /f 

:: Restrict anonymous enumeration of shares
:: https://www.stigviewer.com/stig/windows_10/2021-03-10/finding/V-220930
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RestrictAnonymous" /t REG_DWORD /d "1" /f 

:: disable memory mitigations
bcdedit /set allowedinmemorysettings 0x0 

:: Delete Adobe Font Type Manager
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Font Drivers" /v "Adobe Type Manager" /f 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "DisableATMFD" /t REG_DWORD /d "1" /f 

:: Disable DMA Remapping
:: https://docs.microsoft.com/en-us/windows-hardware/drivers/pci/enabling-dma-remapping-for-device-drivers
for /f %%a in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f "DmaRemappingCompatible" ^| find /i "Services\" ') do (
reg add "%%a" /v "DmaRemappingCompatible" /t Reg_DWORD /d "0" /f 
)

:: Disable DMA Memory Protection
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\DmaGuard\DeviceEnumerationPolicy" /v "value" /t REG_DWORD /d "2" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\FVE" /v "DisableExternalDMAUnderLock" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t REG_DWORD /d "0" /f 

:: Disable Core Isolation Memory Integrity
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "EnableVirtualizationBasedSecurity" /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "RequirePlatformSecurityFeatures" /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HypervisorEnforcedCodeIntegrity" /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HVCIMATRequired" /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "LsaCfgFlags" /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "ConfigureSystemGuardLaunch" /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequireMicrosoftSignedBootChain" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f 

:: Edge Hardening
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "SitePerProcess" /t REG_DWORD /d "0x00000001" /f 
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "SSLVersionMin" /t REG_SZ /d "tls1.2^@" /f 
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "NativeMessagingUserLevelHosts" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "PreventSmartScreenPromptOverride" /t REG_DWORD /d "0x00000001" /f 
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "PreventSmartScreenPromptOverrideForFiles" /t REG_DWORD /d "0x00000001" /f 
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "SSLErrorOverrideAllowed" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "SmartScreenPuaEnabled" /t REG_DWORD /d "0x00000001" /f 
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "AllowDeletingBrowserHistory" /t REG_DWORD /d "0x00000000" /f 

:: Enable DEP
bcdedit /set nx on 

:: Disable TSX 
:: Enabling this could result in improved performance under certain workloads
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableTsx" /t REG_DWORD /d "1" /f 

:: Disable Fault Tolerant Heap
reg add "HKLM\SOFTWARE\Microsoft\FTH" /v "Enabled" /t REG_DWORD /d "0" /f 
rundll32.exe fthsvc.dll,FthSysprepSpecialize

:: Disable SmartScreen
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t Reg_DWORD /d "0" /f 
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "ShellSmartScreenLevel" /f  

:: Disable Lockscreen Security on Servers
if "%server%"=="yes" (reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "disablecad" /t REG_DWORD /d "1" /f )
goto RegistryConfiguration


:: Configuring the Windows Registry
:: - > Configuring the explorer and UI in Windows
:RegistryConfiguration
cls & echo !S_YELLOW!Configuring Registry... [11/18]

:: Explorer Quickness
:: - > Turn down application launch delays
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shutdown\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f 
:: - > Turn down login delays
:: https://james-rankin.com/features/the-ultimate-guide-to-windows-logon-optimizations-part-6/
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DelayedDesktopSwitchTimeout" /t REG_DWORD /d "0" /f 
:: - > Automatically close any apps and continue to restart, shut down, or sign out of windows
reg add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f 
:: - > Reduce menu show delay time
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f 
:: - > Configure app timeout 
reg add "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f 

:: Explorer Colors
:: - > Set windows color scheme to 'storm gray'
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentColorMenu" /t REG_DWORD /d "4290756543" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "StartColorMenu" /t REG_DWORD /d "4289901234" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentPalette" /t REG_BINARY /d "9b9a9900848381006d6b6a004c4a4800363533002625240019191900107c1000" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationColor" /t REG_DWORD /d "3293334088" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationAfterglow" /t REG_DWORD /d "3293334088" /f 
:: - > Set operating system color scheme to 'dark'
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d "0" /f 
:: - > Set tooltips to blue
reg add "HKCU\Control Panel\Colors" /v "InfoWindow" /t REG_SZ /d "246 253 255" /f 

:: Set NeptuneOS Wallpaper
reg add "HKCU\Control Panel\Desktop" /v "Wallpaper" /t REG_SZ /d "C:\Windows\Web\Wallpaper\Windows\NeptuneOS.png" /f 
:: - > Increase JPEG Wallpaper Quality
reg add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d "100" /f 

:: Disable Explorer Animations and Shadows
reg add "HKCU\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "1" /f 
reg add "HKCU\Control Panel\Desktop" /v "FontSmoothing" /t REG_SZ /d "2" /f 
reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9012038010000000" /f 
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisablePreviewDesktop" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "IconsOnly" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f 
:: - > Taskbar / UWP Transprency
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseOLEDTaskbarTransparency" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "DisableAcrylicBackgroundOnLogon" /t REG_DWORD /d "1" /f 
:: - > DWM Shadows and Animations
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "ListviewShadow" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableWindowColorization" /t REG_DWORD /d "1" /f 
:: - > DWM Composition
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "Composition" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowComposition" /t REG_DWORD /d "1" /f 

:: Context Menu Configuration
:: - > Disable wide Context Menus
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\FlightedFeatures" /v "ImmersiveContextMenu" /t REG_DWORD /d "0" /f 
:: - > Remove 'restore previous versions' from Context Menus and File Properties
reg delete "HKCR\AllFilesystemObjects\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f  
reg delete "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f  
reg delete "HKCR\Directory\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f  
reg delete "HKCR\Drive\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f  
reg delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f  
reg delete "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f  
reg delete "HKCR\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f  
reg delete "HKCR\Drive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f  
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "NoPreviousVersionsPage" /f  
reg delete "HKCU\SOFTWARE\Policies\Microsoft\PreviousVersions" /v "DisableLocalPage" /f  
:: - Restore 'new text file' in Context Menus
reg delete "HKCR\.txt\ShellNew" /f  
reg add "HKCR\.txt\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@%%SystemRoot%%\system32\notepad.exe,-470" /f 
reg add "HKCR\.txt\ShellNew" /v "NullFile" /t REG_SZ /d "" /f 
reg delete "HKCR\.txt" /f  
reg add "HKCR\.txt" /ve /t REG_SZ /d "txtfile" /f 
reg add "HKCR\.txt" /v "Content Type" /t REG_SZ /d "text/plain" /f 
reg add "HKCR\.txt" /v "PerceivedType" /t REG_SZ /d "text" /f 
reg add "HKCR\.txt\PersistentHandler" /ve /t REG_SZ /d "{5e941d80-bf96-11cd-b579-08002b30bfeb}" /f 
reg add "HKCR\.txt\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@%%SystemRoot%%\system32\notepad.exe,-470" /f 
reg add "HKCR\.txt\ShellNew" /v "NullFile" /t REG_SZ /d "" /f 
reg delete "HKCR\SystemFileAssociations\.txt" /f  
reg add "HKCR\SystemFileAssociations\.txt" /v "PerceivedType" /t REG_SZ /d "document" /f 
reg delete "HKCR\txtfile" /f  
reg add "HKCR\txtfile" /ve /t REG_SZ /d "Text Document" /f 
reg add "HKCR\txtfile" /v "EditFlags" /t REG_DWORD /d "2162688" /f 
reg add "HKCR\txtfile" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%SystemRoot%%\system32\notepad.exe,-469" /f 
reg add "HKCR\txtfile\DefaultIcon" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\imageres.dll,-102" /f 
reg add "HKCR\txtfile\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\NOTEPAD.EXE %%1" /f 
reg add "HKCR\txtfile\shell\print\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\NOTEPAD.EXE /p %%1" /f 
reg add "HKCR\txtfile\shell\printto\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\notepad.exe /pt \"%%1\" \"%%2\" \"%%3\" \"%%4\"" /f 
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.txt" /f  
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.txt\OpenWithList" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.txt\OpenWithProgids" /v "txtfile" /t REG_NONE /d "" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.txt\UserChoice" /v "Hash" /t REG_SZ /d "hyXk/CpboWw=" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.txt\UserChoice" /v "ProgId" /t REG_SZ /d "txtfile" /f 
reg delete "HKCU\SOFTWARE\Microsoft\Windows\Roaming\OpenWith\FileExts\.txt" /f  
reg add "HKCU\SOFTWARE\Microsoft\Windows\Roaming\OpenWith\FileExts\.txt\UserChoice" /v "Hash" /t REG_SZ /d "FvJcqeZpmOE=" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\Roaming\OpenWith\FileExts\.txt\UserChoice" /v "ProgId" /t REG_SZ /d "txtfile" /f 
:: - > Remove 'edit with Paint 3D' from Context Menus
reg delete "HKCR\SystemFileAssociations\.3mf\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.bmp\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.fbx\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.gif\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.jfif\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.jpe\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.jpeg\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.jpg\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.png\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.tif\Shell\3D Edit" /f  
reg delete "HKCR\SystemFileAssociations\.tiff\Shell\3D Edit" /f  
:: - > Remove 'give access to' from Context Menus
reg delete "HKCR\*\shellex\ContextMenuHandlers\Sharing" /f  
reg delete "HKCR\Directory\Background\shellex\ContextMenuHandlers\Sharing" /f  
reg delete "HKCR\Directory\shellex\ContextMenuHandlers\Sharing" /f  
reg delete "HKCR\Drive\shellex\ContextMenuHandlers\Sharing" /f  
reg delete "HKCR\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing" /f  
reg delete "HKCR\UserLibraryFolder\shellex\ContextMenuHandlers\Sharing" /f 
:: - > Remove 'cast to device' from Context Menus
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" /t REG_SZ /d "" /f  
:: - > Remove 'share' in Context Menus
reg delete "HKCR\*\shellex\ContextMenuHandlers\ModernSharing" /f  
reg delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\ModernSharing" /f  
:: - > Remove 'bitmap image' from the 'new' Context Menus
reg delete "HKCR\.bmp\ShellNew" /f  
:: - > Remove 'rich text document' from 'new' Context Menus
reg delete "HKCR\.rtf\ShellNew" /f  
:: - > Remove 'send to' from Context Menus
reg delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" /f  
reg delete "HKCR\UserLibraryFolder\shellex\ContextMenuHandlers\SendTo" /f  
:: - > Remove 'add to favorites' from Context Menus
reg delete "HKCR\*\shell\pintohomefile" /f  
:: - > Remove 'rotate left' and 'rotate right' from Context Menus
reg delete "HKCR\SystemFileAssociations\.avci\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.avif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.bmp\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.dds\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.dib\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.gif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.heic\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.heif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.hif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.ico\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.jfif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.jpe\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.jpeg\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.jpg\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.jxr\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.png\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.rle\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.tif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.tiff\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.wdp\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
reg delete "HKCR\SystemFileAssociations\.webp\ShellEx\ContextMenuHandlers\ShellImagePreview" /f  
:: - > Remove 'Scan with Defender' from Context Menus
reg delete "HKLM\SOFTWARE\Classes\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}\InprocServer32" /va /f  
reg delete "HKCR\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}" /v "InprocServer32" /f  
reg delete "HKCR\*\shellex\ContextMenuHandlers" /v "EPP" /f  
reg delete "HKCR\Directory\shellex\ContextMenuHandlers" /v "EPP" /f  
reg delete "HKCR\Drive\shellex\ContextMenuHandlers" /v "EPP" /f  
:: - > Remove 'print' from Context Menus
reg add "HKCR\SystemFileAssociations\image\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f  & for %%a in ("batfile" "cmdfile" "docxfile" "fonfile" "htmlfile" "inffile" "inifile" "JSEFile" "otffile" "pfmfile" "regfile" "rtffile" "ttcfile" "ttffile" "txtfile" "VBEFile" "VBSFile" "WSFFile") do (reg add "HKCR\%%~a\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f )
:: - > Remove 'include in library' from Context Menus
reg delete "HKCR\Folder\ShellEx\ContextMenuHandlers\Library Location" /f  
reg delete "HKLM\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location" /f  
:: - > Remove 'troubleshooting compatibility' from Context Menus
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{1d27f844-3a1f-4410-85ac-14651078412d}" /t REG_SZ /d "" /f 
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{1d27f844-3a1f-4410-85ac-14651078412d}" /t REG_SZ /d "" /f 
:: - > Add 'copy to' and 'move to' to Context Menus
reg add "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\Copy To" /ve /t REG_SZ /d "{C2FBB630-2971-11D1-A18C-00C04FD75D13}" /f 
reg add "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\Move To" /ve /t REG_SZ /d "{C2FBB631-2971-11D1-A18C-00C04FD75D13}" /f 
:: - > Add '.bat' to 'new' Context Menus
reg add "HKLM\SOFTWARE\Classes\.bat\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\System32\acppage.dll,-6002" /f 
reg add "HKLM\SOFTWARE\Classes\.bat\ShellNew" /v "NullFile" /t REG_SZ /d "" /f 
:: - > Add '.cmd' to 'new' Context Menus
reg add "HKLM\SOFTWARE\Classes\.cmd\ShellNew" /v "NullFile" /t REG_SZ /d "" /f 
reg add "HKLM\SOFTWARE\Classes\.cmd\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\System32\acppage.dll,-6003" /f 
:: - > Add '.ps1' to 'new' Context Menus
reg add "HKLM\SOFTWARE\Classes\.ps1\ShellNew" /v "NullFile" /t REG_SZ /d "" /f 
reg add "HKLM\SOFTWARE\Classes\.ps1\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "New file" /f 
if "%os%"=="Windows 11" (Reg add "HKCR\.ps1" /ve /t REG_SZ /d "ps1legacy" /f & Reg add "HKCR\.ps1\ShellNew" /v "NullFile" /t REG_SZ /d "" /f & Reg add "HKCR\ps1legacy" /ve /t REG_SZ /d "Windows PowerShell Script" /f & Reg add "HKCR\ps1legacy" /v "FriendlyTypeName" /t REG_SZ /d "Windows PowerShell Script" /f) 
:: - > Add '.reg' to 'new' Context Menus
reg add "HKLM\SOFTWARE\Classes\.reg\ShellNew" /v "NullFile" /t REG_SZ /d "" /f 
reg add "HKLM\SOFTWARE\Classes\.reg\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\regedit.exe,-309" /f 
:: - > Add 'take ownership' to Context Menus
reg add "HKCR\*\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f 
reg add "HKCR\*\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f 
reg add "HKCR\*\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f 
reg add "HKCR\*\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f 
reg add "HKCR\Directory\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f 
reg add "HKCR\Directory\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f 
reg add "HKCR\Directory\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f 
reg add "HKCR\Directory\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "MultipleInvokePromptMinimum" /t REG_DWORD /d "200" /f 
:: - > Add "merge as trusted installer" to .reg Context Menus
reg add "HKCR\regfile\Shell\RunAs" /ve /t REG_SZ /d "Merge As TrustedInstaller" /f 
reg add "HKCR\regfile\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "1" /f 
reg add "HKCR\regfile\Shell\RunAs\Command" /ve /t REG_SZ /d "NSudo.exe -U:T -P:E Reg import "%1"" /f 
:: - > Add 'install' to .cab Context Menus
reg delete "HKCR\CABFolder\Shell\RunAs" /f  
reg add "HKCR\CABFolder\Shell\RunAs" /ve /t REG_SZ /d "Install" /f 
reg add "HKCR\CABFolder\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "" /f 
reg add "HKCR\CABFolder\Shell\RunAs\Command" /ve /t REG_SZ /d "cmd /k DISM /online /add-package /packagepath:\"%1\"" /f 
:: - > Debloat 'Send To' context menu, hidden files do not show up in the 'Send To' context menu
:: attrib +h "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\SendTo\Bluetooth File Transfer.LNK" 
:: attrib +h "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\SendTo\Mail Recipient.MAPIMail" 
:: attrib +h "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\SendTo\Documents.mydocs" 

:: File Explorer Configuration
:: - > Disable 'Network Navigation' in the File Explorer Side Panel
reg add "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2962489444" /f 
:: - > Disable OneDrive in the File Explorer Side Panel
reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /d "0" /t REG_DWORD /f 
reg add "HKCR\Wow6432Node\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /d "0" /t REG_DWORD /f 
:: - > Remove Duplicate Removable Drives in the File Explorer Side Panel
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f  
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f  
:: - > Disable 'Quick Access' in the File Explorer Side Panel
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "HubMode" /t REG_DWORD /d "1" /f 
:: - > Disable '3D Objects' in the File Explorer Side Panel
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f  
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f  
:: - > Hide frequently used files/folders in the 'Quick Access' File Explorer Side Panel
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d "0" /f 
:: - > Hide recently used files/folders in the 'Quick Access' File Explorer Side Panel
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d "0" /f 
:: - > Show the full path in the File Explorer Search Bar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v "Settings" /t REG_BINARY /d "0c0002000b01000060000000" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v "FullPath" /t REG_DWORD /d "1" /f 
:: - > Show hidden files in File Explorer
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d "0" /f 
:: - > Show file extensions in File Explorer
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f 
:: - > Disable Sharing Wizard
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SharingWizardOn" /t REG_DWORD /d "0" /f 
:: - > Disable Sync Provider Notifications
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "0" /f 
:: - > Disable 'Show files from Office.com'
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCloudFilesInQuickAccess" /t REG_DWORD /d "0" /f 
:: - > Disable automatic folder type discovery in File Explorer
:: This might improve explorer performance, but will also make all folders autosort by 'details'
reg delete "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f  
reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v "FolderType" /t REG_SZ /d "NotSpecified" /f 
:: - > Show encrypted NTFS files in color in File Explorer
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowEncryptCompressedColor" /t REG_DWORD /d "1" /f 
:: - > Don't show the status bar in File Explorer
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowStatusBar" /t REG_DWORD /d "0" /f 
:: - > Open File Explorer to 'This PC'
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d "1" /f 
:: - > Revert to classic File Explorer search
reg add "HKLM\SOFTWARE\Classes\CLSID\{1d64637d-31e9-4b06-9124-e83fb178ac6e}\TreatAs" /v "" /t REG_SZ /d "{64bc32b5-4eec-4de7-972d-bd8bd0324537}" /f 
reg add "HKLM\SOFTWARE\Classes\WOW6432Node\CLSID\{1d64637d-31e9-4b06-9124-e83fb178ac6e}\TreatAs" /v "" /t REG_SZ /d "{64bc32b5-4eec-4de7-972d-bd8bd0324537}" /f 
reg add "HKLM\SOFTWARE\WOW6432Node\Classes\CLSID\{1d64637d-31e9-4b06-9124-e83fb178ac6e}\TreatAs" /v "" /t REG_SZ /d "{64bc32b5-4eec-4de7-972d-bd8bd0324537}" /f 
:: - > Always show more details for File Explorer transfers
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" /v "EnthusiastMode" /t REG_DWORD /d "1" /f 

:: Configure Taskbar
:: - > Hide meet now on the Taskbar
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f 
:: - > Hide people button on the Taskbar
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HidePeopleBar" /t REG_DWORD /d "1" /f 
:: - > Hide task view button on the Taskbar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /D "0" /f 
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MultiTaskingView\AllUpView" /v "Enabled" /f  
:: - > Hide search from the Taskbar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f 
:: - > Don't pin the store to the Taskbar
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoPinningStoreToTaskbar" /t REG_DWORD /d "1" /f 
:: - > Disable News and Interests on the Taskbar
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d "2" /f 
:: - > Hide notification badges on the Taskbar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarBadges" /t REG_DWORD /d "0" /f 
:: - > Show command prompt in the WIN+X menu
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DontUsePowerShellOnWinX" /t REG_DWORD /d "1" /f 
:: - > Disable Start Menu Recommendations
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_AccountNotifications" /t REG_DWORD /d "0" /f 
:: - > Clear Default TileGrid
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount" /v "start.tilegrid" /f  
:: - > Disable Start Menu Pins
:: currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "StartMenu_Start_Time" /t REG_BINARY /d "889f04f10c79da01" /f 
:: reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "Start_JumpListModernTime" /t REG_BINARY /d "29210bf10c79da01" /f 
:: reg add "HKU\%SID%\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "StartMenu_Start_Time" /t REG_BINARY /d "889f04f10c79da01" /f 
:: reg add "HKU\%SID%\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "Start_JumpListModernTime" /t REG_BINARY /d "29210bf10c79da01" /f 
:: - > Remove Advertisements and Stubs from Start Menu
if "%os%"=="Windows 11" (reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Start" /v "Config" /f)  
:: -> Hide Recommended Start Menu Apps
if "%os%"=="Windows 11" (reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Start" /v "ShowRecentList" /t REG_DWORD /d "0" /f) 
:: - > Hide Recently Added Apps in the Start Menu
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HideRecentlyAddedApps" /t REG_DWORD /d "1" /f 
:: - > Hide Recently Opened Items in Start Menu
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f 
:: - > Set the Start Menu layout.xml for Windows 10
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_EXPAND_SZ /d "%WinDir%\layout.xml" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "LockedStartLayout" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy Objects\{2F5183E9-4A32-40DD-9639-F9FAF80C79F4}Machine\Software\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_EXPAND_SZ /d "%WinDir%\layout.xml" /f 

:: - > Disable action center on the Taskbar
if "%os%"=="Windows 10" (
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f 
)
:: - > Disable notifications
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /t REG_DWORD /d "1" /f 
:: ^ - > Lock Screen Notifications
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "LockScreenToastEnabled" /t REG_DWORD /d "0" /f 
:: - > Disable cloud optimized taskbars
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableCloudOptimizedContent" /t Reg_DWORD /d "1" /f 
:: - > Disable CoPilot on Windows 11
if "%os%"=="Windows 11" (reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d "1" /f) 
if "%os%"=="Windows 11" (reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCopilotButton" /t REG_DWORD /d "0" /f) 

:: Fix Default Account Icon
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "UseDefaultTile" /t REG_DWORD /d "1" /f 

:: Enable the legacy photo viewer from windows 7 era
for %%a in (tif tiff bmp dib gif jfif jpe jpeg jpg jxr png) do (
reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".%%~a" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f 
)
for %%a in (tif tiff bmp dib gif jfif jpe jpeg jpg jxr png) do (
reg add "HKCU\SOFTWARE\Classes\.%%~a" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f 
)

:: Hide pages in UWP settings
if "%os%"=="Windows 10" (
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "hide:recovery;autoplay;usb;maps;maps-downloadmaps;findmydevice;privacy;privacy-speechtyping;privacy-speech;privacy-feedback;privacy-activityhistory;search-permissions;privacy-location;privacy-general;sync;printers;cortana-windowssearch;mobile-devices;mobile-devices-addphone;backup;" /f 
)
:: - >  Hide unneeded control panel applets
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "RestrictCpl" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "1" /t REG_SZ /d "Administrative Tools" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "2" /t REG_SZ /d "Color Management" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "3" /t REG_SZ /d "Date and Time" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "4" /t REG_SZ /d "Device Manager" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "5" /t REG_SZ /d "File Explorer Options" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "6" /t REG_SZ /d "Internet Options" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "7" /t REG_SZ /d "Keyboard" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "8" /t REG_SZ /d "Mouse" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "9" /t REG_SZ /d "Network and Sharing Center" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "10" /t REG_SZ /d "Power Options" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "11" /t REG_SZ /d "Programs and Features" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "12" /t REG_SZ /d "Region" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "13" /t REG_SZ /d "Sound" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "14" /t REG_SZ /d "Windows Defender Firewall" /f 

:: Configure Windows Search
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsAADCloudSearchEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsMSACloudSearchEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsDeviceSearchHistoryEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "SafeSearchMode" /t REG_DWORD /d "0" /f 
:: - > Explorer Search
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "AutoWildCard" /t REG_DWORD /d "1" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "EnableNaturalQuerySyntax" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "WholeFileSystem" /t REG_DWORD /d "1" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "SystemFolders" /t REG_DWORD /d "1" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "ArchivedFiles" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "SearchOnly" /t REG_DWORD /d "1" /f 

:: Disable AutoRun and AutoPlay
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v "DisableAutoplay" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d "255" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoAutoplayfornonVolume" /t REG_DWORD /d "1" /f 

:: Fix misbehaving icons when using 2 different resolution monitors
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "IconSpacing" /t REG_SZ /d "-1125" /f 
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "IconVerticalSpacing" /t REG_SZ /d "-1125" /f 

:: Disable 'desktop.ini' file creation
:: https://www.makeuseof.com/desktop-ini-files-guide/#:~:text=these%20files%20important%3F-,The%20desktop.,configuring%20specific%20file%2Dsharing%20settings.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "UseDesktopIniCache" /t REG_DWORD /d "0" /f 

:: Legacy Notepad
:: This removes the banner telling you to install the new NotePad
reg add "HKU\%SID%\Software\Microsoft\Notepad" /v "ShowStoreBanner" /t REG_DWORD /d "0" /f 
reg add "HKU\%SID%\Software\Microsoft\Notepad" /v "fWrap" /t REG_DWORD /d "1" /f 
reg add "HKU\%SID%\Software\Microsoft\Notepad" /v "StatusBar" /t REG_DWORD /d "1" /f 

:: Set icon cache to 51.2MB
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "Max Cached Icons" /t REG_SZ /d "51200" /f 

:: Turn off Internet File Association Service
:: https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.InternetCommunicationManagement::ShellNoUseInternetOpenWith_2
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetOpenWith" /t REG_DWORD /d 1 /f 

:: Turn on Verbose Mode
:: https://www.thewindowsclub.com/enable-verbose-status-message-windows
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "VerboseStatus" /t REG_DWORD /d "1" /f 

:: Show drive letters before drive name in File Explorer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowDriveLettersFirst" /t REG_DWORD /d "4" /f 

:: Disable USB Errors
reg add "HKCU\SOFTWARE\Microsoft\Shell\USB" /v "NotifyOnUsbErrors" /t REG_DWORD /d "0" /f 

:: Disable 'Open File - Security Warning' message
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f 
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4" /v "1806" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f 
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Security" /v "DisableSecuritySettingsCheck" /t REG_DWORD /d "1" /f 

:: Disable ShellBags
reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /v "BagMRU Size" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /v "BagMRU Size" /t REG_DWORD /d "1" /f 
reg add "HKCU\Software\Microsoft\Windows\Shell\BagMRU" /f 
reg add "HKCU\Software\Microsoft\Windows\Shell\Bags" /f 
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f  
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f  
reg delete "HKCU\Software\Microsoft\Windows\Shell\BagMRU" /f  
reg delete "HKCU\Software\Microsoft\Windows\Shell\Bags" /f  
reg delete "HKCU\Software\Microsoft\Windows\ShellNoRoam\BagMRU" /f  
reg delete "HKCU\Software\Microsoft\Windows\ShellNoRoam\Bags" /f  

:: Storage Sense Configuration
:: - > Clean files once a month
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "01" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "1024" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "2048" /t REG_DWORD /d "30" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "04" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "32" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "02" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "128" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "08" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "256" /t REG_DWORD /d "30" /f 

:: BSoD QoL
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "LogEvent" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl\StorageTelemetry" /v "DeviceDumpEnabled" /t REG_DWORD /d "0" /f 

:: Disable System Protection (by default)
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SPP\Clients" /v "{09F7EDC5-294E-4180-AF6A-FB0E6A0E9513}" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SPP\Clients" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "RPSessionInterval" /t REG_DWORD /d "0" /f 

:: Edge QoL
reg add "HKLM\Software\Policies\Microsoft\Edge" /f 
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "BackgroundModeEnabled" /t REG_DWORD /d 0 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenPuaEnabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "PreventSmartScreenPromptOverride" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "StartupBoostEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "AddressBarMicrosoftSearchInBingProviderEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "AlternateErrorPagesEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "AutofillAddressEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "AutofillCreditCardEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "ConfigureDoNotTrack" /t REG_DWORD /d "1" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "EdgeShoppingAssistantEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "LocalProvidersEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "MetricsReportingEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "NetworkPredictionOptions" /t REG_DWORD /d "2" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "PaymentMethodQueryEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "PersonalizationReportingEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "ResolveNavigationErrorsUseWebService" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "SearchSuggestEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "SendSiteInfoToImproveServices" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "SmartScreenEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "UserFeedbackAllowed" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Browser" /v "AllowAddressBarDropdown" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "AutofillCreditCardEnabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "UserFeedbackAllowed" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Policies\Microsoft\MicrosoftEdge\TabPreloader" /v "AllowTabPreloading" /t REG_DWORD /d "0" /f 

:: Explorer Audio Configuration
:: - > Fix volume mixer
reg add "HKCU\Software\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore" /f 
:: - > Don't show disconnected/disabled devices in mmsys.cpl
reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowDisconnectedDevices" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowHiddenDevices" /t REG_DWORD /d "0" /f 
:: - > Set audio scheme to none
PowerShell -ExecutionPolicy Unrestricted -Command  "New-ItemProperty -Path 'HKCU:\AppEvents\Schemes' -Name '(Default)' -Value '.None' -Force | Out-Null" 
PowerShell -ExecutionPolicy Unrestricted -Command  "Get-ChildItem -Path 'HKCU:\AppEvents\Schemes\Apps' | Get-ChildItem | Get-ChildItem | Where-Object {$_.PSChildName -eq '.Current'} | Set-ItemProperty -Name '(Default)' -Value ''" 
:: - > Don't reduce sounds while in a call
reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d "3" /f 

:: Configure Windows 11 File Explorer
if "%os%"=="Windows 11" (
:: - > Restore default context menu
reg add "HKCU\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /ve /t REG_SZ /d "" /f 
reg add "HKCU\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /t REG_SZ /d "" /f 
:: - > Disable Start Menu Recommendations
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_IrisRecommendations" /t REG_DWORD /d "0" /f 
:: - > Disable Widgets
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d "0" /f 
:: - > Disable Dynamic Lighting
Reg add "HKCU\Software\Microsoft\Lighting" /v "AmbientLightingEnabled" /t REG_DWORD /d "0" /f 
:: - > Allign the taskbar to the left
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAl" /t REG_DWORD /d "0" /f 
:: - > Use compact view mode in File Explorer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseCompactMode" /t REG_DWORD /d "1" /f 
:: - > Hide UWP settings pages
:: reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "hide:home;recovery;autoplay;usb;maps;maps-downloadmaps;findmydevice;privacy;privacy-speechtyping;privacy-speech;privacy-feedback;privacy-activityhistory;search-permissions;privacy-location;privacy-general;sync;printers;cortana-windowssearch;mobile-devices;mobile-devices-addphone;backup;" /f 
:: - > Hide gallery in File Explorer
reg add "HKCU\SOFTWARE\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f 
:: - > Show more pins in start menu
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_Layout" /t REG_DWORD /d "1" /f 
)


:: - Configuring privacy telemetry, and tracking in Windows.
:: Disable CEIP
reg add "HKCU\SOFTWARE\Policies\Microsoft\Messenger\Client" /v "CEIP" /t REG_DWORD /d "2" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\AppV\CEIP" /v "CEIPEnable" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f 
:: - > Disable CEIP Processes
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\AggregatorHost.exe" /v "Debugger" /t REG_SZ /d "%windir%\System32\taskkill.exe" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\CompatTelRunner.exe" /v "Debugger" /t REG_SZ /d "%WinDir%\System32\taskkill.exe" /f 

:: Disable Microsoft PC Manager Spread
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FeatureLoader.exe" /v "Debugger" /t REG_SZ /d "%windir%\System32\taskkill.exe" /f 

:: Disable Windows Feedback
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t Reg_DWORD /d "0" /f 
reg delete "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t Reg_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t Reg_DWORD /d "1" /f 

:: Disable Tagged Energy
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxTagPerApplication" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "DisableTaggedEnergyLogging" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxApplication" /t REG_DWORD /d "0" /f 

:: Disable Data Collection
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowDeviceNameInTelemetry" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t "REG_DWORD" /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowBuildPreview" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowCommercialDataPipeline" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowDeviceNameInTelemetry" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DisableEnterpriseAuthProxy" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DisableTelemetryOptInChangeNotification" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DisableTelemetryOptInSettingsUx" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitDiagnosticLogCollection" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitDumpCollection" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "MicrosoftEdgeDataOptIn" /t REG_DWORD /d "0" /f 

:: Disable Advertising Info
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t Reg_DWORD /d "0" /f 

:: Disable Tailored Experiences
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableTailoredExperiencesWithDiagnosticData" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t Reg_DWORD /d "0" /f 

:: Disable Health Monitoring
reg add "HKLM\SOFTWARE\Policies\Microsoft\DeviceHealthAttestationService" /v "EnableDeviceHealthAttestationService" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v "DWNoExternalURL" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v "DWNoFileCollection" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v "DWNoSecondLevelCollection" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\HelpSvc" /v "Headlines" /t REG_DWORD /d "0" /f 

:: Disable Text/Ink/Handwriting Telemetry
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f 

:: Disable Error Reporting
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultConsent" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultOverrideBehavior" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "AutoApproveOSDumps" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DontShowUI" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\Consent" /v "0" /t REG_SZ /d "" /f 

:: Disable Application Compatibility Engine
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t Reg_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AllowTelemetry" /t Reg_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableEngine" /t Reg_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t Reg_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t Reg_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t Reg_DWORD /d "1" /f 

:: Disable Tracing
reg add "HKLM\SOFTWARE\Microsoft\Tracing" /v "EnableAutoFileTracing" /t Reg_DWORD /d "0" /f  
reg add "HKLM\SOFTWARE\Microsoft\Tracing" /v "EnableConsoleTracing" /t Reg_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\Tracing" /v "EnableFileTracing" /t Reg_DWORD /d "0" /f 

:: Disallow the windows message cloud sync service as it can harm privacy
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Messaging" /v "AllowMessageSync" /t REG_DWORD /d "0" /f 

:: Disable Windows Spotlight
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "ConfigureWindowsSpotlight" /t REG_DWORD /d "2" /f 
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableTailoredExperiencesWithDiagnosticData" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableThirdPartySuggestions" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightFeatures" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightOnActionCenter" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightOnSettings" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightWindowsWelcomeExperience" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "IncludeEnterpriseSpotlight" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t REG_DWORD /d "1" /f 

:: Disable Content Delivery Manager
::   - > Disable pre-installed apps
::   - > Disable windows welcome experience
::   - > Disable suggested content in immersive control panel
::   - > Disable fun facts, tips, tricks on windows spotlight
::   - > Disable start menu suggestions
::   - > Disable get tips, tricks, and suggestions as you use windows
for %%a in (
"ContentDeliveryAllowed"
"OemPreInstalledAppsEnabled"
"PreInstalledAppsEnabled"
"PreInstalledAppsEverEnabled"
"SilentInstalledAppsEnabled"
"SubscribedContent-310093Enabled"
"SubscribedContent-338393Enabled"
"SubscribedContent-353694Enabled"
"SubscribedContent-353696Enabled"
"SubscribedContent-338387Enabled"
"RotatingLockScreenOverlayEnabled"
"RotatingLockScreenEnabled"
"SubscribedContent-338388Enabled"
"SystemPaneSuggestionsEnabled"
"SubscribedContent-338389Enabled"
"SoftLandingEnabled"
) do (
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "%%~a" /t Reg_DWORD /d "0" /f 
)

:: Disable License Telemetry
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t Reg_DWORD /d "1" /f 

:: Disable tips in UWP settings
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowOnlineTips" /v "value" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllowOnlineTips" /t REG_DWORD /d "0" /f 

:: Allow Microphone on Server
if "%server%"=="yes" (reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /v "Value" /t Reg_SZ /d "Allow" /f )

:: Disable Server Manager from Startup on Server
if "%server%"=="yes" (
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Server\ServerManager" /v "DoNotOpenAtLogon" /t REG_DWORD /d "1" /f 
)

:: Disable Location and Sensors
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocationScripting" /t Reg_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t Reg_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableWindowsLocationProvider" /t Reg_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableSensors" /t Reg_DWORD /d "1" /f 

:: Disable Location Tracking
reg add "HKLM\SOFTWARE\Policies\Microsoft\FindMyDevice" /v "AllowFindMyDevice" /t Reg_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\FindMyDevice" /v "LocationSyncEnabled" /t Reg_DWORD /d "0" /f 

:: Explorer Telemetry
:: - > Clear history of recently opened documents on exit
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ClearRecentDocsOnExit" /t REG_DWORD /d "1" /f 
:: - > Do not track shell shortcuts during roaming
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "LinkResolveIgnoreLinkInfo" /t REG_DWORD /d "1" /f 
:: - > Disable user tracking
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInstrumentation" /t REG_DWORD /d "1" /f 
:: - > Disable internet file association service
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetOpenWith" /t REG_DWORD /d "1" /f 
:: - > Disable low disk space warning
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoLowDiskSpaceChecks" /t REG_DWORD /d "1" /f 
:: - > Do not track history of recently opened documents
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f 
:: - > Do not use the search-based method when resolving shell shortcuts
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveSearch" /t REG_DWORD /d "1" /f 
:: - > Do not use the tracking-based method when resolving shell shortcuts
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveTrack" /t REG_DWORD /d "1" /f 
:: - > Do not display or track items in jump lists from remote locations
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoRemoteDestinations" /t REG_DWORD /d "1" /f 
:: - > Disable new app alert
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoNewAppAlert" /t REG_DWORD /d "1" /f 

:: Track only important failure events
Auditpol /set /subcategory:"Process Termination" /success:disable /failure:enable 
Auditpol /set /subcategory:"RPC Events" /success:disable /failure:enable 
Auditpol /set /subcategory:"Filtering Platform Connection" /success:disable /failure:enable 
Auditpol /set /subcategory:"DPAPI Activity" /success:disable /failure:disable 
Auditpol /set /subcategory:"IPsec Driver" /success:disable /failure:enable 
Auditpol /set /subcategory:"Other System Events" /success:disable /failure:enable 
Auditpol /set /subcategory:"Security State Change" /success:disable /failure:enable 
Auditpol /set /subcategory:"Security System Extension" /success:disable /failure:enable 
Auditpol /set /subcategory:"System Integrity" /success:disable /failure:enable 

:: Disable Sleep Study
wevtutil set-log "Microsoft-Windows-SleepStudy/Diagnostic" /e:false 
wevtutil set-log "Microsoft-Windows-Kernel-Processor-Power/Diagnostic" /e:false 
wevtutil set-log "Microsoft-Windows-UserModePowerService/Diagnostic" /e:false 

:: Disallow microsoft accounts from overriding local accounts
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "NoConnectedUser" /t REG_DWORD /d "1" /f 

:: Disable Setting Sync
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableApplicationSettingSync" /t REG_DWORD /d "2" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableApplicationSettingSyncUserOverride" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWebBrowserSettingSync" /t REG_DWORD /d "2" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWebBrowserSettingSyncUserOverride" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableDesktopThemeSettingSync" /t REG_DWORD /d "2" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableDesktopThemeSettingSyncUserOverride" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSyncOnPaidNetwork" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWindowsSettingSync" /t REG_DWORD /d "2" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWindowsSettingSyncUserOverride" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableCredentialsSettingSync" /t REG_DWORD /d "2" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableCredentialsSettingSyncUserOverride" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisablePersonalizationSettingSync" /t REG_DWORD /d "2" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisablePersonalizationSettingSyncUserOverride" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableStartLayoutSettingSync" /t REG_DWORD /d "2" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableStartLayoutSettingSyncUserOverride" /t REG_DWORD /d "1" /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t Reg_DWORD /d "5" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t Reg_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\AppSync" /v "Enabled" /t Reg_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t Reg_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t Reg_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\DesktopTheme" /v "Enabled" /t Reg_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t Reg_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\PackageState" /v "Enabled" /t Reg_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t Reg_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\StartLayout" /v "Enabled" /t Reg_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t Reg_DWORD /d "0" /f 

:: Disable PowerShell Telemetry
:: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_telemetry?view=powershell-7.3
setx POWERSHELL_TELEMETRY_OPTOUT 1 

:: Disable AutoLoggers
for %%a in (
Circular Kernel Context Logger
CloudExperienceHostOobe
DefenderApiLogger
DefenderAuditLogger
Diagtrack-Listener
LwtNetLog
Microsoft-Windows-Rdp-Graphics-RdpIdd-Trace
NetCore
NtfsLog
RadioMgr
RdrLog
ReadyBoot
SpoolerLogger
UBPM
WdiContextLog
WiFiSession
) do (
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\%%a" /v "Start" /t REG_DWORD /d "0" /f 
)

:: Delete Device Metadata
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /f 2>nul

:: Disable MSRT Telemetry
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\RemovalTools\MpGears" /v "HeartbeatTrackingIndex" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\RemovalTools\MpGears" /v "SpyNetReportingLocation" /t REG_MULTI_SZ /d "" /f 

:: Disable Telemetry and Program Compatibility Assistant Channels
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Assistant" /v "Enabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Assistant/Analytic" /v "Enabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Assistant/Compatibility-Infrastructure-Debug" /v "Enabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Assistant/Trace" /v "Enabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Troubleshooter" /v "Enabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Inventory" /v "Enabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Telemetry" /v "Enabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Steps-Recorder" /v "Enabled" /t REG_DWORD /d "0" /f 

:: Configure Application Permissions
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t Reg_SZ /d "Deny" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /v "Value" /t Reg_SZ /d "Deny" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t Reg_SZ /d "Deny" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /v "Value" /t Reg_SZ /d "Deny" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /v "Value" /t Reg_SZ /d "Deny" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t Reg_SZ /d "Deny" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /v "Value" /t Reg_SZ /d "Deny" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /v "Value" /t Reg_SZ /d "Deny" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" /v "Value" /t Reg_SZ /d "Deny" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /v "Value" /t Reg_SZ /d "Deny" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /v "Value" /t Reg_SZ /d "Deny" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /v "Value" /t Reg_SZ /d "Deny" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t Reg_SZ /d "Deny" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /v "Value" /t Reg_SZ /d "Deny" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /v "Value" /t Reg_SZ /d "Deny" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /v "Value" /t Reg_SZ /d "Deny" /f 

:: Disable DCOM
reg add "HKLM\SOFTWARE\Microsoft\Ole" /v "EnableDCOM" /t REG_SZ /d "N" /f 
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Ole" /v "EnableDCOM" /t REG_SZ /d "N" /f 

:: Disable OLE Logging
reg add "HKLM\SOFTWARE\Microsoft\Ole" /v "ActivationFailureLoggingLevel" /t REG_DWORD /d "2" /f 
reg add "HKLM\SOFTWARE\Microsoft\Ole" /v "CallFailureLoggingLevel" /t REG_DWORD /d "2" /f 

:: Disable RSoP Logging
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "RSoPLogging" /t REG_DWORD /d "0" /f 

:: Disable ReadyBoost
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\EMDMgmt" /v "GroupPolicyDisallowCaches" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\EMDMgmt" /v "AllowNewCachesByDefault" /t REG_DWORD /d "0" /f 

:: Disable Internet Addons
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF90-7B36-11D2-B20E-00C04F983E60}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF90-7B36-11D2-B20E-00C04F983E60}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF91-7B36-11D2-B20E-00C04F983E60}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF91-7B36-11D2-B20E-00C04F983E60}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF94-7B36-11D2-B20E-00C04F983E60}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF94-7B36-11D2-B20E-00C04F983E60}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{3050F819-98B5-11CF-BB82-00AA00BDCE0B}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{3050F819-98B5-11CF-BB82-00AA00BDCE0B}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{333C7BC4-460F-11D0-BC04-0080C7055A83}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{333C7BC4-460F-11D0-BC04-0080C7055A83}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{373984C9-B845-449B-91E7-45AC83036ADE}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{373984C9-B845-449B-91E7-45AC83036ADE}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{3E4D4F1C-2AEE-11D1-9D3D-00C04FC30DF6}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{3E4D4F1C-2AEE-11D1-9D3D-00C04FC30DF6}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{435899C9-44AB-11D1-AF00-080036234103}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{435899C9-44AB-11D1-AF00-080036234103}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{4F664F91-FF01-11D0-8AED-00C04FD7B597}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{4F664F91-FF01-11D0-8AED-00C04FD7B597}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{64AB4BB7-111E-11D1-8F79-00C04FC2FBE1}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{64AB4BB7-111E-11D1-8F79-00C04FC2FBE1}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{65303443-AD66-11D1-9D65-00C04FC30DF6}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{65303443-AD66-11D1-9D65-00C04FC30DF6}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{6BF52A52-394A-11D3-B153-00C04F79FAA6}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{6BF52A52-394A-11D3-B153-00C04F79FAA6}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{884E2049-217D-11DA-B2A4-000E7BBB2B09}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{884E2049-217D-11DA-B2A4-000E7BBB2B09}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{884E2051-217D-11DA-B2A4-000E7BBB2B09}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{884E2051-217D-11DA-B2A4-000E7BBB2B09}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A05-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A05-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A06-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A06-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A07-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A07-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A08-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A08-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A0A-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A0A-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{8E4062D9-FE1B-4B9E-AA16-5E8EEF68F48E}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{8E4062D9-FE1B-4B9E-AA16-5E8EEF68F48E}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{92337A8C-E11D-11D0-BE48-00C04FC30DF6}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{92337A8C-E11D-11D0-BE48-00C04FC30DF6}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{C3701884-B39B-11D1-9D68-00C04FC30DF6}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{C3701884-B39B-11D1-9D68-00C04FC30DF6}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{D2517915-48CE-4286-970F-921E881B8C5C}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{D2517915-48CE-4286-970F-921E881B8C5C}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{EE09B103-97E0-11CF-978F-00A02463E06F}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{EE09B103-97E0-11CF-978F-00A02463E06F}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F32-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F32-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F33-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F33-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F34-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F34-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F35-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F35-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F36-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F36-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F39-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F39-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F6D90F12-9C73-11D3-B32E-00C04F990BB4}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F6D90F12-9C73-11D3-B32E-00C04F990BB4}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F6D90F14-9C73-11D3-B32E-00C04F990BB4}" /v "Flags" /t REG_DWORD /d "1" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F6D90F14-9C73-11D3-B32E-00C04F990BB4}" /v "Version" /t REG_SZ /d "*" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{2933BF90-7B36-11D2-B20E-00C04F983E60}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{2933BF91-7B36-11D2-B20E-00C04F983E60}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{2933BF94-7B36-11D2-B20E-00C04F983E60}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{3050F819-98B5-11CF-BB82-00AA00BDCE0B}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{333C7BC4-460F-11D0-BC04-0080C7055A83}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{373984C9-B845-449B-91E7-45AC83036ADE}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{3E4D4F1C-2AEE-11D1-9D3D-00C04FC30DF6}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{435899C9-44AB-11D1-AF00-080036234103}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{4F664F91-FF01-11D0-8AED-00C04FD7B597}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{64AB4BB7-111E-11D1-8F79-00C04FC2FBE1}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{65303443-AD66-11D1-9D65-00C04FC30DF6}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{6BF52A52-394A-11D3-B153-00C04F79FAA6}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{884E2049-217D-11DA-B2A4-000E7BBB2B09}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{884E2051-217D-11DA-B2A4-000E7BBB2B09}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A05-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A06-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A07-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A08-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A0A-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{8E4062D9-FE1B-4B9E-AA16-5E8EEF68F48E}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{92337A8C-E11D-11D0-BE48-00C04FC30DF6}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{C3701884-B39B-11D1-9D68-00C04FC30DF6}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{D2517915-48CE-4286-970F-921E881B8C5C}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{EE09B103-97E0-11CF-978F-00A02463E06F}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F32-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F33-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F34-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F35-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F36-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F39-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F6D90F12-9C73-11D3-B32E-00C04F990BB4}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F6D90F14-9C73-11D3-B32E-00C04F990BB4}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f 

:: Configuring updates in Windows
:: - > Defer non-critical Windows Updates
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferQualityUpdates" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferQualityUpdatesPeriodInDays" /t REG_DWORD /d "6" /f 
:: - > Disable Feature Updates as these will break the OS
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferFeatureUpdates" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferFeatureUpdatesPeriodInDays" /t REG_DWORD /d "365" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersion" /t REG_DWORD /d "1" /f 
:: - > Disable Auto Updates
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f 
:: - > Prevent DevHome, Outlook and Teams from installing
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler\DevHomeUpdate" /f  
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler\OutlookUpdate" /f  
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v "ConfigureChatAutoInstall" /t REG_DWORD /d "0" /f 
:: - > Prevent random apps from installing, including Widgets or advertisements
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\Settings" /v "STOREBIZCRITICALAPPS" /f  
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\InstallService\State\CategoryCache" /v "48caba8a"-2e62-2097-dcd8-4255c637b32dUS /f  
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "AccountsService" /f  
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "BackupBanner" /f  
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "DesktopSpotlight" /f  
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "IrisService" /f  
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "SystemSettingsExtensions" /f  
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "WebExperienceHost" /f  
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "WindowsBackup" /f  
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\LastOnlineScanTimeForAppCategory\855E8A7C-ECB4-4CA3-B045-1DFA50104289" /v "EA6A8EC8-24BF-48A3-B0F0-A86A6447C0E2" /f  
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RequestedAppCategories\855E8A7C-ECB4-4CA3-B045-1DFA50104289" /v "EA6A8EC8-24BF-48A3-B0F0-A86A6447C0E2" /f  
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\RestrictedServices\AppIso\FirewallRules" /v "{5D2C72C6-969D-4C1E-8484-41ED53782351}" /f  
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{26037439-AD8B-4A56-AF2E-F6CDDB59F6BE}" /f  
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{44000509-BE9E-419B-A60B-54E62CF41203}" /f  
:: - > Prevent Malicious Software Removal Tool from installing
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f 
:: - > Do not adjust default option to 'Install Updates and Shut Down' in Shut Down Windows dialog box
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAUAsDefaultShutdownOption" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "HideMCTLink" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "SetAutoRestartNotificationDisable" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "RestartNotificationsAllowed2" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "SetUpdateNotificationLevel" /t REG_DWORD /d "2" /f 
:: - > Make WU not wake up your computer to install updates
:: https://admx.help/?Category=Windows_11_2022&Policy=Microsoft.Policies.WindowsUpdate::AUPowerManagement_Title
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "AUPowerManagement" /t REG_DWORD /d "0" /f 
:: - > Don't auto reboot for updates
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d "1" /f 
:: - > Disable Windows Insider
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ManagePreviewBuilds" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ManagePreviewBuildsPolicyValue" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableConfigFlighting" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableExperimentation" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility" /v "HideInsiderPage" /t REG_DWORD /d "1" /f 

:: Disable Microsoft Store App Auto-Updates
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d "2" /f 

:: Disable Shared Experiences
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableCdp" /t REG_DWORD /d "0" /f 

: Disable pre-release features
reg add "HKLM\Software\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableConfigFlighting" /t REG_DWORD /d "0" /f 

:: Disable Smart App Control (Fixes slow app loading issues on W11)
reg add "HKLM\SYSTEM\ControlSet001\Control\CI\Policy" /v "VerifiedAndReputablePolicyState" /t REG_DWORD /d "0" /f 

:: Disable Services Attempting to register restart every 30 seconds
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "InactivityShutdownDelay" /t REG_DWORD /d "4294967295" /f 

:: Disable Maintenance
:: reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f 

:: Disable Delivery Optimization
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "SystemSettingsDownloadMode" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings" /v "DownloadMode" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "0" /f 

:: Disable Reserved Storage for Windows Updates
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "MiscPolicyInfo" /t REG_DWORD /d "2" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "PassedPolicy" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "ShippedWithReserves" /t REG_DWORD /d "0" /f 
DISM /Online /Set-ReservedStorageState /State:Disabled 

:: Configuring Performance and Latency in Windows
:: - > MMCSS
:: - > Set system responsiveness to 10%
:: https://learn.microsoft.com/en-us/windows/win32/procthread/multimedia-class-scheduler-service#registry-settings
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "10" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /t REG_DWORD /d "10000" /f 
:: High GPU Priority
:: reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d "8" /f 
:: reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d "6" /f 
:: reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f 
:: reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f 
:: Legacy DWORD
:: reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f 

:: Disable GameBar
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f 
:: - > Disable GameBar tips
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "GamePanelStartupTipIndex" /t REG_DWORD /d "3" /f 
:: - > Disable 'Open Xbox Game Bar using this button on a controller'
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f 
:: - > Disable Game Bar Presence Writer, required for GameBar
reg add "HKLM\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter" /v "ActivationType" /t REG_DWORD /d "0" /f 
:: - > Disable Windows Game Recording and Broadcasting
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" /v "value" /t REG_DWORD /d "0" /f 

:: Disable Wi-Fi Sense
reg add "HKLM\SOFTWARE\Microsoft\wcmsvc\wifinetworkmanager\config" /v "AutoConnectAllowedOEM" /t REG_DWORD /d 0 /f 
reg add "HKLM\SOFTWARE\Microsoft\wcmsvc\wifinetworkmanager" /v "WifiSenseCredShared" /t REG_DWORD /d 0 /f 
reg add "HKLM\SOFTWARE\Microsoft\wcmsvc\wifinetworkmanager" /v "WifiSenseOpen" /t REG_DWORD /d 0 /f 

:: Remove FSO Overrides
reg delete "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" /v "__COMPAT_LAYER" /f  
reg delete "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /f 
reg delete "HKCU\System\GameConfigStore" /v "GameDVR_DSEBehavior" /f 
reg delete "HKLM\System\GameConfigStore" /f  
reg delete "HKU\.Default\System\GameConfigStore" /f  
reg delete "HKU\S-1-5-19\System\GameConfigStore" /f  
reg delete "HKU\S-1-5-20\System\GameConfigStore" /f  
reg delete "HKCU\Software\Classes\System\GameConfigStore" /f  

:: Enable FSO
reg add HKCU\System\GameConfigStore /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f 
reg add HKCU\System\GameConfigStore /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f 
reg add HKCU\System\GameConfigStore /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "0" /f 
reg add HKCU\System\GameConfigStore /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "0" /f 

:: Disable FastBoot (HiberBoot)
reg add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d "0" /f 

:: Configure Process Priorities
:: - > Origin, ShareX, Epic Games Launcher, Rockstar Launcher, Steam and Open-Shell Processes to Below Normal
for %%i in (OriginWebHelperService.exe ShareX.exe EpicWebHelper.exe SocialClubHelper.exe steamwebhelper.exe StartMenu.exe ) do (
  reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "5" /f 
)
:: - > fontdrvhost, lsasss, wmiprvse to Low
for %%i in (fontdrvhost.exe lsass.exe WmiPrvSE.exe ) do (
  reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f 
  reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f 
)
:: - > CSRSS and ntoskrnl to Realtime
:: Commented out because these processes need to be elevated to a kernel level in order to change priorities
:: reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f 
:: reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f 
:: reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f 
:: reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f 
:: - > Foreground Priorities
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\I/O System" /v "PassiveIntRealTimeWorkerPriority" /t REG_DWORD /d "18" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\KernelVelocity" /v "DisableFGBoostDecay" /t REG_DWORD /d "1" /f 
if "%server%"=="yes" (Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "ForceForegroundBoostDecay" /t REG_DWORD /d "0" /f )

:: Win32PrioritySeperation (short variable 1:1, no foreground boost)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f 

:: Enable Timer Resolution on Windows 11 and Server
if "%os%"=="Windows 11" (reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d "1" /f )
if "%server%"=="yes" (reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d "1" /f )

:: Disable WatchDog Timer
:: https://www.analog.com/en/design-notes/disable-the-watchdog-timer-during-system-reboot.html
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableSensorWatchdog" /t REG_DWORD /d "1" /f 

:: Disable Memory Paging
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePageCombining" /t REG_DWORD /d "1" /f 

:: Graphics Card Scheduling
:: - > Disable V-SYNC Interrupt Control
:: This reduces the amount of V-SYNC monitor refresh interrupts occur
:: https://learn.microsoft.com/en-us/windows-hardware/drivers/display/saving-energy-with-vsync-control
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "VsyncIdleTimeout" /t REG_DWORD /d "0" /f 
:: - > Enable GPU Preemption
:: https://learn.microsoft.com/en-us/windows-hardware/drivers/display/changing-the-behavior-of-the-gpu-scheduler-for-debugging
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "DisablePreemption" /t REG_DWORD /d "0" /f 
:: - > Force contiguous DirectX memory allocation
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f 
:: - > Disable GPU Isolation
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "IOMMUFlags" /t REG_DWORD /d "0" /f 

:: Enable VRR and Windowed Mode Optimizations
reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "SwapEffectUpgradeEnable=1;" /f 

:: SVCHOST Split Threshold
reg add "HKLM\SYSTEM\ControlSet001\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "4294967295" /f 

:: Increase decomitting memory threshold
reg add "HKLM\System\CurrentControlSet\Control\Session Manager" /v "HeapDeCommitFreeBlockThreshold" /t REG_DWORD /d "262144" /f 

:: Disable Exclusive Mode on Audio Devices
for /f "delims=" %%a in ('Reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do %WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 %WinDir%\System32\Reg add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d 0 /f 
for /f "delims=" %%a in ('Reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do %WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 %WinDir%\System32\Reg add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d 0 /f 
for /f "delims=" %%a in ('Reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do %WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 %WinDir%\System32\Reg add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d 0 /f 
for /f "delims=" %%a in ('Reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do %WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 %WinDir%\System32\Reg add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d 0 /f 

:: Disable Audio Enhancements
for %%a in ("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture", "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render") do (
for /f "delims=" %%b in ('reg query "%%a"') do (
reg add "%%b\FxProperties" /v "{1da5d803-d492-4edd-8c23-e0c0ffee7f0e},5" /t REG_DWORD /d "1" /f 
reg add "%%b\FxProperties" /v "{1b5c2483-0839-4523-ba87-95f89d27bd8c},3" /t REG_BINARY /d "030044CD0100000000000000" /f 
reg add "%%b\FxProperties" /v "{73ae880e-8258-4e57-b85f-7daa6b7d5ef0},3" /t REG_BINARY /d "030044CD0100000001000000" /f 
reg add "%%b\FxProperties" /v "{9c00eeed-edce-4cd8-ae08-cb05e8ef57a0},3" /t REG_BINARY /d "030044CD0100000004000000" /f 
reg add "%%b\FxProperties" /v "{fc52a749-4be9-4510-896e-966ba6525980},3" /t REG_BINARY /d "0B0044CD0100000000000000" /f 
reg add "%%b\FxProperties" /v "{ae7f0b2a-96fc-493a-9247-a019f1f701e1},3" /t REG_BINARY /d "0300BC5B0100000001000000" /f 
reg add "%%b\FxProperties" /v "{1864a4e0-efc1-45e6-a675-5786cbf3b9f0},4" /t REG_BINARY /d "030044CD0100000000000000" /f 
reg add "%%b\FxProperties" /v "{61e8acb9-f04f-4f40-a65f-8f49fab3ba10},4" /t REG_BINARY /d "030044CD0100000050000000" /f 
reg add "%%b\Properties" /v "{e4870e26-3cc5-4cd2-ba46-ca0a9a70ed04},0" /t REG_BINARY /d "4100FE6901000000FEFF020080BB000000DC05000800200016002000030000000300000000001000800000AA00389B71" /f 
reg add "%%b\Properties" /v "{e4870e26-3cc5-4cd2-ba46-ca0a9a70ed04},1" /t REG_BINARY /d "41008EC901000000A086010000000000" /f 
reg add "%%b\Properties" /v "{3d6e1656-2e50-4c4c-8d85-d0acae3c6c68},3" /t REG_BINARY /d "4100020001000000FEFF020080BB000000DC05000800200016002000030000000300000000001000800000AA00389B71" /f 
reg delete "%%b\Properties" /v "{624f56de-fd24-473e-814a-de40aacaed16},3" /f  
reg delete "%%b\Properties" /v "{3d6e1656-2e50-4c4c-8d85-d0acae3c6c68},2" /f  
)
)


:: Disable WPBT
:: https://github.com/Jamesits/dropWPBT
:: https://download.microsoft.com/download/8/A/2/8A2FB72D-9B96-4E2D-A559-4A27CF905A80/windows-platform-binary-table.docx
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "DisableWpbtExecution" /t REG_DWORD /d "1" /f 

:: Disable Background Apps
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d "2" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f 

:: Configuring ease of access settings in Windows
:: Disable Sticky keys, Mouse Keys, Toggle Keys, and other Keyboard Features
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_DWORD /d "0" /f 
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_DWORD /d "0" /f 
reg add "HKCU\Control Panel\Accessibility\MouseKeys" /v "Flags" /t REG_DWORD /d "0" /f 
reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_DWORD /d "0" /f 

:: Disable Pointer Precision
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f 
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f 
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f 

:: Lower Keyboard Repeat Delay / Cursor Blink Rate
reg add "HKCU\Control Panel\Keyboard" /v "KeyboardDelay" /t REG_SZ /d "0" /f 
reg add "HKCU\Control Panel\Keyboard" /v "KeyboardSpeed" /t REG_SZ /d "31" /f 
reg add "HKCU\Control Panel\Desktop" /v "CursorBlinkRate" /t REG_SZ /d "-1" /f 

:: MarkC 1:1
:: reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d 0000000000000000C0CC0C0000000000809919000000000040662600000000000033330000000000 /f 
:: reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d 0000000000000000000038000000000000007000000000000000A800000000000000E00000000000 /f 

:: Configuring Misc Registry
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "ShowedToastAtLevel" /t Reg_DWORD /d "1" /f 
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "DiagTrackAuthorization" /t REG_DWORD /d "775" /f 
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "DiagTrackStatus" /t REG_DWORD /d "2" /f 
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "UploadPermissionReceived" /t REG_DWORD /d "1" /f 
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\TraceManager" /v "MiniTraceSlotContentPermitted" /t REG_DWORD /d "1" /f 
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\TraceManager" /v "MiniTraceSlotEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /t Reg_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t Reg_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t Reg_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Diagnostics\Performance" /v "DisableDiagnosticTracing" /t Reg_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}" /v "ScenarioExecutionEnabled" /t Reg_DWORD /d "0" /f 

:: Disable RDP
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "fLogonDisabled" /t REG_DWORD /d "1" /f 

:: Disable Settings Banner
reg add "HKLM\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\ValueBanner.IdealStateFeatureControlProvider" /v "ActivationType" /t REG_DWORD /d "0" /f 

:: Disable 'Use my sign-in info to finish setting up this device'
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableAutomaticRestartSignOn" /t REG_DWORD /d "1" /f 

:: Disable Typing Insights
reg add "HKCU\SOFTWARE\Microsoft\Input\Settings" /v "InsightsEnabled" /t REG_DWORD /d "0" /f 

:: Disable Spell Checking
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableSpellchecking" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableTextPrediction" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnablePredictionSpaceInsertion" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableDoubleTapSpace" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableAutocorrection" /t REG_DWORD /d "0" /f 

:: Disable Fast User Switching
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "HideFastUserSwitching" /t REG_DWORD /d "1" /f 

:: Run Startup Scripts Asynchronously
:: https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.Scripts::Run_Startup_Script_Sync
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "RunStartupScriptSync" /t REG_DWORD /d "0" /f 

:: EULA Accept SysInternals
reg add "HKCU\Software\Sysinternals\Regjump" /v "EulaAccepted" /t REG_DWORD /d "1" /f 
goto PerformanceCounters


:PerformanceCounters
cls & echo !S_YELLOW!Rebuilding Performance Counters... [12/18]
lodctr /r 
lodctr /r 
goto DebloatWindows


:DebloatWindows
cls & echo !S_YELLOW!Debloating Windows... [13/18]

:: Debloat Apps
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Windows\NeptuneDir\Scripts\debloat.ps1"

"C:\Windows\NeptuneDir\Tools\RemoveEdge.exe"

:: Remove Microsoft Edge Chromium
:: Powershell -ExecutionPolicy Unrestricted "%WinDir%\NeptuneDir\Scripts\RemoveEdge.ps1" -UninstallEdge -RemoveEdgeData -KeepAppX -NonInteractive 

:: Remove Content Delivery Manager
PowerShell -NoProfile -NoLogo -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.Windows.ContentDeliveryManager'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, ""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path ""$dir"") ) { continue }; cmd /c ('takeown /f ""' + $dir + '"" /r /d y 1'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls ""' + $dir + '"" /grant administrators:F /t 1'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host ""Rename '$($file.FullName)' to '$newName'""; Move-Item -LiteralPath ""$($file.FullName)"" -Destination ""$newName"" -Force; }; }"

:: Prevent Microsoft Teams reinstallation
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v "ConfigureChatAutoInstall" /t REG_DWORD /d "0" /f 

:: UWP Immersive Control Panel Debloat
Powershell -ExecutionPolicy Unrestricted "%WinDir%\NeptuneDir\Scripts\CLIENTCBS.ps1" 

:: Remove Header in Immersive Control Panel
icacls "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SystemSettingsExtensions.dll" /grant Administrators:F 
takeown /f "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SystemSettingsExtensions.dll"
%delF% "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SystemSettingsExtensions.dll"

:: Rename SmartScreen
taskkill /f /im smartscreen.exe
cd %WinDir%\System32 
takeown /f "smartscreen.exe" 
icacls "%WinDir%\System32\smartscreen.exe" /grant Administrators:F 
ren smartscreen.exe smartscreen.old 

:: Remove MobSync
taskkill /f /im mobsync.exe
cd %WinDir%\System32 
takeown /f "mobsync.exe" 
icacls "%WinDir%\System32\mobsync.exe" /grant Administrators:F 
ren mobsync.exe mobsync.old 

:: Remove OneDrive
if exist "C:\" ("%SYSTEMROOT%\System32\OneDriveSetup.exe" /uninstall) else ("C:\Windows\SysWOW64\OneDriveSetup.exe" /uninstall)

:: Remove OneDrive Startup Task
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f  
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f  

:: Disable OneDrive Usage
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /t REG_DWORD /v "DisableFileSyncNGSC" /d 1 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /t REG_DWORD /v "DisableFileSync" /d 1 /f 

:: Remove Residual Files
setlocal DisableDelayedExpansion
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%USERPROFILE%\OneDrive'; if (-Not $directoryGlob.EndsWith('\')) { $directoryGlob += '\' }; $directoryGlob )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%LOCALAPPDATA%\Microsoft\OneDrive'; if (-Not $directoryGlob.EndsWith('\')) { $directoryGlob += '\' }; $directoryGlob )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; <# Not using `Get-Acl`/`Set-Acl` to avoid adjusting token privileges #>; $parentDirectory = [System.IO.Path]::GetDirectoryName($expandedPath); $fileName = [System.IO.Path]::GetFileName($expandedPath); if ($parentDirectory -like '*[*?]*') {; throw "^""Unable to grant permissions to glob path parent directory: `"^""$parentDirectory`"^"", wildcards in parent directory are not supported by ``takeown`` and ``icacls``."^""; }; if (($fileName -ne '*') -and ($fileName -like '*[*?]*')) {; throw "^""Unable to grant permissions to glob path file name: `"^""$fileName`"^"", wildcards in file name is not supported by ``takeown`` and ``icacls``."^""; }; Write-Host "^""Taking ownership of `"^""$expandedPath`"^""."^""; $cmdPath = $expandedPath; if ($cmdPath.EndsWith('\')) {; $cmdPath += '\' <# Escape trailing backslash for correct handling in batch commands #>; }; $takeOwnershipCommand = "^""takeown /f `"^""$cmdPath`"^"" /a"^"" <# `icacls /setowner` does not succeed, so use `takeown` instead. #>; if (-not (Test-Path -Path "^""$expandedPath"^"" -PathType Leaf)) {; $takeOwnershipCommand += ' /r /d y'; }; $takeOwnershipOutput = cmd /c "^""$takeOwnershipCommand 2>&1"^"" <# `stderr` message is misleading, e.g. "^""ERROR: The system cannot find the file specified."^"" is not an error. #>; if ($LASTEXITCODE -eq 0) {; Write-Host "^""Successfully took ownership of `"^""$expandedPath`"^"" (using ``$takeOwnershipCommand``)."^""; } else {; Write-Host "^""Did not take ownership of `"^""$expandedPath`"^"" using ``$takeOwnershipCommand``, status code: $LASTEXITCODE, message: $takeOwnershipOutput."^""; <# Do not write as error or warning, because this can be due to missing path, it's handled in next command. #>; <# `takeown` exits with status code `1`, making it hard to handle missing path here. #>; }; Write-Host "^""Granting permissions for `"^""$expandedPath`"^""."^""; $adminSid = New-Object System.Security.Principal.SecurityIdentifier 'S-1-5-32-544'; $adminAccount = $adminSid.Translate([System.Security.Principal.NTAccount]); $adminAccountName = $adminAccount.Value; $grantPermissionsCommand = "^""icacls `"^""$cmdPath`"^"" /grant `"^""$($adminAccountName):F`"^"" /t"^""; $icaclsOutput = cmd /c "^""$grantPermissionsCommand"^""; if ($LASTEXITCODE -eq 3) {; Write-Host "^""Skipping, no items available for deletion according to: ``$grantPermissionsCommand``."^""; exit 0; } elseif ($LASTEXITCODE -ne 0) {; Write-Host "^""Take ownership message:`n$takeOwnershipOutput"^""; Write-Host "^""Grant permissions:`n$icaclsOutput"^""; Write-Warning "^""Failed to assign permissions for `"^""$expandedPath`"^"" using ``$grantPermissionsCommand``, status code: $LASTEXITCODE."^""; } else {; $fileStats = $icaclsOutput | ForEach-Object { $_ -match '\d+' | Out-Null; $matches[0] } | Where-Object { $_ -ne $null } | ForEach-Object { [int]$_ }; if ($fileStats.Count -gt 0 -and ($fileStats | ForEach-Object { $_ -eq 0 } | Where-Object { $_ -eq $false }).Count -eq 0) {; Write-Host "^""Skipping, no items available for deletion according to: ``$grantPermissionsCommand``."^""; exit 0; } else {; Write-Host "^""Successfully granted permissions for `"^""$expandedPath`"^"" (using ``$grantPermissionsCommand``)."^""; }; }; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%PROGRAMDATA%\Microsoft OneDrive'; if (-Not $directoryGlob.EndsWith('\')) { $directoryGlob += '\' }; $directoryGlob )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%SYSTEMDRIVE%\OneDriveTemp'; if (-Not $directoryGlob.EndsWith('\')) { $directoryGlob += '\' }; $directoryGlob )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"

:: Delete OneDrive Shortcuts
PowerShell -ExecutionPolicy Unrestricted -Command "$shortcuts = @(; @{ Revert = $True;  Path = "^""$env:APPDATA\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"^""; }; @{ Revert = $False; Path = "^""$env:USERPROFILE\Links\OneDrive.lnk"^""; }; @{ Revert = $False; Path = "^""$env:WINDIR\ServiceProfiles\LocalService\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"^""; }; @{ Revert = $False; Path = "^""$env:WINDIR\ServiceProfiles\NetworkService\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"^""; }; ); foreach ($shortcut in $shortcuts) {; if (-Not (Test-Path $shortcut.Path)) {; Write-Host "^""Skipping, shortcut does not exist: `"^""$($shortcut.Path)`"^""."^""; continue; }; try {; Remove-Item -Path $shortcut.Path -Force -ErrorAction Stop; Write-Output "^""Successfully removed shortcut: `"^""$($shortcut.Path)`"^""."^""; } catch {; Write-Error "^""Encountered an issue while attempting to remove shortcut at: `"^""$($shortcut.Path)`"^""."^""; }; }" 
PowerShell -ExecutionPolicy Unrestricted -Command "Set-Location "^""HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace"^""; Get-ChildItem | ForEach-Object {Get-ItemProperty $_.pspath} | ForEach-Object {; $leftnavNodeName = $_."^""(default)"^"";; if (($leftnavNodeName -eq "^""OneDrive"^"") -Or ($leftnavNodeName -eq "^""OneDrive - Personal"^"")) {; if (Test-Path $_.pspath) {; Write-Host "^""Deleting $($_.pspath)."^""; Remove-Item $_.pspath;; }; }; }"
goto ConfigureFeatures


:ConfigureFeatures
setlocal EnableDelayedExpansion
cls & echo !S_YELLOW!Configuring Windows Features and Capabilities... [14/18]
:: Features and Components
:: Enable DirectPlay
dism /Online /Enable-Feature /FeatureName:"LegacyComponents" /NoRestart 
dism /Online /Enable-Feature /FeatureName:"DirectPlay" /NoRestart 
:: Disable Hyper-V
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-All" /NoRestart 
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Management-Clients" /NoRestart 
:: Disable Hyper-V Management Tools
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Tools-All" /NoRestart 
:: Disable Hyper-V Module for Windows PowerShell
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Management-PowerShell" /NoRestart 
:: Disable Telnet Client
dism /Online /Disable-Feature /FeatureName:"TelnetClient" /NoRestart 
:: Disable Net.TCP Port Sharing
dism /Online /Disable-Feature /FeatureName:"WCF-TCP-PortSharing45" /NoRestart 
:: Disable SMB Direct
dism /Online /Disable-Feature /FeatureName:"SmbDirect" /NoRestart 
:: Disable SMB1 Protocol
dism /online /Disable-Feature /FeatureName:"SMB1Protocol" /NoRestart 
dism /Online /Disable-Feature /FeatureName:"SMB1Protocol-Client" /NoRestart 
dism /Online /Disable-Feature /FeatureName:"SMB1Protocol-Server" /NoRestart 
:: Disable TFTP Client
dism /Online /Disable-Feature /FeatureName:"TFTP" /NoRestart 
:: Disable Internet Printing Client
dism /Online /Disable-Feature /FeatureName:"Printing-Foundation-InternetPrinting-Client" /NoRestart 
:: Disable LPD Print Service
dism /Online /Disable-Feature /FeatureName:"LPDPrintService" /NoRestart 
:: Disable Internet Explorer
dism /Online /Disable-Feature /FeatureName:"Internet-Explorer-Optional-x64" /NoRestart 
dism /Online /Disable-Feature /FeatureName:"Internet-Explorer-Optional-x84" /NoRestart 
dism /Online /Disable-Feature /FeatureName:"Internet-Explorer-Optional-amd64" /NoRestart 
:: Disable LPR Port Monitor
dism /Online /Disable-Feature /FeatureName:"Printing-Foundation-LPRPortMonitor" /NoRestart 
:: Disable Microsoft Print to PDF
dism /Online /Disable-Feature /FeatureName:"Printing-PrintToPDFServices-Features" /NoRestart 
:: Disable "PS Services
dism /Online /Disable-Feature /FeatureName:"Printing-XPSServices-Features" /NoRestart 
:: Disable XPS Viewer
dism /Online /Disable-Feature /FeatureName:"Xps-Foundation-Xps-Viewer" /NoRestart 
:: Disable Print and Document Services
dism /Online /Disable-Feature /FeatureName:"Printing-Foundation-Features" /NoRestart 
:: Disable Work Folders Client
dism /Online /Disable-Feature /FeatureName:"WorkFolders-Client" /NoRestart 
:: Disable Windows Media Player
dism /Online /Disable-Feature /FeatureName:"MediaPlayback" /NoRestart 
dism /Online /Disable-Feature /FeatureName:"WindowsMediaPlayer" /NoRestart 
:: Disable "Scan Management" feature
dism /Online /Disable-Feature /FeatureName:"ScanManagementConsole" /NoRestart 
:: Disable "Windows Fax and Scan" feature
dism /Online /Disable-Feature /FeatureName:"FaxServicesClientPackage" /NoRestart 
:: Disable PowerShell V2
dism /Online /Disable-Feature /FeatureName:"MicrosoftWindowsPowerShellV2Root" /NoRestart 
:: Disable Remote Differential Compression
dism /Online /Disable-Feature /FeatureName:"MSRDC-Infrastructure" /NoRestart 
:: Disable WCF Services
dism /Online /Disable-Feature /FeatureName:"WCF-Services45" /NoRestart 
:: Disable Remote Desktop Connection
dism /Online /Disable-Feature /FeatureName:"Microsoft-RemoteDesktopConnection" /NoRestart 


:: Capabilities
:: Remove "Internet Explorer 11
%PowerShell% "Get-WindowsCapability -Online -Name 'Browser.InternetExplorer*' | Remove-WindowsCapability -Online" 
:: Remove Math Recognizer
%PowerShell% "Get-WindowsCapability -Online -Name 'MathRecognizer~~~~0.0.1.0*' | Remove-WindowsCapability -Online" 
:: Remove "OneSync" (breaks Mail, People, and Calendar)
%PowerShell% "Get-WindowsCapability -Online -Name 'OneCoreUAP.OneSync*' | Remove-WindowsCapability -Online" 
:: Remove OpenSSH client
%PowerShell% "Get-WindowsCapability -Online -Name 'OpenSSH.Client*' | Remove-WindowsCapability -Online" 
:: Remove PowerShell ISE
%PowerShell% "Get-WindowsCapability -Online -Name 'Microsoft.Windows.PowerShell.ISE*' | Remove-WindowsCapability -Online" 
:: Remove Print Management Console
%PowerShell% "Get-WindowsCapability -Online -Name 'Print.Management.Console*' | Remove-WindowsCapability -Online" 
:: Remove Quick Assist
%PowerShell% "Get-WindowsCapability -Online -Name 'App.Support.QuickAssist*' | Remove-WindowsCapability -Online" 
:: Remove Steps Recorder
%PowerShell% "Get-WindowsCapability -Online -Name 'App.StepsRecorder*' | Remove-WindowsCapability -Online" 
:: Remove Windows Fax and Scan
%PowerShell% "Get-WindowsCapability -Online -Name 'Print.Fax.Scan*' | Remove-WindowsCapability -Online" 
:: Remove Hello Face
%PowerShell% "Get-WindowsCapability -Online -Name 'Hello.Face.20134~~~~0.0.1.0*' | Remove-WindowsCapability -Online" 
:: Remove WordPad
%PowerShell% "Get-WindowsCapability -Online -Name 'Microsoft.Windows.WordPad~~~~0.0.1.0*' | Remove-WindowsCapability -Online" 
:: Remove Extended Wallpapers
%PowerShell% "Get-WindowsCapability -Online -Name 'Microsoft.Wallpapers.Extended~~~~0.0.1.0*' | Remove-WindowsCapability -Online" 

:: UWP Deprovision
for %%a in (1527c705-839a-4832-9118-54d4Bd6a0c89_cw5n1h2txyewy Microsoft.3DBuilder_8wekyb3d8bbwe Microsoft.BingFinance_8wekyb3d8bbwe Microsoft.BingNews_8wekyb3d8bbwe Microsoft.BingSports_8wekyb3d8bbwe Microsoft.BingWeather_8wekyb3d8bbwe
Microsoft.Microsoft3DViewer_8wekyb3d8bbwe Microsoft.MicrosoftEdge_8wekyb3d8bbwe Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe Microsoft.Office.OneNote_8wekyb3d8bbwe Microsoft.Office.Sway_8wekyb3d8bbwe
Microsoft.StorePurchaseApp_8wekyb3d8bbwe Microsoft.Windows.CloudExperienceHost_cw5n1h2txyewy Microsoft.Windows.Phone_8wekyb3d8bbwe Microsoft.WindowsPhone_8wekyb3d8bbwe Microsoft.WindowsStore_8wekyb3d8bbwe Microsoft.Xbox.TCUI_8wekyb3d8bbwe
Microsoft.XboxApp_8wekyb3d8bbwe Microsoft.XboxGameOverlay_8wekyb3d8bbwe Microsoft.XboxGamingOverlay_8wekyb3d8bbwe Microsoft.XboxIdentityProvider_8wekyb3d8bbwe Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe 
Microsoft.MicrosoftTeams_8wekyb3d8bbwe) do reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\%%a" /f 
goto PrerequisitesInstallation


:PrerequisitesInstallation
cls & echo !S_YELLOW!Installing Visual C++... [15/18]
"%WinDir%\NeptuneDir\Prerequisites\vcredist.exe" /ai8X239T 

cls & echo !S_YELLOW!Installing DirectX... [16/18]
"%WinDir%\NeptuneDir\Prerequisites\DirectX\DXSETUP.exe" /silent 

cls & echo !S_YELLOW!Installing 7-Zip... [17/18]
"%WinDir%\NeptuneDir\Prerequisites\7z.exe" /S  
setlocal DisableDelayedExpansion

:: Context Menu Options
reg add "HKCU\Software\7-Zip\FM\Columns" /v "RootFolder" /t REG_BINARY /d "0100000000000000010000000400000001000000A0000000" /f 
reg add "HKCU\Software\7-Zip\Options" /v "ElimDupExtract" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\7-Zip\Options" /v "ContextMenu" /t REG_DWORD /d "4100" /f 
reg add "HKU\%SID%\SOFTWARE\7-Zip\Options" /v "ContextMenu" /t REG_DWORD /d "1073746726" /f
:: File Assoc
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.001\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.001\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.7z\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.7z\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.apfs\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.apfs\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.arj\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.arj\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.bz2\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.bz2\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.bzip2\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.bzip2\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.cab\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.cab\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.cpio\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.cpio\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.deb\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.deb\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.dmg\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.dmg\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.esd\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.esd\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.fat\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.fat\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.gz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.gz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.gzip\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.gzip\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.hfs\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.hfs\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.iso\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.iso\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lha\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lha\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lzh\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lzh\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lzma\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lzma\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.ntfs\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.ntfs\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.rar\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.rar\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.rpm\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.rpm\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.squashfs\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.squashfs\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.swm\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.swm\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tar\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tar\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.taz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.taz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tbz2\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tbz2\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tbz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tbz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tgz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tgz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tpz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tpz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.txz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.txz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.vhd\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.vhd\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.vhdx\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.vhdx\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.wim\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.wim\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.xz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.xz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.z\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.z\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.zip\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.zip\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.001\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.001\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.7z\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.7z\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.apfs\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.apfs\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.arj\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.arj\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.bz2\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.bz2\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.bzip2\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.bzip2\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.cab\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.cab\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.cpio\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.cpio\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.deb\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.deb\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.dmg\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.dmg\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.esd\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.esd\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.fat\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.fat\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.gz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.gz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.gzip\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.gzip\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.hfs\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.hfs\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.iso\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.iso\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lha\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lha\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lzh\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lzh\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lzma\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lzma\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.ntfs\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.ntfs\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.rar\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.rar\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.rpm\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.rpm\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.squashfs\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.squashfs\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.swm\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.swm\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tar\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tar\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.taz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.taz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz2\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz2\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tgz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tgz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tpz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tpz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.txz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.txz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.vhd\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.vhd\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.vhdx\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.vhdx\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.wim\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.wim\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.xz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.xz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.z\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.z\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.zip\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.zip\shell\open" /ve /t REG_SZ /d ^"" /f

:: SetUserFTA
:: This code is blocked with parantheses because if it is not, it will not put everything on the proper lines
(
	echo .7z, 7-Zip.7z
	echo .zip, 7-Zip.zip
	echo .rar, 7-Zip.rar
	echo .001, 7-Zip.001
	echo .cab, 7-Zip.cab
	echo .iso, 7-Zip.iso
	echo .xz, 7-Zip.xz
	echo .txz, 7-Zip.txz
	echo .lzma, 7-Zip.lzma
	echo .tar, 7-Zip.tar
	echo .cpio, 7-Zip.cpio
	echo .bz2, 7-Zip.bz2
	echo .bzip2, 7-Zip.bzip2
	echo .tbz2, 7-Zip.tbz2
	echo .tbz, 7-Zip.tbz
	echo .gz, 7-Zip.gz
	echo .gzip, 7-Zip.gzip
	echo .tgz, 7-Zip.tgz
	echo .tpz, 7-Zip.tpz
	echo .z, 7-Zip.z
	echo .taz, 7-Zip.taz
	echo .lzh, 7-Zip.lzh
	echo .lha, 7-Zip.lha
	echo .rpm, 7-Zip.rpm
	echo .deb, 7-Zip.deb
	echo .arj, 7-Zip.arj
	echo .vhd, 7-Zip.vhd
	echo .wim, 7-Zip.wim
	echo .swm, 7-Zip.swm
	echo .esd, 7-Zip.esd
	echo .fat, 7-Zip.fat
	echo .ntfs, 7-Zip.ntfs
	echo .dmg, 7-Zip.dmg
	echo .hfs, 7-Zip.hfs
	echo .xar, 7-Zip.xar
	echo .squashfs, 7-Zip.squashfs
	echo .apfs, 7-Zip.apfs
) > assoc.txt
%WinDir%\NeptuneDir\Tools\SetUserFTA.exe "assoc.txt"
move "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\7-Zip\7-Zip File Manager.lnk" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\7-Zip"
setlocal EnableDelayedExpansion


if "%os%"=="Windows 10" (
cls & echo !S_YELLOW!Installing Open Shell... [17/18]
:: Disable windows search and start menu on Windows 10
"%WinDir%\NeptuneDir\Prerequisites\openshell.exe" /qn ADDLOCAL=StartMenu 

cls & echo !S_YELLOW!Configuring Open Shell
reg add "HKCU\Software\OpenShell\StartMenu" /v "ShowedStyle2" /t REG_DWORD /d "2" /f 
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "Version" /t REG_DWORD /d "67371150" /f 
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkipMetro" /t REG_DWORD /d "1" /f 
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "MenuStyle" /t REG_SZ /d "Win7" /f 
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "ProgramsMenuDelay" /t REG_DWORD /d "99999999" /f 
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "StartScreenShortcut" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkinW7" /t REG_SZ /d "" /f 
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkinVariationW7" /t REG_SZ /d "" /f 
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkinOptionsW7" /t REG_MULTI_SZ /d "USER_IMAGE=1\0SMALL_ICONS=1\0THICK_BORDER=0\0SOLID_SELECTION=0" /f 
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "MenuItems7" /t REG_MULTI_SZ /d "Item1.Command=user_files\0Item1.Settings=NOEXPAND\0Item2.Command=user_documents\0Item2.Settings=NOEXPAND\0Item3.Command=user_pictures\0Item3.Settings=NOEXPAND\0Item4.Command=user_music\0Item4.Settings=NOEXPAND\0Item5.Command=user_videos\0Item5.Settings=ITEM_DISABLED\0Item6.Command=downloads\0Item6.Settings=ITEM_DISABLED\0Item7.Command=homegroup\0Item7.Settings=ITEM_DISABLED\0Item8.Command=separator\0Item9.Command=games\0Item9.Settings=TRACK_RECENT|NOEXPAND|ITEM_DISABLED\0Item10.Command=favorites\0Item10.Settings=ITEM_DISABLED\0Item11.Command=computer\0Item11.Settings=NOEXPAND\0Item12.Command=downloads\0Item12.Settings=NOEXPAND\0Item13.Command=network\0Item13.Settings=ITEM_DISABLED\0Item14.Command=network_connections\0Item14.Settings=ITEM_DISABLED\0Item15.Command=separator\0Item16.Command=control_panel\0Item16.Settings=TRACK_RECENT|NOEXPAND\0Item17.Command=pc_settings\0Item17.Settings=TRACK_RECENT\0Item18.Command=admin\0Item18.Settings=TRACK_RECENT|ITEM_DISABLED\0Item19.Command=devmgmt.msc\0Item19.Label=Device Manager\0Item19.Icon=C:\Windows\system32\devmgr.dll, 201\0Item19.Settings=NOEXPAND\0Item20.Command=defaults\0Item20.Settings=ITEM_DISABLED\0Item21.Command=help\0Item21.Settings=ITEM_DISABLED\0Item22.Command=run\0Item23.Command=apps\0Item23.Settings=ITEM_DISABLED\0Item24.Command=windows_security\0Item24.Settings=ITEM_DISABLED" /f 
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "ShiftRight" /t REG_DWORD /d "1" /f 
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "RecentPrograms" /t REG_SZ /d "None" /f 
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchTrack" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchAutoComplete" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchInternet" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "MainMenuAnimate" /t REG_DWORD /d "0" /f 
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "FontSmoothing" /t REG_SZ /d "Default" /f 
move "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Open-Shell\Open-Shell Menu Settings.lnk" "%WinDir%\NeptuneDir\Neptune\3. Configuration\Start Menu" 
rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Open-Shell" 

:: Disable default start menu
cd C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy 
takeown /f "StartMenuExperienceHost.exe" 
icacls "C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\StartMenuExperienceHost.exe" /grant Administrators:F 
ren StartMenuExperienceHost.exe StartMenuExperienceHost.old 
taskkill /f /im searchapp.exe 
taskkill /f /im SearchHost.exe 
taskkill /f /im StartMenuExperienceHost.exe 
cd C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy 
takeown /f "searchapp.exe" 
icacls "C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\searchapp.exe" /grant Administrators:F 
ren searchapp.exe searchapp.old 
cd C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy 
icacls "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe" /grant Administrators:F 
takeown /f "SearchHost.exe" 
ren SearchHost.exe SearchHost.old 
taskkill /f /im TextInputHost.exe
takeown /f "TextInputHost.exe" 
icacls "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\TextInputHost.exe" /grant Administrators:F 
ren TextInputHost.exe TextInputHost.old 
)
goto PartingPhase


:PartingPhase
cls & echo !S_YELLOW!Finalizing Setup 
:: Set Lockscreen
Powershell -ExecutionPolicy Unrestricted "%WinDir%\NeptuneDir\Scripts\lockscreen.ps1"

:: Remove Start Menu Pins
copy /y "%WinDir%\Layout.xml" "%userProfile%\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml" 
%delF% "%userProfile%\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start.bin" 
%delF% "%userProfile%\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start2.bin" 

:: Set notice text
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticecaption" /t REG_SZ /d "Welcome to NeptuneOS %version%. A custom windows modification." /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticetext" /t REG_SZ /d "https://discord.gg/NeptuneOS" /f 

:: Set OEM Information
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "HelpCustomized" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Manufacturer" /t REG_SZ /d "@nyn9pm" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "SupportURL" /t REG_SZ /d "https://discord.gg/NeptuneOS" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Model" /t REG_SZ /d "NeptuneOS 0.5" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "SupportPhone" /t REG_SZ /d "Join our discord for support" /f 

:: Importing finalization script into RunOnce
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "Finalization" /t REG_SZ /d "%WinDir%\NeptuneDir\Scripts\FINAL.cmd" /f 

:: Move activate.cmd to %WinDir%
move "%WinDir%\NeptuneDir\Scripts\activate.cmd" "%WinDir%"

:: Delete neptune setup files
%delF% "%WinDir%\NeptuneDir\lockscreen.png" 
%delF% "%WinDir%\NeptuneDir\Scripts\CLIENTCBS.ps1" 
%delF% "%WinDir%\NeptuneDir\Scripts\FullscreenCMD.vbs" 
%delF% "%WinDir%\NeptuneDir\Scripts\lockscreen.ps1" 
%delF% "%WinDir%\NeptuneDir\Scripts\NGEN.ps1" 
%delF% "%WinDir%\NeptuneDir\Scripts\online-sxs.cmd" 
%delF% "%WinDir%\NeptuneDir\Scripts\RefreshEnv.cmd" 
%delF% "%WinDir%\NeptuneDir\user.png" 
%delF% "%WinDir%\NeptuneDir\Scripts\STARTMENU.CMD" 
rmdir /s /q "%WinDir%\NeptuneDir\Prerequisites" 
if "%server%"=="no" (rmdir /s /q "%WinDir%\NeptuneDir\Neptune\Server Configuration") 
if "%server%"=="yes" (rmdir /s /q "%WinDir%\NeptuneDir\Neptune\Optional\Windows 11") 
if "%os%"=="Windows 10" (rmdir /s /q "%WinDir%\NeptuneDir\Neptune\Optional\Windows 11") 
if "%os%"=="Windows 11" (rmdir /s /q "%WinDir%\NeptuneDir\Neptune\Optional\Windows 10") 
if exist "C:\NeptuneOS-installer-dev" (rmdir /s /q "C:\NeptuneOS-installer-dev" )
if exist "C:\NeptuneOS-installer" (rmdir /s /q "C:\NeptuneOS-installer" )
if exist "%userprofile%\Desktop\neptune-dev.cmd" (%delF% "%userprofile%\Desktop\neptune-dev.cmd")
if exist "%userprofile%\Desktop\neptune-installer.cmd" (%delF% "%userprofile%\Desktop\neptune-installer.cmd")

echo %time% %date% Finished neptune-master.cmd 
echo --------------------------------- 
cls & echo !S_RED!We're finished, rebooting in a moment.
timeout /t 4 /nobreak >nul
shutdown /f /r /t 0 & del "%~f0"
exit /b

:::::::::::::::::::::::
::: Batch Functions :::
:::::::::::::::::::::::

:setSvc
:: %svc% (service name) (0-4)
if "%1"=="" (
echo You need to run this with a service to disable.
echo You need to run this with an argument ^(1-4^) to configure the service's startup.
exit /b 1
)
if "%2"=="" (
echo You need to run this with an argument ^(1-4^) to configure the service's startup.
exit /b 1 )
if %2 LSS 0 (
echo Invalid configuration.
exit /b 1 )
if %2 GTR 4 (
echo Invalid configuration.
exit /b 1 )
Reg query "HKLM\System\CurrentControlSet\Services\%1" >nul || (
echo The specified service/driver %1 is not found. 
exit /b 1 )
reg add "HKLM\System\CurrentControlSet\Services\%1" /v "Start" /t Reg_DWORD /d "%2" /f 
echo Service/Driver %1 was configured