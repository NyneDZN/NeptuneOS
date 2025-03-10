:: Created for NeptuneOS by Nyne (https://twitter.com/nynedzn)
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

@echo off && setlocal EnableDelayedExpansion

:: NeptuneOS Variables
set version=0.5

:: Window Title
title "NeptuneOS Installation %version% | By Nyne"

:: Check if this is a development build or not
if /i "%~2"=="/devbuild"   set "devbuild=yes"

:: Batch Variables
set "PowerShell=%WinDir%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProf -NonI -NoL -EP Bypass -C"
set currentuser=%WinDir%\NeptuneDir\Tools\NSudoLG.exe -U:C -P:E -ShowWindowMode:Hide -Wait
set system=%WinDir%\NeptuneDir\Tools\NSudoLG.exe -U:T -P:E -ShowWindowMode:Hide -Wait
set DevMan="%WinDir%\NeptuneDir\Tools\dmv.exe"
set svc=call :setSvc
set delf=del /f /s /q

:: Fetch ANSI
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul

:: Fullsceen Script
%currentuser% "%WinDir%\System32\cscript.exe" //nologo "%WinDir%\NeptuneDir\Scripts\FullScreenCMD.vbs"

:: Create Log Files (neptune.txt, user.txt)
echo This log is completely local and is not uploaded anywhere. >> %neptlog%
echo --------------------------------------------------------- >> %neptlog%
echo %time% %date% Started neptune-master.cmd. >> %neptlog%
echo This log is completely local and is not uploaded anywhere. >> %userlog%
echo --------------------------------------------------------- >> %userlog%

:: Fetch PC Type
for /f "delims=:{}" %%a in ('wmic path Win32_SystemEnclosure get ChassisTypes ^| findstr [0-9]') do set "CHASSIS=%%a"
set "DEVICE_TYPE=PC"
for %%a in (8 9 10 11 12 13 14 18 21 30 31 32) do if "%CHASSIS%" == "%%a" (set "DEVICE_TYPE=LAPTOP")

:: Fetch User SID
for /f "tokens=2 delims==" %%A in ('wmic useraccount where "name='%username%'" get sid /value') do (set "SID=%%A")

:: Fetch RAM amount
for /f "skip=1" %%i in ('wmic os get TotalVisibleMemorySize') do if not defined TOTAL_MEMORY set "TOTAL_MEMORY=%%i"

:: Fetch Disk Type
for /f %%a in ('PowerShell -NoP -C "(Get-PhysicalDisk -SerialNumber (Get-Disk -Number (Get-Partition -DriveLetter $env:SystemDrive.Substring(0, 1)).DiskNumber).SerialNumber.TrimStart()).MediaType"') do (set "diskDrive=%%a")
  
:: Fetch GPU
:: Basic one liner for now that will assume you have a RADEON GPU if NVIDIA is not found
for /f "tokens=2 delims==" %%a in ('wmic path Win32_VideoController get VideoProcessor /value ^| findstr /i "GeForce NVIDIA RTX GTX Radeon AMD"') do (echo %%a | findstr /i "GeForce NVIDIA RTX GTX" >nul && set GPU=NVIDIA || set GPU=RADEON)

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
:: if /i "%~1"=="/RegistryConfigruation"   goto RegistryConfiguration
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
taskkill /f /im explorer.exe >> %neptlog%

:: echo to user
echo !S_YELLOW!Beginning NeptuneOS !S_RED!%version% !S_YELLOW!Installation.
echo]
echo !S_YELLOW!Please ignore any errors you may see in this script, and report any issues to our Discord Server, or GitHub.
timeout /t 7 /nobreak >nul

:: ngen, from atlas
Powershell -ExecutionPolicy Unrestricted "C:\Windows\NeptuneDir\Scripts\NGEN.ps1"

cls & echo !S_YELLOW!Configuring NTP Server [1/18]
:: change ntp server from windows server to pool.ntp.org
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org" >> %neptlog%

:: resync time to pool.ntp.org
sc config w32time start=auto >> %neptlog%
%svc% W32Time 2 >> %neptlog%
net start w32time >> %neptlog%
w32tm /config /update >> %neptlog%
w32tm /resync >> %neptlog%
%svc% W32Time 4 >> %neptlog%
goto PowerConfiguration


:PowerConfiguration
cls & echo !S_YELLOW!Configuring Powerplan [2/18]
:: Unhide Hidden Power Configuration
:: source: https://gist.github.com/Velocet/7ded4cd2f7e8c5fa475b8043b76561b5#file-unlock-powercfg-ps1
PowerShell -ExecutionPolicy Unrestricted -Command  "$PowerCfg = (Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings' -Recurse).Name -notmatch '\bDefaultPowerSchemeValues|(\\[0-9]|\b255)$';foreach ($item in $PowerCfg) { Set-ItemProperty -Path $item.Replace('HKEY_LOCAL_MACHINE','HKLM:') -Name 'Attributes' -Value 0 -Force}" >> %neptlog%

:: Import Ultimate Powerplan and Rename
powercfg -import "%WinDir%\NeptuneDir\Prerequisites\power.pow" 11111111-1111-1111-1111-111111111111 >> %neptlog%
powercfg -setactive 11111111-1111-1111-1111-111111111111 >> %neptlog%
powercfg -changename 11111111-1111-1111-1111-111111111111 "NeptuneOS Powerplan 4.0." "A powerplan created to achieve low latency and high 0.01% lows." >> %neptlog%
:: Remove Stock Powerplans
powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a >> %neptlog%
powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e >> %neptlog%
powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >> %neptlog%
powercfg -delete e9a42b02-d5df-448d-aa00-03f14749eb61 >> %neptlog%

:: -  Hard Disk & NVMe Settings
:: Turn off hard disk after 0 seconds
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0 >> %neptlog%
:: Turn off secondary NVMe idle timeout
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 0012ee47-9041-4b5d-9b77-535fba8b1442 d3d55efd-c1ff-424e-9dc3-441be7833010 0 >> %neptlog%
:: Turn off primary NVMe idle timeout
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 0012ee47-9041-4b5d-9b77-535fba8b1442 d639518a-e56d-4345-8af2-b9f32fb26109 0 >> %neptlog%
:: Turn off NVMe noppme
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 0012ee47-9041-4b5d-9b77-535fba8b1442 fc7372b6-ab2d-43ee-8797-15e9841f2cca 0 >> %neptlog%

:: -  USB and Sleep Settings
:: Disable hub selective suspend timeout
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 2a737441-1930-4402-8d77-b2bebba308a3 0853a681-27c8-4100-a2fd-82013e970683 0 >> %neptlog%
:: Disable USB selective suspend setting
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >> %neptlog%
:: Set USB 3 link power management to maximum performance
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0 >> %neptlog%
:: Disable deep sleep
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 2e601130-5351-4d9d-8e04-252966bad054 d502f7ee-1dc7-4efd-a55d-f04b6f5c0545 0 >> %neptlog%
:: Disable away mode policy
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 0 >> %neptlog%
powercfg -setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 0 >> %neptlog%
:: Disable idle states
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0 >> %neptlog%
powercfg -setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0 >> %neptlog%
:: Disable hybrid sleep
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0 >> %neptlog%
powercfg -setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0 >> %neptlog%
:: Turn off system unattended sleep timeout
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 0 >> %neptlog%
:: Disable allow wake timers
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0 >> %neptlog%

:: -  Display and Battery Settings
:: Turn off display after 0 seconds
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0 >> %neptlog%
:: Disable critical battery notification
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 e73a048d-bf27-4f12-9731-8b2076e8891f 5dbb7c9f-38e9-40d2-9749-4f8a0e9f640f 0 >> %neptlog%
:: Disable critical battery action
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 e73a048d-bf27-4f12-9731-8b2076e8891f 637ea02f-bbcb-4015-8e2c-a1c7b9c0b546 0 >> %neptlog%
:: Set low battery level to 0
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 e73a048d-bf27-4f12-9731-8b2076e8891f 8183ba9a-e910-48da-8769-14ae6dc1170a 0 >> %neptlog%
:: Set critical battery level to 0
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 e73a048d-bf27-4f12-9731-8b2076e8891f 9a66d8d7-4ff7-4ef9-b5a2-5a326ca2a469 0 >> %neptlog%
:: Disable low battery notification
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 e73a048d-bf27-4f12-9731-8b2076e8891f bcded951-187b-4d05-bccc-f7e51960c258 0 >> %neptlog%
:: Set reserve battery level to 0
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 e73a048d-bf27-4f12-9731-8b2076e8891f f3c5027d-cd16-4930-aa6b-90db844a8f00 0 >> %neptlog%

:: - Processor and Performance Settings
:: Set processor states
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor PROCTHROTTLEMIN 100 >> %neptlog%
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor PROCTHROTTLEMAX 100 >> %neptlog%
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor 06cadf0e-64ed-448a-8927-ce7bf90eb35d 1 >> %neptlog%
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 1 >> %neptlog%
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor 7b224883-b3cc-4d79-819f-8374152cbe7c 100 >> %neptlog%
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor 4b92d758-5a24-4851-a470-815d78aee119 100 >> %neptlog%
:: Enable Turbo Boost
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor PERFBOOSTMODE 2 >> %neptlog%
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor PERFBOOSTPOL 100 >> %neptlog%
:: Prefer Performant Processors
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor SHORTSCHEDPOLICY 2 >> %neptlog%
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor SCHEDPOLICY 2 >> %neptlog%
:: Processor performance time check interval - 200 miliseconds
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 54533251-82be-4824-96c1-47b60b740d00 4d2b0152-7d5c-498b-88e2-34345392a2c5 200 >> %neptlog%
:: Allow Throttle States to Off
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 54533251-82be-4824-96c1-47b60b740d00 3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb 0 >> %neptlog%

:: - Miscellaneous
:: Set slideshow to paused
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 0d7dbae2-4294-402a-ba8e-26777e8488cd 309dce9b-bef4-4119-9921-a851fb12f0f4 1 >> %neptlog%
:: Disable hibernation
powercfg -h off >> %neptlog%

:: Set NeptuneOS Scheme as Current
powercfg -setactive scheme_current >> %neptlog%

:: Disable Sleep Study
wevtutil set-log "Microsoft-Windows-SleepStudy/Diagnostic" /e:false >> %neptlog%
wevtutil set-log "Microsoft-Windows-Kernel-Processor-Power/Diagnostic" /e:false >> %neptlog%
wevtutil set-log "Microsoft-Windows-UserModePowerService/Diagnostic" /e:false >> %neptlog%


cls & echo !S_YELLOW!Disabling PowerSaving [3/18]
:: Most of this section is forked from AtlasOS
if "!DEVICE_TYPE!"=="PC" (
	PowerShell -NoP -C "$usb_devices = @('Win32_USBController', 'Win32_USBControllerDevice', 'Win32_USBHub'); $power_device_enable = Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi; foreach ($power_device in $power_device_enable){$instance_name = $power_device.InstanceName.ToUpper(); foreach ($device in $usb_devices){foreach ($hub in Get-WmiObject $device){$pnp_id = $hub.PNPDeviceID; if ($instance_name -like \"*$pnp_id*\"){$power_device.enable = $False; $power_device.psbase.put()}}}}" >> %neptlog%

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
            reg add "%%b" /v "%%~a" /t REG_DWORD /d "0" /f >> %neptlog%
        )
    )

	:: Disable Storage Powersaving
	Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Storage" /v "StorageD3InModernStandby" /t REG_DWORD /d "0" /f >> %neptlog%

    ::  Disable IdlePowerMode for stornvme.sys 
    Reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters\Device" /v "IdlePowerMode" /t REG_DWORD /d "0" /f >> %neptlog%

	:: - > Disable Energy Estimation
	Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f >> %neptlog%

	:: - > Disable Connected Standby
	Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
	Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f >> %neptlog%

    :: Disable power throttling
    :: https://blogs.windows.com/windows-insider/2017/04/18/introducing-power-throttling
    Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f >> %neptlog%

	:: Disable Timer Coalescing
	Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >> %neptlog%
	Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >> %neptlog%

	:: Disable ACPI C-States
	:: https://learn.microsoft.com/sl-SI/troubleshoot/windows-server/virtualization/virtual-machines-slow-startup-shutdown
	Reg add "HKLM\System\CurrentControlSet\Control\Processor" /v "Capabilities" /t REG_DWORD /d "0x0007e066" /f >> %neptlog%
 

	:: Disable Advanced Configuration Power Interfaces
	%DevMan% /disable "ACPI Processor Aggregator" 
	%DevMan% /disable "Microsoft Windows Management Interface for ACPI" 
)


:: Disable Powersaving on Network Adapter
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" /v "DefaultPnPCapabilities" /t REG_DWORD /d "24" /f >> %neptlog%
goto NTFSConfiguration


:NTFSConfiguration
cls & echo !S_YELLOW!Configuring NTFS [4/18]
:: Configuring the NTFS file system in Windows

:: Adjust MFT (master file table) and paged pool memory cache levels according to ram size
:: if !TOTAL_MEMORY! LSS 8000000 (
:: FSUTIL behavior set memoryusage 1 >> %neptlog%
:: FSUTIL behavior set mftzone 1 >> %neptlog%
:: ) else if !TOTAL_MEMORY! LSS 16000000 (
:: FSUTIL behavior set memoryusage 1 >> %neptlog%
:: FSUTIL behavior set mftzone 2 >> %neptlog%
:: ) else (
:: FSUTIL behavior set memoryusage 2 >> %neptlog%
:: FSUTIL behavior set mftzone 2 >> %neptlog%
:: )

:: Disallows characters from the extended character set to be used in 8.3 character-length short file names
FSUTIL behavior set allowextchar 0 >> %neptlog%
:: Disallow generation of a bug check
FSUTIL behavior set bugcheckoncorrupt 0 >> %neptlog%
:: Disable 8.3 File Creation
:: https://ttcshelbyville.wordpress.com/2018/12/02/should-you-disable-8dot3-for-performance-and-security
FSUTIL behavior set disable8dot3 1 >> %neptlog%
:: Disable NTFS File Compression
FSUTIL behavior set disablecompression 1 >> %neptlog%
:: Disable NTFS File Encryption
:: Commented out because this disables XBOX downloads
:: FSUTIL behavior set disableencryption 1 >> %neptlog%
:: Disable Last Accessed Timestamp
FSUTIL behavior set disablelastaccess 1 >> %neptlog%
FSUTIL behavior set disablespotcorruptionhandling 1 >> %neptlog%
:: Enable Trimming for SSD's
FSUTIL behavior set disabledeletenotify 0 >> %neptlog%
:: Disable paging file encryption
FSUTIL behavior set encryptpagingfile 0 >> %neptlog%
FSUTIL behavior set quotanotify 86400 >> %neptlog%
FSUTIL behavior set symlinkevaluation L2L:1 >> %neptlog%
:: Disable self repair on boot drive
FSUTIL repair set C: 0 >> %neptlog%

:: Disable Write Cache Buffer
for /f "tokens=*" %%i in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI"^| findstr "HKEY"') do (
for /f "tokens=*" %%a in ('Reg query "%%i"^| findstr "HKEY"') do Reg add "%%a\Device Parameters\Disk" /v "CacheIsPowerProtected" /t Reg_DWORD /d "1" /f >> %neptlog%
)
for /f "tokens=*" %%i in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI"^| findstr "HKEY"') do (
for /f "tokens=*" %%a in ('Reg query "%%i"^| findstr "HKEY"') do Reg add "%%a\Device Parameters\Disk" /v "UserWriteCacheSetting" /t Reg_DWORD /d "1" /f >> %neptlog%
)
)

:: Disable HIPM, DIPM, and HDD parking
FOR /F "eol=E" %%a in ('Reg QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "EnableHIPM"^| FINDSTR /V "EnableHIPM"') DO (
Reg add "%%a" /F /V "EnableHIPM" /T Reg_DWORD /d 0 >> %neptlog%
Reg add "%%a" /F /V "EnableDIPM" /T Reg_DWORD /d 0 >> %neptlog%
Reg add "%%a" /F /V "EnableHDDParking" /T Reg_DWORD /d 0 >> %neptlog%
)

:: IOLATENCYCAP to 0
FOR /F "eol=E" %%a in ('Reg QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "IoLatencyCap"^| FINDSTR /V "IoLatencyCap"') DO (
Reg add "%%a" /F /V "IoLatencyCap" /T Reg_DWORD /d 0 >> %neptlog%
)

:: Set Drive Label
label C: NeptuneOS >> %neptlog%

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
%system% schtasks.exe /change /disable /TN %%a >> %neptlog%
)

:: Enable Storage Sense
schtasks /change /enable /TN "\Microsoft\Windows\DiskCleanup\SilentCleanup" >> %neptlog%

:: Disable OneDrive Tasks
PowerShell -ExecutionPolicy Unrestricted -Command "$taskPathPattern='\'; $taskNamePattern='OneDrive Reporting Task-*'; Write-Output "^""Disabling tasks matching pattern `"^""$taskNamePattern`"^""."^""; $tasks = @(Get-ScheduledTask -TaskPath $taskPathPattern -TaskName $taskNamePattern -ErrorAction Ignore); if (-Not $tasks) {; Write-Output "^""Skipping, no tasks matching pattern `"^""$taskNamePattern`"^"" found, no action needed."^""; exit 0; }; $operationFailed = $false; foreach ($task in $tasks) {; $taskName = $task.TaskName; if ($task.State -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.ScheduledTask.StateEnum]::Disabled) {; Write-Output "^""Skipping, task `"^""$taskName`"^"" is already disabled, no action needed."^""; continue; }; try {; $task | Disable-ScheduledTask -ErrorAction Stop | Out-Null; Write-Output "^""Successfully disabled task `"^""$taskName`"^""."^""; } catch {; Write-Error "^""Failed to disable task `"^""$taskName`"^"": $($_.Exception.Message)"^""; $operationFailed = $true; }; }; if ($operationFailed) {; Write-Output 'Failed to disable some tasks. Check error messages above.'; exit 1; }" >> %neptlog%
PowerShell -ExecutionPolicy Unrestricted -Command "$taskPathPattern='\'; $taskNamePattern='OneDrive Standalone Update Task-*'; Write-Output "^""Disabling tasks matching pattern `"^""$taskNamePattern`"^""."^""; $tasks = @(Get-ScheduledTask -TaskPath $taskPathPattern -TaskName $taskNamePattern -ErrorAction Ignore); if (-Not $tasks) {; Write-Output "^""Skipping, no tasks matching pattern `"^""$taskNamePattern`"^"" found, no action needed."^""; exit 0; }; $operationFailed = $false; foreach ($task in $tasks) {; $taskName = $task.TaskName; if ($task.State -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.ScheduledTask.StateEnum]::Disabled) {; Write-Output "^""Skipping, task `"^""$taskName`"^"" is already disabled, no action needed."^""; continue; }; try {; $task | Disable-ScheduledTask -ErrorAction Stop | Out-Null; Write-Output "^""Successfully disabled task `"^""$taskName`"^""."^""; } catch {; Write-Error "^""Failed to disable task `"^""$taskName`"^"": $($_.Exception.Message)"^""; $operationFailed = $true; }; }; if ($operationFailed) {; Write-Output 'Failed to disable some tasks. Check error messages above.'; exit 1; }" >> %neptlog%
PowerShell -ExecutionPolicy Unrestricted -Command "$taskPathPattern='\'; $taskNamePattern='OneDrive Per-Machine Standalone Update'; Write-Output "^""Disabling tasks matching pattern `"^""$taskNamePattern`"^""."^""; $tasks = @(Get-ScheduledTask -TaskPath $taskPathPattern -TaskName $taskNamePattern -ErrorAction Ignore); if (-Not $tasks) {; Write-Output "^""Skipping, no tasks matching pattern `"^""$taskNamePattern`"^"" found, no action needed."^""; exit 0; }; $operationFailed = $false; foreach ($task in $tasks) {; $taskName = $task.TaskName; if ($task.State -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.ScheduledTask.StateEnum]::Disabled) {; Write-Output "^""Skipping, task `"^""$taskName`"^"" is already disabled, no action needed."^""; continue; }; try {; $task | Disable-ScheduledTask -ErrorAction Stop | Out-Null; Write-Output "^""Successfully disabled task `"^""$taskName`"^""."^""; } catch {; Write-Error "^""Failed to disable task `"^""$taskName`"^"": $($_.Exception.Message)"^""; $operationFailed = $true; }; }; if ($operationFailed) {; Write-Output 'Failed to disable some tasks. Check error messages above.'; exit 1; }" >> %neptlog%
goto BCDConfiguration


:: Configuring the Boot Configuration Data in Windows
:BCDConfiguration
cls & echo !S_YELLOW!Configuring BCDEdit [6/16]

:: Enable the Legacy Boot Menu
bcdedit /set bootmenupolicy legacy >> %neptlog%
:: Disable Hyper-V
bcdedit /set hypervisorlaunchtype off >> %neptlog%
:: Disable Automatic Drive Repair
bcdedit /set {current} recoveryenabled no >> %neptlog%
:: Set Boot Label
bcdedit /set {current} description "NeptuneOS %version%" >> %neptlog%
:: Disable Laptop Powersaving
bcdedit /set disabledynamictick yes >> %neptlog%
:: Use Synthetic Timers
bcdedit /set useplatformtick yes >> %neptlog%
:: Disable HPET
:: This isn't even set by default in windows, commented out.
:: bcdedit /deletevalue useplatformclock >> %neptlog%
:: 15 Second Timeout
bcdedit /timeout 15 >> %neptlog%
:: Disable Emergency Management Services
:: bcdedit /set ems no >> %neptlog%
:: bcdedit /set bootems no >> %neptlog%
:: Disable Kernel Debugging
:: Unable to disable with secure boot enabled
:: bcdedit /set debug no >> %neptlog%
:: Stop using uncontiguous portions of low-memory
:: https://sites.google.com/view/melodystweaks/basictweaks
:: bcdedit /set firstmegabytepolicy useall >> %neptlog%
:: bcdedit /set avoidlowmemory 0x8000000 >> %neptlog%
:: bcdedit /set nolowmem yes >> %neptlog%
:: Enable X2Apic
bcdedit /set x2apicpolicy enable >> %neptlog%
bcdedit /set uselegacyapicmode no >> %neptlog%
:: Enable Legacy TSCSyncPolicy
:: bcdedit /set tscsyncpolicy enhanced >> %neptlog%
:: Linear Address 57
:: https://en.wikipedia.org/wiki/Intel_5-level_paging
bcdedit /set linearaddress57 OptOut >> %neptlog%
bcdedit /set increaseuserva 268435328 >> %neptlog%
goto DevConfiguration


:: Configuring devices in Windows
:DevConfiguration
cls & echo !S_YELLOW!Configuring Devices and MSI Mode [7/18]

:: Device Manager
:: - > System Devices
%DevMan% /disable "ACPI Wake Alarm" >> %neptlog%
%DevMan% /disable "Composite Bus Enumerator" >> %neptlog%
%DevMan% /disable "Direct memory access controller" >> %neptlog%
%DevMan% /disable "High precision event timer" >> %neptlog%
%DevMan% /disable "Legacy device" >> %neptlog%
%DevMan% /disable "Microsoft GS Wavetable Synth" >> %neptlog%
%DevMan% /disable "Microsoft Kernel Debug Network Adapter" >> %neptlog%
%DevMan% /disable "Motherboard resources" >> %neptlog%
%DevMan% /disable "Numeric data processor" >> %neptlog%
%DevMan% /disable "PCI Data Acquisition and Signal Processing Controller" >> %neptlog%
%DevMan% /disable "PCI Device" >> %neptlog%
%DevMan% /disable "PCI Memory Controller" >> %neptlog%
%DevMan% /disable "PCI Simple Communications Controller" >> %neptlog%
%DevMan% /disable "PCI Simple Communications Controller" >> %neptlog%
%DevMan% /disable "PCI standard RAM Controller" >> %neptlog%
%DevMan% /disable "Programmable interrupt controller" >> %neptlog%
%DevMan% /disable "SM Bus Controller"
%DevMan% /disable "System board" >> %neptlog%
%DevMan% /disable "System CMOS/real time clock" >> %neptlog%
%DevMan% /disable "System Speaker" >> %neptlog%
%DevMan% /disable "System Timer" >> %neptlog%
%DevMan% /disable "UMBus Root Bus Enumerator" >> %neptlog%
%DevMan% /disable "Unknown device" >> %neptlog%

:: Hyper-V
%DevMan% /disable "Microsoft Hyper-V Virtualization Infrastructure Driver" >> %neptlog%
%DevMan% /disable "Remote Desktop Device Redirector Bus" >> %neptlog%

:: VPN Devices
%DevMan% /disable "Microsoft RRAS Root Enumerator" >> %neptlog%
%DevMan% /disable "NDIS Virtual Network Adapter Enumerator" >> %neptlog%
%DevMan% /disable "WAN Miniport (IKEv2)" >> %neptlog%
%DevMan% /disable "WAN Miniport (IP)" >> %neptlog%
%DevMan% /disable "WAN Miniport (IPv6)" >> %neptlog%
%DevMan% /disable "WAN Miniport (L2TP)" >> %neptlog%
%DevMan% /disable "WAN Miniport (Network Monitor)" >> %neptlog%
%DevMan% /disable "WAN Miniport (PPPOE)" >> %neptlog%
%DevMan% /disable "WAN Miniport (PPTP)" >> %neptlog%
%DevMan% /disable "WAN Miniport (SSTP)" >> %neptlog%

:: TPM Devices
if "%os%"=="Windows 10" (%DevMan% /disable "AMD PSP 10.0 Device" & %DevMan% /disable "Trusted Platform Module 2.0")

:: Enable MSI mode on USB, GPU, Audio, SATA controllers, disk drives and network adapters
:: Deleting DevicePriority sets the priority to undefined
for %%a in ("CIM_NetworkAdapter", "CIM_USBController", "CIM_VideoController" "Win32_IDEController", "Win32_PnPEntity", "Win32_SoundDevice") do (
    if "%%~a" == "Win32_PnPEntity" (
        for /f "tokens=*" %%b in ('PowerShell -NoP -C "Get-WmiObject -Class Win32_PnPEntity | Where-Object {($_.PNPClass -eq 'SCSIAdapter') -or ($_.Caption -like '*High Definition Audio*')} | Where-Object { $_.PNPDeviceID -like 'PCI\VEN_*' } | Select-Object -ExpandProperty DeviceID"') do (
            reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%b\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f >> %neptlog%
            reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%b\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >> %neptlog%
        )
    ) else (
        for /f %%b in ('wmic path %%a get PNPDeviceID ^| findstr /l "PCI\VEN_"') do (
            reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%b\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f >> %neptlog%
            reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%b\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >> %neptlog%
        )
    )
)

:: If a virtual machine is used, set network adapter to normal priority as Undefined may break internet connection
for %%a in ("hvm", "hyper", "innotek", "kvm", "parallel", "qemu", "virtual", "xen", "vmware") do (
    wmic computersystem get manufacturer /format:value | findstr /i /c:%%~a && (
        for /f %%b in ('wmic path CIM_NetworkAdapter get PNPDeviceID ^| findstr /l "PCI\VEN_"') do (
            reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%b\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "2" /f >> %neptlog%
        )
    )
)

goto NetworkConfiguration


:: Configuring network settings and the NIC adapter in Windows
:NetworkConfiguration
cls & echo !S_YELLOW!Configuring Network Settings [8/18]

:: Network Shell
:: Reset the Network Configuration
ipconfig /release >> %neptlog%
ipconfig /renew >> %neptlog%
ipconfig /flushdns >> %neptlog%
netsh int ip reset >> %neptlog%
netsh int ipv4 reset >> %neptlog%
netsh int ipv6 reset >> %neptlog%
netsh int tcp reset >> %neptlog%
netsh winsock reset >> %neptlog%
netsh advfirewall reset >> %neptlog%
netsh branchcache reset >> %neptlog%
netsh http flush logbuffer >> %neptlog%
:: - > Disable IPV6
:: IPV6 is disabled through regedit, so I'm commenting this out so it doesn't cause unforseen issues.
:: netsh int 6to4 set state disabled >> %neptlog%
:: netsh int IPV6 set global randomizeidentifier=disabled >> %neptlog%
:: netsh int IPV6 set privacy state=disable >> %neptlog%
:: netsh int IPV6 6to4 set state state=disabled >> %neptlog%
:: netsh int IPV6 isatap set state state=disabled >> %neptlog%
:: netsh int IPV6 set teredo disable
:: - > Increase TTL (Time to Live)
:: https://packetpushers.net/ip-time-to-live-and-hop-limit-basics/
netsh int ip set global defaultcurhoplimit=255 >> %neptlog%
:: - > Disable Media Sense
netsh int ip set global dhcpmediasense=disabled >> %neptlog%
netsh int ip set global neighborcachelimit=4096 >> %neptlog%
:: - > Enable Task Offloading
netsh int ip set global taskoffload=enabled >> %neptlog%
:: netsh int ip set interface "Ethernet" metric=60 >> %neptlog%
:: - > Set MTU (maximum transmission unit)
netsh int ipv4 set subinterface "Ethernet" mtu=1500 store=persistent >> %neptlog%
netsh int ipv4 set subinterface "Wi-Fi" mtu=1500 store=persistent >> %neptlog%
:: - > Set AutoTuningLevel
:: https://www.majorgeeks.com/content/page/what_is_windows_auto_tuning.html
netsh int tcp set global autotuninglevel=normal >> %neptlog%
netsh int tcp set global chimney=disabled >> %neptlog%
:: - > Set Congestion Provider to CTCP (Client to Client Protocol)
:: - > CTCP Provides better throughput and latency for gaming
:: https://www.speedguide.net/articles/tcp-congestion-control-algorithms-comparison-7423
netsh int tcp set global congestionprovider=ctcp >> %neptlog%
:: - > Set Congestion Provider to BBR2 on Windows 11
if "%os%"=="Windows 11" (
netsh int tcp set supplemental Template=Internet CongestionProvider=bbr2 >> %neptlog%
netsh int tcp set supplemental Template=Datacenter CongestionProvider=bbr2 >> %neptlog%
netsh int tcp set supplemental Template=Compat CongestionProvider=bbr2 >> %neptlog%
netsh int tcp set supplemental Template=DatacenterCustom CongestionProvider=bbr2 >> %neptlog%
netsh int tcp set supplemental Template=InternetCustom CongestionProvider=bbr2 >> %neptlog%
)
:: - > Enable Direct Cache Access
:: - > This will have a bigger impact on older CPU's
netsh int tcp set global dca=enabled >> %neptlog%
:: - > Disable Explicit Congestion Notification
:: https://en.wikipedia.org/wiki/Explicit_Congestion_Notification
:: https://www.bufferbloat.net/projects/cerowrt/wiki/Enable_ECN/#:~:text=Enabling%20ECN%20does%20not%20much,already%2C%20but%20few%20clients%20do.
netsh int tcp set global ecncapability=disabled >> %neptlog%
:: - > Enable TCP Fast Open
:: https://en.wikipedia.org/wiki/TCP_Fast_Open
netsh int tcp set global fastopen=enabled >> %neptlog%
:: - > Set the TCP Retransmission Timer
:: https://www.speedguide.net/faq/how-does-tcpinitialrtt-or-initialrto-affect-tcp-498
netsh int tcp set global initialRto=3000 >> %neptlog%
:: - > Set Max SYN Retransmissions to the lowest value
:: https://medium.com/@avocadi/tcp-syn-retries-f30756ec7c55
netsh int tcp set global maxsynretransmissions=2 >> %neptlog%
netsh int tcp set global netdma=enabled >> %neptlog%
:: - > Disable Non Sack RTT Resiliency
:: - > If you have fluctuating ping and packet loss, enabling this might benefit
:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
netsh int tcp set global nonsackrttresiliency=disabled >> %neptlog%
:: - > Disable Receive Segment Coalescing State
:: - > Enabling this may provide higher throughput when lower CPU utilization is important
:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
netsh int tcp set global rsc=disabled >> %neptlog%
:: - > Enable Receive Side Scaling
:: - > This allows multiple cores to process incoming packets, improving network performance
:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
netsh int tcp set global rss=enabled >> %neptlog%
:: - > Disable TCP 1323 Timestamps
:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
netsh int tcp set global timestamps=disabled >> %neptlog%
:: - > Disable Scaling Heuristics
netsh int tcp set heuristics disabled >> %neptlog%
:: - > Set Max Port Ranges
netsh int ipv4 set dynamicport udp start=1025 num=64511 >> %neptlog%
netsh int ipv4 set dynamicport tcp start=1025 num=64511 >> %neptlog%
:: - > Disable Memory Pressure Protection
:: - > This is a network security feature that will kill malicious TCP connections and SYN requests with no sort of performance or stability loss.
:: https://support.microsoft.com/en-us/topic/description-of-the-new-memory-pressure-protection-feature-for-tcp-stack-749c1746-ba10-ec18-d61a-bbdabbc403fc
:: netsh int tcp set security mpp=disabled >> %neptlog%
:: netsh int tcp set security profiles=disabled >> %neptlog%
netsh int tcp set supplemental Internet congestionprovider=ctcp >> %neptlog%
netsh int tcp set supplemental template=custom icw=10 >> %neptlog%
:: - > Disable Teredo
netsh int teredo set state disabled >> %neptlog%


:: Disable Bandwith Preservation
Reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t Reg_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t Reg_DWORD /d "00000000" /f >> %neptlog%

:: Disable Network Level Authentication
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t Reg_SZ /d "1" /f >> %neptlog%

:: Disable DHCP MediaSense
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v " DisableDHCPMediaSense" /t REG_DWORD /d "1" /f >> %neptlog%

:: No TCP Connection Limit
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxConnectionsPerServer" /t Reg_DWORD /d "0" /f >> %neptlog%

:: Set Max Port to 65534
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t Reg_DWORD /d "65534" /f >> %neptlog%

:: Reduce Time_Wait
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t Reg_DWORD /d "32" /f >> %neptlog%

:: Reduce TTL (Time to Live)
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t Reg_DWORD /d "64" /f >> %neptlog%

:: Duplicate ACKS
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t Reg_DWORD /d "2" /f >> %neptlog%

:: Disable Sacks
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t Reg_DWORD /d "0" /f >> %neptlog%

:: Disable Multicast
Reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t Reg_DWORD /d "0" /f >> %neptlog%

:: Disable TCP Extensions
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t Reg_DWORD /d "0" /f >> %neptlog%

:: Disable Smart Name Resolution
:: This may cause DNS leaks
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "DisableParallelAandAAAA" /t REG_DWORD /d 1 /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v "DisableSmartNameResolution" /t REG_DWORD /d 1 /f >> %neptlog%

:: Allow ICMP redirects to override OSPF generated routes
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableICMPRedirect" /t Reg_DWORD /d "1" /f >> %neptlog%

:: TCP Window Size
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t Reg_DWORD /d "8760" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpWindowSize" /t Reg_DWORD /d "8760" /f >> %neptlog%

:: Disable Network Discovery
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" /f >> %neptlog%

:: Enable DNS > HTTPS
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableAutoDoh" /t Reg_DWORD /d "2" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t Reg_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeSOACacheTime" /t Reg_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NetFailureCacheTime" /t Reg_DWORD /d "0" /f >> %neptlog%

:: Disable LLMNR
Reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t Reg_DWORD /d "0" /f >> %neptlog%

:: Disable Administrative Shares
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "AutoShareWks" /t Reg_DWORD /d "0" /f >> %neptlog%

:: Enable Network Offloading
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableTaskOffload" /t Reg_DWORD /d "0" /f >> %neptlog%

:: Disable the TCP Autotuning Diagnostic Tool
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableWsd" /t Reg_DWORD /d "0" /f >> %neptlog%

:: Host Resolution Priority
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t Reg_DWORD /d "6" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t Reg_DWORD /d "5" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t Reg_DWORD /d "4" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t Reg_DWORD /d "7" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "Class" /t Reg_DWORD /d "8" /f >> %neptlog%

:: TCP Congestion Control/Avoidance Algorithm
Reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "0200" /t Reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f >> %neptlog%
Reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "1700" /t Reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f >> %neptlog%

:: Detect Congestion Failure
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPCongestionControl" /t Reg_DWORD /d "00000001" /f >> %neptlog%

:: Disable SYN-DOS Protection
:: Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SynAttackProtect" /t Reg_DWORD /d "0" /f >> %neptlog%
:: Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock" /v "UseDelayedAcceptance" /t Reg_DWORD /d "0" /f >> %neptlog%

:: Prevent NIC Resets
Reg add "HKLM\SYSTEM\CurrentControlSet\services\NDIS\Parameters" /v "DisableNDISWatchDog" /t Reg_DWORD /d "1" /f >> %neptlog%

:: Disable Nagle's Algorithm
:: https://en.wikipedia.org/wiki/Nagle%27s_algorithm
:: for /f %%a in ('wmic path Win32_NetworkAdapter get GUID ^| findstr "{"') do (
:: Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%a" /v "TcpAckFrequency" /t Reg_DWORD /d "1" /f >> %neptlog%
:: Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%a" /v "TcpDelAckTicks" /t Reg_DWORD /d "0" /f >> %neptlog%
:: Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%a" /v "TCPNoDelay" /t Reg_DWORD /d "1" /f >> %neptlog%
:: )

:: Disable NetBIOS over TCP
for /f "delims=" %%a in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces" /s /f "NetbiosOptions" ^| findstr "HKEY"') do (
Reg add "%%a" /v "NetbiosOptions" /t Reg_DWORD /d "2" /f >> %neptlog%
)

:: Disable Network Protocols
:: This includes IPV6, File and Printer Sharing for Microsoft Networks, Client for Microsoft Networks, etc
PowerShell -ExecutionPolicy Unrestricted -Command  "Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6, ms_msclient, ms_server, ms_lldp, ms_lltdio, ms_rspndr" >> %neptlog%

:: Disable IPV6 through TCPIP
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v "DisabledComponents" /t REG_DWORD /d "32" /f >> %neptlog%

:: Disable Telemetry IP's
cd %SystemRoot%\System32\drivers\etc
if not exist hosts.bak ren hosts hosts.bak >> %neptlog%
curl -l -s https://winhelp2002.mvps.org/hosts.txt -o hosts
if not exist hosts ren hosts.bak hosts >> %neptlog%
goto ServiceConfiguration



:ServiceConfiguration
cls & echo !S_YELLOW!Disabling Drivers and Services [9/18]
:: Configuring the services and drivers in Windows

:: Configuring Driver Dependencies
:: - > DHCP, allows for TDX to be disabled
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dhcp" /v "DependOnService" /t Reg_MULTI_SZ /d "NSI\0Afd" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache" /v "DependOnService" /t Reg_MULTI_SZ /d "nsi" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc" /v "DependOnService" /t Reg_MULTI_SZ /d "NSI\0RpcSs\0TcpIp" /f >> %neptlog%

:: Configure Driver Filters
:: - > ReadyBoost
if "%server%"=="no" (
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t Reg_MULTI_SZ /d "fvevol\0iorate" /f >> %neptlog%
)

:: Split Audio Services
:: This will prevent audio dropouts when setting svchost.exe to low priority
copy /y "%windir%\System32\svchost.exe" "%windir%\System32\audiosvchost.exe" >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv" /v "ImagePath" /t Reg_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalServiceNetworkRestricted -p" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AudioEndpointBuilder" /v "ImagePath" /t Reg_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalSystemNetworkRestricted -p" /f >> %neptlog%

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
%svc% DispBrokerDesktopSvc 4
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
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f >> %neptlog%
::  - > Disable ASLR Mitigations
::  - > This might break TestMem5
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "MoveImages" /t REG_DWORD /d "0" /f >> %neptlog%
::  - > Disable Control Flow Guard
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f >> %neptlog%
::  - > NTFS/ReFS Mitigations
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f >> %neptlog%
::  - > System Mitigations
PowerShell -ExecutionPolicy Unrestricted -Command  "Set-ProcessMitigation -System -Disable DEP, EmulateAtlThunks, SEHOP, ForceRelocateImages, RequireInfo, BottomUp, HighEntropy, StrictHandle, DisableWin32kSystemCalls, AuditSystemCall, DisableExtensionPoints, BlockDynamicCode, AllowThreadsToOptOut, AuditDynamicCode, CFG, SuppressExports, StrictCFG, MicrosoftSignedOnly, AllowStoreSignedBinaries, AuditMicrosoftSigned, AuditStoreSigned, EnforceModuleDependencySigning, DisableNonSystemFonts, AuditFont, BlockRemoteImageLoads, BlockLowLabelImageLoads, PreferSystem32, AuditRemoteImageLoads, AuditLowLabelImageLoads, AuditPreferSystem32, EnableExportAddressFilter, AuditEnableExportAddressFilter, EnableExportAddressFilterPlus, AuditEnableExportAddressFilterPlus, EnableImportAddressFilter, AuditEnableImportAddressFilter, EnableRopStackPivot, AuditEnableRopStackPivot, EnableRopCallerCheck, AuditEnableRopCallerCheck, EnableRopSimExec, AuditEnableRopSimExec, SEHOP, AuditSEHOP, SEHOPTelemetry, TerminateOnError, DisallowChildProcessCreation, AuditChildProcess" >> %neptlog%
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
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%a" /v "MitigationOptions" /t Reg_BINARY /d "!mitigation_mask!" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%a" /v "MitigationAuditOptions" /t Reg_BINARY /d "!mitigation_mask!" /f >> %neptlog%
)
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t Reg_BINARY /d "!mitigation_mask!" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions" /t Reg_BINARY /d "!mitigation_mask!" /f >> %neptlog%
::  - > Disable SEHOP
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f >> %neptlog%

:: Mitigate HiveNightmare aka SeriousSAM (CVE-2021-36934)
icacls %WinDir%\system32\config\*.* /inheritance:e >> %neptlog%

:: Harden LSASS
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe" /v "AuditLevel" /t REG_DWORD /d "8" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation" /v "AllowProtectedCreds" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdminOutboundCreds" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdmin" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RunAsPPL" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" /v "Negotiate" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" /v "UseLogonCredential" /t REG_DWORD /d "0" /f >> %neptlog%

:: Harden WinRM
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" /v "AllowUnencryptedTraffic" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client" /v "AllowDigest" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule" /v "DisableRpcOverTcp" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "DisableRemoteScmEndpoints" /t REG_DWORD /d "1" /f >> %neptlog%

:: Block enumeration of anonymous SAM accounts
:: https://www.stigviewer.com/stig/windows_10/2021-03-10/finding/V-220929
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RestrictAnonymousSAM" /t REG_DWORD /d "1" /f >> %neptlog%

:: Enable UAC
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "5" /f >> %neptlog%

:: Mitigation for CVE-2021-40444 and other future activex related attacks
:: https://msrc.microsoft.com/update-guide/vulnerability/CVE-2021-40444
:: https://www.huntress.com/blog/cybersecurity-advisory-hackers-are-exploiting-cve-2021-40444
:: https://nitter.unixfox.eu/wdormann/status/1437530613536501765
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v "1001" /t REG_DWORD /d 00000003 /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1001" /t REG_DWORD /d 00000003 /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1001" /t REG_DWORD /d 00000003 /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1001" /t REG_DWORD /d 00000003 /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v "1004" /t REG_DWORD /d 00000003 /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1004" /t REG_DWORD /d 00000003 /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1004" /t REG_DWORD /d 00000003 /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1004" /t REG_DWORD /d 00000003 /f >> %neptlog%

:: Prevent Kerberos from using DES or RC4
:: https://gist.github.com/mackwage/08604751462126599d7e52f233490efe?permalink_comment_id=3310398
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters" /v SupportedEncryptionTypes /t REG_DWORD /d 2147483640 /f >> %neptlog%

:: Mitigate ClickOnce
Reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v "MyComputer" /t Reg_SZ /d "Disabled" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v "LocalIntranet" /t Reg_SZ /d "Disabled" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v "Internet" /t Reg_SZ /d "Disabled" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v "TrustedSites" /t Reg_SZ /d "Disabled" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v "UntrustedSites" /t Reg_SZ /d "Disabled" /f >> %neptlog%

:: Set strong cryptography on 64 bit and 32 bit .net framework
:: https://github.com/ScoopInstaller/Scoop/issues/2040#issuecomment-369686748
Reg add "HKLM\SOFTWARE\Microsoft\.NetFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "1" /f >> %neptlog%

:: Restrict anonymous enumeration of shares
:: https://www.stigviewer.com/stig/windows_10/2021-03-10/finding/V-220930
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RestrictAnonymous" /t REG_DWORD /d "1" /f >> %neptlog%

:: disable memory mitigations
bcdedit /set allowedinmemorysettings 0x0 >> %neptlog%

:: Delete Adobe Font Type Manager
Reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Font Drivers" /v "Adobe Type Manager" /f >> %neptlog% 
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "DisableATMFD" /t REG_DWORD /d "1" /f >> %neptlog%

:: Disable DMA Remapping
:: https://docs.microsoft.com/en-us/windows-hardware/drivers/pci/enabling-dma-remapping-for-device-drivers
for /f %%a in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f "DmaRemappingCompatible" ^| find /i "Services\" ') do (
Reg add "%%a" /v "DmaRemappingCompatible" /t Reg_DWORD /d "0" /f >> %neptlog%
)

:: Disable DMA Memory Protection
Reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\DmaGuard\DeviceEnumerationPolicy" /v "value" /t REG_DWORD /d "2" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\FVE" /v "DisableExternalDMAUnderLock" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t REG_DWORD /d "0" /f >> %neptlog%

:: Disable Core Isolation Memory Integrity
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "EnableVirtualizationBasedSecurity" /d "0" /f >> %neptlog%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "RequirePlatformSecurityFeatures" /d "1" /f >> %neptlog%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HypervisorEnforcedCodeIntegrity" /d "0" /f >> %neptlog%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HVCIMATRequired" /d "0" /f >> %neptlog%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "LsaCfgFlags" /d "0" /f >> %neptlog%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "ConfigureSystemGuardLaunch" /d "0" /f >> %neptlog%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequireMicrosoftSignedBootChain" /t REG_DWORD /d "0" /f >> %neptlog%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /t REG_DWORD /d "0" /f >> %neptlog%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f >> %neptlog%

:: Edge Hardening
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "SitePerProcess" /t REG_DWORD /d "0x00000001" /f >> %neptlog%
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "SSLVersionMin" /t REG_SZ /d "tls1.2^@" /f >> %neptlog%
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "NativeMessagingUserLevelHosts" /t REG_DWORD /d "0" /f >> %neptlog%
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "PreventSmartScreenPromptOverride" /t REG_DWORD /d "0x00000001" /f >> %neptlog%
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "PreventSmartScreenPromptOverrideForFiles" /t REG_DWORD /d "0x00000001" /f >> %neptlog%
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "SSLErrorOverrideAllowed" /t REG_DWORD /d "0" /f >> %neptlog%
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "SmartScreenPuaEnabled" /t REG_DWORD /d "0x00000001" /f >> %neptlog%
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "AllowDeletingBrowserHistory" /t REG_DWORD /d "0x00000000" /f >> %neptlog%

:: Enable DEP
bcdedit /set nx on >> %neptlog%

:: Disable TSX 
:: Enabling this could result in improved performance under certain workloads
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableTsx" /t REG_DWORD /d "1" /f >> %neptlog%

:: Disable Fault Tolerant Heap
Reg add "HKLM\SOFTWARE\Microsoft\FTH" /v "Enabled" /t REG_DWORD /d "0" /f >> %neptlog%
rundll32.exe fthsvc.dll,FthSysprepSpecialize

:: Disable SmartScreen
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t Reg_DWORD /d "0" /f >> %neptlog%
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "ShellSmartScreenLevel" /f >> %neptlog% 

:: Disable Lockscreen Security on Servers
if "%server%"=="yes" (Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "disablecad" /t REG_DWORD /d "1" /f >> %neptlog%)
goto RegistryCongiruation


:: Configuring the Windows Registry
: - > Configuring the explorer and UI in Windows
:RegistryCongiruation
cls & echo !S_YELLOW!Configuring Registry... [11/18]

:: Explorer Quickness
:: - > Turn down application launch delays
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shutdown\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Turn down login delays
:: https://james-rankin.com/features/the-ultimate-guide-to-windows-logon-optimizations-part-6/
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DelayedDesktopSwitchTimeout" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Automatically close any apps and continue to restart, shut down, or sign out of windows
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f >> %neptlog%
:: - > Reduce menu show delay time
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >> %neptlog%
:: - > Configure app timeout 
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f >> %neptlog%

:: Explorer Colors
:: - > Set windows color scheme to 'storm gray'
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentColorMenu" /t REG_DWORD /d "4290756543" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "StartColorMenu" /t REG_DWORD /d "4289901234" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentPalette" /t REG_BINARY /d "9b9a9900848381006d6b6a004c4a4800363533002625240019191900107c1000" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationColor" /t REG_DWORD /d "3293334088" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationAfterglow" /t REG_DWORD /d "3293334088" /f >> %neptlog%
:: - > Set operating system color scheme to 'dark'
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Set tooltips to blue
%currentuser% Reg add "HKCU\Control Panel\Colors" /v "InfoWindow" /t REG_SZ /d "246 253 255" /f >> %neptlog%

:: Set NeptuneOS Wallpaper
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "Wallpaper" /t REG_SZ /d "C:\Windows\Web\Wallpaper\Windows\NeptuneOS.png" /f >> %neptlog%
:: - > Increase JPEG Wallpaper Quality
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d "100" /f >> %neptlog%

:: Disable Explorer Animations and Shadows
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "FontSmoothing" /t REG_SZ /d "2" /f >> %neptlog%
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9012038010000000" /f >> %neptlog%
%currentuser% Reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisablePreviewDesktop" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "IconsOnly" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f >> %neptlog%
:: - > Taskbar / UWP Transprency
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseOLEDTaskbarTransparency" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "DisableAcrylicBackgroundOnLogon" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > DWM Shadows and Animations
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "ListviewShadow" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableWindowColorization" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > DWM Composition
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "Composition" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowComposition" /t REG_DWORD /d "1" /f >> %neptlog%

:: Context Menu Configuration
:: - > Disable wide Context Menus
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\FlightedFeatures" /v "ImmersiveContextMenu" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Remove 'restore previous versions' from Context Menus and File Properties
Reg delete "HKCR\AllFilesystemObjects\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >> %neptlog% 
Reg delete "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >> %neptlog% 
Reg delete "HKCR\Directory\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >> %neptlog% 
Reg delete "HKCR\Drive\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >> %neptlog% 
Reg delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >> %neptlog% 
Reg delete "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >> %neptlog% 
Reg delete "HKCR\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >> %neptlog% 
Reg delete "HKCR\Drive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >> %neptlog% 
%currentuser% Reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "NoPreviousVersionsPage" /f >> %neptlog% 
%currentuser% Reg delete "HKCU\SOFTWARE\Policies\Microsoft\PreviousVersions" /v "DisableLocalPage" /f >> %neptlog% 
:: - Restore 'new text file' in Context Menus
Reg delete "HKCR\.txt\ShellNew" /f >> %neptlog% 
Reg add "HKCR\.txt\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@%%SystemRoot%%\system32\notepad.exe,-470" /f >> %neptlog%
Reg add "HKCR\.txt\ShellNew" /v "NullFile" /t REG_SZ /d "" /f >> %neptlog%
Reg delete "HKCR\.txt" /f >> %neptlog% 
Reg add "HKCR\.txt" /ve /t REG_SZ /d "txtfile" /f >> %neptlog%
Reg add "HKCR\.txt" /v "Content Type" /t REG_SZ /d "text/plain" /f >> %neptlog%
Reg add "HKCR\.txt" /v "PerceivedType" /t REG_SZ /d "text" /f >> %neptlog%
Reg add "HKCR\.txt\PersistentHandler" /ve /t REG_SZ /d "{5e941d80-bf96-11cd-b579-08002b30bfeb}" /f >> %neptlog%
Reg add "HKCR\.txt\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@%%SystemRoot%%\system32\notepad.exe,-470" /f >> %neptlog%
Reg add "HKCR\.txt\ShellNew" /v "NullFile" /t REG_SZ /d "" /f >> %neptlog%
Reg delete "HKCR\SystemFileAssociations\.txt" /f >> %neptlog% 
Reg add "HKCR\SystemFileAssociations\.txt" /v "PerceivedType" /t REG_SZ /d "document" /f >> %neptlog%
Reg delete "HKCR\txtfile" /f >> %neptlog% 
Reg add "HKCR\txtfile" /ve /t REG_SZ /d "Text Document" /f >> %neptlog%
Reg add "HKCR\txtfile" /v "EditFlags" /t REG_DWORD /d "2162688" /f >> %neptlog%
Reg add "HKCR\txtfile" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%SystemRoot%%\system32\notepad.exe,-469" /f >> %neptlog%
Reg add "HKCR\txtfile\DefaultIcon" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\imageres.dll,-102" /f >> %neptlog%
Reg add "HKCR\txtfile\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\NOTEPAD.EXE %%1" /f >> %neptlog%
Reg add "HKCR\txtfile\shell\print\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\NOTEPAD.EXE /p %%1" /f >> %neptlog%
Reg add "HKCR\txtfile\shell\printto\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\notepad.exe /pt \"%%1\" \"%%2\" \"%%3\" \"%%4\"" /f >> %neptlog%
Reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.txt" /f >> %neptlog% 
Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.txt\OpenWithList" /f >> %neptlog%
Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.txt\OpenWithProgids" /v "txtfile" /t REG_NONE /d "" /f >> %neptlog%
%system% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.txt\UserChoice" /v "Hash" /t REG_SZ /d "hyXk/CpboWw=" /f >> %neptlog%
%system% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.txt\UserChoice" /v "ProgId" /t REG_SZ /d "txtfile" /f >> %neptlog%
Reg delete "HKCU\SOFTWARE\Microsoft\Windows\Roaming\OpenWith\FileExts\.txt" /f >> %neptlog% 
Reg add "HKCU\SOFTWARE\Microsoft\Windows\Roaming\OpenWith\FileExts\.txt\UserChoice" /v "Hash" /t REG_SZ /d "FvJcqeZpmOE=" /f >> %neptlog%
Reg add "HKCU\SOFTWARE\Microsoft\Windows\Roaming\OpenWith\FileExts\.txt\UserChoice" /v "ProgId" /t REG_SZ /d "txtfile" /f >> %neptlog%
:: - > Remove 'edit with Paint 3D' from Context Menus
Reg delete "HKCR\SystemFileAssociations\.3mf\Shell\3D Edit" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.bmp\Shell\3D Edit" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.fbx\Shell\3D Edit" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.gif\Shell\3D Edit" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.jfif\Shell\3D Edit" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.jpe\Shell\3D Edit" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.jpeg\Shell\3D Edit" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.jpg\Shell\3D Edit" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.png\Shell\3D Edit" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.tif\Shell\3D Edit" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.tiff\Shell\3D Edit" /f >> %neptlog% 
:: - > Remove 'give access to' from Context Menus
Reg delete "HKCR\*\shellex\ContextMenuHandlers\Sharing" /f >> %neptlog% 
Reg delete "HKCR\Directory\Background\shellex\ContextMenuHandlers\Sharing" /f >> %neptlog% 
Reg delete "HKCR\Directory\shellex\ContextMenuHandlers\Sharing" /f >> %neptlog% 
Reg delete "HKCR\Drive\shellex\ContextMenuHandlers\Sharing" /f >> %neptlog% 
Reg delete "HKCR\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing" /f >> %neptlog% 
Reg delete "HKCR\UserLibraryFolder\shellex\ContextMenuHandlers\Sharing" /f >> %neptlog%
:: - > Remove 'cast to device' from Context Menus
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" /t REG_SZ /d "" /f >> %neptlog% 
:: - > Remove 'share' in Context Menus
Reg delete "HKCR\*\shellex\ContextMenuHandlers\ModernSharing" /f >> %neptlog% 
Reg delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\ModernSharing" /f >> %neptlog% 
:: - > Remove 'bitmap image' from the 'new' Context Menus
Reg delete "HKCR\.bmp\ShellNew" /f >> %neptlog% 
:: - > Remove 'rich text document' from 'new' Context Menus
Reg delete "HKCR\.rtf\ShellNew" /f >> %neptlog% 
:: - > Remove 'send to' from Context Menus
Reg delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" /f >> %neptlog% 
Reg delete "HKCR\UserLibraryFolder\shellex\ContextMenuHandlers\SendTo" /f >> %neptlog% 
:: - > Remove 'add to favorites' from Context Menus
Reg delete "HKCR\*\shell\pintohomefile" /f >> %neptlog% 
:: - > Remove 'rotate left' and 'rotate right' from Context Menus
Reg delete "HKCR\SystemFileAssociations\.avci\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.avif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.bmp\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.dds\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.dib\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.gif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.heic\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.heif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.hif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.ico\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.jfif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.jpe\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.jpeg\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.jpg\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.jxr\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.png\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.rle\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.tif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.tiff\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.wdp\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
Reg delete "HKCR\SystemFileAssociations\.webp\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >> %neptlog% 
:: - > Remove 'Scan with Defender' from Context Menus
Reg delete "HKLM\SOFTWARE\Classes\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}\InprocServer32" /va /f >> %neptlog% 
Reg delete "HKCR\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}" /v "InprocServer32" /f >> %neptlog% 
Reg delete "HKCR\*\shellex\ContextMenuHandlers" /v "EPP" /f >> %neptlog% 
Reg delete "HKCR\Directory\shellex\ContextMenuHandlers" /v "EPP" /f >> %neptlog% 
Reg delete "HKCR\Drive\shellex\ContextMenuHandlers" /v "EPP" /f >> %neptlog% 
:: - > Remove 'print' from Context Menus
%currentuser% Reg add "HKCR\SystemFileAssociations\image\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f >> %neptlog% & for %%a in ("batfile" "cmdfile" "docxfile" "fonfile" "htmlfile" "inffile" "inifile" "JSEFile" "otffile" "pfmfile" "regfile" "rtffile" "ttcfile" "ttffile" "txtfile" "VBEFile" "VBSFile" "WSFFile") do (%currentuser% Reg add "HKCR\%%~a\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f >> %neptlog%)
:: - > Remove 'include in library' from Context Menus
Reg delete "HKCR\Folder\ShellEx\ContextMenuHandlers\Library Location" /f >> %neptlog% 
Reg delete "HKLM\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location" /f >> %neptlog% 
:: - > Remove 'troubleshooting compatibility' from Context Menus
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{1d27f844-3a1f-4410-85ac-14651078412d}" /t REG_SZ /d "" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{1d27f844-3a1f-4410-85ac-14651078412d}" /t REG_SZ /d "" /f >> %neptlog%
:: - > Add 'copy to' and 'move to' to Context Menus
Reg add "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\Copy To" /ve /t REG_SZ /d "{C2FBB630-2971-11D1-A18C-00C04FD75D13}" /f >> %neptlog%
Reg add "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\Move To" /ve /t REG_SZ /d "{C2FBB631-2971-11D1-A18C-00C04FD75D13}" /f >> %neptlog%
:: - > Add '.bat' to 'new' Context Menus
Reg add "HKLM\SOFTWARE\Classes\.bat\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\System32\acppage.dll,-6002" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Classes\.bat\ShellNew" /v "NullFile" /t REG_SZ /d "" /f >> %neptlog%
:: - > Add '.cmd' to 'new' Context Menus
Reg add "HKLM\SOFTWARE\Classes\.cmd\ShellNew" /v "NullFile" /t REG_SZ /d "" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Classes\.cmd\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\System32\acppage.dll,-6003" /f >> %neptlog%
:: - > Add '.ps1' to 'new' Context Menus
Reg add "HKLM\SOFTWARE\Classes\.ps1\ShellNew" /v "NullFile" /t REG_SZ /d "" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Classes\.ps1\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "New file" /f >> %neptlog%
if "%os%"=="Windows 11" (Reg.exe add "HKCR\.ps1" /ve /t REG_SZ /d "ps1legacy" /f & Reg.exe add "HKCR\.ps1\ShellNew" /v "NullFile" /t REG_SZ /d "" /f & Reg.exe add "HKCR\ps1legacy" /ve /t REG_SZ /d "Windows PowerShell Script" /f & Reg.exe add "HKCR\ps1legacy" /v "FriendlyTypeName" /t REG_SZ /d "Windows PowerShell Script" /f) >> %neptlog%
:: - > Add '.reg' to 'new' Context Menus
Reg add "HKLM\SOFTWARE\Classes\.reg\ShellNew" /v "NullFile" /t REG_SZ /d "" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Classes\.reg\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\regedit.exe,-309" /f >> %neptlog%
:: - > Add 'take ownership' to Context Menus
Reg add "HKCR\*\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f >> %neptlog%
Reg add "HKCR\*\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >> %neptlog%
Reg add "HKCR\*\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >> %neptlog%
Reg add "HKCR\*\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >> %neptlog%
Reg add "HKCR\Directory\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f >> %neptlog%
Reg add "HKCR\Directory\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >> %neptlog%
Reg add "HKCR\Directory\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f >> %neptlog%
Reg add "HKCR\Directory\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "MultipleInvokePromptMinimum" /t REG_DWORD /d "200" /f >> %neptlog%
:: - > Add "merge as trusted installer" to .reg Context Menus
Reg add "HKCR\regfile\Shell\RunAs" /ve /t REG_SZ /d "Merge As TrustedInstaller" /f >> %neptlog%
Reg add "HKCR\regfile\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "1" /f >> %neptlog%
Reg add "HKCR\regfile\Shell\RunAs\Command" /ve /t REG_SZ /d "NSudo.exe -U:T -P:E Reg import "%1"" /f >> %neptlog%
:: - > Add 'install' to .cab Context Menus
Reg delete "HKCR\CABFolder\Shell\RunAs" /f >> %neptlog% 
Reg add "HKCR\CABFolder\Shell\RunAs" /ve /t REG_SZ /d "Install" /f >> %neptlog%
Reg add "HKCR\CABFolder\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "" /f >> %neptlog%
Reg add "HKCR\CABFolder\Shell\RunAs\Command" /ve /t REG_SZ /d "cmd /k DISM /online /add-package /packagepath:\"%1\"" /f >> %neptlog%
:: - > Debloat 'Send To' context menu, hidden files do not show up in the 'Send To' context menu
:: attrib +h "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\SendTo\Bluetooth File Transfer.LNK" >> %neptlog%
:: attrib +h "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\SendTo\Mail Recipient.MAPIMail" >> %neptlog%
:: attrib +h "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\SendTo\Documents.mydocs" >> %neptlog%

:: File Explorer Configuration
:: - > Disable 'Network Navigation' in the File Explorer Side Panel
%system% Reg add "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2962489444" /f >> %neptlog%
:: - > Disable OneDrive in the File Explorer Side Panel
Reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /d "0" /t REG_DWORD /f >> %neptlog%
Reg add "HKCR\Wow6432Node\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /d "0" /t REG_DWORD /f >> %neptlog%
:: - > Remove Duplicate Removable Drives in the File Explorer Side Panel
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f >> %neptlog% 
Reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f >> %neptlog% 
:: - > Disable 'Quick Access' in the File Explorer Side Panel
%system% Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "HubMode" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Disable '3D Objects' in the File Explorer Side Panel
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f >> %neptlog% 
Reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f >> %neptlog% 
:: - > Hide frequently used files/folders in the 'Quick Access' File Explorer Side Panel
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Hide recently used files/folders in the 'Quick Access' File Explorer Side Panel
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Show the full path in the File Explorer Search Bar
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v "Settings" /t REG_BINARY /d "0c0002000b01000060000000" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v "FullPath" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Show hidden files in File Explorer
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Show file extensions in File Explorer
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Disable Sharing Wizard
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SharingWizardOn" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Disable Sync Provider Notifications
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Disable 'Show files from Office.com'
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCloudFilesInQuickAccess" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Disable automatic folder type discovery in File Explorer
:: This might improve explorer performance, but will also make all folders autosort by 'details'
%currentuser% Reg delete "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f >> %neptlog% 
%currentuser% Reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v "FolderType" /t REG_SZ /d "NotSpecified" /f >> %neptlog%
:: - > Show encrypted NTFS files in color in File Explorer
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowEncryptCompressedColor" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Don't show the status bar in File Explorer
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowStatusBar" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Open File Explorer to 'This PC'
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Revert to classic File Explorer search
%system% Reg add "HKLM\SOFTWARE\Classes\CLSID\{1d64637d-31e9-4b06-9124-e83fb178ac6e}\TreatAs" /v "" /t REG_SZ /d "{64bc32b5-4eec-4de7-972d-bd8bd0324537}" /f >> %neptlog%
%system% Reg add "HKLM\SOFTWARE\Classes\WOW6432Node\CLSID\{1d64637d-31e9-4b06-9124-e83fb178ac6e}\TreatAs" /v "" /t REG_SZ /d "{64bc32b5-4eec-4de7-972d-bd8bd0324537}" /f >> %neptlog%
%system% Reg add "HKLM\SOFTWARE\WOW6432Node\Classes\CLSID\{1d64637d-31e9-4b06-9124-e83fb178ac6e}\TreatAs" /v "" /t REG_SZ /d "{64bc32b5-4eec-4de7-972d-bd8bd0324537}" /f >> %neptlog%
:: - > Always show more details for File Explorer transfers
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" /v "EnthusiastMode" /t REG_DWORD /d "1" /f >> %neptlog%

:: Configure Taskbar
:: - > Hide meet now on the Taskbar
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Hide people button on the Taskbar
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HidePeopleBar" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Hide task view button on the Taskbar
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /D "0" /f >> %neptlog%
%currentuser% Reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MultiTaskingView\AllUpView" /v "Enabled" /f >> %neptlog% 
:: - > Hide search from the Taskbar
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Don't pin the store to the Taskbar
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoPinningStoreToTaskbar" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Disable News and Interests on the Taskbar
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d "2" /f >> %neptlog%
:: - > Hide notification badges on the Taskbar
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarBadges" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Show command prompt in the WIN+X menu
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DontUsePowerShellOnWinX" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Disable Start Menu Recommendations
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_AccountNotifications" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Clear Default TileGrid
%currentuser% Reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount" /v "start.tilegrid" /f >> %neptlog% 
:: - > Disable Start Menu Pins
:: currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "StartMenu_Start_Time" /t REG_BINARY /d "889f04f10c79da01" /f >> %neptlog%
:: %currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "Start_JumpListModernTime" /t REG_BINARY /d "29210bf10c79da01" /f >> %neptlog%
:: Reg add "HKU\%SID%\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "StartMenu_Start_Time" /t REG_BINARY /d "889f04f10c79da01" /f >> %neptlog%
:: Reg add "HKU\%SID%\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "Start_JumpListModernTime" /t REG_BINARY /d "29210bf10c79da01" /f >> %neptlog%
:: - > Remove Advertisements and Stubs from Start Menu
if "%os%"=="Windows 11" (%currentuser% Reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Start" /v "Config" /f) >> %neptlog% 
:: -> Hide Recommended Start Menu Apps
if "%os%"=="Windows 11" (%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Start" /v "ShowRecentList" /t REG_DWORD /d "0" /f) >> %neptlog%
:: - > Hide Recently Added Apps in the Start Menu
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HideRecentlyAddedApps" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Hide Recently Opened Items in Start Menu
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Set the Start Menu layout.xml for Windows 10
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_EXPAND_SZ /d "%WinDir%\layout.xml" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "LockedStartLayout" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy Objects\{2F5183E9-4A32-40DD-9639-F9FAF80C79F4}Machine\Software\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_EXPAND_SZ /d "%WinDir%\layout.xml" /f >> %neptlog%

:: - > Disable action center on the Taskbar
if "%os%"=="Windows 10" (
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f >> %neptlog%
)
:: - > Disable notifications
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /t REG_DWORD /d "1" /f >> %neptlog%
:: ^ - > Lock Screen Notifications
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "LockScreenToastEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Disable cloud optimized taskbars
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableCloudOptimizedContent" /t Reg_DWORD /d "1" /f >> %neptlog%
:: - > Disable CoPilot on Windows 11
if "%os%"=="Windows 11" (%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d "1" /f) >> %neptlog%
if "%os%"=="Windows 11" (%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCopilotButton" /t REG_DWORD /d "0" /f) >> %neptlog%

:: Fix Default Account Icon
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "UseDefaultTile" /t REG_DWORD /d "1" /f >> %neptlog%

:: Enable the legacy photo viewer from windows 7 era
for %%a in (tif tiff bmp dib gif jfif jpe jpeg jpg jxr png) do (
Reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".%%~a" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >> %neptlog%
)
for %%a in (tif tiff bmp dib gif jfif jpe jpeg jpg jxr png) do (
%currentuser% Reg add "HKCU\SOFTWARE\Classes\.%%~a" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >> %neptlog%
)

:: Hide pages in UWP settings
if "%os%"=="Windows 10" (
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "hide:recovery;autoplay;usb;maps;maps-downloadmaps;findmydevice;privacy;privacy-speechtyping;privacy-speech;privacy-feedback;privacy-activityhistory;search-permissions;privacy-location;privacy-general;sync;printers;cortana-windowssearch;mobile-devices;mobile-devices-addphone;backup;" /f >> %neptlog%
)
:: - >  Hide unneeded control panel applets
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "RestrictCpl" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "1" /t REG_SZ /d "Administrative Tools" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "2" /t REG_SZ /d "Color Management" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "3" /t REG_SZ /d "Date and Time" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "4" /t REG_SZ /d "Device Manager" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "5" /t REG_SZ /d "File Explorer Options" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "6" /t REG_SZ /d "Internet Options" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "7" /t REG_SZ /d "Keyboard" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "8" /t REG_SZ /d "Mouse" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "9" /t REG_SZ /d "Network and Sharing Center" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "10" /t REG_SZ /d "Power Options" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "11" /t REG_SZ /d "Programs and Features" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "12" /t REG_SZ /d "Region" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "13" /t REG_SZ /d "Sound" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "14" /t REG_SZ /d "Windows Defender Firewall" /f >> %neptlog%

:: Configure Windows Search
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsAADCloudSearchEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsMSACloudSearchEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsDeviceSearchHistoryEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "SafeSearchMode" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Explorer Search
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "AutoWildCard" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "EnableNaturalQuerySyntax" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "WholeFileSystem" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "SystemFolders" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "ArchivedFiles" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "SearchOnly" /t REG_DWORD /d "1" /f >> %neptlog%

:: Disable AutoRun and AutoPlay
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v "DisableAutoplay" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d "255" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoAutoplayfornonVolume" /t REG_DWORD /d "1" /f >> %neptlog%

:: Fix misbehaving icons when using 2 different resolution monitors
%currentuser% Reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "IconSpacing" /t REG_SZ /d "-1125" /f >> %neptlog%
%currentuser% Reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "IconVerticalSpacing" /t REG_SZ /d "-1125" /f >> %neptlog%

:: Disable 'desktop.ini' file creation
:: https://www.makeuseof.com/desktop-ini-files-guide/#:~:text=these%20files%20important%3F-,The%20desktop.,configuring%20specific%20file%2Dsharing%20settings.
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "UseDesktopIniCache" /t REG_DWORD /d "0" /f >> %neptlog%

:: Legacy Notepad
:: This removes the banner telling you to install the new NotePad
Reg add "HKU\%SID%\Software\Microsoft\Notepad" /v "ShowStoreBanner" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKU\%SID%\Software\Microsoft\Notepad" /v "fWrap" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKU\%SID%\Software\Microsoft\Notepad" /v "StatusBar" /t REG_DWORD /d "1" /f >> %neptlog%

:: Set icon cache to 51.2MB
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "Max Cached Icons" /t REG_SZ /d "51200" /f >> %neptlog%

:: Turn off Internet File Association Service
:: https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.InternetCommunicationManagement::ShellNoUseInternetOpenWith_2
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetOpenWith" /t REG_DWORD /d 1 /f >> %neptlog%

:: Turn on Verbose Mode
:: https://www.thewindowsclub.com/enable-verbose-status-message-windows
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "VerboseStatus" /t REG_DWORD /d "1" /f >> %neptlog%

:: Show drive letters before drive name in File Explorer
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowDriveLettersFirst" /t REG_DWORD /d "4" /f >> %neptlog%

:: Disable USB Errors
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Shell\USB" /v "NotifyOnUsbErrors" /t REG_DWORD /d "0" /f >> %neptlog%

:: Disable 'Open File - Security Warning' message
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v "1806" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1806" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1806" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1806" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4" /v "1806" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v "1806" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1806" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1806" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1806" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4" /v "1806" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Security" /v "DisableSecuritySettingsCheck" /t REG_DWORD /d "1" /f >> %neptlog%

:: Disable ShellBags
%currentuser% Reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /v "BagMRU Size" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /v "BagMRU Size" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\Shell\BagMRU" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\Shell\Bags" /f >> %neptlog%
%currentuser% Reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f >> %neptlog% 
%currentuser% Reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f >> %neptlog% 
%currentuser% Reg delete "HKCU\Software\Microsoft\Windows\Shell\BagMRU" /f >> %neptlog% 
%currentuser% Reg delete "HKCU\Software\Microsoft\Windows\Shell\Bags" /f >> %neptlog% 
%currentuser% Reg delete "HKCU\Software\Microsoft\Windows\ShellNoRoam\BagMRU" /f >> %neptlog% 
%currentuser% Reg delete "HKCU\Software\Microsoft\Windows\ShellNoRoam\Bags" /f >> %neptlog% 

:: Storage Sense Configuration
:: - > Clean files once a month
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "01" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "1024" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "2048" /t REG_DWORD /d "30" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "04" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "32" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "02" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "128" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "08" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "256" /t REG_DWORD /d "30" /f >> %neptlog%

:: BSoD QoL
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "LogEvent" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl\StorageTelemetry" /v "DeviceDumpEnabled" /t REG_DWORD /d "0" /f >> %neptlog%

:: Disable System Protection (by default)
Reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SPP\Clients" /v "{09F7EDC5-294E-4180-AF6A-FB0E6A0E9513}" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SPP\Clients" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "RPSessionInterval" /t REG_DWORD /d "0" /f >> %neptlog%

:: Edge QoL
Reg add "HKLM\Software\Policies\Microsoft\Edge" /f >> %neptlog%
Reg add "HKLM\Software\Policies\Microsoft\Edge" /v "BackgroundModeEnabled" /t REG_DWORD /d 0 /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenPuaEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "PreventSmartScreenPromptOverride" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "StartupBoostEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Policies\Microsoft\Edge" /v "AddressBarMicrosoftSearchInBingProviderEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Policies\Microsoft\Edge" /v "AlternateErrorPagesEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Policies\Microsoft\Edge" /v "AutofillAddressEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Policies\Microsoft\Edge" /v "AutofillCreditCardEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Policies\Microsoft\Edge" /v "ConfigureDoNotTrack" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Policies\Microsoft\Edge" /v "EdgeShoppingAssistantEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Policies\Microsoft\Edge" /v "LocalProvidersEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Policies\Microsoft\Edge" /v "MetricsReportingEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Policies\Microsoft\Edge" /v "NetworkPredictionOptions" /t REG_DWORD /d "2" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Policies\Microsoft\Edge" /v "PaymentMethodQueryEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Policies\Microsoft\Edge" /v "PersonalizationReportingEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Policies\Microsoft\Edge" /v "ResolveNavigationErrorsUseWebService" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Policies\Microsoft\Edge" /v "SearchSuggestEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Policies\Microsoft\Edge" /v "SendSiteInfoToImproveServices" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Policies\Microsoft\Edge" /v "SmartScreenEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Policies\Microsoft\Edge" /v "UserFeedbackAllowed" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Browser" /v "AllowAddressBarDropdown" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\Software\Policies\Microsoft\Edge" /v "AutofillCreditCardEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\Software\Policies\Microsoft\Edge" /v "UserFeedbackAllowed" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\Software\Policies\Microsoft\MicrosoftEdge\TabPreloader" /v "AllowTabPreloading" /t REG_DWORD /d "0" /f >> %neptlog%

:: Explorer Audio Configuration
:: - > Fix volume mixer
%currentuser% Reg add "HKCU\Software\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore" /f >> %neptlog%
:: - > Don't show disconnected/disabled devices in mmsys.cpl
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowDisconnectedDevices" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowHiddenDevices" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Set audio scheme to none
%currentuser% PowerShell -ExecutionPolicy Unrestricted -Command  "New-ItemProperty -Path 'HKCU:\AppEvents\Schemes' -Name '(Default)' -Value '.None' -Force | Out-Null" >> %neptlog%
%currentuser% PowerShell -ExecutionPolicy Unrestricted -Command  "Get-ChildItem -Path 'HKCU:\AppEvents\Schemes\Apps' | Get-ChildItem | Get-ChildItem | Where-Object {$_.PSChildName -eq '.Current'} | Set-ItemProperty -Name '(Default)' -Value ''" >> %neptlog%
:: - > Don't reduce sounds while in a call
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d "3" /f >> %neptlog%

:: Configure Windows 11 File Explorer
if "%os%"=="Windows 11" (
:: - > Restore default context menu
%currentuser% Reg add "HKCU\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /ve /t REG_SZ /d "" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /t REG_SZ /d "" /f >> %neptlog%
:: - > Disable Start Menu Recommendations
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_IrisRecommendations" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Disable Widgets
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Disable Dynamic Lighting
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Lighting" /v "AmbientLightingEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Allign the taskbar to the left
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAl" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Use compact view mode in File Explorer
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseCompactMode" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Hide UWP settings pages
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "hide:home;recovery;autoplay;usb;maps;maps-downloadmaps;findmydevice;privacy;privacy-speechtyping;privacy-speech;privacy-feedback;privacy-activityhistory;search-permissions;privacy-location;privacy-general;sync;printers;cortana-windowssearch;mobile-devices;mobile-devices-addphone;backup;" /f >> %neptlog%
:: - > Hide gallery in File Explorer
%currentuser% Reg add "HKCU\SOFTWARE\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f >> %neptlog%
:: - > Show more pins in start menu
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_Layout" /t REG_DWORD /d "1" /f >> %neptlog%
)


:: - Configuring privacy telemetry, and tracking in Windows.
:: Disable CEIP
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Messenger\Client" /v "CEIP" /t REG_DWORD /d "2" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\AppV\CEIP" /v "CEIPEnable" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Disable CEIP Processes
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\AggregatorHost.exe" /v "Debugger" /t REG_SZ /d "%windir%\System32\taskkill.exe" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\CompatTelRunner.exe" /v "Debugger" /t REG_SZ /d "%WinDir%\System32\taskkill.exe" /f >> %neptlog%

:: Disable Microsoft PC Manager Spread
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FeatureLoader.exe" /v "Debugger" /t REG_SZ /d "%windir%\System32\taskkill.exe" /f >> %neptlog%

:: Disable Windows Feedback
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t Reg_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg delete "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t Reg_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t Reg_DWORD /d "1" /f >> %neptlog%

:: Disable Tagged Energy
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxTagPerApplication" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "DisableTaggedEnergyLogging" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxApplication" /t REG_DWORD /d "0" /f >> %neptlog%

:: Disable Data Collection
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowDeviceNameInTelemetry" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t "REG_DWORD" /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowBuildPreview" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowCommercialDataPipeline" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowDeviceNameInTelemetry" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DisableEnterpriseAuthProxy" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DisableTelemetryOptInChangeNotification" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DisableTelemetryOptInSettingsUx" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitDiagnosticLogCollection" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitDumpCollection" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "MicrosoftEdgeDataOptIn" /t REG_DWORD /d "0" /f >> %neptlog%

:: Disable Advertising Info
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t Reg_DWORD /d "0" /f >> %neptlog%

:: Disable Tailored Experiences
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableTailoredExperiencesWithDiagnosticData" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t Reg_DWORD /d "0" /f >> %neptlog%

:: Disable Health Monitoring
Reg add "HKLM\SOFTWARE\Policies\Microsoft\DeviceHealthAttestationService" /v "EnableDeviceHealthAttestationService" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v "DWNoExternalURL" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v "DWNoFileCollection" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v "DWNoSecondLevelCollection" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\HelpSvc" /v "Headlines" /t REG_DWORD /d "0" /f >> %neptlog%

:: Disable Text/Ink/Handwriting Telemetry
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f >> %neptlog%

:: Disable Error Reporting
Reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultConsent" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultOverrideBehavior" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "AutoApproveOSDumps" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DontShowUI" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\Consent" /v "0" /t REG_SZ /d "" /f >> %neptlog%

:: Disable Application Compatibility Engine
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t Reg_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AllowTelemetry" /t Reg_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableEngine" /t Reg_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t Reg_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t Reg_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t Reg_DWORD /d "1" /f >> %neptlog%

:: Disable Tracing
Reg add "HKLM\SOFTWARE\Microsoft\Tracing" /v "EnableAutoFileTracing" /t Reg_DWORD /d "0" /f  >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Tracing" /v "EnableConsoleTracing" /t Reg_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Tracing" /v "EnableFileTracing" /t Reg_DWORD /d "0" /f >> %neptlog%

:: Disallow the windows message cloud sync service as it can harm privacy
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Messaging" /v "AllowMessageSync" /t REG_DWORD /d "0" /f >> %neptlog%

:: Disable Windows Spotlight
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "ConfigureWindowsSpotlight" /t REG_DWORD /d "2" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableTailoredExperiencesWithDiagnosticData" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableThirdPartySuggestions" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightFeatures" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightOnActionCenter" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightOnSettings" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightWindowsWelcomeExperience" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "IncludeEnterpriseSpotlight" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t REG_DWORD /d "1" /f >> %neptlog%

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
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "%%~a" /t Reg_DWORD /d "0" /f >> %neptlog%
)

:: Disable License Telemetry
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t Reg_DWORD /d "1" /f >> %neptlog%

:: Disable tips in UWP settings
Reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowOnlineTips" /v "value" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllowOnlineTips" /t REG_DWORD /d "0" /f >> %neptlog%

:: Allow Microphone on Server
if "%server%"=="yes" (%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /v "Value" /t Reg_SZ /d "Allow" /f >> %neptlog%)

:: Disable Server Manager from Startup on Server
if "%server%"=="yes" (
	Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Server\ServerManager" /v "DoNotOpenAtLogon" /t REG_DWORD /d "1" /f >> %neptlog%
)

:: Disable Location and Sensors
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocationScripting" /t Reg_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t Reg_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableWindowsLocationProvider" /t Reg_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableSensors" /t Reg_DWORD /d "1" /f >> %neptlog%

:: Disable Location Tracking
Reg add "HKLM\SOFTWARE\Policies\Microsoft\FindMyDevice" /v "AllowFindMyDevice" /t Reg_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\FindMyDevice" /v "LocationSyncEnabled" /t Reg_DWORD /d "0" /f >> %neptlog%

:: Explorer Telemetry
:: - > Clear history of recently opened documents on exit
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ClearRecentDocsOnExit" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Do not track shell shortcuts during roaming
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "LinkResolveIgnoreLinkInfo" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Disable user tracking
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInstrumentation" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Disable internet file association service
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetOpenWith" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Disable low disk space warning
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoLowDiskSpaceChecks" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Do not track history of recently opened documents
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Do not use the search-based method when resolving shell shortcuts
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveSearch" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Do not use the tracking-based method when resolving shell shortcuts
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveTrack" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Do not display or track items in jump lists from remote locations
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoRemoteDestinations" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Disable new app alert
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoNewAppAlert" /t REG_DWORD /d "1" /f >> %neptlog%

:: Track only important failure events
Auditpol /set /subcategory:"Process Termination" /success:disable /failure:enable >> %neptlog%
Auditpol /set /subcategory:"RPC Events" /success:disable /failure:enable >> %neptlog%
Auditpol /set /subcategory:"Filtering Platform Connection" /success:disable /failure:enable >> %neptlog%
Auditpol /set /subcategory:"DPAPI Activity" /success:disable /failure:disable >> %neptlog%
Auditpol /set /subcategory:"IPsec Driver" /success:disable /failure:enable >> %neptlog%
Auditpol /set /subcategory:"Other System Events" /success:disable /failure:enable >> %neptlog%
Auditpol /set /subcategory:"Security State Change" /success:disable /failure:enable >> %neptlog%
Auditpol /set /subcategory:"Security System Extension" /success:disable /failure:enable >> %neptlog%
Auditpol /set /subcategory:"System Integrity" /success:disable /failure:enable >> %neptlog%

:: Disable Sleep Study
wevtutil set-log "Microsoft-Windows-SleepStudy/Diagnostic" /e:false >> %neptlog%
wevtutil set-log "Microsoft-Windows-Kernel-Processor-Power/Diagnostic" /e:false >> %neptlog%
wevtutil set-log "Microsoft-Windows-UserModePowerService/Diagnostic" /e:false >> %neptlog%

:: Disallow microsoft accounts from overriding local accounts
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "NoConnectedUser" /t REG_DWORD /d "1" /f >> %neptlog%

:: Disable Setting Sync
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableApplicationSettingSync" /t REG_DWORD /d "2" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableApplicationSettingSyncUserOverride" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWebBrowserSettingSync" /t REG_DWORD /d "2" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWebBrowserSettingSyncUserOverride" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableDesktopThemeSettingSync" /t REG_DWORD /d "2" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableDesktopThemeSettingSyncUserOverride" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSyncOnPaidNetwork" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWindowsSettingSync" /t REG_DWORD /d "2" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWindowsSettingSyncUserOverride" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableCredentialsSettingSync" /t REG_DWORD /d "2" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableCredentialsSettingSyncUserOverride" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisablePersonalizationSettingSync" /t REG_DWORD /d "2" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisablePersonalizationSettingSyncUserOverride" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableStartLayoutSettingSync" /t REG_DWORD /d "2" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableStartLayoutSettingSyncUserOverride" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t Reg_DWORD /d "5" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t Reg_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\AppSync" /v "Enabled" /t Reg_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t Reg_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t Reg_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\DesktopTheme" /v "Enabled" /t Reg_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t Reg_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\PackageState" /v "Enabled" /t Reg_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t Reg_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\StartLayout" /v "Enabled" /t Reg_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t Reg_DWORD /d "0" /f >> %neptlog%

:: Disable PowerShell Telemetry
:: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_telemetry?view=powershell-7.3
setx POWERSHELL_TELEMETRY_OPTOUT 1 >> %neptlog%

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
%system% Reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\%%a" /v "Start" /t REG_DWORD /d "0" /f >> %neptlog%
)

:: Delete Device Metadata
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /f >> %neptlog% 

:: Disable MSRT Telemetry
Reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\RemovalTools\MpGears" /v "HeartbeatTrackingIndex" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\RemovalTools\MpGears" /v "SpyNetReportingLocation" /t REG_MULTI_SZ /d "" /f >> %neptlog%

:: Disable Telemetry and Program Compatibility Assistant Channels
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Assistant" /v "Enabled" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Assistant/Analytic" /v "Enabled" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Assistant/Compatibility-Infrastructure-Debug" /v "Enabled" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Assistant/Trace" /v "Enabled" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Troubleshooter" /v "Enabled" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Inventory" /v "Enabled" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Telemetry" /v "Enabled" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Steps-Recorder" /v "Enabled" /t REG_DWORD /d "0" /f >> %neptlog%

:: Configure Application Permissions
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t Reg_SZ /d "Deny" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /v "Value" /t Reg_SZ /d "Deny" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t Reg_SZ /d "Deny" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /v "Value" /t Reg_SZ /d "Deny" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /v "Value" /t Reg_SZ /d "Deny" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t Reg_SZ /d "Deny" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /v "Value" /t Reg_SZ /d "Deny" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /v "Value" /t Reg_SZ /d "Deny" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" /v "Value" /t Reg_SZ /d "Deny" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /v "Value" /t Reg_SZ /d "Deny" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /v "Value" /t Reg_SZ /d "Deny" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /v "Value" /t Reg_SZ /d "Deny" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t Reg_SZ /d "Deny" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /v "Value" /t Reg_SZ /d "Deny" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /v "Value" /t Reg_SZ /d "Deny" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /v "Value" /t Reg_SZ /d "Deny" /f >> %neptlog%

:: Disable DCOM
Reg add "HKLM\SOFTWARE\Microsoft\Ole" /v "EnableDCOM" /t REG_SZ /d "N" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Ole" /v "EnableDCOM" /t REG_SZ /d "N" /f >> %neptlog%

:: Disable OLE Logging
Reg add "HKLM\SOFTWARE\Microsoft\Ole" /v "ActivationFailureLoggingLevel" /t REG_DWORD /d "2" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Ole" /v "CallFailureLoggingLevel" /t REG_DWORD /d "2" /f >> %neptlog%

:: Disable RSoP Logging
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "RSoPLogging" /t REG_DWORD /d "0" /f >> %neptlog%

:: Disable ReadyBoost
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\EMDMgmt" /v "GroupPolicyDisallowCaches" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\EMDMgmt" /v "AllowNewCachesByDefault" /t REG_DWORD /d "0" /f >> %neptlog%

:: Disable Internet Addons
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF90-7B36-11D2-B20E-00C04F983E60}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF90-7B36-11D2-B20E-00C04F983E60}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF91-7B36-11D2-B20E-00C04F983E60}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF91-7B36-11D2-B20E-00C04F983E60}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF94-7B36-11D2-B20E-00C04F983E60}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF94-7B36-11D2-B20E-00C04F983E60}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{3050F819-98B5-11CF-BB82-00AA00BDCE0B}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{3050F819-98B5-11CF-BB82-00AA00BDCE0B}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{333C7BC4-460F-11D0-BC04-0080C7055A83}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{333C7BC4-460F-11D0-BC04-0080C7055A83}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{373984C9-B845-449B-91E7-45AC83036ADE}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{373984C9-B845-449B-91E7-45AC83036ADE}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{3E4D4F1C-2AEE-11D1-9D3D-00C04FC30DF6}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{3E4D4F1C-2AEE-11D1-9D3D-00C04FC30DF6}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{435899C9-44AB-11D1-AF00-080036234103}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{435899C9-44AB-11D1-AF00-080036234103}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{4F664F91-FF01-11D0-8AED-00C04FD7B597}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{4F664F91-FF01-11D0-8AED-00C04FD7B597}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{64AB4BB7-111E-11D1-8F79-00C04FC2FBE1}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{64AB4BB7-111E-11D1-8F79-00C04FC2FBE1}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{65303443-AD66-11D1-9D65-00C04FC30DF6}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{65303443-AD66-11D1-9D65-00C04FC30DF6}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{6BF52A52-394A-11D3-B153-00C04F79FAA6}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{6BF52A52-394A-11D3-B153-00C04F79FAA6}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{884E2049-217D-11DA-B2A4-000E7BBB2B09}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{884E2049-217D-11DA-B2A4-000E7BBB2B09}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{884E2051-217D-11DA-B2A4-000E7BBB2B09}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{884E2051-217D-11DA-B2A4-000E7BBB2B09}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A05-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A05-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A06-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A06-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A07-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A07-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A08-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A08-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A0A-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A0A-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{8E4062D9-FE1B-4B9E-AA16-5E8EEF68F48E}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{8E4062D9-FE1B-4B9E-AA16-5E8EEF68F48E}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{92337A8C-E11D-11D0-BE48-00C04FC30DF6}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{92337A8C-E11D-11D0-BE48-00C04FC30DF6}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{C3701884-B39B-11D1-9D68-00C04FC30DF6}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{C3701884-B39B-11D1-9D68-00C04FC30DF6}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{D2517915-48CE-4286-970F-921E881B8C5C}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{D2517915-48CE-4286-970F-921E881B8C5C}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{EE09B103-97E0-11CF-978F-00A02463E06F}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{EE09B103-97E0-11CF-978F-00A02463E06F}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F32-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F32-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F33-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F33-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F34-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F34-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F35-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F35-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F36-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F36-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F39-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F39-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F6D90F12-9C73-11D3-B32E-00C04F990BB4}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F6D90F12-9C73-11D3-B32E-00C04F990BB4}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F6D90F14-9C73-11D3-B32E-00C04F990BB4}" /v "Flags" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F6D90F14-9C73-11D3-B32E-00C04F990BB4}" /v "Version" /t REG_SZ /d "*" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{2933BF90-7B36-11D2-B20E-00C04F983E60}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{2933BF91-7B36-11D2-B20E-00C04F983E60}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{2933BF94-7B36-11D2-B20E-00C04F983E60}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{3050F819-98B5-11CF-BB82-00AA00BDCE0B}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{333C7BC4-460F-11D0-BC04-0080C7055A83}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{373984C9-B845-449B-91E7-45AC83036ADE}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{3E4D4F1C-2AEE-11D1-9D3D-00C04FC30DF6}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{435899C9-44AB-11D1-AF00-080036234103}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{4F664F91-FF01-11D0-8AED-00C04FD7B597}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{64AB4BB7-111E-11D1-8F79-00C04FC2FBE1}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{65303443-AD66-11D1-9D65-00C04FC30DF6}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{6BF52A52-394A-11D3-B153-00C04F79FAA6}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{884E2049-217D-11DA-B2A4-000E7BBB2B09}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{884E2051-217D-11DA-B2A4-000E7BBB2B09}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A05-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A06-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A07-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A08-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A0A-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{8E4062D9-FE1B-4B9E-AA16-5E8EEF68F48E}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{92337A8C-E11D-11D0-BE48-00C04FC30DF6}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{C3701884-B39B-11D1-9D68-00C04FC30DF6}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{D2517915-48CE-4286-970F-921E881B8C5C}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{EE09B103-97E0-11CF-978F-00A02463E06F}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F32-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F33-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F34-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F35-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F36-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F39-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F6D90F12-9C73-11D3-B32E-00C04F990BB4}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F6D90F14-9C73-11D3-B32E-00C04F990BB4}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >> %neptlog%

:: Configuring updates in Windows
:: - > Defer non-critical Windows Updates
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferQualityUpdates" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferQualityUpdatesPeriodInDays" /t REG_DWORD /d "6" /f >> %neptlog%
:: - > Disable Feature Updates as these will break the OS
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferFeatureUpdates" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferFeatureUpdatesPeriodInDays" /t REG_DWORD /d "365" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersion" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Disable Auto Updates
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Prevent DevHome, Outlook and Teams from installing
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler\DevHomeUpdate" /f >> %neptlog% 
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler\OutlookUpdate" /f >> %neptlog% 
%system% Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v "ConfigureChatAutoInstall" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Prevent random apps from installing, including Widgets or advertisements
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\Settings" /v "STOREBIZCRITICALAPPS" /f >> %neptlog% 
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\InstallService\State\CategoryCache" /v "48caba8a"-2e62-2097-dcd8-4255c637b32dUS /f >> %neptlog% 
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "AccountsService" /f >> %neptlog% 
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "BackupBanner" /f >> %neptlog% 
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "DesktopSpotlight" /f >> %neptlog% 
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "IrisService" /f >> %neptlog% 
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "SystemSettingsExtensions" /f >> %neptlog% 
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "WebExperienceHost" /f >> %neptlog% 
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "WindowsBackup" /f >> %neptlog% 
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\LastOnlineScanTimeForAppCategory\855E8A7C-ECB4-4CA3-B045-1DFA50104289" /v "EA6A8EC8-24BF-48A3-B0F0-A86A6447C0E2" /f >> %neptlog% 
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RequestedAppCategories\855E8A7C-ECB4-4CA3-B045-1DFA50104289" /v "EA6A8EC8-24BF-48A3-B0F0-A86A6447C0E2" /f >> %neptlog% 
Reg delete "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\RestrictedServices\AppIso\FirewallRules" /v "{5D2C72C6-969D-4C1E-8484-41ED53782351}" /f >> %neptlog% 
Reg delete "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{26037439-AD8B-4A56-AF2E-F6CDDB59F6BE}" /f >> %neptlog% 
Reg delete "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{44000509-BE9E-419B-A60B-54E62CF41203}" /f >> %neptlog% 
:: - > Prevent Malicious Software Removal Tool from installing
Reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Do not adjust default option to 'Install Updates and Shut Down' in Shut Down Windows dialog box
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAUAsDefaultShutdownOption" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "HideMCTLink" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "SetAutoRestartNotificationDisable" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "RestartNotificationsAllowed2" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "SetUpdateNotificationLevel" /t REG_DWORD /d "2" /f >> %neptlog%
:: - > Make WU not wake up your computer to install updates
:: https://admx.help/?Category=Windows_11_2022&Policy=Microsoft.Policies.WindowsUpdate::AUPowerManagement_Title
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "AUPowerManagement" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Don't auto reboot for updates
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Disable Windows Insider
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ManagePreviewBuilds" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ManagePreviewBuildsPolicyValue" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableConfigFlighting" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableExperimentation" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility" /v "HideInsiderPage" /t REG_DWORD /d "1" /f >> %neptlog%

:: Disable Microsoft Store App Auto-Updates
Reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d "2" /f >> %neptlog%

:: Disable Shared Experiences
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableCdp" /t REG_DWORD /d "0" /f >> %neptlog%

: Disable pre-release features
Reg add "HKLM\Software\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableConfigFlighting" /t REG_DWORD /d "0" /f >> %neptlog%

:: Disable Smart App Control (Fixes slow app loading issues on W11)
Reg add "HKLM\SYSTEM\ControlSet001\Control\CI\Policy" /v "VerifiedAndReputablePolicyState" /t REG_DWORD /d "0" /f >> %neptlog%

:: Disable Services Attempting to register restart every 30 seconds
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "InactivityShutdownDelay" /t REG_DWORD /d "4294967295" /f >> %neptlog%

:: Disable Maintenance
:: Reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f >> %neptlog%

:: Disable Delivery Optimization
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "SystemSettingsDownloadMode" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings" /v "DownloadMode" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "0" /f >> %neptlog%

:: Disable Reserved Storage for Windows Updates
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "MiscPolicyInfo" /t REG_DWORD /d "2" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "PassedPolicy" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "ShippedWithReserves" /t REG_DWORD /d "0" /f >> %neptlog%
DISM /Online /Set-ReservedStorageState /State:Disabled >> %neptlog%

:: Configuring Performance and Latency in Windows
:: - > MMCSS
:: - > Set system responsiveness to 10%
:: https://learn.microsoft.com/en-us/windows/win32/procthread/multimedia-class-scheduler-service#registry-settings
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "10" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /t REG_DWORD /d "10000" /f >> %neptlog%
:: High GPU Priority
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d "8" /f >> %neptlog%
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d "6" /f >> %neptlog%
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >> %neptlog%
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >> %neptlog%
:: Legacy DWORD
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f >> %neptlog%

:: Disable GameBar
%currentuser% Reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Disable GameBar tips
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "GamePanelStartupTipIndex" /t REG_DWORD /d "3" /f >> %neptlog%
:: - > Disable 'Open Xbox Game Bar using this button on a controller'
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Disable Game Bar Presence Writer, required for GameBar
%system% Reg add "HKLM\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter" /v "ActivationType" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Disable Windows Game Recording and Broadcasting
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" /v "value" /t REG_DWORD /d "0" /f >> %neptlog%

:: Disable Wi-Fi Sense
Reg add "HKLM\SOFTWARE\Microsoft\wcmsvc\wifinetworkmanager\config" /v "AutoConnectAllowedOEM" /t REG_DWORD /d 0 /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\wcmsvc\wifinetworkmanager" /v "WifiSenseCredShared" /t REG_DWORD /d 0 /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\wcmsvc\wifinetworkmanager" /v "WifiSenseOpen" /t REG_DWORD /d 0 /f >> %neptlog%

:: Remove FSO Overrides
Reg delete "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" /v "__COMPAT_LAYER" /f >> %neptlog% 
%currentuser% Reg delete "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /f >> %neptlog%
%currentuser% Reg delete "HKCU\System\GameConfigStore" /v "GameDVR_DSEBehavior" /f >> %neptlog%
Reg delete "HKLM\System\GameConfigStore" /f >> %neptlog% 
Reg delete "HKU\.Default\System\GameConfigStore" /f >> %neptlog% 
Reg delete "HKU\S-1-5-19\System\GameConfigStore" /f >> %neptlog% 
Reg delete "HKU\S-1-5-20\System\GameConfigStore" /f >> %neptlog% 
%currentuser% Reg delete "HKCU\Software\Classes\System\GameConfigStore" /f >> %neptlog% 

:: Enable FSO
%currentuser% Reg add HKCU\System\GameConfigStore /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f >> %neptlog%
%currentuser% Reg add HKCU\System\GameConfigStore /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add HKCU\System\GameConfigStore /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add HKCU\System\GameConfigStore /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "0" /f >> %neptlog%

:: Disable FastBoot (HiberBoot)
Reg add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d "0" /f >> %neptlog%

:: Configure Process Priorities
:: - > Origin, ShareX, Epic Games Launcher, Rockstar Launcher, Steam and Open-Shell Processes to Below Normal
for %%i in (OriginWebHelperService.exe ShareX.exe EpicWebHelper.exe SocialClubHelper.exe steamwebhelper.exe StartMenu.exe ) do (
  Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "5" /f >> %neptlog%
)
:: - > fontdrvhost, lsasss, wmiprvse to Low
for %%i in (fontdrvhost.exe lsass.exe WmiPrvSE.exe ) do (
  Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >> %neptlog%
  Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >> %neptlog%
)
:: - > CSRSS and ntoskrnl to Realtime
:: Commented out because these processes need to be elevated to a kernel level in order to change priorities
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >> %neptlog%
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >> %neptlog%
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >> %neptlog%
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >> %neptlog%
:: - > Foreground Priorities
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\I/O System" /v "PassiveIntRealTimeWorkerPriority" /t REG_DWORD /d "18" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\KernelVelocity" /v "DisableFGBoostDecay" /t REG_DWORD /d "1" /f >> %neptlog%
if "%server%"=="yes" (Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "ForceForegroundBoostDecay" /t REG_DWORD /d "0" /f >> %neptlog%)

:: Win32PrioritySeperation (short variable 1:1, no foreground boost)
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f >> %neptlog%

:: Enable Timer Resolution on Windows 11 and Server
if "%os%"=="Windows 11" (Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d "1" /f >> %neptlog%)
if "%server%"=="yes" (Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d "1" /f >> %neptlog%)

:: Disable WatchDog Timer
:: https://www.analog.com/en/design-notes/disable-the-watchdog-timer-during-system-reboot.html
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableSensorWatchdog" /t REG_DWORD /d "1" /f >> %neptlog%

:: Disable Memory Paging
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePageCombining" /t REG_DWORD /d "1" /f >> %neptlog%

:: Graphics Card Scheduling
:: - > Disable V-SYNC Interrupt Control
:: This reduces the amount of V-SYNC monitor refresh interrupts occur
:: https://learn.microsoft.com/en-us/windows-hardware/drivers/display/saving-energy-with-vsync-control
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "VsyncIdleTimeout" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Enable GPU Preemption
:: https://learn.microsoft.com/en-us/windows-hardware/drivers/display/changing-the-behavior-of-the-gpu-scheduler-for-debugging
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "DisablePreemption" /t REG_DWORD /d "0" /f >> %neptlog%
:: - > Force contiguous DirectX memory allocation
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f >> %neptlog%
:: - > Disable GPU Isolation
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "IOMMUFlags" /t REG_DWORD /d "0" /f >> %neptlog%

:: Enable VRR and Windowed Mode Optimizations
%currentuser% Reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "SwapEffectUpgradeEnable=1;" /f >> %neptlog%

:: SVCHOST Split Threshold
Reg add "HKLM\SYSTEM\ControlSet001\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "4294967295" /f >> %neptlog%

:: Increase decomitting memory threshold
Reg add "HKLM\System\CurrentControlSet\Control\Session Manager" /v "HeapDeCommitFreeBlockThreshold" /t REG_DWORD /d "262144" /f >> %neptlog%

:: Disable Exclusive Mode on Audio Devices
for /f "delims=" %%a in ('Reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do %WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 %WinDir%\System32\Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d 0 /f >> %neptlog%
for /f "delims=" %%a in ('Reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do %WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 %WinDir%\System32\Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d 0 /f >> %neptlog%
for /f "delims=" %%a in ('Reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do %WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 %WinDir%\System32\Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d 0 /f >> %neptlog%
for /f "delims=" %%a in ('Reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do %WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 %WinDir%\System32\Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d 0 /f >> %neptlog%

:: Disable Audio Enhancements
for %%a in ("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture", "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render") do (
for /f "delims=" %%b in ('reg query "%%a"') do (
%system% Reg add "%%b\FxProperties" /v "{1da5d803-d492-4edd-8c23-e0c0ffee7f0e},5" /t REG_DWORD /d "1" /f >> %neptlog%
%system% Reg add "%%b\FxProperties" /v "{1b5c2483-0839-4523-ba87-95f89d27bd8c},3" /t REG_BINARY /d "030044CD0100000000000000" /f >> %neptlog%
%system% Reg add "%%b\FxProperties" /v "{73ae880e-8258-4e57-b85f-7daa6b7d5ef0},3" /t REG_BINARY /d "030044CD0100000001000000" /f >> %neptlog%
%system% Reg add "%%b\FxProperties" /v "{9c00eeed-edce-4cd8-ae08-cb05e8ef57a0},3" /t REG_BINARY /d "030044CD0100000004000000" /f >> %neptlog%
%system% Reg add "%%b\FxProperties" /v "{fc52a749-4be9-4510-896e-966ba6525980},3" /t REG_BINARY /d "0B0044CD0100000000000000" /f >> %neptlog%
%system% Reg add "%%b\FxProperties" /v "{ae7f0b2a-96fc-493a-9247-a019f1f701e1},3" /t REG_BINARY /d "0300BC5B0100000001000000" /f >> %neptlog%
%system% Reg add "%%b\FxProperties" /v "{1864a4e0-efc1-45e6-a675-5786cbf3b9f0},4" /t REG_BINARY /d "030044CD0100000000000000" /f >> %neptlog%
%system% Reg add "%%b\FxProperties" /v "{61e8acb9-f04f-4f40-a65f-8f49fab3ba10},4" /t REG_BINARY /d "030044CD0100000050000000" /f >> %neptlog%
%system% Reg add "%%b\Properties" /v "{e4870e26-3cc5-4cd2-ba46-ca0a9a70ed04},0" /t REG_BINARY /d "4100FE6901000000FEFF020080BB000000DC05000800200016002000030000000300000000001000800000AA00389B71" /f >> %neptlog%
%system% Reg add "%%b\Properties" /v "{e4870e26-3cc5-4cd2-ba46-ca0a9a70ed04},1" /t REG_BINARY /d "41008EC901000000A086010000000000" /f >> %neptlog%
%system% Reg add "%%b\Properties" /v "{3d6e1656-2e50-4c4c-8d85-d0acae3c6c68},3" /t REG_BINARY /d "4100020001000000FEFF020080BB000000DC05000800200016002000030000000300000000001000800000AA00389B71" /f >> %neptlog%
%system% Reg delete "%%b\Properties" /v "{624f56de-fd24-473e-814a-de40aacaed16},3" /f >> %neptlog% 
%system% Reg delete "%%b\Properties" /v "{3d6e1656-2e50-4c4c-8d85-d0acae3c6c68},2" /f >> %neptlog% 
)
)


:: Disable WPBT
:: https://github.com/Jamesits/dropWPBT
:: https://download.microsoft.com/download/8/A/2/8A2FB72D-9B96-4E2D-A559-4A27CF905A80/windows-platform-binary-table.docx
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "DisableWpbtExecution" /t REG_DWORD /d "1" /f >> %neptlog%

:: Disable Background Apps
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d "2" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f >> %neptlog%

:: Configuring ease of access settings in Windows
:: Disable Sticky keys, Mouse Keys, Toggle Keys, and other Keyboard Features
%currentuser% Reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Control Panel\Accessibility\MouseKeys" /v "Flags" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_DWORD /d "0" /f >> %neptlog%

:: Disable Pointer Precision
%currentuser% Reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >> %neptlog%

:: Lower Keyboard Repeat Delay / Cursor Blink Rate
%currentuser% Reg add "HKCU\Control Panel\Keyboard" /v "KeyboardDelay" /t REG_SZ /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Control Panel\Keyboard" /v "KeyboardSpeed" /t REG_SZ /d "31" /f >> %neptlog%
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "CursorBlinkRate" /t REG_SZ /d "-1" /f >> %neptlog%

:: MarkC 1:1
:: %currentuser% Reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d 0000000000000000C0CC0C0000000000809919000000000040662600000000000033330000000000 /f >> %neptlog%
:: %currentuser% Reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d 0000000000000000000038000000000000007000000000000000A800000000000000E00000000000 /f >> %neptlog%

:: Configuring Misc Registry
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "ShowedToastAtLevel" /t Reg_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "DiagTrackAuthorization" /t REG_DWORD /d "775" /f >> %neptlog%
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "DiagTrackStatus" /t REG_DWORD /d "2" /f >> %neptlog%
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "UploadPermissionReceived" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\TraceManager" /v "MiniTraceSlotContentPermitted" /t REG_DWORD /d "1" /f >> %neptlog%
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\TraceManager" /v "MiniTraceSlotEnabled" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /t Reg_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t Reg_DWORD /d "0" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t Reg_DWORD /d "0" /f >> %neptlog%
%system% Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Diagnostics\Performance" /v "DisableDiagnosticTracing" /t Reg_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}" /v "ScenarioExecutionEnabled" /t Reg_DWORD /d "0" /f >> %neptlog%

:: Disable RDP
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "fLogonDisabled" /t REG_DWORD /d "1" /f >> %neptlog%

:: Disable Settings Banner
%system% Reg add "HKLM\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\ValueBanner.IdealStateFeatureControlProvider" /v "ActivationType" /t REG_DWORD /d "0" /f >> %neptlog%

:: Disable 'Use my sign-in info to finish setting up this device'
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableAutomaticRestartSignOn" /t REG_DWORD /d "1" /f >> %neptlog%

:: Disable Typing Insights
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Input\Settings" /v "InsightsEnabled" /t REG_DWORD /d "0" /f >> %neptlog%

:: Disable Spell Checking
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableSpellchecking" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableTextPrediction" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnablePredictionSpaceInsertion" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableDoubleTapSpace" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableAutocorrection" /t REG_DWORD /d "0" /f >> %neptlog%

:: Disable Fast User Switching
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "HideFastUserSwitching" /t REG_DWORD /d "1" /f >> %neptlog%

:: Run Startup Scripts Asynchronously
:: https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.Scripts::Run_Startup_Script_Sync
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "RunStartupScriptSync" /t REG_DWORD /d "0" /f >> %neptlog%

:: EULA Accept SysInternals
%currentuser% Reg add "HKCU\Software\Sysinternals\Regjump" /v "EulaAccepted" /t REG_DWORD /d "1" /f >> %neptlog%
goto PerformanceCounters


:PerformanceCounters
cls & echo !S_YELLOW!Rebuilding Performance Counters... [12/18]
lodctr /r >> %neptlog%
lodctr /r >> %neptlog%
goto DebloatWindows


:DebloatWindows
cls & echo !S_YELLOW!Debloating Windows... [13/18]
:: For loop broke on Windows 11, so we're gonna remove each package 1 by 1
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *3DBuilder* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *bing* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *bingfinance* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *bingsports* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *BingWeather* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Clipchamp.Clipchamp* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *CommsPhone* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Drawboard PDF* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Facebook* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Getstarted* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Microsoft.549981C3F5F10* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Microsoft.Cortana* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Microsoft.GamingApp* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Microsoft.GetHelp* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Microsoft.Messaging* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Microsoft.MicrosoftEdge.Stable* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Microsoft.MicrosoftStickyNotes* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Microsoft.OutlookForWindows* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Microsoft.PowerAutomateDesktop* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Microsoft.Todos* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Microsoft.Windows.Photos* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Microsoft.Xbox* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Microsoft.YourPhone* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *MicrosoftCorporationII.QuickAssist* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *MicrosoftOfficeHub* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Office.OneNote* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *OneNote* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *people* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *SkypeApp* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *solit* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Sway* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Twitter* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Windows.DevHome* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *WindowsAlarms* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *WindowsCalculator* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *WindowsCamera* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *WindowsFeedbackHub* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *WindowsMaps* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *WindowsPhone* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *WindowsSoundRecorder* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *WindowsTerminal* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *zune* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Microsoft.Microsoft3DViewer* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Microsoft.MixedReality.Portal* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *ScreenSketch* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Microsoft.Paint* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *MicrosoftCorporationII.MicrosoftFamily* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *MicrosoftTeams* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Microsoft.MSPaint* | Remove-AppxPackage"
%currentuser% PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage *Microsoft.WindowsNotepad* | Remove-AppxPackage"

:: Remove Microsoft Edge Chromium
%currentuser% Powershell -ExecutionPolicy Unrestricted "%WinDir%\NeptuneDir\Scripts\RemoveEdge.ps1" -UninstallEdge -RemoveEdgeData -KeepAppX -NonInteractive >> %neptlog%

:: Remove Content Delivery Manager
%currentuser% PowerShell -NoProfile -NoLogo -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.Windows.ContentDeliveryManager'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1>> %neptlog%'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1>> %neptlog%'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"

:: Prevent Microsoft Teams reinstallation
%system% Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v "ConfigureChatAutoInstall" /t REG_DWORD /d "0" /f >> %neptlog%

:: UWP Immersive Control Panel Debloat
Powershell -ExecutionPolicy Unrestricted "%WinDir%\NeptuneDir\Scripts\CLIENTCBS.ps1"

:: Remove Header in Immersive Control Panel
icacls "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SystemSettingsExtensions.dll" /grant Administrators:F >> %neptlog%
takeown /f "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SystemSettingsExtensions.dll" >> %neptlog% 
%delF% /f /q "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SystemSettingsExtensions.dll" >> %neptlog%

:: Rename SmartScreen
taskkill /f /im smartscreen.exe
cd %WinDir%\System32 >> %neptlog%
takeown /f "smartscreen.exe" >> %neptlog%
icacls "%WinDir%\System32\smartscreen.exe" /grant Administrators:F >> %neptlog%
ren smartscreen.exe smartscreen.old >> %neptlog%

:: Remove MobSync
taskkill /f /im mobsync.exe
cd %WinDir%\System32 >> %neptlog%
takeown /f "mobsync.exe" >> %neptlog%
icacls "%WinDir%\System32\mobsync.exe" /grant Administrators:F >> %neptlog%
ren mobsync.exe mobsync.old >> %neptlog%

:: Remove OneDrive
if exist "C:\" ("%SYSTEMROOT%\System32\OneDriveSetup.exe" /uninstall >> %neptlog%) else ("C:\Windows\SysWOW64\OneDriveSetup.exe" /uninstall >> %neptlog%)

:: Remove OneDrive Startup Task
%currentuser% Reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >> %neptlog% 
%currentuser% Reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f >> %neptlog% 

:: Disable OneDrive Usage
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /t REG_DWORD /v "DisableFileSyncNGSC" /d 1 /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /t REG_DWORD /v "DisableFileSync" /d 1 /f >> %neptlog%


:: Remove Residual Files
setlocal DisableDelayedExpansion
%currentuser% PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%USERPROFILE%\OneDrive'; if (-Not $directoryGlob.EndsWith('\')) { $directoryGlob += '\' }; $directoryGlob )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%LOCALAPPDATA%\Microsoft\OneDrive'; if (-Not $directoryGlob.EndsWith('\')) { $directoryGlob += '\' }; $directoryGlob )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; <# Not using `Get-Acl`/`Set-Acl` to avoid adjusting token privileges #>; $parentDirectory = [System.IO.Path]::GetDirectoryName($expandedPath); $fileName = [System.IO.Path]::GetFileName($expandedPath); if ($parentDirectory -like '*[*?]*') {; throw "^""Unable to grant permissions to glob path parent directory: `"^""$parentDirectory`"^"", wildcards in parent directory are not supported by ``takeown`` and ``icacls``."^""; }; if (($fileName -ne '*') -and ($fileName -like '*[*?]*')) {; throw "^""Unable to grant permissions to glob path file name: `"^""$fileName`"^"", wildcards in file name is not supported by ``takeown`` and ``icacls``."^""; }; Write-Host "^""Taking ownership of `"^""$expandedPath`"^""."^""; $cmdPath = $expandedPath; if ($cmdPath.EndsWith('\')) {; $cmdPath += '\' <# Escape trailing backslash for correct handling in batch commands #>; }; $takeOwnershipCommand = "^""takeown /f `"^""$cmdPath`"^"" /a"^"" <# `icacls /setowner` does not succeed, so use `takeown` instead. #>; if (-not (Test-Path -Path "^""$expandedPath"^"" -PathType Leaf)) {; $takeOwnershipCommand += ' /r /d y'; }; $takeOwnershipOutput = cmd /c "^""$takeOwnershipCommand 2>&1"^"" <# `stderr` message is misleading, e.g. "^""ERROR: The system cannot find the file specified."^"" is not an error. #>; if ($LASTEXITCODE -eq 0) {; Write-Host "^""Successfully took ownership of `"^""$expandedPath`"^"" (using ``$takeOwnershipCommand``)."^""; } else {; Write-Host "^""Did not take ownership of `"^""$expandedPath`"^"" using ``$takeOwnershipCommand``, status code: $LASTEXITCODE, message: $takeOwnershipOutput."^""; <# Do not write as error or warning, because this can be due to missing path, it's handled in next command. #>; <# `takeown` exits with status code `1`, making it hard to handle missing path here. #>; }; Write-Host "^""Granting permissions for `"^""$expandedPath`"^""."^""; $adminSid = New-Object System.Security.Principal.SecurityIdentifier 'S-1-5-32-544'; $adminAccount = $adminSid.Translate([System.Security.Principal.NTAccount]); $adminAccountName = $adminAccount.Value; $grantPermissionsCommand = "^""icacls `"^""$cmdPath`"^"" /grant `"^""$($adminAccountName):F`"^"" /t"^""; $icaclsOutput = cmd /c "^""$grantPermissionsCommand"^""; if ($LASTEXITCODE -eq 3) {; Write-Host "^""Skipping, no items available for deletion according to: ``$grantPermissionsCommand``."^""; exit 0; } elseif ($LASTEXITCODE -ne 0) {; Write-Host "^""Take ownership message:`n$takeOwnershipOutput"^""; Write-Host "^""Grant permissions:`n$icaclsOutput"^""; Write-Warning "^""Failed to assign permissions for `"^""$expandedPath`"^"" using ``$grantPermissionsCommand``, status code: $LASTEXITCODE."^""; } else {; $fileStats = $icaclsOutput | ForEach-Object { $_ -match '\d+' | Out-Null; $matches[0] } | Where-Object { $_ -ne $null } | ForEach-Object { [int]$_ }; if ($fileStats.Count -gt 0 -and ($fileStats | ForEach-Object { $_ -eq 0 } | Where-Object { $_ -eq $false }).Count -eq 0) {; Write-Host "^""Skipping, no items available for deletion according to: ``$grantPermissionsCommand``."^""; exit 0; } else {; Write-Host "^""Successfully granted permissions for `"^""$expandedPath`"^"" (using ``$grantPermissionsCommand``)."^""; }; }; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%PROGRAMDATA%\Microsoft OneDrive'; if (-Not $directoryGlob.EndsWith('\')) { $directoryGlob += '\' }; $directoryGlob )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%SYSTEMDRIVE%\OneDriveTemp'; if (-Not $directoryGlob.EndsWith('\')) { $directoryGlob += '\' }; $directoryGlob )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"

:: Delete OneDrive Shortcuts
PowerShell -ExecutionPolicy Unrestricted -Command "$shortcuts = @(; @{ Revert = $True;  Path = "^""$env:APPDATA\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"^""; }; @{ Revert = $False; Path = "^""$env:USERPROFILE\Links\OneDrive.lnk"^""; }; @{ Revert = $False; Path = "^""$env:WINDIR\ServiceProfiles\LocalService\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"^""; }; @{ Revert = $False; Path = "^""$env:WINDIR\ServiceProfiles\NetworkService\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"^""; }; ); foreach ($shortcut in $shortcuts) {; if (-Not (Test-Path $shortcut.Path)) {; Write-Host "^""Skipping, shortcut does not exist: `"^""$($shortcut.Path)`"^""."^""; continue; }; try {; Remove-Item -Path $shortcut.Path -Force -ErrorAction Stop; Write-Output "^""Successfully removed shortcut: `"^""$($shortcut.Path)`"^""."^""; } catch {; Write-Error "^""Encountered an issue while attempting to remove shortcut at: `"^""$($shortcut.Path)`"^""."^""; }; }" >> %neptlog%
%currentuser% PowerShell -ExecutionPolicy Unrestricted -Command "Set-Location "^""HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace"^""; Get-ChildItem | ForEach-Object {Get-ItemProperty $_.pspath} | ForEach-Object {; $leftnavNodeName = $_."^""(default)"^"";; if (($leftnavNodeName -eq "^""OneDrive"^"") -Or ($leftnavNodeName -eq "^""OneDrive - Personal"^"")) {; if (Test-Path $_.pspath) {; Write-Host "^""Deleting $($_.pspath)."^""; Remove-Item $_.pspath;; }; }; }" >> %neptlog%
goto ConfigureFeatures


:ConfigureFeatures
setlocal EnableDelayedExpansion
cls & echo !S_YELLOW!Configuring Windows Features and Capabilities... [14/18]
:: Features and Components
:: Enable DirectPlay
dism /Online /Enable-Feature /FeatureName:"LegacyComponents" /NoRestart >> %neptlog%
dism /Online /Enable-Feature /FeatureName:"DirectPlay" /NoRestart >> %neptlog%
:: Disable Hyper-V
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-All" /NoRestart >> %neptlog%
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Management-Clients" /NoRestart >> %neptlog%
:: Disable Hyper-V Management Tools
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Tools-All" /NoRestart >> %neptlog%
:: Disable Hyper-V Module for Windows PowerShell
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Management-PowerShell" /NoRestart >> %neptlog%
:: Disable Telnet Client
dism /Online /Disable-Feature /FeatureName:"TelnetClient" /NoRestart >> %neptlog%
:: Disable Net.TCP Port Sharing
dism /Online /Disable-Feature /FeatureName:"WCF-TCP-PortSharing45" /NoRestart >> %neptlog%
:: Disable SMB Direct
dism /Online /Disable-Feature /FeatureName:"SmbDirect" /NoRestart >> %neptlog%
:: Disable SMB1 Protocol
dism /online /Disable-Feature /FeatureName:"SMB1Protocol" /NoRestart >> %neptlog%
dism /Online /Disable-Feature /FeatureName:"SMB1Protocol-Client" /NoRestart >> %neptlog%
dism /Online /Disable-Feature /FeatureName:"SMB1Protocol-Server" /NoRestart >> %neptlog%
:: Disable TFTP Client
dism /Online /Disable-Feature /FeatureName:"TFTP" /NoRestart >> %neptlog%
:: Disable Internet Printing Client
dism /Online /Disable-Feature /FeatureName:"Printing-Foundation-InternetPrinting-Client" /NoRestart >> %neptlog%
:: Disable LPD Print Service
dism /Online /Disable-Feature /FeatureName:"LPDPrintService" /NoRestart >> %neptlog%
:: Disable Internet Explorer
dism /Online /Disable-Feature /FeatureName:"Internet-Explorer-Optional-x64" /NoRestart >> %neptlog%
dism /Online /Disable-Feature /FeatureName:"Internet-Explorer-Optional-x84" /NoRestart >> %neptlog%
dism /Online /Disable-Feature /FeatureName:"Internet-Explorer-Optional-amd64" /NoRestart >> %neptlog%
:: Disable LPR Port Monitor
dism /Online /Disable-Feature /FeatureName:"Printing-Foundation-LPRPortMonitor" /NoRestart >> %neptlog%
:: Disable Microsoft Print to PDF
dism /Online /Disable-Feature /FeatureName:"Printing-PrintToPDFServices-Features" /NoRestart >> %neptlog%
:: Disable "PS Services
dism /Online /Disable-Feature /FeatureName:"Printing-XPSServices-Features" /NoRestart >> %neptlog%
:: Disable XPS Viewer
dism /Online /Disable-Feature /FeatureName:"Xps-Foundation-Xps-Viewer" /NoRestart >> %neptlog%
:: Disable Print and Document Services
dism /Online /Disable-Feature /FeatureName:"Printing-Foundation-Features" /NoRestart >> %neptlog%
:: Disable Work Folders Client
dism /Online /Disable-Feature /FeatureName:"WorkFolders-Client" /NoRestart >> %neptlog%
:: Disable Windows Media Player
dism /Online /Disable-Feature /FeatureName:"MediaPlayback" /NoRestart >> %neptlog%
dism /Online /Disable-Feature /FeatureName:"WindowsMediaPlayer" /NoRestart >> %neptlog%
:: Disable "Scan Management" feature
dism /Online /Disable-Feature /FeatureName:"ScanManagementConsole" /NoRestart >> %neptlog%
:: Disable "Windows Fax and Scan" feature
dism /Online /Disable-Feature /FeatureName:"FaxServicesClientPackage" /NoRestart >> %neptlog%
:: Disable PowerShell V2
dism /Online /Disable-Feature /FeatureName:"MicrosoftWindowsPowerShellV2Root" /NoRestart >> %neptlog%
:: Disable Remote Differential Compression
dism /Online /Disable-Feature /FeatureName:"MSRDC-Infrastructure" /NoRestart >> %neptlog%
:: Disable WCF Services
dism /Online /Disable-Feature /FeatureName:"WCF-Services45" /NoRestart >> %neptlog%
:: Disable Remote Desktop Connection
dism /Online /Disable-Feature /FeatureName:"Microsoft-RemoteDesktopConnection" /NoRestart >> %neptlog%


:: Capabilities
:: Remove "Internet Explorer 11
%PowerShell% "Get-WindowsCapability -Online -Name 'Browser.InternetExplorer*' | Remove-WindowsCapability -Online" >> %neptlog%
:: Remove Math Recognizer
%PowerShell% "Get-WindowsCapability -Online -Name 'MathRecognizer~~~~0.0.1.0*' | Remove-WindowsCapability -Online" >> %neptlog%
:: Remove "OneSync" (breaks Mail, People, and Calendar)
%PowerShell% "Get-WindowsCapability -Online -Name 'OneCoreUAP.OneSync*' | Remove-WindowsCapability -Online" >> %neptlog%
:: Remove OpenSSH client
%PowerShell% "Get-WindowsCapability -Online -Name 'OpenSSH.Client*' | Remove-WindowsCapability -Online" >> %neptlog%
:: Remove PowerShell ISE
%PowerShell% "Get-WindowsCapability -Online -Name 'Microsoft.Windows.PowerShell.ISE*' | Remove-WindowsCapability -Online" >> %neptlog%
:: Remove Print Management Console
%PowerShell% "Get-WindowsCapability -Online -Name 'Print.Management.Console*' | Remove-WindowsCapability -Online" >> %neptlog%
:: Remove Quick Assist
%PowerShell% "Get-WindowsCapability -Online -Name 'App.Support.QuickAssist*' | Remove-WindowsCapability -Online" >> %neptlog%
:: Remove Steps Recorder
%PowerShell% "Get-WindowsCapability -Online -Name 'App.StepsRecorder*' | Remove-WindowsCapability -Online" >> %neptlog%
:: Remove Windows Fax and Scan
%PowerShell% "Get-WindowsCapability -Online -Name 'Print.Fax.Scan*' | Remove-WindowsCapability -Online" >> %neptlog%
:: Remove Hello Face
%PowerShell% "Get-WindowsCapability -Online -Name 'Hello.Face.20134~~~~0.0.1.0*' | Remove-WindowsCapability -Online" >> %neptlog%
:: Remove WordPad
%PowerShell% "Get-WindowsCapability -Online -Name 'Microsoft.Windows.WordPad~~~~0.0.1.0*' | Remove-WindowsCapability -Online" >> %neptlog%
:: Remove Extended Wallpapers
%PowerShell% "Get-WindowsCapability -Online -Name 'Microsoft.Wallpapers.Extended~~~~0.0.1.0*' | Remove-WindowsCapability -Online" >> %neptlog%

:: UWP Deprovision
for %%a in (1527c705-839a-4832-9118-54d4Bd6a0c89_cw5n1h2txyewy Microsoft.3DBuilder_8wekyb3d8bbwe Microsoft.BingFinance_8wekyb3d8bbwe Microsoft.BingNews_8wekyb3d8bbwe Microsoft.BingSports_8wekyb3d8bbwe Microsoft.BingWeather_8wekyb3d8bbwe
Microsoft.Microsoft3DViewer_8wekyb3d8bbwe Microsoft.MicrosoftEdge_8wekyb3d8bbwe Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe Microsoft.Office.OneNote_8wekyb3d8bbwe Microsoft.Office.Sway_8wekyb3d8bbwe
Microsoft.StorePurchaseApp_8wekyb3d8bbwe Microsoft.Windows.CloudExperienceHost_cw5n1h2txyewy Microsoft.Windows.Phone_8wekyb3d8bbwe Microsoft.WindowsPhone_8wekyb3d8bbwe Microsoft.WindowsStore_8wekyb3d8bbwe Microsoft.Xbox.TCUI_8wekyb3d8bbwe
Microsoft.XboxApp_8wekyb3d8bbwe Microsoft.XboxGameOverlay_8wekyb3d8bbwe Microsoft.XboxGamingOverlay_8wekyb3d8bbwe Microsoft.XboxIdentityProvider_8wekyb3d8bbwe Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe 
Microsoft.MicrosoftTeams_8wekyb3d8bbwe) do Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\%%a" /f >> %neptlog%
goto PrerequisitesInstallation


:PrerequisitesInstallation
cls & echo !S_YELLOW!Installing Visual C++... [15/18]
"%WinDir%\NeptuneDir\Prerequisites\vcredist.exe" /ai8X239T >> %neptlog%

cls & echo !S_YELLOW!Installing DirectX... [16/18]
"%WinDir%\NeptuneDir\Prerequisites\DirectX\DXSETUP.exe" /silent >> %neptlog%

cls & echo !S_YELLOW!Installing 7-Zip... [17/18]
"%WinDir%\NeptuneDir\Prerequisites\7z.exe" /S  >> %neptlog%
setlocal DisableDelayedExpansion

:: Context Menu Options
%currentuser% Reg add "HKCU\Software\7-Zip\FM\Columns" /v "RootFolder" /t REG_BINARY /d "0100000000000000010000000400000001000000A0000000" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\7-Zip\Options" /v "ElimDupExtract" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\7-Zip\Options" /v "ContextMenu" /t REG_DWORD /d "4100" /f >> %neptlog%
Reg add "HKU\%SID%\SOFTWARE\7-Zip\Options" /v "ContextMenu" /t REG_DWORD /d "1073746726" /f
:: File Assoc
Reg add "HKU\%SID%\SOFTWARE\Classes\.001" /ve /t REG_SZ /d "7-Zip.001" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.7z" /ve /t REG_SZ /d "7-Zip.7z" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.apfs" /ve /t REG_SZ /d "7-Zip.apfs" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.arj" /ve /t REG_SZ /d "7-Zip.arj" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.bz2" /ve /t REG_SZ /d "7-Zip.bz2" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.bzip2" /ve /t REG_SZ /d "7-Zip.bzip2" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.cab" /ve /t REG_SZ /d "7-Zip.cab" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.cpio" /ve /t REG_SZ /d "7-Zip.cpio" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.deb" /ve /t REG_SZ /d "7-Zip.deb" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.dmg" /ve /t REG_SZ /d "7-Zip.dmg" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.esd" /ve /t REG_SZ /d "7-Zip.esd" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.fat" /ve /t REG_SZ /d "7-Zip.fat" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.gz" /ve /t REG_SZ /d "7-Zip.gz" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.gzip" /ve /t REG_SZ /d "7-Zip.gzip" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.hfs" /ve /t REG_SZ /d "7-Zip.hfs" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.iso" /ve /t REG_SZ /d "7-Zip.iso" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.lha" /ve /t REG_SZ /d "7-Zip.lha" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.lzh" /ve /t REG_SZ /d "7-Zip.lzh" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.lzma" /ve /t REG_SZ /d "7-Zip.lzma" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.ntfs" /ve /t REG_SZ /d "7-Zip.ntfs" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.rar" /ve /t REG_SZ /d "7-Zip.rar" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.rpm" /ve /t REG_SZ /d "7-Zip.rpm" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.squashfs" /ve /t REG_SZ /d "7-Zip.squashfs" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.swm" /ve /t REG_SZ /d "7-Zip.swm" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.tar" /ve /t REG_SZ /d "7-Zip.tar" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.taz" /ve /t REG_SZ /d "7-Zip.taz" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.tbz" /ve /t REG_SZ /d "7-Zip.tbz" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.tbz2" /ve /t REG_SZ /d "7-Zip.tbz2" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.tgz" /ve /t REG_SZ /d "7-Zip.tgz" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.tpz" /ve /t REG_SZ /d "7-Zip.tpz" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.txz" /ve /t REG_SZ /d "7-Zip.txz" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.vhd" /ve /t REG_SZ /d "7-Zip.vhd" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.vhdx" /ve /t REG_SZ /d "7-Zip.vhdx" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.wim" /ve /t REG_SZ /d "7-Zip.wim" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.xar" /ve /t REG_SZ /d "7-Zip.xar" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.xz" /ve /t REG_SZ /d "7-Zip.xz" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.z" /ve /t REG_SZ /d "7-Zip.z" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\.zip" /ve /t REG_SZ /d "7-Zip.zip" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.001" /ve /t REG_SZ /d "001 Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.001\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,9" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.001\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.001\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.001\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.7z" /ve /t REG_SZ /d "7z Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.7z\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,0" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.7z\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.7z\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.7z\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.apfs" /ve /t REG_SZ /d "apfs Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.apfs\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,25" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.apfs\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.apfs\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.apfs\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.arj" /ve /t REG_SZ /d "arj Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.arj\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,4" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.arj\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.arj\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.arj\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.bz2" /ve /t REG_SZ /d "bz2 Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.bz2\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,2" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.bz2\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.bz2\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.bz2\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.bzip2" /ve /t REG_SZ /d "bzip2 Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.bzip2\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,2" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.bzip2\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.bzip2\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.bzip2\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.cab" /ve /t REG_SZ /d "cab Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.cab\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,7" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.cab\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.cab\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.cab\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.cpio" /ve /t REG_SZ /d "cpio Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.cpio\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,12" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.cpio\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.cpio\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.cpio\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.deb" /ve /t REG_SZ /d "deb Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.deb\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,11" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.deb\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.deb\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.deb\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.dmg" /ve /t REG_SZ /d "dmg Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.dmg\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,17" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.dmg\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.dmg\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.dmg\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.esd" /ve /t REG_SZ /d "esd Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.esd\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,15" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.esd\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.esd\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.esd\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.fat" /ve /t REG_SZ /d "fat Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.fat\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,21" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.fat\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.fat\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.fat\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.gz" /ve /t REG_SZ /d "gz Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.gz\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,14" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.gz\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.gz\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.gz\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.gzip" /ve /t REG_SZ /d "gzip Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.gzip\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,14" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.gzip\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.gzip\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.gzip\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.hfs" /ve /t REG_SZ /d "hfs Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.hfs\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,18" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.hfs\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.hfs\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.hfs\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.iso" /ve /t REG_SZ /d "iso Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.iso\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,8" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.iso\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.iso\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.iso\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lha" /ve /t REG_SZ /d "lha Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lha\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,6" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lha\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lha\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lha\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lzh" /ve /t REG_SZ /d "lzh Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lzh\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,6" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lzh\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lzh\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lzh\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lzma" /ve /t REG_SZ /d "lzma Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lzma\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,16" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lzma\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lzma\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.lzma\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.ntfs" /ve /t REG_SZ /d "ntfs Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.ntfs\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,22" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.ntfs\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.ntfs\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.ntfs\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.rar" /ve /t REG_SZ /d "rar Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.rar\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,3" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.rar\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.rar\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.rar\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.rpm" /ve /t REG_SZ /d "rpm Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.rpm\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,10" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.rpm\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.rpm\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.rpm\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.squashfs" /ve /t REG_SZ /d "squashfs Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.squashfs\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,24" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.squashfs\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.squashfs\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.squashfs\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.swm" /ve /t REG_SZ /d "swm Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.swm\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,15" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.swm\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.swm\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.swm\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tar" /ve /t REG_SZ /d "tar Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tar\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,13" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tar\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tar\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tar\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.taz" /ve /t REG_SZ /d "taz Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.taz\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,5" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.taz\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.taz\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.taz\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tbz" /ve /t REG_SZ /d "tbz Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tbz2" /ve /t REG_SZ /d "tbz2 Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tbz2\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,2" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tbz2\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tbz2\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tbz2\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tbz\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,2" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tbz\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tbz\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tbz\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tgz" /ve /t REG_SZ /d "tgz Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tgz\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,14" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tgz\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tgz\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tgz\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tpz" /ve /t REG_SZ /d "tpz Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tpz\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,14" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tpz\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tpz\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.tpz\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.txz" /ve /t REG_SZ /d "txz Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.txz\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,23" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.txz\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.txz\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.txz\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.vhd" /ve /t REG_SZ /d "vhd Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.vhd\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,20" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.vhd\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.vhd\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.vhd\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.vhdx" /ve /t REG_SZ /d "vhdx Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.vhdx\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,20" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.vhdx\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.vhdx\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.vhdx\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.wim" /ve /t REG_SZ /d "wim Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.wim\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,15" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.wim\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.wim\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.xz\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.xz\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.z" /ve /t REG_SZ /d "z Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.z\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,5" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.z\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.z\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.z\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.zip" /ve /t REG_SZ /d "zip Archive" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.zip\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,1" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.zip\shell" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.zip\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKU\%SID%\SOFTWARE\Classes\7-Zip.zip\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\.001" /ve /t REG_SZ /d "7-Zip.001" /f
Reg add "HKLM\SOFTWARE\Classes\.7z" /ve /t REG_SZ /d "7-Zip.7z" /f
Reg add "HKLM\SOFTWARE\Classes\.apfs" /ve /t REG_SZ /d "7-Zip.apfs" /f
Reg add "HKLM\SOFTWARE\Classes\.arj" /ve /t REG_SZ /d "7-Zip.arj" /f
Reg add "HKLM\SOFTWARE\Classes\.bz2" /ve /t REG_SZ /d "7-Zip.bz2" /f
Reg add "HKLM\SOFTWARE\Classes\.bzip2" /ve /t REG_SZ /d "7-Zip.bzip2" /f
Reg add "HKLM\SOFTWARE\Classes\.cab" /ve /t REG_SZ /d "7-Zip.cab" /f
Reg add "HKLM\SOFTWARE\Classes\.cpio" /ve /t REG_SZ /d "7-Zip.cpio" /f
Reg add "HKLM\SOFTWARE\Classes\.deb" /ve /t REG_SZ /d "7-Zip.deb" /f
Reg add "HKLM\SOFTWARE\Classes\.dmg" /ve /t REG_SZ /d "7-Zip.dmg" /f
Reg add "HKLM\SOFTWARE\Classes\.esd" /ve /t REG_SZ /d "7-Zip.esd" /f
Reg add "HKLM\SOFTWARE\Classes\.fat" /ve /t REG_SZ /d "7-Zip.fat" /f
Reg add "HKLM\SOFTWARE\Classes\.gz" /ve /t REG_SZ /d "7-Zip.gz" /f
Reg add "HKLM\SOFTWARE\Classes\.gzip" /ve /t REG_SZ /d "7-Zip.gzip" /f
Reg add "HKLM\SOFTWARE\Classes\.hfs" /ve /t REG_SZ /d "7-Zip.hfs" /f
Reg add "HKLM\SOFTWARE\Classes\.iso" /ve /t REG_SZ /d "7-Zip.iso" /f
Reg add "HKLM\SOFTWARE\Classes\.lha" /ve /t REG_SZ /d "7-Zip.lha" /f
Reg add "HKLM\SOFTWARE\Classes\.lzh" /ve /t REG_SZ /d "7-Zip.lzh" /f
Reg add "HKLM\SOFTWARE\Classes\.lzma" /ve /t REG_SZ /d "7-Zip.lzma" /f
Reg add "HKLM\SOFTWARE\Classes\.ntfs" /ve /t REG_SZ /d "7-Zip.ntfs" /f
Reg add "HKLM\SOFTWARE\Classes\.rar" /ve /t REG_SZ /d "7-Zip.rar" /f
Reg add "HKLM\SOFTWARE\Classes\.rpm" /ve /t REG_SZ /d "7-Zip.rpm" /f
Reg add "HKLM\SOFTWARE\Classes\.squashfs" /ve /t REG_SZ /d "7-Zip.squashfs" /f
Reg add "HKLM\SOFTWARE\Classes\.swm" /ve /t REG_SZ /d "7-Zip.swm" /f
Reg add "HKLM\SOFTWARE\Classes\.tar" /ve /t REG_SZ /d "7-Zip.tar" /f
Reg add "HKLM\SOFTWARE\Classes\.taz" /ve /t REG_SZ /d "7-Zip.taz" /f
Reg add "HKLM\SOFTWARE\Classes\.tbz" /ve /t REG_SZ /d "7-Zip.tbz" /f
Reg add "HKLM\SOFTWARE\Classes\.tbz2" /ve /t REG_SZ /d "7-Zip.tbz2" /f
Reg add "HKLM\SOFTWARE\Classes\.tgz" /ve /t REG_SZ /d "7-Zip.tgz" /f
Reg add "HKLM\SOFTWARE\Classes\.tpz" /ve /t REG_SZ /d "7-Zip.tpz" /f
Reg add "HKLM\SOFTWARE\Classes\.txz" /ve /t REG_SZ /d "7-Zip.txz" /f
Reg add "HKLM\SOFTWARE\Classes\.vhd" /ve /t REG_SZ /d "7-Zip.vhd" /f
Reg add "HKLM\SOFTWARE\Classes\.vhdx" /ve /t REG_SZ /d "7-Zip.vhdx" /f
Reg add "HKLM\SOFTWARE\Classes\.wim" /ve /t REG_SZ /d "7-Zip.wim" /f
Reg add "HKLM\SOFTWARE\Classes\.xar" /ve /t REG_SZ /d "7-Zip.xar" /f
Reg add "HKLM\SOFTWARE\Classes\.xz" /ve /t REG_SZ /d "7-Zip.xz" /f
Reg add "HKLM\SOFTWARE\Classes\.z" /ve /t REG_SZ /d "7-Zip.z" /f
Reg add "HKLM\SOFTWARE\Classes\.zip" /ve /t REG_SZ /d "7-Zip.zip" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.001" /ve /t REG_SZ /d "001 Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.001\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,9" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.001\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.001\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.001\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.7z" /ve /t REG_SZ /d "7z Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.7z\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,0" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.7z\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.7z\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.7z\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.apfs" /ve /t REG_SZ /d "apfs Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.apfs\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,25" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.apfs\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.apfs\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.apfs\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.arj" /ve /t REG_SZ /d "arj Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.arj\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,4" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.arj\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.arj\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.arj\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.bz2" /ve /t REG_SZ /d "bz2 Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.bz2\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,2" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.bz2\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.bz2\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.bz2\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.bzip2" /ve /t REG_SZ /d "bzip2 Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.bzip2\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,2" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.bzip2\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.bzip2\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.bzip2\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.cab" /ve /t REG_SZ /d "cab Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.cab\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,7" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.cab\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.cab\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.cab\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.cpio" /ve /t REG_SZ /d "cpio Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.cpio\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,12" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.cpio\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.cpio\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.cpio\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.deb" /ve /t REG_SZ /d "deb Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.deb\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,11" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.deb\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.deb\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.deb\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.dmg" /ve /t REG_SZ /d "dmg Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.dmg\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,17" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.dmg\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.dmg\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.dmg\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.esd" /ve /t REG_SZ /d "esd Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.esd\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,15" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.esd\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.esd\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.esd\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.fat" /ve /t REG_SZ /d "fat Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.fat\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,21" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.fat\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.fat\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.fat\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.gz" /ve /t REG_SZ /d "gz Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.gz\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,14" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.gz\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.gz\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.gz\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.gzip" /ve /t REG_SZ /d "gzip Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.gzip\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,14" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.gzip\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.gzip\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.gzip\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.hfs" /ve /t REG_SZ /d "hfs Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.hfs\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,18" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.hfs\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.hfs\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.hfs\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.iso" /ve /t REG_SZ /d "iso Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.iso\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,8" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.iso\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.iso\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.iso\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.lha" /ve /t REG_SZ /d "lha Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.lha\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,6" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.lha\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.lha\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.lha\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.lzh" /ve /t REG_SZ /d "lzh Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.lzh\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,6" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.lzh\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.lzh\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.lzh\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.lzma" /ve /t REG_SZ /d "lzma Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.lzma\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,16" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.lzma\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.lzma\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.lzma\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.ntfs" /ve /t REG_SZ /d "ntfs Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.ntfs\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,22" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.ntfs\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.ntfs\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.ntfs\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.rar" /ve /t REG_SZ /d "rar Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.rar\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,3" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.rar\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.rar\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.rar\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.rpm" /ve /t REG_SZ /d "rpm Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.rpm\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,10" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.rpm\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.rpm\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.rpm\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.squashfs" /ve /t REG_SZ /d "squashfs Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.squashfs\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,24" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.squashfs\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.squashfs\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.squashfs\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.swm" /ve /t REG_SZ /d "swm Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.swm\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,15" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.swm\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.swm\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.swm\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tar" /ve /t REG_SZ /d "tar Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tar\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,13" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tar\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tar\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tar\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.taz" /ve /t REG_SZ /d "taz Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.taz\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,5" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.taz\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.taz\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.taz\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz" /ve /t REG_SZ /d "tbz Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz2" /ve /t REG_SZ /d "tbz2 Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz2\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,2" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz2\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz2\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz2\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,2" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tgz" /ve /t REG_SZ /d "tgz Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tgz\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,14" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tgz\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tgz\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tgz\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tpz" /ve /t REG_SZ /d "tpz Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tpz\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,14" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tpz\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tpz\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.tpz\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.txz" /ve /t REG_SZ /d "txz Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.txz\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,23" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.txz\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.txz\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.txz\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.vhd" /ve /t REG_SZ /d "vhd Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.vhd\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,20" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.vhd\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.vhd\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.vhd\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.vhdx" /ve /t REG_SZ /d "vhdx Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.vhdx\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,20" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.vhdx\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.vhdx\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.vhdx\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.wim" /ve /t REG_SZ /d "wim Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.wim\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,15" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.wim\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.wim\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.wim\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.xar" /ve /t REG_SZ /d "xar Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.xar\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,19" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.xar\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.xar\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.xar\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.xz" /ve /t REG_SZ /d "xz Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.xz\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,23" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.xz\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.xz\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.xz\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.z" /ve /t REG_SZ /d "z Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.z\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,5" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.z\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.z\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.z\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.zip" /ve /t REG_SZ /d "zip Archive" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.zip\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\7-Zip\7z.dll,1" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.zip\shell" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.zip\shell\open" /ve /t REG_SZ /d "" /f
Reg add "HKLM\SOFTWARE\Classes\7-Zip.zip\shell\open\command" /ve /t REG_SZ /d "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts.zip\UserChoice" /v "Hash" /t REG_SZ /d "UfO2BmgRhuY=" /f
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts.zip\UserChoice" /v "ProgId" /t REG_SZ /d "7-Zip.zip" /f

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
"%WinDir%\NeptuneDir\Prerequisites\openshell.exe" /qn ADDLOCAL=StartMenu >> %neptlog%

cls & echo !S_YELLOW!Configuring Open Shell
%currentuser% Reg add "HKCU\Software\OpenShell\StartMenu" /v "ShowedStyle2" /t REG_DWORD /d "2" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "Version" /t REG_DWORD /d "67371150" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkipMetro" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "MenuStyle" /t REG_SZ /d "Win7" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "ProgramsMenuDelay" /t REG_DWORD /d "99999999" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "StartScreenShortcut" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkinW7" /t REG_SZ /d "" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkinVariationW7" /t REG_SZ /d "" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkinOptionsW7" /t REG_MULTI_SZ /d "USER_IMAGE=1\0SMALL_ICONS=1\0THICK_BORDER=0\0SOLID_SELECTION=0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "MenuItems7" /t REG_MULTI_SZ /d "Item1.Command=user_files\0Item1.Settings=NOEXPAND\0Item2.Command=user_documents\0Item2.Settings=NOEXPAND\0Item3.Command=user_pictures\0Item3.Settings=NOEXPAND\0Item4.Command=user_music\0Item4.Settings=NOEXPAND\0Item5.Command=user_videos\0Item5.Settings=ITEM_DISABLED\0Item6.Command=downloads\0Item6.Settings=ITEM_DISABLED\0Item7.Command=homegroup\0Item7.Settings=ITEM_DISABLED\0Item8.Command=separator\0Item9.Command=games\0Item9.Settings=TRACK_RECENT|NOEXPAND|ITEM_DISABLED\0Item10.Command=favorites\0Item10.Settings=ITEM_DISABLED\0Item11.Command=computer\0Item11.Settings=NOEXPAND\0Item12.Command=downloads\0Item12.Settings=NOEXPAND\0Item13.Command=network\0Item13.Settings=ITEM_DISABLED\0Item14.Command=network_connections\0Item14.Settings=ITEM_DISABLED\0Item15.Command=separator\0Item16.Command=control_panel\0Item16.Settings=TRACK_RECENT|NOEXPAND\0Item17.Command=pc_settings\0Item17.Settings=TRACK_RECENT\0Item18.Command=admin\0Item18.Settings=TRACK_RECENT|ITEM_DISABLED\0Item19.Command=devmgmt.msc\0Item19.Label=Device Manager\0Item19.Icon=C:\Windows\system32\devmgr.dll, 201\0Item19.Settings=NOEXPAND\0Item20.Command=defaults\0Item20.Settings=ITEM_DISABLED\0Item21.Command=help\0Item21.Settings=ITEM_DISABLED\0Item22.Command=run\0Item23.Command=apps\0Item23.Settings=ITEM_DISABLED\0Item24.Command=windows_security\0Item24.Settings=ITEM_DISABLED" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "ShiftRight" /t REG_DWORD /d "1" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "RecentPrograms" /t REG_SZ /d "None" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchTrack" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchAutoComplete" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchInternet" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "MainMenuAnimate" /t REG_DWORD /d "0" /f >> %neptlog%
%currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "FontSmoothing" /t REG_SZ /d "Default" /f >> %neptlog%
move "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Open-Shell\Open-Shell Menu Settings.lnk" "%WinDir%\NeptuneDir\Neptune\3. Configuration\Start Menu" >> %neptlog%
rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Open-Shell" >> %neptlog%

:: Disable default start menu
cd C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy >> %neptlog%
takeown /f "StartMenuExperienceHost.exe" >> %neptlog%
icacls "C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\StartMenuExperienceHost.exe" /grant Administrators:F >> %neptlog%
ren StartMenuExperienceHost.exe StartMenuExperienceHost.old >> %neptlog%
taskkill /f /im searchapp.exe >> %neptlog%
taskkill /f /im SearchHost.exe >> %neptlog%
taskkill /f /im StartMenuExperienceHost.exe >> %neptlog%
cd C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy >> %neptlog%
takeown /f "searchapp.exe" >> %neptlog%
icacls "C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\searchapp.exe" /grant Administrators:F >> %neptlog%
ren searchapp.exe searchapp.old >> %neptlog%
cd C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy >> %neptlog%
icacls "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe" /grant Administrators:F >> %neptlog%
takeown /f "SearchHost.exe" >> %neptlog%
ren SearchHost.exe SearchHost.old >> %neptlog%
taskkill /f /im TextInputHost.exe
takeown /f "TextInputHost.exe" >> %neptlog%
icacls "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\TextInputHost.exe" /grant Administrators:F >> %neptlog%
ren TextInputHost.exe TextInputHost.old >> %neptlog%
)
goto PartingPhase


:PartingPhase
cls & echo !S_YELLOW!Finalizing Setup 
:: Set Lockscreen
%currentuser% Powershell -ExecutionPolicy Unrestricted "%WinDir%\NeptuneDir\Scripts\lockscreen.ps1"

:: Remove Start Menu Pins
copy /y "%WinDir%\Layout.xml" "%userProfile%\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml" >> %neptlog%
%delF% "%userProfile%\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start.bin" >> %neptlog%
%delF% "%userProfile%\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start2.bin" >> %neptlog%

:: Set notice text
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticecaption" /t REG_SZ /d "Welcome to NeptuneOS %version%. A custom windows modification." /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticetext" /t REG_SZ /d "https://discord.gg/NeptuneOS" /f >> %neptlog%

:: Set OEM Information
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "HelpCustomized" /t REG_DWORD /d "1" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Manufacturer" /t REG_SZ /d "@NyneDZN" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "SupportURL" /t REG_SZ /d "https://discord.gg/NeptuneOS" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Model" /t REG_SZ /d "NeptuneOS 0.5" /f >> %neptlog%
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "SupportPhone" /t REG_SZ /d "Join our discord for support" /f >> %neptlog%

:: Importing finalization script into RunOnce
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "Finalization" /t REG_SZ /d "%WinDir%\NeptuneDir\Scripts\FINAL.cmd" /f >> %neptlog%

:: Move activate.cmd to %WinDir%
move "%WinDir%\NeptuneDir\Scripts\activate.cmd" "%WinDir%"

:: Delete neptune setup files
%delF% "%WinDir%\NeptuneDir\lockscreen.png" >> %neptlog%
%delF% "%WinDir%\NeptuneDir\Scripts\CLIENTCBS.ps1" >> %neptlog%
%delF% "%WinDir%\NeptuneDir\Scripts\FullscreenCMD.vbs" >> %neptlog%
%delF% "%WinDir%\NeptuneDir\Scripts\lockscreen.ps1" >> %neptlog%
%delF% "%WinDir%\NeptuneDir\Scripts\NGEN.ps1" >> %neptlog%
%delF% "%WinDir%\NeptuneDir\Scripts\online-sxs.cmd" >> %neptlog%
%delF% "%WinDir%\NeptuneDir\Scripts\RefreshEnv.cmd" >> %neptlog%
%delF% "%WinDir%\NeptuneDir\user.png" >> %neptlog%
%delF% "%WinDir%\NeptuneDir\Scripts\STARTMENU.CMD" >> %neptlog%
rmdir /s /q "%WinDir%\NeptuneDir\Prerequisites" >> %neptlog%
if "%server%"=="no" (rmdir /s /q "%WinDir%\NeptuneDir\Neptune\Server Configuration") >> %neptlog%
if "%server%"=="yes" (rmdir /s /q "%WinDir%\NeptuneDir\Neptune\Optional\Windows 11") >> %neptlog%
if "%os%"=="Windows 10" (rmdir /s /q "%WinDir%\NeptuneDir\Neptune\Optional\Windows 11") >> %neptlog%
if "%os%"=="Windows 11" (rmdir /s /q "%WinDir%\NeptuneDir\Neptune\Optional\Windows 10") >> %neptlog%
if exist "C:\NeptuneOS-installer-dev" (rmdir /s /q "C:\NeptuneOS-installer-dev" >> %neptlog%)
if exist "C:\NeptuneOS-installer" (rmdir /s /q "C:\NeptuneOS-installer" >> %neptlog%)
if exist "%userprofile%\Desktop\neptune-dev.cmd" (%delF% "%userprofile%\Desktop\neptune-dev.cmd")
if exist "%userprofile%\Desktop\neptune-installer.cmd" (%delF% "%userprofile%\Desktop\neptune-installer.cmd")

echo %time% %date% Finished neptune-master.cmd >> %neptlog%
echo --------------------------------- >> %neptlog%
cls & echo !S_RED!We're finished, rebooting in a moment.
timeout /t 4 /nobreak >nul
shutdown /f /r /t 0 & del "%~f0"

































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
echo The specified service/driver %1 is not found. >> %neptlog%
exit /b 1 )
%system% Reg add "HKLM\System\CurrentControlSet\Services\%1" /v "Start" /t Reg_DWORD /d "%2" /f >> %neptlog%
echo Service/Driver %1 was configured >> %neptlog%