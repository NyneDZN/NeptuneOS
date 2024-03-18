:: Created for NeptuneOS by Nyne
:: Compatible with Windows 10 21H2 and up

:: I take no credit for any code in this script, this was all compiled from open sources
:: Credits, in no particular order:
:: - Amit
:: - Artanis
:: - AtlasOS
:: - Ancel
:: - CatGamerOP
:: - CoutX
:: - EverythingTech
:: - he3als
:: - HeavenOS
:: - imribiy
:: - Melody
:: - nohopestage
:: - Phlegm
:: - privacy.sexy
:: - Revision
:: - Timecard
:: - Winaero
:: - Zusier
:: - Yoshii64

:: Neptune is a fork of older era AtlasOS
:: https://github.com/Atlas-OS/Atlas/tree/main/src

@echo off & setlocal EnableDelayedExpansion

:: NeptuneOS Variables
set version=0.4

:: Check if this is a development build or not
if /i "%~2"=="/devbuild"   set "devbuild=yes"

:: Batch Variables
set "CMDLINE=RED=[31m,S_GRAY=[90m,S_RED=[91m,S_GREEN=[92m,S_YELLOW=[93m,S_MAGENTA=[95m,S_WHITE=[97m,B_BLACK=[40m,B_YELLOW=[43m,UNDERLINE=[4m,_UNDERLINE=[24m"
set "%CMDLINE:,=" & set "%"
set "PowerShell=%WinDir%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command"
set currentuser=%WinDir%\NeptuneDir\Tools\NSudoLG.exe -U:C -P:E -ShowWindowMode:Hide -Wait
set system=%WinDir%\NeptuneDir\Tools\NSudoLG.exe -U:T -P:E -ShowWindowMode:Hide -Wait
set DevMan="%WinDir%\NeptuneDir\Tools\dmv.exe"
set svc=call :setSvc

:: Create Log File
echo. > %WinDir%\NeptuneDir\neptune.txt

:: Fetch User SID
for /f "tokens=2 delims==" %%A in ('wmic useraccount where "name='%username%'" get sid /value') do (set "SID=%%A")

:: Fetch RAM amount
for /f "skip=1" %%i in ('wmic os get TotalVisibleMemorySize') do if not defined TOTAL_MEMORY set "TOTAL_MEMORY=%%i"

:: Check GPU
:: for /f "tokens=2 delims==" %%a in ('wmic path Win32_VideoController get VideoProcessor /value') do (
:: for %%n in (GeForce NVIDIA RTX GTX) do echo %%a | find /I "%%n" >nul && set GPU=NVIDIA
:: )

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
taskkill /f /im explorer.exe >nul 2>&1

cls & echo !S_GREEN!Configuring NTP Server
:: change ntp server from windows server to pool.ntp.org
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org" >nul 2>&1

:: resync time to pool.ntp.org
sc config w32time start=auto >nul 2>&1
%svc% W32Time 2 >nul 2>&1
net start w32time >nul 2>&1
w32tm /config /update >nul 2>&1
w32tm /resync >nul 2>&1
%svc% W32Time 4 >nul 2>&1


cls & echo !S_GREEN!Configuring Powerplan
:: Unhide Hidden Power Configuration
:: source: https://gist.github.com/Velocet/7ded4cd2f7e8c5fa475b8043b76561b5#file-unlock-powercfg-ps1
PowerShell -ExecutionPolicy Unrestricted -Command  "$PowerCfg = (Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings' -Recurse).Name -notmatch '\bDefaultPowerSchemeValues|(\\[0-9]|\b255)$';foreach ($item in $PowerCfg) { Set-ItemProperty -Path $item.Replace('HKEY_LOCAL_MACHINE','HKLM:') -Name 'Attributes' -Value 0 -Force}" >nul 2>&1

:: Import Ultimate Powerplan and Rename
powercfg -import "%WinDir%\NeptuneDir\Prerequisites\power.pow" 11111111-1111-1111-1111-111111111111 >nul 2>&1
powercfg -setactive 11111111-1111-1111-1111-111111111111 >nul 2>&1
powercfg -changename 11111111-1111-1111-1111-111111111111 "NeptuneOS Powerplan 3.0." "A powerplan created to achieve low latency and high 0.01% lows." >nul 2>&1
:: Remove Stock Powerplans
powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a >nul 2>&1
powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg -delete e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1

:: -  Hard Disk & NVMe Settings
:: Turn off hard disk after 0 seconds
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0 >nul 2>&1
:: Turn off secondary NVMe idle timeout
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 0012ee47-9041-4b5d-9b77-535fba8b1442 d3d55efd-c1ff-424e-9dc3-441be7833010 0 >nul 2>&1
:: Turn off primary NVMe idle timeout
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 0012ee47-9041-4b5d-9b77-535fba8b1442 d639518a-e56d-4345-8af2-b9f32fb26109 0 >nul 2>&1
:: Turn off NVMe noppme
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 0012ee47-9041-4b5d-9b77-535fba8b1442 fc7372b6-ab2d-43ee-8797-15e9841f2cca 0 >nul 2>&1

:: -  USB and Sleep Settings
:: Disable hub selective suspend timeout
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 2a737441-1930-4402-8d77-b2bebba308a3 0853a681-27c8-4100-a2fd-82013e970683 0 >nul 2>&1
:: Disable USB selective suspend setting
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
:: Set USB 3 link power management to maximum performance
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0 >nul 2>&1
:: Disable deep sleep
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 2e601130-5351-4d9d-8e04-252966bad054 d502f7ee-1dc7-4efd-a55d-f04b6f5c0545 0 >nul 2>&1
:: Disable away mode policy
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 0 >nul 2>&1
powercfg -setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 0 >nul 2>&1
:: Disable idle states
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0 >nul 2>&1
powercfg -setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0 >nul 2>&1
:: Disable hybrid sleep
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0 >nul 2>&1
powercfg -setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0 >nul 2>&1
:: Turn off system unattended sleep timeout
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 0 >nul 2>&1
:: Disable allow wake timers
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0 >nul 2>&1

:: -  Display and Battery Settings
:: Turn off display after 0 seconds
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0 >nul 2>&1
:: Disable critical battery notification
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 e73a048d-bf27-4f12-9731-8b2076e8891f 5dbb7c9f-38e9-40d2-9749-4f8a0e9f640f 0 >nul 2>&1
:: Disable critical battery action
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 e73a048d-bf27-4f12-9731-8b2076e8891f 637ea02f-bbcb-4015-8e2c-a1c7b9c0b546 0 >nul 2>&1
:: Set low battery level to 0
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 e73a048d-bf27-4f12-9731-8b2076e8891f 8183ba9a-e910-48da-8769-14ae6dc1170a 0 >nul 2>&1
:: Set critical battery level to 0
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 e73a048d-bf27-4f12-9731-8b2076e8891f 9a66d8d7-4ff7-4ef9-b5a2-5a326ca2a469 0 >nul 2>&1
:: Disable low battery notification
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 e73a048d-bf27-4f12-9731-8b2076e8891f bcded951-187b-4d05-bccc-f7e51960c258 0 >nul 2>&1
:: Set reserve battery level to 0
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 e73a048d-bf27-4f12-9731-8b2076e8891f f3c5027d-cd16-4930-aa6b-90db844a8f00 0 >nul 2>&1

:: - Processor and Performance Settings
:: Set processor states
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor PROCTHROTTLEMIN 100 >nul 2>&1
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor PROCTHROTTLEMAX 100 >nul 2>&1
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor 06cadf0e-64ed-448a-8927-ce7bf90eb35d 1 >nul 2>&1
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 1 >nul 2>&1
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor 7b224883-b3cc-4d79-819f-8374152cbe7c 100 >nul 2>&1
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor 4b92d758-5a24-4851-a470-815d78aee119 100 >nul 2>&1
:: Enable Turbo Boost
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor PERFBOOSTMODE 1 >nul 2>&1
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor PERFBOOSTPOL 100 >nul 2>&1
:: Prefer Performant Processors
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor SHORTSCHEDPOLICY 2 >nul 2>&1
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor SCHEDPOLICY 2 >nul 2>&1

:: - Miscellaneous
:: Set slideshow to paused
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 0d7dbae2-4294-402a-ba8e-26777e8488cd 309dce9b-bef4-4119-9921-a851fb12f0f4 1 >nul 2>&1
:: Disable hibernation
powercfg -h off >nul 2>&1

:: Set NeptuneOS Scheme as Current
powercfg -setactive scheme_current >nul 2>&1

:: Disable Sleep Study
wevtutil set-log "Microsoft-Windows-SleepStudy/Diagnostic" /e:false >nul 2>&1
wevtutil set-log "Microsoft-Windows-Kernel-Processor-Power/Diagnostic" /e:false >nul 2>&1
wevtutil set-log "Microsoft-Windows-UserModePowerService/Diagnostic" /e:false >nul 2>&1


cls & echo !S_GREEN!Disabling PowerSaving
for /f "tokens=*" %%i in ('wmic PATH Win32_PnPEntity GET DeviceID ^| findstr "USB\VID_"') do (
	Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnhancedPowerManagementEnabled" /t Reg_DWORD /d "0" /f
	Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "AllowIdleIrpInD3" /t Reg_DWORD /d "0" /f
	Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnableSelectiveSuspend" /t Reg_DWORD /d "0" /f
	Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "DeviceSelectiveSuspended" /t Reg_DWORD /d "0" /f
	Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendEnabled" /t Reg_DWORD /d "0" /f
	Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendOn" /t Reg_DWORD /d "0" /f
	Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "D3ColdSupported" /t Reg_DWORD /d "0" /f
) >nul 2>&1

:: Disable PnP Powersaving
PowerShell -ExecutionPolicy Unrestricted -Command  "$usb_devices = @('Win32_USBController', 'Win32_USBControllerDevice', 'Win32_USBHub'); $power_device_enable = Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi; foreach ($power_device in $power_device_enable){$instance_name = $power_device.InstanceName.ToUpper(); foreach ($device in $usb_devices){foreach ($hub in Get-WmiObject $device){$pnp_id = $hub.PNPDeviceID; if ($instance_name -like \"*$pnp_id*\"){$power_device.enable = $False; $power_device.psbase.put()}}}}" >nul 2>&1

:: Disable Powersaving on Network Adapter
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" /v "DefaultPnPCapabilities" /t REG_DWORD /d "24" /f >nul 2>&1


cls & echo !S_GREEN!Configuring NTFS
:: Configuring the NTFS file system in Windows

:: Adjust MFT (master file table) and paged pool memory cache levels according to ram size
if !TOTAL_MEMORY! LSS 8000000 (
    FSUTIL behavior set memoryusage 1 >nul 2>&1
    FSUTIL behavior set mftzone 1 >nul 2>&1
) else if !TOTAL_MEMORY! LSS 16000000 (
    FSUTIL behavior set memoryusage 1 >nul 2>&1
    FSUTIL behavior set mftzone 2 >nul 2>&1
) else (
    FSUTIL behavior set memoryusage 2 >nul 2>&1
    FSUTIL behavior set mftzone 2 >nul 2>&1
)

:: Disallows characters from the extended character set to be used in 8.3 character-length short file names 
FSUTIL behavior set allowextchar 0 >nul 2>&1
:: Disallow generation of a bug check 
FSUTIL behavior set bugcheckoncorrupt 0 >nul 2>&1
:: Disable 8.3 File Creation
:: https://ttcshelbyville.wordpress.com/2018/12/02/should-you-disable-8dot3-for-performance-and-security
FSUTIL behavior set disable8dot3 1 >nul 2>&1
:: Disable NTFS File Compression
FSUTIL behavior set disablecompression 1 >nul 2>&1
:: Disable NTFS File Encryption
:: Commented out because this disables XBOX downloads
:: FSUTIL behavior set disableencryption 1 >nul 2>&1
:: Disable Last Accessed Timestamp
FSUTIL behavior set disablelastaccess 1 >nul 2>&1
FSUTIL behavior set disablespotcorruptionhandling 1 >nul 2>&1
:: Enable Trimming for SSD's
FSUTIL behavior set disabledeletenotify 0 >nul 2>&1
:: Disable paging file encryption
FSUTIL behavior set encryptpagingfile 0 >nul 2>&1
FSUTIL behavior set quotanotify 86400 >nul 2>&1
FSUTIL behavior set symlinkevaluation L2L:1 >nul 2>&1
:: Disable self repair on boot drive
FSUTIL repair set C: 0 >nul 2>&1

:: Disable Write Cache Buffer
    for /f "tokens=*" %%i in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI"^| findstr "HKEY"') do (
        for /f "tokens=*" %%a in ('Reg query "%%i"^| findstr "HKEY"') do Reg add "%%a\Device Parameters\Disk" /v "CacheIsPowerProtected" /t Reg_DWORD /d "1" /f >nul 2>&1
    )
    for /f "tokens=*" %%i in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI"^| findstr "HKEY"') do (
        for /f "tokens=*" %%a in ('Reg query "%%i"^| findstr "HKEY"') do Reg add "%%a\Device Parameters\Disk" /v "UserWriteCacheSetting" /t Reg_DWORD /d "1" /f >nul 2>&1
    )
)

:: Disable HIPM, DIPM, and HDD parking
FOR /F "eol=E" %%a in ('Reg QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "EnableHIPM"^| FINDSTR /V "EnableHIPM"') DO (
    Reg add "%%a" /F /V "EnableHIPM" /T Reg_DWORD /d 0 >nul 2>&1
    Reg add "%%a" /F /V "EnableDIPM" /T Reg_DWORD /d 0 >nul 2>&1
    Reg add "%%a" /F /V "EnableHDDParking" /T Reg_DWORD /d 0 >nul 2>&1
)

:: IOLATENCYCAP to 0
FOR /F "eol=E" %%a in ('Reg QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "IoLatencyCap"^| FINDSTR /V "IoLatencyCap"') DO (
    Reg add "%%a" /F /V "IoLatencyCap" /T Reg_DWORD /d 0 >nul 2>&1
)


:: Configuring the task scheduler in Windows
cls & echo !S_GREEN!Configuring Scheduled Tasks

for %%a in (
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
) do (
    schtasks /change /disable /TN %%a >nul 2>&1
)

:: Enable Storage Sense
schtasks /change /enable /TN "\Microsoft\Windows\DiskCleanup\SilentCleanup" >nul 2>&1

:: Disable OneDrive Tasks
PowerShell -ExecutionPolicy Unrestricted -Command "$taskPathPattern='\'; $taskNamePattern='OneDrive Reporting Task-*'; Write-Output "^""Disabling tasks matching pattern `"^""$taskNamePattern`"^""."^""; $tasks = @(Get-ScheduledTask -TaskPath $taskPathPattern -TaskName $taskNamePattern -ErrorAction Ignore); if (-Not $tasks) {; Write-Output "^""Skipping, no tasks matching pattern `"^""$taskNamePattern`"^"" found, no action needed."^""; exit 0; }; $operationFailed = $false; foreach ($task in $tasks) {; $taskName = $task.TaskName; if ($task.State -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.ScheduledTask.StateEnum]::Disabled) {; Write-Output "^""Skipping, task `"^""$taskName`"^"" is already disabled, no action needed."^""; continue; }; try {; $task | Disable-ScheduledTask -ErrorAction Stop | Out-Null; Write-Output "^""Successfully disabled task `"^""$taskName`"^""."^""; } catch {; Write-Error "^""Failed to disable task `"^""$taskName`"^"": $($_.Exception.Message)"^""; $operationFailed = $true; }; }; if ($operationFailed) {; Write-Output 'Failed to disable some tasks. Check error messages above.'; exit 1; }" >nul 2>&1 
PowerShell -ExecutionPolicy Unrestricted -Command "$taskPathPattern='\'; $taskNamePattern='OneDrive Standalone Update Task-*'; Write-Output "^""Disabling tasks matching pattern `"^""$taskNamePattern`"^""."^""; $tasks = @(Get-ScheduledTask -TaskPath $taskPathPattern -TaskName $taskNamePattern -ErrorAction Ignore); if (-Not $tasks) {; Write-Output "^""Skipping, no tasks matching pattern `"^""$taskNamePattern`"^"" found, no action needed."^""; exit 0; }; $operationFailed = $false; foreach ($task in $tasks) {; $taskName = $task.TaskName; if ($task.State -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.ScheduledTask.StateEnum]::Disabled) {; Write-Output "^""Skipping, task `"^""$taskName`"^"" is already disabled, no action needed."^""; continue; }; try {; $task | Disable-ScheduledTask -ErrorAction Stop | Out-Null; Write-Output "^""Successfully disabled task `"^""$taskName`"^""."^""; } catch {; Write-Error "^""Failed to disable task `"^""$taskName`"^"": $($_.Exception.Message)"^""; $operationFailed = $true; }; }; if ($operationFailed) {; Write-Output 'Failed to disable some tasks. Check error messages above.'; exit 1; }" >nul 2>&1 
PowerShell -ExecutionPolicy Unrestricted -Command "$taskPathPattern='\'; $taskNamePattern='OneDrive Per-Machine Standalone Update'; Write-Output "^""Disabling tasks matching pattern `"^""$taskNamePattern`"^""."^""; $tasks = @(Get-ScheduledTask -TaskPath $taskPathPattern -TaskName $taskNamePattern -ErrorAction Ignore); if (-Not $tasks) {; Write-Output "^""Skipping, no tasks matching pattern `"^""$taskNamePattern`"^"" found, no action needed."^""; exit 0; }; $operationFailed = $false; foreach ($task in $tasks) {; $taskName = $task.TaskName; if ($task.State -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.ScheduledTask.StateEnum]::Disabled) {; Write-Output "^""Skipping, task `"^""$taskName`"^"" is already disabled, no action needed."^""; continue; }; try {; $task | Disable-ScheduledTask -ErrorAction Stop | Out-Null; Write-Output "^""Successfully disabled task `"^""$taskName`"^""."^""; } catch {; Write-Error "^""Failed to disable task `"^""$taskName`"^"": $($_.Exception.Message)"^""; $operationFailed = $true; }; }; if ($operationFailed) {; Write-Output 'Failed to disable some tasks. Check error messages above.'; exit 1; }" >nul 2>&1


:: Configuring the Boot Configuration Data in Windows
cls & echo !S_GREEN!Configuring BCDEdit

:: Enable the Legacy Boot Menu 
bcdedit /set bootmenupolicy legacy >nul 2>&1
:: Disable Hyper-V
bcdedit /set hypervisorlaunchtype off >nul 2>&1
:: Disable Automatic Drive Repair
bcdedit /set {current} recoveryenabled no >nul 2>&1
:: Set Boot Label
bcdedit /set {current} description "NeptuneOS %version%" >nul 2>&1
:: Disable Laptop Powersaving
bcdedit /set disabledynamictick yes >nul 2>&1
:: Use Synthetic Timers
bcdedit /set useplatformtick yes >nul 2>&1
:: Disable HPET
:: This isn't even set by default in windows, commented out.
:: bcdedit /deletevalue useplatformclock >nul 2>&1
:: 15 Second Timeout
bcdedit /timeout 15 >nul 2>&1
:: Disable Emergency Management Services
:: bcdedit /set ems no >nul 2>&1
:: bcdedit /set bootems no >nul 2>&1
:: Disable Kernel Debugging
bcdedit /set debug no >nul 2>&1
:: Stop using uncontiguous portions of low-memory
:: https://sites.google.com/view/melodystweaks/basictweaks
:: bcdedit /set firstmegabytepolicy useall >nul 2>&1
:: bcdedit /set avoidlowmemory 0x8000000 >nul 2>&1
:: bcdedit /set nolowmem yes >nul 2>&1
:: Enable X2Apic
bcdedit /set x2apicpolicy enable >nul 2>&1
bcdedit /set uselegacyapicmode no >nul 2>&1
:: Enable Legacy TSCSyncPolicy
:: bcdedit /set tscsyncpolicy enhanced >nul 2>&1
:: Linear Address 57
:: https://en.wikipedia.org/wiki/Intel_5-level_paging
bcdedit /set linearaddress57 OptOut >nul 2>&1
bcdedit /set increaseuserva 268435328 >nul 2>&1


:: Configuring devices in Windows
cls & echo !S_GREEN!Configuring Devices and MSI Mode

:: Device Manager
:: - > System Devices
%DevMan% /disable "ACPI Processor AggRegator" >nul 2>&1
%DevMan% /disable "ACPI Wake Alarm" >nul 2>&1
%DevMan% /disable "Composite Bus Enumerator" >nul 2>&1
%DevMan% /disable "Direct memory access controller" >nul 2>&1
%DevMan% /disable "High precision event timer" >nul 2>&1
%DevMan% /disable "Legacy device" >nul 2>&1
%DevMan% /disable "Microsoft GS Wavetable Synth" >nul 2>&1
%DevMan% /disable "Microsoft Hyper-V Virtualization Infrastructure Driver" >nul 2>&1
%DevMan% /disable "Microsoft Kernel Debug Network Adapter" >nul 2>&1
%DevMan% /disable "Microsoft Windows Management Interface for ACPI" >nul 2>&1
%DevMan% /disable "Motherboard resources" >nul 2>&1
%DevMan% /disable "Numeric data processor" >nul 2>&1
%DevMan% /disable "PCI Data Acquisition and Signal Processing Controller" >nul 2>&1
%DevMan% /disable "PCI Device" >nul 2>&1
%DevMan% /disable "PCI Memory Controller" >nul 2>&1
%DevMan% /disable "PCI Simple Communications Controller" >nul 2>&1
%DevMan% /disable "PCI Simple Communications Controller" >nul 2>&1
%DevMan% /disable "PCI standard RAM Controller" >nul 2>&1
%DevMan% /disable "Programmable interrupt controller" >nul 2>&1
%DevMan% /disable "Remote Desktop Device Redirector Bus" >nul 2>&1
%DevMan% /disable "SM Bus Controller"
%DevMan% /disable "System board" >nul 2>&1
%DevMan% /disable "System Speaker" >nul 2>&1
%DevMan% /disable "System Timer" >nul 2>&1
%DevMan% /disable "UMBus Root Bus Enumerator" >nul 2>&1
%DevMan% /disable "Unknown device" >nul 2>&1

:: VPN Devices
%DevMan% /disable "Microsoft RRAS Root Enumerator" >nul 2>&1 
%DevMan% /disable "NDIS Virtual Network Adapter Enumerator" >nul 2>&1 
%DevMan% /disable "WAN Miniport (IKEv2)" >nul 2>&1 
%DevMan% /disable "WAN Miniport (IP)" >nul 2>&1 
%DevMan% /disable "WAN Miniport (IPv6)" >nul 2>&1 
%DevMan% /disable "WAN Miniport (L2TP)" >nul 2>&1 
%DevMan% /disable "WAN Miniport (Network Monitor)" >nul 2>&1 
%DevMan% /disable "WAN Miniport (PPPOE)" >nul 2>&1 
%DevMan% /disable "WAN Miniport (PPTP)" >nul 2>&1 
%DevMan% /disable "WAN Miniport (SSTP)" >nul 2>&1 

:: TPM Devices
if "%os%"=="Windows 10" (%DevMan% /disable "AMD PSP 10.0 Device" & %DevMan% /disable "Trusted Platform Module 2.0")

:: MSI Mode
:: Enable MSI mode on USB, GPU, SATA controllers and network adapters
:: Deleting DevicePriority sets the priority to undefined
for %%a in (
    Win32_USBController, 
    Win32_VideoController, 
    Win32_NetworkAdapter, 
    Win32_IDEController
) do (
    for /f %%i in ('wmic path %%a get PNPDeviceID ^| findstr /L "PCI\VEN_"') do (
        Reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t Reg_DWORD /d "1" /f > nul 2>nul
        Reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f > nul 2>nul
    )
)

:: if e.g. VMWare is used, set network adapter to normal priority as undefined on some virtual machines may break internet connection
wmic computersystem get manufacturer /format:value | findstr /i /C:VMWare && (
    for /f %%a in ('wmic path Win32_NetworkAdapter get PNPDeviceID ^| findstr /L "PCI\VEN_"') do (
        Reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t Reg_DWORD /d "2"  /f > nul 2>nul
    )
)


:: Configuring network settings and the NIC adapter in Windows
cls & echo !S_GREEN!Configuring Network Settings

:: Network Shell
:: Reset the Network Configuration
ipconfig /release >nul 2>&1
ipconfig /renew >nul 2>&1
ipconfig /flushdns >nul 2>&1
netsh int ip reset >nul 2>&1
netsh int ipv4 reset >nul 2>&1
netsh int ipv6 reset >nul 2>&1
netsh int tcp reset >nul 2>&1
netsh winsock reset >nul 2>&1
netsh advfirewall reset >nul 2>&1
netsh branchcache reset >nul 2>&1
netsh http flush logbuffer >nul 2>&1
:: - > Disable IPV6
:: IPV6 is disabled through regedit, so I'm commenting this out so it doesn't cause unforseen issues.
:: netsh int 6to4 set state disabled >nul 2>&1
:: netsh int IPV6 set global randomizeidentifier=disabled >nul 2>&1
:: netsh int IPV6 set privacy state=disable >nul 2>&1
:: netsh int IPV6 6to4 set state state=disabled >nul 2>&1
:: netsh int IPV6 isatap set state state=disabled >nul 2>&1
:: netsh int IPV6 set teredo disable
:: - > Increase TTL (Time to Live)
:: https://packetpushers.net/ip-time-to-live-and-hop-limit-basics/
netsh int ip set global defaultcurhoplimit=255 >nul 2>&1
:: - > Disable Media Sense
netsh int ip set global dhcpmediasense=disabled >nul 2>&1
netsh int ip set global neighborcachelimit=4096 >nul 2>&1
:: - > Enable Task Offloading
netsh int ip set global taskoffload=enabled >nul 2>&1
:: netsh int ip set interface "Ethernet" metric=60 >nul 2>&1
:: - > Set MTU (maximum transmission unit)
netsh int ipv4 set subinterface "Ethernet" mtu=1500 store=persistent >nul 2>&1
netsh int ipv4 set subinterface "Wi-Fi" mtu=1500 store=persistent >nul 2>&1
:: - > Set AutoTuningLevel
:: https://www.majorgeeks.com/content/page/what_is_windows_auto_tuning.html
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global chimney=disabled >nul 2>&1
:: - > Set Congestion Provider to CTCP (Client to Client Protocol)
:: - > CTCP Provides better throughput and latency for gaming
:: https://www.speedguide.net/articles/tcp-congestion-control-algorithms-comparison-7423
netsh int tcp set global congestionprovider=ctcp >nul 2>&1
:: - > Set Congestion Provider to BBR2 on Windows 11
if "%os%"=="Windows 11" (
    netsh int tcp set supplemental Template=Internet CongestionProvider=bbr2 >nul 2>&1
    netsh int tcp set supplemental Template=Datacenter CongestionProvider=bbr2 >nul 2>&1
    netsh int tcp set supplemental Template=Compat CongestionProvider=bbr2 >nul 2>&1
    netsh int tcp set supplemental Template=DatacenterCustom CongestionProvider=bbr2 >nul 2>&1
    netsh int tcp set supplemental Template=InternetCustom CongestionProvider=bbr2 >nul 2>&1
)
:: - > Enable Direct Cache Access
:: - > This will have a bigger impact on older CPU's
netsh int tcp set global dca=enabled >nul 2>&1
:: - > Disable Explicit Congestion Notification
:: https://en.wikipedia.org/wiki/Explicit_Congestion_Notification
:: https://www.bufferbloat.net/projects/cerowrt/wiki/Enable_ECN/#:~:text=Enabling%20ECN%20does%20not%20much,already%2C%20but%20few%20clients%20do.
netsh int tcp set global ecncapability=disabled >nul 2>&1
:: - > Enable TCP Fast Open
:: https://en.wikipedia.org/wiki/TCP_Fast_Open
netsh int tcp set global fastopen=enabled >nul 2>&1
:: - > Set the TCP Retransmission Timer
:: https://www.speedguide.net/faq/how-does-tcpinitialrtt-or-initialrto-affect-tcp-498
netsh int tcp set global initialRto=3000 >nul 2>&1
:: - > Set Max SYN Retransmissions to the lowest value
:: https://medium.com/@avocadi/tcp-syn-retries-f30756ec7c55
netsh int tcp set global maxsynretransmissions=2 >nul 2>&1
netsh int tcp set global netdma=enabled >nul 2>&1
:: - > Disable Non Sack RTT Resiliency 
:: - > If you have fluctuating ping and packet loss, enabling this might benefit
:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
netsh int tcp set global nonsackrttresiliency=disabled >nul 2>&1
:: - > Disable Receive Segment Coalescing State
:: - > Enabling this may provide higher throughput when lower CPU utilization is important
:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
netsh int tcp set global rsc=disabled >nul 2>&1
:: - > Enable Receive Side Scaling
:: - > This allows multiple cores to process incoming packets, improving network performance
:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
netsh int tcp set global rss=enabled >nul 2>&1
:: - > Disable TCP 1323 Timestamps
:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
netsh int tcp set global timestamps=disabled >nul 2>&1
:: - > Disable Scaling Heuristics
netsh int tcp set heuristics disabled >nul 2>&1
:: - > Set Max Port Ranges
netsh int ipv4 set dynamicport udp start=1025 num=64511 >nul 2>&1
netsh int ipv4 set dynamicport tcp start=1025 num=64511 >nul 2>&1
:: - > Disable Memory Pressure Protection
:: - > This is a network security feature that will kill malicious TCP connections and SYN requests with no sort of performance or stability loss.
:: https://support.microsoft.com/en-us/topic/description-of-the-new-memory-pressure-protection-feature-for-tcp-stack-749c1746-ba10-ec18-d61a-bbdabbc403fc
:: netsh int tcp set security mpp=disabled >nul 2>&1
:: netsh int tcp set security profiles=disabled >nul 2>&1
netsh int tcp set supplemental Internet congestionprovider=ctcp >nul 2>&1
netsh int tcp set supplemental template=custom icw=10 >nul 2>&1
:: - > Disable Teredo 
netsh int teredo set state disabled >nul 2>&1


:: Disable Bandwith Preservation
Reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t Reg_DWORD /d "00000000" /f >nul 2>&1

:: Disable Network Level Authentication
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t Reg_SZ /d "1" /f >nul 2>&1

:: Disable DHCP MediaSense
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v " DisableDHCPMediaSense" /t REG_DWORD /d "1" /f >nul 2>&1

:: No TCP Connection Limit
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxConnectionsPerServer" /t Reg_DWORD /d "0" /f >nul 2>&1

:: Set Max Port to 65534
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t Reg_DWORD /d "65534" /f >nul 2>&1

:: Reduce Time_Wait
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t Reg_DWORD /d "32" /f >nul 2>&1

:: Reduce TTL (Time to Live)
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t Reg_DWORD /d "64" /f >nul 2>&1

:: Duplicate ACKS
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t Reg_DWORD /d "2" /f >nul 2>&1

:: Disable Sacks
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t Reg_DWORD /d "0" /f >nul 2>&1

:: Disable Multicast
Reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t Reg_DWORD /d "0" /f >nul 2>&1

:: Disable TCP Extensions
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t Reg_DWORD /d "0" /f >nul 2>&1

:: Disable Smart Name Resolution
:: This may cause DNS leaks
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "DisableParallelAandAAAA" /t REG_DWORD /d 1 /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v "DisableSmartNameResolution" /t REG_DWORD /d 1 /f >nul 2>&1
 
:: Allow ICMP redirects to override OSPF generated routes
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableICMPRedirect" /t Reg_DWORD /d "1" /f >nul 2>&1

:: TCP Window Size
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t Reg_DWORD /d "8760" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpWindowSize" /t Reg_DWORD /d "8760" /f >nul 2>&1

:: Disable Network Discovery
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" /f >nul 2>&1

:: Enable DNS > HTTPS
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableAutoDoh" /t Reg_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeSOACacheTime" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NetFailureCacheTime" /t Reg_DWORD /d "0" /f >nul 2>&1

:: Disable LLMNR
Reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t Reg_DWORD /d "0" /f >nul 2>&1

:: Disable Administrative Shares
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "AutoShareWks" /t Reg_DWORD /d "0" /f >nul 2>&1

:: Enable Network Offloading
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableTaskOffload" /t Reg_DWORD /d "0" /f >nul 2>&1

:: Disable the TCP Autotuning Diagnostic Tool
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableWsd" /t Reg_DWORD /d "0" /f >nul 2>&1

:: Host Resolution Priority
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t Reg_DWORD /d "6" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t Reg_DWORD /d "5" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t Reg_DWORD /d "7" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "Class" /t Reg_DWORD /d "8" /f >nul 2>&1

:: TCP Congestion Control/Avoidance Algorithm
Reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "0200" /t Reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "1700" /t Reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f >nul 2>&1

:: Detect Congestion Failure
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPCongestionControl" /t Reg_DWORD /d "00000001" /f >nul 2>&1

:: Disable SYN-DOS Protection
:: Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SynAttackProtect" /t Reg_DWORD /d "0" /f >nul 2>&1
:: Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock" /v "UseDelayedAcceptance" /t Reg_DWORD /d "0" /f >nul 2>&1

:: Prevent NIC Resets
Reg add "HKLM\SYSTEM\CurrentControlSet\services\NDIS\Parameters" /v "DisableNDISWatchDog" /t Reg_DWORD /d "1" /f >nul 2>&1

:: Disable Nagle's Algorithm
:: https://en.wikipedia.org/wiki/Nagle%27s_algorithm
:: for /f %%a in ('wmic path Win32_NetworkAdapter get GUID ^| findstr "{"') do (
::     Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%a" /v "TcpAckFrequency" /t Reg_DWORD /d "1" /f >nul 2>&1
::     Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%a" /v "TcpDelAckTicks" /t Reg_DWORD /d "0" /f >nul 2>&1
::     Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%a" /v "TCPNoDelay" /t Reg_DWORD /d "1" /f >nul 2>&1
:: )

:: Disable NetBIOS over TCP
for /f "delims=" %%a in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces" /s /f "NetbiosOptions" ^| findstr "HKEY"') do (
    Reg add "%%a" /v "NetbiosOptions" /t Reg_DWORD /d "2" /f >nul 2>&1
)

:: Disable Network Protocols
:: This includes IPV6, File and Printer Sharing for Microsoft Networks, Client for Microsoft Networks, etc
PowerShell -ExecutionPolicy Unrestricted -Command  "Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6, ms_msclient, ms_server, ms_lldp, ms_lltdio, ms_rspndr" >nul 2>&1

:: Disable IPV6 through TCPIP
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v "DisabledComponents" /t REG_DWORD /d "32" /f >nul 2>&1

:: Disable Telemetry IP's
cd %SystemRoot%\System32\drivers\etc
if not exist hosts.bak ren hosts hosts.bak >nul 2>&1
curl -l -s https://winhelp2002.mvps.org/hosts.txt -o hosts
if not exist hosts ren hosts.bak hosts >nul 2>&1


cls & echo !S_GREEN!Disabling Drivers and Services
:: Configuring the services and drivers in Windows

:: Configuring Driver Dependencies
:: - > Audio Service
Reg add "HKLM\System\CurrentControlSet\Services\Audiosrv" /v "DependOnService" /t Reg_MULTI_SZ /d "" /f >nul 2>&1
:: - > DHCP, allows for TDX to be disabled
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dhcp" /v "DependOnService" /t Reg_MULTI_SZ /d "NSI\0Afd" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache" /v "DependOnService" /t Reg_MULTI_SZ /d "nsi" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc" /v "DependOnService" /t Reg_MULTI_SZ /d "NSI\0RpcSs\0TcpIp" /f >nul 2>&1

:: Configure Driver Filters
:: - > ReadyBoost
if "%server%"=="no" (
    Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t Reg_MULTI_SZ /d "fvevol\0iorate" /f >nul 2>&1
)

:: Split Audio Services
:: This will prevent audio dropouts when setting svchost.exe to low priority
copy /y "%windir%\System32\svchost.exe" "%windir%\System32\audiosvchost.exe" >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv" /v "ImagePath" /t Reg_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalServiceNetworkRestricted -p" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AudioEndpointBuilder" /v "ImagePath" /t Reg_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalSystemNetworkRestricted -p" /f >nul 2>&1

:: Backing up default Windows services and drivers
set BACKUP="%WINDIR%\NeptuneDir\POST-INSTALL\Troubleshooting\windows-default-services.Reg"
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
) >nul 2>&1

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
:: Driver related to UAC
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
:: Oculus needs this driver to function
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
:: Windows Defender Drivers
%svc% WdBoot 4
%svc% WdFilter 4
%svc% WdNisDrv 4
%svc% MsSecCore 4

:: Services
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
:: SuperFetch Driver
%svc% SysMain 4
%svc% vmicguestinterface 4
%svc% vmicheartbeat 4
%svc% vmickvpexchange 4
%svc% vmicrdv 4
%svc% vmicshutdown 4
%svc% vmictimesync 4
%svc% vmicvmsession 4
%svc% vmicvss 4
%svc% W32Time 4
%svc% WaaSMedicSvc 4
%svc% WarpJITSvc 4
%svc% WdiServiceHost 4
%svc% webthreatdefusersvc 4
%svc% WinHttpAutoProxySvc 4 
%svc% WPDBusEnum 4
%svc% WerSvc 4
%svc% WSearch 4
%svc% WpnService 4
%svc% WpnUserService 4
:: Windows Defender Services
%svc% WinDefend 4
%svc% WdNisSvc 4
%svc% SecurityHealthService 4
%svc% Sense 4

:: Backup default NeptuneOS drivers and services
set BACKUP=%WINDIR%\NeptuneDir\POST-INSTALL\Troubleshooting\neptune-default-services.Reg"
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
) >nul 2>&1

:: check if battery information is available to determine system type
:: if this method ends up being unreliable it will be replaced, but it seems to be working as of now.
:: a VM detection method needs to be implemented into this, as it breaks VM keyboard control
:: re-enable keyboard control on VM by running Desktop\POST-INSTALL\Advanced Configuration\Services and Drivers\Serial Port\Enable Serial Port.reg
:: wmic path Win32_Battery get BatteryStatus > nul 2>&1
:: if %errorlevel% equ 0 (
::     set SystemType=Desktop
:: ) else (
::     set SystemType=Laptop
:: )
:: if "%SystemType%"=="Laptop" (
::     echo Running Laptop Configuration...
::     %svc% serenum 3
::     %svc% sermouse 3
::     %svc% serial 3
::     %svc% i8042prt 3
::     %svc% wlansvc 2
::     %svc% wmiacpi 2
::     Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t Reg_DWORD /d "0" /f >nul 2>&1
::     %DevMan% /enable "Communications Port (COM1)" >nul 2>&1
::     %DevMan% /enable "Communications Port (COM2)" >nul 2>&1
::     %DevMan% /enable "Communications Port (SER1)" >nul 2>&1
::     %DevMan% /enable "Communications Port (SER2)" >nul 2>&1
:: ) else (
::     %svc% acpiex 4
::     %svc% acpipagr 4
::     %svc% acpimi 4
::     %svc% acpipmi 4
::     %svc% acpitime 4
::     %svc% iaLPSS2i_GPIO2 4
::     %svc% iaLPSS2i_I2C 4
::     %svc% iaLPSSi_GPIO 4
::     %svc% iaLPSSi_I2C 4
::     %svc% sermouse 4
::     %svc% serial 4
::     %svc% i8042prt 4
:: )


:: Configuring security vulnerabilities and hardening Windows
cls & echo !S_GREEN!Security and Hardening

:: Mitigations
:: - > Spectre & Meltdown
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f >nul 2>&1
::  - > Disable ASLR Mitigations
::  - > This might break TestMem5
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "MoveImages" /t REG_DWORD /d "0" /f >nul 2>&1
::  - > Disable Control Flow Guard 
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f >nul 2>&1
::  - > NTFS/ReFS Mitigations 
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f >nul 2>&1
::  - > System Mitigations
PowerShell -ExecutionPolicy Unrestricted -Command  "Set-ProcessMitigation -System -Disable DEP, EmulateAtlThunks, SEHOP, ForceRelocateImages, RequireInfo, BottomUp, HighEntropy, StrictHandle, DisableWin32kSystemCalls, AuditSystemCall, DisableExtensionPoints, BlockDynamicCode, AllowThreadsToOptOut, AuditDynamicCode, CFG, SuppressExports, StrictCFG, MicrosoftSignedOnly, AllowStoreSignedBinaries, AuditMicrosoftSigned, AuditStoreSigned, EnforceModuleDependencySigning, DisableNonSystemFonts, AuditFont, BlockRemoteImageLoads, BlockLowLabelImageLoads, PreferSystem32, AuditRemoteImageLoads, AuditLowLabelImageLoads, AuditPreferSystem32, EnableExportAddressFilter, AuditEnableExportAddressFilter, EnableExportAddressFilterPlus, AuditEnableExportAddressFilterPlus, EnableImportAddressFilter, AuditEnableImportAddressFilter, EnableRopStackPivot, AuditEnableRopStackPivot, EnableRopCallerCheck, AuditEnableRopCallerCheck, EnableRopSimExec, AuditEnableRopSimExec, SEHOP, AuditSEHOP, SEHOPTelemetry, TerminateOnError, DisallowChildProcessCreation, AuditChildProcess" >nul 2>&1
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
    Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%a" /v "MitigationOptions" /t Reg_BINARY /d "!mitigation_mask!" /f >nul 2>&1
    Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%a" /v "MitigationAuditOptions" /t Reg_BINARY /d "!mitigation_mask!" /f >nul 2>&1
)
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t Reg_BINARY /d "!mitigation_mask!" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions" /t Reg_BINARY /d "!mitigation_mask!" /f >nul 2>&1
::  - > Disable SEHOP
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Mitigate HiveNightmare aka SeriousSAM (CVE-2021-36934)
icacls %WinDir%\system32\config\*.* /inheritance:e >nul 2>&1

:: Harden LSASS
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe" /v "AuditLevel" /t REG_DWORD /d "8" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation" /v "AllowProtectedCreds" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdminOutboundCreds" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdmin" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RunAsPPL" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" /v "Negotiate" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" /v "UseLogonCredential" /t REG_DWORD /d "0" /f >nul 2>&1

:: Harden WinRM
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" /v "AllowUnencryptedTraffic" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client" /v "AllowDigest" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule" /v "DisableRpcOverTcp" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "DisableRemoteScmEndpoints" /t REG_DWORD /d "1" /f >nul 2>&1

:: Block enumeration of anonymous SAM accounts
:: https://www.stigviewer.com/stig/windows_10/2021-03-10/finding/V-220929
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RestrictAnonymousSAM" /t REG_DWORD /d "1" /f >nul 2>&1


:: Enable UAC
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "1" /f > nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d "1" /f > nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "5" /f > nul 2>&1

:: Mitigation for CVE-2021-40444 and other future activex related attacks 
:: https://msrc.microsoft.com/update-guide/vulnerability/CVE-2021-40444
:: https://www.huntress.com/blog/cybersecurity-advisory-hackers-are-exploiting-cve-2021-40444
:: https://nitter.unixfox.eu/wdormann/status/1437530613536501765
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v "1001" /t REG_DWORD /d 00000003 /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1001" /t REG_DWORD /d 00000003 /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1001" /t REG_DWORD /d 00000003 /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1001" /t REG_DWORD /d 00000003 /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v "1004" /t REG_DWORD /d 00000003 /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1004" /t REG_DWORD /d 00000003 /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1004" /t REG_DWORD /d 00000003 /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1004" /t REG_DWORD /d 00000003 /f >nul 2>&1

:: Prevent Kerberos from using DES or RC4
:: https://gist.github.com/mackwage/08604751462126599d7e52f233490efe?permalink_comment_id=3310398
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters" /v SupportedEncryptionTypes /t REG_DWORD /d 2147483640 /f >nul 2>&1

:: Mitigate ClickOnce
Reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v "MyComputer" /t Reg_SZ /d "Disabled" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v "LocalIntranet" /t Reg_SZ /d "Disabled" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v "Internet" /t Reg_SZ /d "Disabled" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v "TrustedSites" /t Reg_SZ /d "Disabled" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v "UntrustedSites" /t Reg_SZ /d "Disabled" /f >nul 2>&1

:: Set strong cryptography on 64 bit and 32 bit .net framework 
:: https://github.com/ScoopInstaller/Scoop/issues/2040#issuecomment-369686748
Reg add "HKLM\SOFTWARE\Microsoft\.NetFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "1" /f >nul 2>&1

:: Restrict anonymous enumeration of shares
:: https://www.stigviewer.com/stig/windows_10/2021-03-10/finding/V-220930
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RestrictAnonymous" /t REG_DWORD /d "1" /f >nul 2>&1

:: disable memory mitigations
bcdedit /set allowedinmemorysettings 0x0 >nul 2>&1

:: Delete Adobe Font Type Manager
Reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Font Drivers" /v "Adobe Type Manager" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "DisableATMFD" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable DMA Remapping
:: https://docs.microsoft.com/en-us/windows-hardware/drivers/pci/enabling-dma-remapping-for-device-drivers
for /f %%a in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f "DmaRemappingCompatible" ^| find /i "Services\" ') do (
    Reg add "%%a" /v "DmaRemappingCompatible" /t Reg_DWORD /d "0" /f >nul 2>&1
)

:: Disable DMA Memory Protection
Reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\DmaGuard\DeviceEnumerationPolicy" /v "value" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\FVE" /v "DisableExternalDMAUnderLock" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t REG_DWORD /d "0" /f >nul 2>&1
bcdedit /set vm no >nul 2>&1
bcdedit /set vsmlaunchtype off >nul 2>&1

:: Disable Core Isolation Memory Integrity
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable DEP
bcdedit /set nx alwaysoff >nul 2>&1

:: Disable TSX 
:: Enabling this could result in improved performance under certain workloads
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableTsx" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Fault Tolerant Heap
Reg add "HKLM\SOFTWARE\Microsoft\FTH" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
rundll32.exe fthsvc.dll,FthSysprepSpecialize

:: Disable SmartScreen
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "ShellSmartScreenLevel" /f >nul 2>&1


:: Configuring the Windows Registry
: - > Configuring the explorer and UI in Windows
cls & echo !S_GREEN!Configuring Registry

:: Explorer Quickness
:: - > Turn down application launch delays
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shutdown\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Turn down login delays
:: https://james-rankin.com/features/the-ultimate-guide-to-windows-logon-optimizations-part-6/
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DelayedDesktopSwitchTimeout" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Automatically close any apps and continue to restart, shut down, or sign out of windows
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f >nul 2>&1
:: - > Reduce menu show delay time
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1

:: Explorer Colors
:: - > Set windows color scheme to 'storm gray'
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentColorMenu" /t REG_DWORD /d "4290756543" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "StartColorMenu" /t REG_DWORD /d "4289901234" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentPalette" /t REG_BINARY /d "9b9a9900848381006d6b6a004c4a4800363533002625240019191900107c1000" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationColor" /t REG_DWORD /d "3293334088" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationAfterglow" /t REG_DWORD /d "3293334088" /f >nul 2>&1
:: - > Set operating system color scheme to 'dark'
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Set tooltips to blue
%currentuser% Reg add "HKCU\Control Panel\Colors" /v "InfoWindow" /t REG_SZ /d "246 253 255" /f >nul 2>&1

:: Set NeptuneOS Wallpaper
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "Wallpaper" /t REG_SZ /d "C:\Windows\Web\Wallpaper\Windows\NeptuneOS.png" /f >nul 2>&1
:: - > Increase JPEG Wallpaper Quality
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d "100" /f >nul 2>&1

:: Disable Explorer Animations and Shadows
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "FontSmoothing" /t REG_SZ /d "2" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9012038010000000" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisablePreviewDesktop" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "IconsOnly" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f >nul 2>&1
:: - > Taskbar / UWP Transprency
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseOLEDTaskbarTransparency" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "DisableAcrylicBackgroundOnLogon" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > DWM Shadows and Animations
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "ListviewShadow" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableWindowColorization" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > DWM Composition
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "Composition" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowComposition" /t REG_DWORD /d "1" /f >nul 2>&1

:: Context Menu Configuration
:: - > Disable wide Context Menus
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\FlightedFeatures" /v "ImmersiveContextMenu" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Remove 'restore previous versions' from Context Menus and File Properties
Reg delete "HKCR\AllFilesystemObjects\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >nul 2>&1
Reg delete "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >nul 2>&1
Reg delete "HKCR\Directory\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >nul 2>&1
Reg delete "HKCR\Drive\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >nul 2>&1
Reg delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >nul 2>&1
Reg delete "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >nul 2>&1
Reg delete "HKCR\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >nul 2>&1
Reg delete "HKCR\Drive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >nul 2>&1
%currentuser% Reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "NoPreviousVersionsPage" /f >nul 2>&1
%currentuser% Reg delete "HKCU\SOFTWARE\Policies\Microsoft\PreviousVersions" /v "DisableLocalPage" /f >nul 2>&1
:: - > Remove 'edit with Paint 3D' from Context Menus
Reg delete "HKCR\SystemFileAssociations\.3mf\Shell\3D Edit" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.bmp\Shell\3D Edit" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.fbx\Shell\3D Edit" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.gif\Shell\3D Edit" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.jfif\Shell\3D Edit" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.jpe\Shell\3D Edit" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.jpeg\Shell\3D Edit" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.jpg\Shell\3D Edit" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.png\Shell\3D Edit" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.tif\Shell\3D Edit" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.tiff\Shell\3D Edit" /f >nul 2>&1
:: - > Remove 'give access to' from Context Menus
Reg delete "HKCR\*\shellex\ContextMenuHandlers\Sharing" /f >nul 2>&1
Reg delete "HKCR\Directory\Background\shellex\ContextMenuHandlers\Sharing" /f >nul 2>&1
Reg delete "HKCR\Directory\shellex\ContextMenuHandlers\Sharing" /f >nul 2>&1
Reg delete "HKCR\Drive\shellex\ContextMenuHandlers\Sharing" /f >nul 2>&1
Reg delete "HKCR\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing" /f >nul 2>&1
Reg delete "HKCR\UserLibraryFolder\shellex\ContextMenuHandlers\Sharing" /f >nul 2>&1
:: - > Remove 'cast to device' from Context Menus
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" /t REG_SZ /d "" /f >nul 2>&1
:: - > Remove 'share' in Context Menus
Reg delete "HKCR\*\shellex\ContextMenuHandlers\ModernSharing" /f >nul 2>&1
Reg delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\ModernSharing" /f >nul 2>&1
:: - > Remove 'bitmap image' from the 'new' Context Menus
Reg delete "HKCR\.bmp\ShellNew" /f >nul 2>&1
:: - > Remove 'rich text document' from 'new' Context Menus
Reg delete "HKCR\.rtf\ShellNew" /f >nul 2>&1
:: - > Remove 'send to' from Context Menus
Reg delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" /f >nul 2>&1
Reg delete "HKCR\UserLibraryFolder\shellex\ContextMenuHandlers\SendTo" /f >nul 2>&1
:: - > Remove 'add to favorites' from Context Menus
Reg delete "HKCR\*\shell\pintohomefile" /f >nul 2>&1
:: - > Remove 'rotate left' and 'rotate right' from Context Menus
Reg delete "HKCR\SystemFileAssociations\.avci\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.avif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.bmp\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.dds\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.dib\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.gif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.heic\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.heif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.hif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.ico\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.jfif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.jpe\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.jpeg\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.jpg\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.jxr\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.png\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.rle\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.tif\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.tiff\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.wdp\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
Reg delete "HKCR\SystemFileAssociations\.webp\ShellEx\ContextMenuHandlers\ShellImagePreview" /f >nul 2>&1
:: - > Remove 'Scan with Defender' from Context Menus
Reg delete "HKLM\SOFTWARE\Classes\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}\InprocServer32" /va /f >nul 2>&1
Reg delete "HKCR\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}" /v "InprocServer32" /f >nul 2>&1
Reg delete "HKCR\*\shellex\ContextMenuHandlers" /v "EPP" /f >nul 2>&1
Reg delete "HKCR\Directory\shellex\ContextMenuHandlers" /v "EPP" /f >nul 2>&1
Reg delete "HKCR\Drive\shellex\ContextMenuHandlers" /v "EPP" /f >nul 2>&1
:: - > Remove 'print' from Context Menus
Reg add "HKCR\SystemFileAssociations\image\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f >nul 2>&1
for %%a in (
    "batfile"
    "cmdfile"
    "docxfile"
    "fonfile"
    "htmlfile"
    "inffile"
    "inifile"
    "JSEFile"
    "otffile"
    "pfmfile"
    "regfile"
    "rtffile"
    "ttcfile"
    "ttffile"
    "txtfile"
    "VBEFile"
    "VBSFile"
    "WSFFile"
) do (
    Reg add "HKCR\%%~a\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f >nul 2>&1
)
:: - > Remove 'include in library' from Context Menus
Reg delete "HKCR\Folder\ShellEx\ContextMenuHandlers\Library Location" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location" /f >nul 2>&1
:: - > Remove 'troubleshooting compatibility' from Context Menus
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{1d27f844-3a1f-4410-85ac-14651078412d}" /t REG_SZ /d "" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{1d27f844-3a1f-4410-85ac-14651078412d}" /t REG_SZ /d "" /f >nul 2>&1
:: - > Add 'copy to' and 'move to' to Context Menus
Reg add "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\Copy To" /ve /t REG_SZ /d "{C2FBB630-2971-11D1-A18C-00C04FD75D13}" /f >nul 2>&1
Reg add "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\Move To" /ve /t REG_SZ /d "{C2FBB631-2971-11D1-A18C-00C04FD75D13}" /f >nul 2>&1
:: - > Add '.bat' to 'new' Context Menus
Reg add "HKLM\SOFTWARE\Classes\.bat\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\System32\acppage.dll,-6002" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Classes\.bat\ShellNew" /v "NullFile" /t REG_SZ /d "" /f >nul 2>&1
:: - > Add '.cmd' to 'new' Context Menus
Reg add "HKLM\SOFTWARE\Classes\.cmd\ShellNew" /v "NullFile" /t REG_SZ /d "" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Classes\.cmd\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\System32\acppage.dll,-6003" /f >nul 2>&1
:: - > Add '.ps1' to 'new' Context Menus
Reg add "HKLM\SOFTWARE\Classes\.ps1\ShellNew" /v "NullFile" /t REG_SZ /d "" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Classes\.ps1\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "New file" /f >nul 2>&1
:: - > Add '.reg' to 'new' Context Menus
Reg add "HKLM\SOFTWARE\Classes\.reg\ShellNew" /v "NullFile" /t REG_SZ /d "" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Classes\.reg\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\regedit.exe,-309" /f >nul 2>&1
:: - > Add 'take ownership' to Context Menus
Reg add "HKCR\*\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f >nul 2>&1
Reg add "HKCR\*\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul 2>&1
Reg add "HKCR\*\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul 2>&1
Reg add "HKCR\*\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul 2>&1
Reg add "HKCR\Directory\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f >nul 2>&1
Reg add "HKCR\Directory\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul 2>&1
Reg add "HKCR\Directory\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f >nul 2>&1
Reg add "HKCR\Directory\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "MultipleInvokePromptMinimum" /t REG_DWORD /d "200" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Winaero.com\Winaero Tweaker\Changes" /v "pageContextMenuSelectionLimit" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Add "merge as trusted installer" to .reg Context Menus
Reg add "HKCR\regfile\Shell\RunAs" /ve /t REG_SZ /d "Merge As TrustedInstaller" /f >nul 2>&1
Reg add "HKCR\regfile\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "1" /f >nul 2>&1
Reg add "HKCR\regfile\Shell\RunAs\Command" /ve /t REG_SZ /d "NSudo.exe -U:T -P:E Reg import "%1"" /f >nul 2>&1
:: - > Add 'install' to .cab Context Menus
Reg delete "HKCR\CABFolder\Shell\RunAs" /f >nul 2>&1
Reg add "HKCR\CABFolder\Shell\RunAs" /ve /t REG_SZ /d "Install" /f >nul 2>&1
Reg add "HKCR\CABFolder\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "" /f >nul 2>&1
Reg add "HKCR\CABFolder\Shell\RunAs\Command" /ve /t REG_SZ /d "cmd /k DISM /online /add-package /packagepath:\"%1\"" /f >nul 2>&1
:: - > Debloat 'Send To' context menu, hidden files do not show up in the 'Send To' context menu
attrib +h "C:\Users\%loggedinUsername%\AppData\Roaming\Microsoft\Windows\SendTo\Bluetooth File Transfer.LNK" >nul 2>&1
attrib +h "C:\Users\%loggedinUsername%\AppData\Roaming\Microsoft\Windows\SendTo\Mail Recipient.MAPIMail" >nul 2>&1
attrib +h "C:\Users\%loggedinUsername%\AppData\Roaming\Microsoft\Windows\SendTo\Documents.mydocs" >nul 2>&1

:: File Explorer Configuration
:: - > Disable 'Network Navigation' in the File Explorer Side Panel
Reg add "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2962489444" /f >nul 2>&1
:: - > Disable OneDrive in the File Explorer Side Panel
Reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /d "0" /t REG_DWORD /f >nul 2>&1
Reg add "HKCR\Wow6432Node\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /d "0" /t REG_DWORD /f >nul 2>&1
:: - > Remove Duplicate Removable Drives in the File Explorer Side Panel
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f >nul 2>&1
:: - > Disable 'Quick Access' in the File Explorer Side Panel
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "HubMode" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Disable '3D Objects' in the File Explorer Side Panel
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f >nul 2>&1
:: - > Hide frequently used files/folders in the 'Quick Access' File Explorer Side Panel
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Hide recently used files/folders in the 'Quick Access' File Explorer Side Panel
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Show the full path in the File Explorer Search Bar
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v "Settings" /t REG_BINARY /d "0c0002000b01000060000000" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v "FullPath" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Show hidden files in File Explorer
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Show file extensions in File Explorer
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Disable automatic folder type discovery in File Explorer
:: This is commented out as it causes your photos folder to auto sort by details
:: %currentuser% Reg delete "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f >nul 2>&1
:: %currentuser% Reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v "FolderType" /t REG_SZ /d "NotSpecified" /f >nul 2>&1
:: - > Show encrypted NTFS files in color in File Explorer
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowEncryptCompressedColor" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Don't show the status bar in File Explorer
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowStatusBar" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Open File Explorer to 'This PC'
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Revert to classic File Explorer search
Reg add "HKLM\SOFTWARE\Classes\CLSID\{1d64637d-31e9-4b06-9124-e83fb178ac6e}\TreatAs" /v "" /t REG_SZ /d "{64bc32b5-4eec-4de7-972d-bd8bd0324537}" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Classes\WOW6432Node\CLSID\{1d64637d-31e9-4b06-9124-e83fb178ac6e}\TreatAs" /v "" /t REG_SZ /d "{64bc32b5-4eec-4de7-972d-bd8bd0324537}" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\WOW6432Node\Classes\CLSID\{1d64637d-31e9-4b06-9124-e83fb178ac6e}\TreatAs" /v "" /t REG_SZ /d "{64bc32b5-4eec-4de7-972d-bd8bd0324537}" /f >nul 2>&1
:: - > Always show more details for File Explorer transfers
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" /v "EnthusiastMode" /t REG_DWORD /d "1" /f >nul 2>&1

:: Configure Taskbar
:: - > Hide meet now on the Taskbar
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Hide people button on the Taskbar
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HidePeopleBar" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Hide task view button on the Taskbar
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /D "0" /f >nul 2>&1
%currentuser% Reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MultiTaskingView\AllUpView" /v "Enabled" /f >nul 2>&1
:: - > Hide search from the Taskbar
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Don't pin the store to the Taskbar
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoPinningStoreToTaskbar" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Disable News and Interests on the Taskbar
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d "2" /f >nul 2>&1
:: - > Hide notification badges on the Taskbar
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarBadges" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Show command prompt in the WIN+X menu
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DontUsePowerShellOnWinX" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Disable Start Menu Recommendations
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_AccountNotifications" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Disable Start Menu Pins
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "StartMenu_Start_Time" /t REG_BINARY /d "889f04f10c79da01" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "Start_JumpListModernTime" /t REG_BINARY /d "29210bf10c79da01" /f >nul 2>&1
Reg add "HKU\%SID%\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "StartMenu_Start_Time" /t REG_BINARY /d "889f04f10c79da01" /f >nul 2>&1
Reg add "HKU\%SID%\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "Start_JumpListModernTime" /t REG_BINARY /d "29210bf10c79da01" /f >nul 2>&1
:: - > Hide Recently Added Apps in the Start Menu
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HideRecentlyAddedApps" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Set the Start Menu layout.xml
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_EXPAND_SZ /d "%WinDir%\layout.xml" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "LockedStartLayout" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy Objects\{2F5183E9-4A32-40DD-9639-F9FAF80C79F4}Machine\Software\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_EXPAND_SZ /d "%WinDir%\layout.xml" /f >nul 2>&1
:: - > Disable action center on the Taskbar
if "%os%"=="Windows 10" (
    Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f >nul 2>&1
)
:: - > Disable notifications
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /t REG_DWORD /d "1" /f >nul 2>&1
:: ^ - > Lock Screen Notifications
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "LockScreenToastEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Disable cloud optimized taskbars
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableCloudOptimizedContent" /t Reg_DWORD /d "1" /f >nul 2>&1
:: - > Disable CoPilot on Windows 11
if "%os%"=="Windows 11" do (%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCopilotButton" /t REG_DWORD /d "0" /f) >nul 2>&1

:: Enable the legacy photo viewer from windows 7 era
for %%a in (tif tiff bmp dib gif jfif jpe jpeg jpg jxr png) do (
    Reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".%%~a" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul 2>&1
)
for %%a in (tif tiff bmp dib gif jfif jpe jpeg jpg jxr png) do (
    %currentuser% Reg add "HKCU\SOFTWARE\Classes\.%%~a" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul 2>&1
)
:: - > File Explorer as only taskbar pin
Reg add "HKU\%SID%\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /v "FavoritesResolve" /t REG_BINARY /d "4a0300004c0000000114020000000000c0000000000000468300800020200000590db5b8fc78da012421b5b8fc78da011558413ce243d701970100000000000001000000000000000000000000000000a4013a001f80c827341f105c1042aa032ee45287d668260001002600efbe122000006e14cad6a972da01640049dba972da01e25d6fc3cb78da01140056003100000000007258e03211205461736b42617200400009000400efbe6a58d5297258e0322e0000004f9301000000010000000000000000000000000000009217c8005400610073006b00420061007200000016001201320097010000a852e041202046696c65204578706c6f7265722e6c6e6b007c0009000400efbe7258e0327258e0322e0000002096010000001f000000000000000000520000000000ebc1fe00460069006c00650020004500780070006c006f007200650072002e006c006e006b00000040007300680065006c006c00330032002e0064006c006c002c002d003200320030003600370000002000220000001e00efbe02005500730065007200500069006e006e006500640000002000120000002b00efbe3a36b6b8fc78da012000420000001d00efbe02004d006900630072006f0073006f00660074002e00570069006e0064006f00770073002e004500780070006c006f00720065007200000020000000af0000001c000000010000001c0000003800000000000000ae0000001c00000003000000283ae86810000000536572766572203230323200433a5c55736572735c41646d696e6973747261746f725c417070446174615c526f616d696e675c4d6963726f736f66745c496e7465726e6574204578706c6f7265725c517569636b204c61756e63685c557365722050696e6e65645c5461736b4261725c46696c65204578706c6f7265722e6c6e6b000060000000030000a0580000000000000077696e2d66717039616c756637386f008e8df7fd4d0d9e428f794b128d12d1b1d6ca9e90e6e4ee11846b7085c23c97408e8df7fd4d0d9e428f794b128d12d1b1d6ca9e90e6e4ee11846b7085c23c974045000000090000a03900000031535053b1166d44ad8d7048a748402ea43d788c1d000000680000000048000000b0bedfad7c6eda01580fcd443e37ed00000000000000000000000000" /f >nul 2>&1
Reg add "HKU\%SID%\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /v "Favorites" /t REG_BINARY /d "00a40100003a001f80c827341f105c1042aa032ee45287d668260001002600efbe122000006e14cad6a972da01640049dba972da01e25d6fc3cb78da01140056003100000000007258e03211205461736b42617200400009000400efbe6a58d5297258e0322e0000004f9301000000010000000000000000000000000000009217c8005400610073006b00420061007200000016001201320097010000a852e041202046696c65204578706c6f7265722e6c6e6b007c0009000400efbe7258e0327258e0322e0000002096010000001f000000000000000000520000000000ebc1fe00460069006c00650020004500780070006c006f007200650072002e006c006e006b00000040007300680065006c006c00330032002e0064006c006c002c002d003200320030003600370000002000120000002b00efbe3a36b6b8fc78da012000420000001d00efbe02004d006900630072006f0073006f00660074002e00570069006e0064006f00770073002e004500780070006c006f0072006500720000002000220000001e00efbe02005500730065007200500069006e006e0065006400000020000000ff" /f >nul 2>&1


:: Hide pages in UWP settings
if "%os%"=="Windows 10" (
    Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "hide:recovery;autoplay;usb;maps;maps-downloadmaps;findmydevice;privacy;privacy-speechtyping;privacy-speech;privacy-feedback;privacy-activityhistory;search-permissions;privacy-location;privacy-general;sync;printers;cortana-windowssearch;mobile-devices;mobile-devices-addphone;backup;" /f >nul 2>&1
)
:: - >  Hide unneeded control panel applets
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "RestrictCpl" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "1" /t REG_SZ /d "Administrative Tools" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "2" /t REG_SZ /d "Color Management" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "3" /t REG_SZ /d "Date and Time" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "4" /t REG_SZ /d "Device Manager" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "5" /t REG_SZ /d "File Explorer Options" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "6" /t REG_SZ /d "Internet Options" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "7" /t REG_SZ /d "Keyboard" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "8" /t REG_SZ /d "Mouse" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "9" /t REG_SZ /d "Network and Sharing Center" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "10" /t REG_SZ /d "Power Options" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "11" /t REG_SZ /d "Programs and Features" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "12" /t REG_SZ /d "Region" /f >nul 2>&1 
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "13" /t REG_SZ /d "Sound" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictCpl" /v "14" /t REG_SZ /d "Windows Defender Firewall" /f >nul 2>&1

:: Configure Windows Search
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsAADCloudSearchEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsMSACloudSearchEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsDeviceSearchHistoryEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "SafeSearchMode" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Explorer Search
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "AutoWildCard" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "EnableNaturalQuerySyntax" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "WholeFileSystem" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "SystemFolders" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "ArchivedFiles" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "SearchOnly" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable AutoRun and AutoPlay
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v "DisableAutoplay" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d "255" /f >nul 2>&1 
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoAutoplayfornonVolume" /t REG_DWORD /d "1" /f >nul 2>&1

:: Fix misbehaving icons when using 2 different resolution monitors
%currentuser% Reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "IconSpacing" /t REG_SZ /d "-1125" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "IconVerticalSpacing" /t REG_SZ /d "-1125" /f >nul 2>&1

:: Disable 'desktop.ini' file creation
:: https://www.makeuseof.com/desktop-ini-files-guide/#:~:text=these%20files%20important%3F-,The%20desktop.,configuring%20specific%20file%2Dsharing%20settings.
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "UseDesktopIniCache" /t REG_DWORD /d "0" /f >nul 2>&1

:: Set icon cache to 51.2MB
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "Max Cached Icons" /t REG_SZ /d "51200" /f >nul 2>&1

:: Turn off Internet File Association Service
:: https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.InternetCommunicationManagement::ShellNoUseInternetOpenWith_2
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetOpenWith" /t REG_DWORD /d 1 /f >nul 2>&1

:: Turn on Verbose Mode
:: https://www.thewindowsclub.com/enable-verbose-status-message-windows
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "VerboseStatus" /t REG_DWORD /d "1" /f >nul 2>&1

:: Show drive letters before drive name in File Explorer
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowDriveLettersFirst" /t REG_DWORD /d "4" /f >nul 2>&1

:: Disable USB Errors
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Shell\USB" /v "NotifyOnUsbErrors" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable 'Open File - Security Warning' message
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v "1806" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1806" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1806" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1806" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4" /v "1806" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v "1806" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1806" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1806" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1806" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4" /v "1806" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Security" /v "DisableSecuritySettingsCheck" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable ShellBags
%currentuser% Reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /v "BagMRU Size" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /v "BagMRU Size" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\Shell\BagMRU" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\Shell\Bags" /f >nul 2>&1
%currentuser% Reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f >nul 2>&1
%currentuser% Reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f >nul 2>&1
%currentuser% Reg delete "HKCU\Software\Microsoft\Windows\Shell\BagMRU" /f >nul 2>&1
%currentuser% Reg delete "HKCU\Software\Microsoft\Windows\Shell\Bags" /f >nul 2>&1
%currentuser% Reg delete "HKCU\Software\Microsoft\Windows\ShellNoRoam\BagMRU" /f >nul 2>&1
%currentuser% Reg delete "HKCU\Software\Microsoft\Windows\ShellNoRoam\Bags" /f >nul 2>&1

:: Storage Sense Configuration
:: - > Clean files once a month
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "01" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "1024" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "2048" /t REG_DWORD /d "30" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "04" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "32" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "02" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "128" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "08" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "256" /t REG_DWORD /d "30" /f >nul 2>&1

:: BSoD QoL
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "LogEvent" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl\StorageTelemetry" /v "DeviceDumpEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Explorer Audio Configuration
:: - > Fix volume mixer
%currentuser% Reg add "HKCU\Software\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore" /f >nul 2>&1 
:: - > Don't show disconnected/disabled devices in mmsys.cpl
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowDisconnectedDevices" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowHiddenDevices" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Set audio scheme to none
%currentuser% PowerShell -ExecutionPolicy Unrestricted -Command  "New-ItemProperty -Path 'HKCU:\AppEvents\Schemes' -Name '(Default)' -Value '.None' -Force | Out-Null" >nul 2>&1
%currentuser% PowerShell -ExecutionPolicy Unrestricted -Command  "Get-ChildItem -Path 'HKCU:\AppEvents\Schemes\Apps' | Get-ChildItem | Get-ChildItem | Where-Object {$_.PSChildName -eq '.Current'} | Set-ItemProperty -Name '(Default)' -Value ''" >nul 2>&1
:: - > Don't reduce sounds while in a call
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d "3" /f >nul 2>&1

:: Configure Windows 11 File Explorer
if "%os%"=="Windows 11" (
    :: - > Restore default context menu
    %currentuser% Reg add "HKCU\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /ve /t REG_SZ /d "" /f >nul 2>&1
    %currentuser% Reg add "HKCU\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /t REG_SZ /d "" /f >nul 2>&1
    :: - > Disable Start Menu Recommendations
    %currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_IrisRecommendations" /t REG_DWORD /d "0" /f >nul 2>&1
    :: - > Disable Widgets
    Reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d "0" /f >nul 2>&1
    :: - > Disable Dynamic Lighting
    %currentuser% Reg.exe add "HKCU\Software\Microsoft\Lighting" /v "AmbientLightingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    :: - > Allign the taskbar to the left
    %currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAl" /t REG_DWORD /d "0" /f >nul 2>&1
    :: - > Use compact view mode in File Explorer
    %currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseCompactMode" /t REG_DWORD /d "1" /f >nul 2>&1
    :: - > Hide UWP settings pages
    Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "hide:home;recovery;autoplay;usb;maps;maps-downloadmaps;findmydevice;privacy;privacy-speechtyping;privacy-speech;privacy-feedback;privacy-activityhistory;search-permissions;privacy-location;privacy-general;sync;printers;cortana-windowssearch;mobile-devices;mobile-devices-addphone;backup;" /f >nul 2>&1
    :: - > Hide gallery in File Explorer
    %currentuser% Reg add "HKCU\SOFTWARE\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f >nul 2>&1
    :: - > Show more pins in start menu
    %currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_Layout" /t REG_DWORD /d "1" /f >nul 2>&1
)


:: - Configuring privacy telemetry, and tracking in Windows.
:: Disable CEIP
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Messenger\Client" /v "CEIP" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\AppV\CEIP" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Disable CEIP Processes
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\AggregatorHost.exe" /v "Debugger" /t REG_SZ /d "%windir%\System32\taskkill.exe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\CompatTelRunner.exe" /v "Debugger" /t REG_SZ /d "%WinDir%\System32\taskkill.exe" /f >nul 2>&1

:: Disable Microsoft PC Manager Spread
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FeatureLoader.exe" /v "Debugger" /t REG_SZ /d "%windir%\System32\taskkill.exe" /f >nul 2>&1

:: Disable Windows Feedback
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t Reg_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg delete "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t Reg_DWORD /d "1" /f >nul 2>&1

:: Disable Data Collection
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowDeviceNameInTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t "REG_DWORD" /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowBuildPreview" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowCommercialDataPipeline" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowDeviceNameInTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DisableEnterpriseAuthProxy" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DisableTelemetryOptInChangeNotification" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DisableTelemetryOptInSettingsUx" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitDiagnosticLogCollection" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitDumpCollection" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "MicrosoftEdgeDataOptIn" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Advertising Info
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1

:: Disable Tailored Experiences
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableTailoredExperiencesWithDiagnosticData" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t Reg_DWORD /d "0" /f >nul 2>&1

:: Disable Health Monitoring
Reg add "HKLM\SOFTWARE\Policies\Microsoft\DeviceHealthAttestationService" /v "EnableDeviceHealthAttestationService" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v "DWNoExternalURL" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v "DWNoFileCollection" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v "DWNoSecondLevelCollection" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\HelpSvc" /v "Headlines" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Text/Ink/Handwriting Telemetry
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Error Reporting
Reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultConsent" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultOverrideBehavior" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "AutoApproveOSDumps" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DontShowUI" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\Consent" /v "0" /t REG_SZ /d "" /f >nul 2>&1

:: Disable Application Compatibility Engine
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AllowTelemetry" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableEngine" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t Reg_DWORD /d "1" /f >nul 2>&1

:: Disable Tracing
Reg add "HKLM\SOFTWARE\Microsoft\Tracing" /v "EnableAutoFileTracing" /t Reg_DWORD /d "0" /f  >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Tracing" /v "EnableConsoleTracing" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Tracing" /v "EnableFileTracing" /t Reg_DWORD /d "0" /f >nul 2>&1

:: Disallow the windows message cloud sync service as it can harm privacy
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Messaging" /v "AllowMessageSync" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Windows Spotlight
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "ConfigureWindowsSpotlight" /t REG_DWORD /d "2" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableTailoredExperiencesWithDiagnosticData" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableThirdPartySuggestions" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightFeatures" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightOnActionCenter" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightOnSettings" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightWindowsWelcomeExperience" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "IncludeEnterpriseSpotlight" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t REG_DWORD /d "1" /f >nul 2>&1

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
    %currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "%%~a" /t Reg_DWORD /d "0" /f >nul 2>&1
)

:: Disable License Telemetry
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t Reg_DWORD /d "1" /f >nul 2>&1

:: Disable tips in UWP settings
Reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowOnlineTips" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllowOnlineTips" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Location and Sensors
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocationScripting" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableWindowsLocationProvider" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableSensors" /t Reg_DWORD /d "1" /f >nul 2>&1

:: Disable Location Tracking
Reg add "HKLM\SOFTWARE\Policies\Microsoft\FindMyDevice" /v "AllowFindMyDevice" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\FindMyDevice" /v "LocationSyncEnabled" /t Reg_DWORD /d "0" /f >nul 2>&1

:: Explorer Telemetry
:: - > Clear history of recently opened documents on exit
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ClearRecentDocsOnExit" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Do not track shell shortcuts during roaming
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "LinkResolveIgnoreLinkInfo" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Disable user tracking
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInstrumentation" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Disable internet file association service
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetOpenWith" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Disable low disk space warning
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoLowDiskSpaceChecks" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Do not track history of recently opened documents
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Do not use the search-based method when resolving shell shortcuts
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveSearch" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Do not use the tracking-based method when resolving shell shortcuts
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveTrack" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Do not display or track items in jump lists from remote locations
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoRemoteDestinations" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Disable new app alert
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoNewAppAlert" /t REG_DWORD /d "1" /f >nul 2>&1

:: Track only important failure events
Auditpol /set /subcategory:"Process Termination" /success:disable /failure:enable > nul 2>&1
Auditpol /set /subcategory:"RPC Events" /success:disable /failure:enable > nul 2>&1
Auditpol /set /subcategory:"Filtering Platform Connection" /success:disable /failure:enable > nul 2>&1
Auditpol /set /subcategory:"DPAPI Activity" /success:disable /failure:disable > nul 2>&1
Auditpol /set /subcategory:"IPsec Driver" /success:disable /failure:enable > nul 2>&1
Auditpol /set /subcategory:"Other System Events" /success:disable /failure:enable > nul 2>&1
Auditpol /set /subcategory:"Security State Change" /success:disable /failure:enable > nul 2>&1
Auditpol /set /subcategory:"Security System Extension" /success:disable /failure:enable > nul 2>&1
Auditpol /set /subcategory:"System Integrity" /success:disable /failure:enable > nul 2>&1

:: Disable Sleep Study
wevtutil set-log "Microsoft-Windows-SleepStudy/Diagnostic" /e:false >nul 2>&1
wevtutil set-log "Microsoft-Windows-Kernel-Processor-Power/Diagnostic" /e:false >nul 2>&1
wevtutil set-log "Microsoft-Windows-UserModePowerService/Diagnostic" /e:false >nul 2>&1

:: Disallow microsoft accounts from overriding local accounts
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "NoConnectedUser" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Setting Sync
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableApplicationSettingSync" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableApplicationSettingSyncUserOverride" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWebBrowserSettingSync" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWebBrowserSettingSyncUserOverride" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableDesktopThemeSettingSync" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableDesktopThemeSettingSyncUserOverride" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSyncOnPaidNetwork" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWindowsSettingSync" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWindowsSettingSyncUserOverride" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableCredentialsSettingSync" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableCredentialsSettingSyncUserOverride" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisablePersonalizationSettingSync" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisablePersonalizationSettingSyncUserOverride" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableStartLayoutSettingSync" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableStartLayoutSettingSyncUserOverride" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t Reg_DWORD /d "5" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\AppSync" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\DesktopTheme" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\PackageState" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\StartLayout" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1

:: Disable PowerShell Telemetry
:: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_telemetry?view=powershell-7.3
setx POWERSHELL_TELEMETRY_OPTOUT 1 >nul 2>&1

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
    Reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\%%a" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
)

:: Delete Device Metadata
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /f >nul 2>&1

:: Disable MSRT Telemetry
Reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\RemovalTools\MpGears" /v "HeartbeatTrackingIndex" /t REG_DWORD /d "0" /f >nul 2>&1 
Reg add "HKLM\SOFTWARE\Microsoft\RemovalTools\MpGears" /v "SpyNetReportingLocation" /t REG_MULTI_SZ /d "" /f >nul 2>&1

:: Disable Telemetry and Program Compatibility Assistant Channels
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Assistant" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Assistant/Analytic" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Assistant/Compatibility-Infrastructure-Debug" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Assistant/Trace" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Troubleshooter" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Inventory" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Telemetry" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Steps-Recorder" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Configure Application Permissions
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1

:: Disable DCOM 
Reg add "HKLM\SOFTWARE\Microsoft\Ole" /v "EnableDCOM" /t REG_SZ /d "N" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Ole" /v "EnableDCOM" /t REG_SZ /d "N" /f >nul 2>&1

:: Disable OLE Logging
Reg add "HKLM\SOFTWARE\Microsoft\Ole" /v "ActivationFailureLoggingLevel" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Ole" /v "CallFailureLoggingLevel" /t REG_DWORD /d "2" /f >nul 2>&1

:: Disable RSoP Logging
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "RSoPLogging" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable ReadyBoost
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\EMDMgmt" /v "GroupPolicyDisallowCaches" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\EMDMgmt" /v "AllowNewCachesByDefault" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Internet Addons
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF90-7B36-11D2-B20E-00C04F983E60}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF90-7B36-11D2-B20E-00C04F983E60}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF91-7B36-11D2-B20E-00C04F983E60}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF91-7B36-11D2-B20E-00C04F983E60}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF94-7B36-11D2-B20E-00C04F983E60}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{2933BF94-7B36-11D2-B20E-00C04F983E60}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{3050F819-98B5-11CF-BB82-00AA00BDCE0B}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{3050F819-98B5-11CF-BB82-00AA00BDCE0B}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{333C7BC4-460F-11D0-BC04-0080C7055A83}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{333C7BC4-460F-11D0-BC04-0080C7055A83}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{373984C9-B845-449B-91E7-45AC83036ADE}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{373984C9-B845-449B-91E7-45AC83036ADE}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{3E4D4F1C-2AEE-11D1-9D3D-00C04FC30DF6}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{3E4D4F1C-2AEE-11D1-9D3D-00C04FC30DF6}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{435899C9-44AB-11D1-AF00-080036234103}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{435899C9-44AB-11D1-AF00-080036234103}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{4F664F91-FF01-11D0-8AED-00C04FD7B597}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1           
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{4F664F91-FF01-11D0-8AED-00C04FD7B597}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1   
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{64AB4BB7-111E-11D1-8F79-00C04FC2FBE1}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{64AB4BB7-111E-11D1-8F79-00C04FC2FBE1}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{65303443-AD66-11D1-9D65-00C04FC30DF6}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{65303443-AD66-11D1-9D65-00C04FC30DF6}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{6BF52A52-394A-11D3-B153-00C04F79FAA6}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{6BF52A52-394A-11D3-B153-00C04F79FAA6}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{884E2049-217D-11DA-B2A4-000E7BBB2B09}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{884E2049-217D-11DA-B2A4-000E7BBB2B09}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1 
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{884E2051-217D-11DA-B2A4-000E7BBB2B09}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{884E2051-217D-11DA-B2A4-000E7BBB2B09}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A05-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A05-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A06-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A06-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A07-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A07-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A08-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A08-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A0A-F192-11D4-A65F-0040963251E5}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{88D96A0A-F192-11D4-A65F-0040963251E5}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{8E4062D9-FE1B-4B9E-AA16-5E8EEF68F48E}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{8E4062D9-FE1B-4B9E-AA16-5E8EEF68F48E}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{92337A8C-E11D-11D0-BE48-00C04FC30DF6}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{92337A8C-E11D-11D0-BE48-00C04FC30DF6}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{C3701884-B39B-11D1-9D68-00C04FC30DF6}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{C3701884-B39B-11D1-9D68-00C04FC30DF6}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{D2517915-48CE-4286-970F-921E881B8C5C}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{D2517915-48CE-4286-970F-921E881B8C5C}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{EE09B103-97E0-11CF-978F-00A02463E06F}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{EE09B103-97E0-11CF-978F-00A02463E06F}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F32-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F32-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F33-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F33-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F34-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F34-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F35-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F35-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F36-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F36-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F39-C551-11D3-89B9-0000F81FE221}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F5078F39-C551-11D3-89B9-0000F81FE221}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F6D90F12-9C73-11D3-B32E-00C04F990BB4}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F6D90F12-9C73-11D3-B32E-00C04F990BB4}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F6D90F14-9C73-11D3-B32E-00C04F990BB4}" /v "Flags" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{F6D90F14-9C73-11D3-B32E-00C04F990BB4}" /v "Version" /t REG_SZ /d "*" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{2933BF90-7B36-11D2-B20E-00C04F983E60}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{2933BF91-7B36-11D2-B20E-00C04F983E60}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{2933BF94-7B36-11D2-B20E-00C04F983E60}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{3050F819-98B5-11CF-BB82-00AA00BDCE0B}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{333C7BC4-460F-11D0-BC04-0080C7055A83}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{373984C9-B845-449B-91E7-45AC83036ADE}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{3E4D4F1C-2AEE-11D1-9D3D-00C04FC30DF6}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{435899C9-44AB-11D1-AF00-080036234103}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{4F664F91-FF01-11D0-8AED-00C04FD7B597}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{64AB4BB7-111E-11D1-8F79-00C04FC2FBE1}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{65303443-AD66-11D1-9D65-00C04FC30DF6}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{6BF52A52-394A-11D3-B153-00C04F79FAA6}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{884E2049-217D-11DA-B2A4-000E7BBB2B09}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{884E2051-217D-11DA-B2A4-000E7BBB2B09}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A05-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A06-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A07-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A08-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{88D96A0A-F192-11D4-A65F-0040963251E5}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{8E4062D9-FE1B-4B9E-AA16-5E8EEF68F48E}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{92337A8C-E11D-11D0-BE48-00C04FC30DF6}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{C3701884-B39B-11D1-9D68-00C04FC30DF6}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{D2517915-48CE-4286-970F-921E881B8C5C}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{EE09B103-97E0-11CF-978F-00A02463E06F}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F32-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F33-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F34-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F35-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F36-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F5078F39-C551-11D3-89B9-0000F81FE221}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F6D90F12-9C73-11D3-B32E-00C04F990BB4}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{F6D90F14-9C73-11D3-B32E-00C04F990BB4}\iexplore" /v "Flags" /t REG_DWORD /d "4" /f >nul 2>&1

:: Configuring updates in Windows
:: - > Defer non-critical Windows Updates
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferQualityUpdates" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferQualityUpdatesPeriodInDays" /t REG_DWORD /d "6" /f >nul 2>&1
:: - > Disable Feature Updates as these will break the OS
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferFeatureUpdates" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferFeatureUpdatesPeriodInDays" /t REG_DWORD /d "365" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersion" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "BranchReadinessLevel" /t REG_DWORD /d "20" /f >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command  "if ((Get-WmiObject Win32_OperatingSystem).Caption -match '11') { $a = 'Windows 11' } else { $a = 'Windows 10' }; New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Name 'ProductVersion' -Value $a -PropertyType String -Force" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command  "$ver = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').DisplayVersion; New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Name 'TargetReleaseVersion' -Value $ver -PropertyType String -Force" >nul 2>&1
:: - > Disable Auto Updates
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Prevent DevHome, Outlook and Teams from installing
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler\DevHomeUpdate" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler\OutlookUpdate" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v "ConfigureChatAutoInstall" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Prevent random apps from installing, including Widgets or advertisements
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\Settings" /v "STOREBIZCRITICALAPPS" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\InstallService\State\CategoryCache" /v "48caba8a"-2e62-2097-dcd8-4255c637b32dUS /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "AccountsService" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "BackupBanner" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "DesktopSpotlight" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "IrisService" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "SystemSettingsExtensions" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "WebExperienceHost" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages\Components" /v "WindowsBackup" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\LastOnlineScanTimeForAppCategory\855E8A7C-ECB4-4CA3-B045-1DFA50104289" /v "EA6A8EC8-24BF-48A3-B0F0-A86A6447C0E2" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RequestedAppCategories\855E8A7C-ECB4-4CA3-B045-1DFA50104289" /v "EA6A8EC8-24BF-48A3-B0F0-A86A6447C0E2" /f >nul 2>&1
Reg delete "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\RestrictedServices\AppIso\FirewallRules" /v "{5D2C72C6-969D-4C1E-8484-41ED53782351}" /f >nul 2>&1
Reg delete "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{26037439-AD8B-4A56-AF2E-F6CDDB59F6BE}" /f >nul 2>&1
Reg delete "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{44000509-BE9E-419B-A60B-54E62CF41203}" /f >nul 2>&1
:: - > Prevent Malicious Software Removal Tool from installing
Reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Do not adjust default option to 'Install Updates and Shut Down' in Shut Down Windows dialog box
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAUAsDefaultShutdownOption" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "HideMCTLink" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "SetAutoRestartNotificationDisable" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "RestartNotificationsAllowed2" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "SetUpdateNotificationLevel" /t REG_DWORD /d "2" /f >nul 2>&1
:: - > Make WU not wake up your computer to install updates
:: https://admx.help/?Category=Windows_11_2022&Policy=Microsoft.Policies.WindowsUpdate::AUPowerManagement_Title
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "AUPowerManagement" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Don't auto reboot for updates
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Disable Windows Insider
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ManagePreviewBuilds" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ManagePreviewBuildsPolicyValue" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableConfigFlighting" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableExperimentation" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility" /v "HideInsiderPage" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Microsoft Store App Auto-Updates
Reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d "2" /f >nul 2>&1

: Disable pre-release features
Reg add "HKLM\Software\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableConfigFlighting" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Delivery Optimization
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "SystemSettingsDownloadMode" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings" /v "DownloadMode" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Reserved Storage for Windows Updates
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "MiscPolicyInfo" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "PassedPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "ShippedWithReserves" /t REG_DWORD /d "0" /f >nul 2>&1
DISM /Online /Set-ReservedStorageState /State:Disabled >nul 2>&1

:: Configuring Performance and Latency in Windows
:: - > MMCSS
:: - > Set system responsiveness to 10%
:: https://learn.microsoft.com/en-us/windows/win32/procthread/multimedia-class-scheduler-service#registry-settings
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "10" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /t REG_DWORD /d "10000" /f >nul 2>&1
:: High GPU Priority
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d "8" /f >nul 2>&1
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d "6" /f >nul 2>&1
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
:: Legacy DWORD
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1

:: Disable GameBar
%currentuser% Reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Disable GameBar tips
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "GamePanelStartupTipIndex" /t REG_DWORD /d "3" /f >nul 2>&1
:: - > Disable 'Open Xbox Game Bar using this button on a controller'
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Disable Game Bar Presence Writer, required for GameBar
Reg add "HKLM\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter" /v "ActivationType" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Disable Windows Game Recording and Broadcasting
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1

:: Remove FSO Overrides
Reg delete "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" /v "__COMPAT_LAYER" /f >nul 2>&1
%currentuser% Reg delete "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /f >nul 2>&1
%currentuser% Reg delete "HKCU\System\GameConfigStore" /v "GameDVR_DSEBehavior" /f >nul 2>&1
Reg delete "HKLM\System\GameConfigStore" /f >nul 2>&1
Reg delete "HKU\.Default\System\GameConfigStore" /f >nul 2>&1
Reg delete "HKU\S-1-5-19\System\GameConfigStore" /f >nul 2>&1
Reg delete "HKU\S-1-5-20\System\GameConfigStore" /f >nul 2>&1
%currentuser% Reg delete "HKCU\Software\Classes\System\GameConfigStore" /f >nul 2>&1

:: Enable FSO
%currentuser% Reg add HKCU\System\GameConfigStore /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f >nul 2>&1
%currentuser% Reg add HKCU\System\GameConfigStore /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add HKCU\System\GameConfigStore /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add HKCU\System\GameConfigStore /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable FastBoot (HiberBoot)
Reg add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Configure Process Priorities
:: - > Origin, ShareX, Epic Games Launcher, Rockstar Launcher, Steam and Open-Shell Processes to Below Normal
for %%i in (OriginWebHelperService.exe ShareX.exe EpicWebHelper.exe SocialClubHelper.exe steamwebhelper.exe StartMenu.exe ) do (
  Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "5" /f >nul 2>&1
)
:: - > fontdrvhost, lsasss, wmiprvse, svchost to Low
for %%i in (fontdrvhost.exe lsass.exe WmiPrvSE.exe svchost.exe ) do (
  Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
  Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>&1
)
:: - > CSRSS and ntoskrnl to Realtime
:: Commented out because these processes need to be elevated to a kernel level in order to change priorities
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>&1
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>&1
:: Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1
:: - > Foreground Priorities
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\I/O System" /v "PassiveIntRealTimeWorkerPriority" /t REG_DWORD /d "18" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\KernelVelocity" /v "DisableFGBoostDecay" /t REG_DWORD /d "1" /f >nul 2>&1
if "%server%"=="yes" do (Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "ForceForegroundBoostDecay" /t REG_DWORD /d "0" /f) >nul 2>&1

:: Win32PrioritySeperation (short variable 1:1, no foreground boost)
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f >nul 2>&1

:: Enable Timer Resolution on Windows 11
if "%os%"=="Windows 11" (
    Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d "1" /f >nul 2>&1
) else if "%server%"=="yes" (
    Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d "1" /f >nul 2>&1
)

:: Disable WatchDog Timer
:: https://www.analog.com/en/design-notes/disable-the-watchdog-timer-during-system-reboot.html
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableSensorWatchdog" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Memory Paging
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePageCombining" /t REG_DWORD /d "1" /f >nul 2>&1

:: Graphics Card Scheduling
:: - > Disable V-SYNC Interrupt Control
:: This reduces the amount of V-SYNC monitor refresh interrupts occur
:: https://learn.microsoft.com/en-us/windows-hardware/drivers/display/saving-energy-with-vsync-control
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "VsyncIdleTimeout" /t REG_DWORD /d "0" /f >nul 2>&1 
:: - > Enable GPU Preemption
:: https://learn.microsoft.com/en-us/windows-hardware/drivers/display/changing-the-behavior-of-the-gpu-scheduler-for-debugging
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "DisablePreemption" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Force contiguous DirectX memory allocation
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Disable GPU Isolation 
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "IOMMUFlags" /t REG_DWORD /d "0" /f >nul 2>&1

:: Enable VRR and Windowed Mode Optimizations
%currentuser% Reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "SwapEffectUpgradeEnable=1;" /f >nul 2>&1

:: SVCHOST Split Threshold 
Reg add "HKLM\SYSTEM\ControlSet001\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "4294967295" /f >nul 2>&1

:: Increase decomitting memory threshold
Reg add "HKLM\System\CurrentControlSet\Control\Session Manager" /v "HeapDeCommitFreeBlockThreshold" /t REG_DWORD /d "262144" /f >nul 2>&1

:: Disable Exclusive Mode on Audio Devices
for /f "delims=" %%a in ('Reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do %WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 %WinDir%\System32\Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d 0 /f >nul 2>&1
for /f "delims=" %%a in ('Reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do %WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 %WinDir%\System32\Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d 0 /f >nul 2>&1
for /f "delims=" %%a in ('Reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do %WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 %WinDir%\System32\Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d 0 /f >nul 2>&1
for /f "delims=" %%a in ('Reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do %WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 %WinDir%\System32\Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable Audio Enhancements
for %%a in ("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture", "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render") do (
    for /f "delims=" %%b in ('reg query "%%a"') do (
        Reg add "%%b\FxProperties" /v "{1da5d803-d492-4edd-8c23-e0c0ffee7f0e},5" /t REG_DWORD /d "1" /f >nul 2>&1
        Reg add "%%b\FxProperties" /v "{1b5c2483-0839-4523-ba87-95f89d27bd8c},3" /t REG_BINARY /d "030044CD0100000000000000" /f >nul 2>&1
        Reg add "%%b\FxProperties" /v "{73ae880e-8258-4e57-b85f-7daa6b7d5ef0},3" /t REG_BINARY /d "030044CD0100000001000000" /f >nul 2>&1
        Reg add "%%b\FxProperties" /v "{9c00eeed-edce-4cd8-ae08-cb05e8ef57a0},3" /t REG_BINARY /d "030044CD0100000004000000" /f >nul 2>&1
        Reg add "%%b\FxProperties" /v "{fc52a749-4be9-4510-896e-966ba6525980},3" /t REG_BINARY /d "0B0044CD0100000000000000" /f >nul 2>&1
        Reg add "%%b\FxProperties" /v "{ae7f0b2a-96fc-493a-9247-a019f1f701e1},3" /t REG_BINARY /d "0300BC5B0100000001000000" /f >nul 2>&1
        Reg add "%%b\FxProperties" /v "{1864a4e0-efc1-45e6-a675-5786cbf3b9f0},4" /t REG_BINARY /d "030044CD0100000000000000" /f >nul 2>&1
        Reg add "%%b\FxProperties" /v "{61e8acb9-f04f-4f40-a65f-8f49fab3ba10},4" /t REG_BINARY /d "030044CD0100000050000000" /f >nul 2>&1
        Reg add "%%b\Properties" /v "{e4870e26-3cc5-4cd2-ba46-ca0a9a70ed04},0" /t REG_BINARY /d "4100FE6901000000FEFF020080BB000000DC05000800200016002000030000000300000000001000800000AA00389B71" /f >nul 2>&1
        Reg add "%%b\Properties" /v "{e4870e26-3cc5-4cd2-ba46-ca0a9a70ed04},1" /t REG_BINARY /d "41008EC901000000A086010000000000" /f >nul 2>&1
        Reg add "%%b\Properties" /v "{3d6e1656-2e50-4c4c-8d85-d0acae3c6c68},3" /t REG_BINARY /d "4100020001000000FEFF020080BB000000DC05000800200016002000030000000300000000001000800000AA00389B71" /f >nul 2>&1
        Reg delete "%%b\Properties" /v "{624f56de-fd24-473e-814a-de40aacaed16},3" /f >nul 2>&1
        Reg delete "%%b\Properties" /v "{3d6e1656-2e50-4c4c-8d85-d0acae3c6c68},2" /f >nul 2>&1
    )
)

:: Power Registry
:: - > Disable Energy Estimation
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Disable Connected Standby
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
:: - > Disable PowerThrottling (8th gen and up?)
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f >nul 2>&1
:: - > Coalescing Timer 
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable WPBT
:: https://github.com/Jamesits/dropWPBT
:: https://download.microsoft.com/download/8/A/2/8A2FB72D-9B96-4E2D-A559-4A27CF905A80/windows-platform-binary-table.docx
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "DisableWpbtExecution" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Background Apps
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d "2" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f >nul 2>&1

:: Configuring ease of access settings in Windows
:: Disable Sticky keys, Mouse Keys, Toggle Keys, and other Keyboard Features
%currentuser% Reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Accessibility\MouseKeys" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Pointer Precision
%currentuser% Reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul 2>&1

:: Lower Keyboard Repeat Delay / Cursor Blink Rate
:: Keyboard repeat delay has 0 effect on gaming
%currentuser% Reg add "HKCU\Control Panel\Keyboard" /v "KeyboardDelay" /t REG_SZ /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Keyboard" /v "KeyboardSpeed" /t REG_SZ /d "31" /f >nul 2>&1

:: MarkC 1:1
:: %currentuser% Reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d 0000000000000000C0CC0C0000000000809919000000000040662600000000000033330000000000 /f >nul 2>&1
:: %currentuser% Reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d 0000000000000000000038000000000000007000000000000000A800000000000000E00000000000 /f >nul 2>&1

:: Configuring Misc Registry
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "ShowedToastAtLevel" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "DiagTrackAuthorization" /t REG_DWORD /d "775" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "DiagTrackStatus" /t REG_DWORD /d "2" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "UploadPermissionReceived" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\TraceManager" /v "MiniTraceSlotContentPermitted" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\TraceManager" /v "MiniTraceSlotEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Diagnostics\Performance" /v "DisableDiagnosticTracing" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}" /v "ScenarioExecutionEnabled" /t Reg_DWORD /d "0" /f >nul 2>&1

:: Disable RDP
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "fLogonDisabled" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable 'Use my sign-in info to finish setting up this device'
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableAutomaticRestartSignOn" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Typing Insights
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Input\Settings" /v "InsightsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Spell Checking
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableSpellchecking" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableTextPrediction" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnablePredictionSpaceInsertion" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableDoubleTapSpace" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableAutocorrection" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Fast User Switching
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "HideFastUserSwitching" /t REG_DWORD /d "1" /f >nul 2>&1

:: Run Startup Scripts Asynchronously
:: https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.Scripts::Run_Startup_Script_Sync
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "RunStartupScriptSync" /t REG_DWORD /d "0" /f >nul 2>&1


cls & echo !S_GREEN!Rebuilding Performance Counters...
lodctr /r >nul 2>&1
lodctr /r >nul 2>&1


cls & echo !S_GREEN!Debloating Windows...
for %%i in (
    3DBuilder bing bingfinance bingsports BingWeather
    Clipchamp.Clipchamp CommsPhone "Drawboard PDF" Facebook
    Getstarted Microsoft.549981C3F5F10 Microsoft.Cortana Microsoft.GamingApp
    Microsoft.GetHelp Microsoft.Messaging Microsoft.MicrosoftEdge.Stable Microsoft.MicrosoftStickyNotes
    Microsoft.OutlookForWindows Microsoft.PowerAutomateDesktop Microsoft.Todos Microsoft.Windows.Photos
    Microsoft.Xbox Microsoft.YourPhone MicrosoftCorporationII.QuickAssist MicrosoftOfficeHub
    Office.OneNote OneNote people SkypeApp solit Sway
    Twitter Windows.DevHome WindowsAlarms WindowsCalculator WindowsCamera
    windowscommunicationsapps WindowsFeedbackHub WindowsMaps WindowsPhone
    WindowsSoundRecorder WindowsTerminal zune Microsoft.Microsoft3DViewer Microsoft.MixedReality.Portal
    Microsoft.MSPaint
) do (
    %currentuser% PowerShell -Command "Get-AppxPackage -allusers *%%i* | Remove-AppxPackage" >nul
)

:: Remove OneDrive
taskkill /f /im OneDrive.exe
taskkill /f /im OneDrive.exe
if "%os%"=="Windows 11" (start /wait "" "%SYSTEMROOT%\System32\ONEDRIVESETUP.EXE" /UNINSTALL >nul) 
if "%os%"=="Windows 10" (start /wait "" "%SYSTEMROOT%\SysWOW64\ONEDRIVESETUP.EXE" /UNINSTALL >nul)

:: Remove OneDrive Startup Task
%currentuser% Reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1

:: Disable OneDrive Usage
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /t REG_DWORD /v "DisableFileSyncNGSC" /d 1 /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /t REG_DWORD /v "DisableFileSync" /d 1 /f >nul 2>&1

:: Remove Residual Files
%currentuser% PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%USERPROFILE%\OneDrive'; if (-Not $directoryGlob.EndsWith('\')) { $directoryGlob += '\' }; $directoryGlob )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%LOCALAPPDATA%\Microsoft\OneDrive'; if (-Not $directoryGlob.EndsWith('\')) { $directoryGlob += '\' }; $directoryGlob )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; <# Not using `Get-Acl`/`Set-Acl` to avoid adjusting token privileges #>; $parentDirectory = [System.IO.Path]::GetDirectoryName($expandedPath); $fileName = [System.IO.Path]::GetFileName($expandedPath); if ($parentDirectory -like '*[*?]*') {; throw "^""Unable to grant permissions to glob path parent directory: `"^""$parentDirectory`"^"", wildcards in parent directory are not supported by ``takeown`` and ``icacls``."^""; }; if (($fileName -ne '*') -and ($fileName -like '*[*?]*')) {; throw "^""Unable to grant permissions to glob path file name: `"^""$fileName`"^"", wildcards in file name is not supported by ``takeown`` and ``icacls``."^""; }; Write-Host "^""Taking ownership of `"^""$expandedPath`"^""."^""; $cmdPath = $expandedPath; if ($cmdPath.EndsWith('\')) {; $cmdPath += '\' <# Escape trailing backslash for correct handling in batch commands #>; }; $takeOwnershipCommand = "^""takeown /f `"^""$cmdPath`"^"" /a"^"" <# `icacls /setowner` does not succeed, so use `takeown` instead. #>; if (-not (Test-Path -Path "^""$expandedPath"^"" -PathType Leaf)) {; $takeOwnershipCommand += ' /r /d y'; }; $takeOwnershipOutput = cmd /c "^""$takeOwnershipCommand 2>&1"^"" <# `stderr` message is misleading, e.g. "^""ERROR: The system cannot find the file specified."^"" is not an error. #>; if ($LASTEXITCODE -eq 0) {; Write-Host "^""Successfully took ownership of `"^""$expandedPath`"^"" (using ``$takeOwnershipCommand``)."^""; } else {; Write-Host "^""Did not take ownership of `"^""$expandedPath`"^"" using ``$takeOwnershipCommand``, status code: $LASTEXITCODE, message: $takeOwnershipOutput."^""; <# Do not write as error or warning, because this can be due to missing path, it's handled in next command. #>; <# `takeown` exits with status code `1`, making it hard to handle missing path here. #>; }; Write-Host "^""Granting permissions for `"^""$expandedPath`"^""."^""; $adminSid = New-Object System.Security.Principal.SecurityIdentifier 'S-1-5-32-544'; $adminAccount = $adminSid.Translate([System.Security.Principal.NTAccount]); $adminAccountName = $adminAccount.Value; $grantPermissionsCommand = "^""icacls `"^""$cmdPath`"^"" /grant `"^""$($adminAccountName):F`"^"" /t"^""; $icaclsOutput = cmd /c "^""$grantPermissionsCommand"^""; if ($LASTEXITCODE -eq 3) {; Write-Host "^""Skipping, no items available for deletion according to: ``$grantPermissionsCommand``."^""; exit 0; } elseif ($LASTEXITCODE -ne 0) {; Write-Host "^""Take ownership message:`n$takeOwnershipOutput"^""; Write-Host "^""Grant permissions:`n$icaclsOutput"^""; Write-Warning "^""Failed to assign permissions for `"^""$expandedPath`"^"" using ``$grantPermissionsCommand``, status code: $LASTEXITCODE."^""; } else {; $fileStats = $icaclsOutput | ForEach-Object { $_ -match '\d+' | Out-Null; $matches[0] } | Where-Object { $_ -ne $null } | ForEach-Object { [int]$_ }; if ($fileStats.Count -gt 0 -and ($fileStats | ForEach-Object { $_ -eq 0 } | Where-Object { $_ -eq $false }).Count -eq 0) {; Write-Host "^""Skipping, no items available for deletion according to: ``$grantPermissionsCommand``."^""; exit 0; } else {; Write-Host "^""Successfully granted permissions for `"^""$expandedPath`"^"" (using ``$grantPermissionsCommand``)."^""; }; }; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%PROGRAMDATA%\Microsoft OneDrive'; if (-Not $directoryGlob.EndsWith('\')) { $directoryGlob += '\' }; $directoryGlob )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%SYSTEMDRIVE%\OneDriveTemp'; if (-Not $directoryGlob.EndsWith('\')) { $directoryGlob += '\' }; $directoryGlob )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"

:: Delete OneDrive Shortcuts
PowerShell -ExecutionPolicy Unrestricted -Command "$shortcuts = @(; @{ Revert = $True;  Path = "^""$env:APPDATA\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"^""; }; @{ Revert = $False; Path = "^""$env:USERPROFILE\Links\OneDrive.lnk"^""; }; @{ Revert = $False; Path = "^""$env:WINDIR\ServiceProfiles\LocalService\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"^""; }; @{ Revert = $False; Path = "^""$env:WINDIR\ServiceProfiles\NetworkService\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"^""; }; ); foreach ($shortcut in $shortcuts) {; if (-Not (Test-Path $shortcut.Path)) {; Write-Host "^""Skipping, shortcut does not exist: `"^""$($shortcut.Path)`"^""."^""; continue; }; try {; Remove-Item -Path $shortcut.Path -Force -ErrorAction Stop; Write-Output "^""Successfully removed shortcut: `"^""$($shortcut.Path)`"^""."^""; } catch {; Write-Error "^""Encountered an issue while attempting to remove shortcut at: `"^""$($shortcut.Path)`"^""."^""; }; }" >nul 2>&1
%currentuser% PowerShell -ExecutionPolicy Unrestricted -Command "Set-Location "^""HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace"^""; Get-ChildItem | ForEach-Object {Get-ItemProperty $_.pspath} | ForEach-Object {; $leftnavNodeName = $_."^""(default)"^"";; if (($leftnavNodeName -eq "^""OneDrive"^"") -Or ($leftnavNodeName -eq "^""OneDrive - Personal"^"")) {; if (Test-Path $_.pspath) {; Write-Host "^""Deleting $($_.pspath)."^""; Remove-Item $_.pspath;; }; }; }" >nul 2>&1


cls & echo !S_GREEN!Configuring Windows Features and Capabilities...
:: Features and Components
:: Enable DirectPlay
dism /Online /Enable-Feature /FeatureName:"LegacyComponents" /NoRestart >nul 2>&1
dism /Online /Enable-Feature /FeatureName:"DirectPlay" /NoRestart >nul 2>&1
:: Disable Hyper-V
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-All" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Management-Clients" /NoRestart >nul 2>&1
:: Disable Hyper-V Management Tools
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Tools-All" /NoRestart >nul 2>&1
:: Disable Hyper-V Module for Windows PowerShell
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Management-PowerShell" /NoRestart >nul 2>&1
:: Disable Telnet Client
dism /Online /Disable-Feature /FeatureName:"TelnetClient" /NoRestart >nul 2>&1
:: Disable Net.TCP Port Sharing
dism /Online /Disable-Feature /FeatureName:"WCF-TCP-PortSharing45" /NoRestart >nul 2>&1
:: Disable SMB Direct
dism /Online /Disable-Feature /FeatureName:"SmbDirect" /NoRestart >nul 2>&1
:: Disable SMB1 Protocol
dism /online /Disable-Feature /FeatureName:"SMB1Protocol" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"SMB1Protocol-Client" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"SMB1Protocol-Server" /NoRestart >nul 2>&1
:: Disable TFTP Client
dism /Online /Disable-Feature /FeatureName:"TFTP" /NoRestart >nul 2>&1
:: Disable Internet Printing Client
dism /Online /Disable-Feature /FeatureName:"Printing-Foundation-InternetPrinting-Client" /NoRestart >nul 2>&1
:: Disable LPD Print Service
dism /Online /Disable-Feature /FeatureName:"LPDPrintService" /NoRestart >nul 2>&1
:: Disable Internet Explorer
dism /Online /Disable-Feature /FeatureName:"Internet-Explorer-Optional-x64" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"Internet-Explorer-Optional-x84" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"Internet-Explorer-Optional-amd64" /NoRestart >nul 2>&1
:: Disable LPR Port Monitor
dism /Online /Disable-Feature /FeatureName:"Printing-Foundation-LPRPortMonitor" /NoRestart >nul 2>&1
:: Disable Microsoft Print to PDF
dism /Online /Disable-Feature /FeatureName:"Printing-PrintToPDFServices-Features" /NoRestart >nul 2>&1
:: Disable "PS Services
dism /Online /Disable-Feature /FeatureName:"Printing-XPSServices-Features" /NoRestart >nul 2>&1
:: Disable XPS Viewer
dism /Online /Disable-Feature /FeatureName:"Xps-Foundation-Xps-Viewer" /NoRestart >nul 2>&1
:: Disable Print and Document Services
dism /Online /Disable-Feature /FeatureName:"Printing-Foundation-Features" /NoRestart >nul 2>&1
:: Disable Work Folders Client
dism /Online /Disable-Feature /FeatureName:"WorkFolders-Client" /NoRestart >nul 2>&1
:: Enable Windows Media Player
dism /Online /Enable-Feature /FeatureName:"MediaPlayback" /NoRestart >nul 2>&1
dism /Online /Enable-Feature /FeatureName:"WindowsMediaPlayer" /NoRestart >nul 2>&1
:: Disable "Scan Management" feature
dism /Online /Disable-Feature /FeatureName:"ScanManagementConsole" /NoRestart >nul 2>&1
:: Disable "Windows Fax and Scan" feature
dism /Online /Disable-Feature /FeatureName:"FaxServicesClientPackage" /NoRestart >nul 2>&1
:: Disable PowerShell V2
dism /Online /Disable-Feature /FeatureName:"MicrosoftWindowsPowerShellV2Root" /NoRestart >nul 2>&1
:: Disable Remote Differential Compression
dism /Online /Disable-Feature /FeatureName:"MSRDC-Infrastructure" /NoRestart >nul 2>&1
:: Disable WCF Services
dism /Online /Disable-Feature /FeatureName:"WCF-Services45" /NoRestart >nul 2>&1


:: Capabilities
:: Remove "Internet Explorer 11
%PowerShell% "Get-WindowsCapability -Online -Name 'Browser.InternetExplorer*' | Remove-WindowsCapability -Online" >nul 2>&1
:: Remove Math Recognizer
%PowerShell% "Get-WindowsCapability -Online -Name 'MathRecognizer~~~~0.0.1.0*' | Remove-WindowsCapability -Online" >nul 2>&1
:: Remove "OneSync" (breaks Mail, People, and Calendar)
%PowerShell% "Get-WindowsCapability -Online -Name 'OneCoreUAP.OneSync*' | Remove-WindowsCapability -Online" >nul 2>&1
:: Remove OpenSSH client 
%PowerShell% "Get-WindowsCapability -Online -Name 'OpenSSH.Client*' | Remove-WindowsCapability -Online" >nul 2>&1
:: Remove PowerShell ISE
%PowerShell% "Get-WindowsCapability -Online -Name 'Microsoft.Windows.PowerShell.ISE*' | Remove-WindowsCapability -Online" >nul 2>&1
:: Remove Print Management Console
%PowerShell% "Get-WindowsCapability -Online -Name 'Print.Management.Console*' | Remove-WindowsCapability -Online" >nul 2>&1
:: Remove Quick Assist
%PowerShell% "Get-WindowsCapability -Online -Name 'App.Support.QuickAssist*' | Remove-WindowsCapability -Online" >nul 2>&1
:: Remove Steps Recorder
%PowerShell% "Get-WindowsCapability -Online -Name 'App.StepsRecorder*' | Remove-WindowsCapability -Online" >nul 2>&1
:: Remove Windows Fax and Scan
%PowerShell% "Get-WindowsCapability -Online -Name 'Print.Fax.Scan*' | Remove-WindowsCapability -Online" >nul 2>&1
:: Remove Hello Face
%PowerShell% "Get-WindowsCapability -Online -Name 'Hello.Face.20134~~~~0.0.1.0*' | Remove-WindowsCapability -Online" >nul 2>&1 
:: Remove WordPad
%PowerShell% "Get-WindowsCapability -Online -Name 'Microsoft.Windows.WordPad~~~~0.0.1.0*' | Remove-WindowsCapability -Online" >nul 2>&1
:: Remove Legacy NotePad
%PowerShell% "Get-WindowsCapability -Online -Name 'Microsoft.Windows.Notepad.System~~~~0.0.1.0*' | Remove-WindowsCapability -Online" >nul 2>&1
:: Remove Extended Wallpapers
%PowerShell% "Get-WindowsCapability -Online -Name 'Microsoft.Wallpapers.Extended~~~~0.0.1.0*' | Remove-WindowsCapability -Online" >nul 2>&1

if "%server%"=="yes" (
    %PowerShell% "Remove-WindowsFeature AzureArcSetup"
)

:: UWP Deprovision
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\1527c705-839a-4832-9118-54d4Bd6a0c89_cw5n1h2txyewy" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.3DBuilder_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.BingFinance_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.BingNews_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.BingSports_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.BingWeather_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.Microsoft3DViewer_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.Office.OneNote_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.Office.Sway_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.StorePurchaseApp_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.Windows.CloudExperienceHost_cw5n1h2txyewy" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.Windows.Phone_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.WindowsPhone_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.WindowsStore_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.Xbox.TCUI_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.XboxApp_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.XboxGameOverlay_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.XboxIdentityProvider_8wekyb3d8bbwe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe" /f >nul 2>&1


cls & echo !S_GREEN!Installing Visual C++
"%WinDir%\NeptuneDir\Prerequisites\vcredist.exe" /ai8X239T >nul 2>&1

cls & echo !S_GREEN!Installing DirectX
"%WinDir%\NeptuneDir\Prerequisites\DirectX\DXSETUP.exe" /silent >nul 2>&1

cls & echo !S_GREEN!Installing 7-Zip
"%WinDir%\NeptuneDir\Prerequisites\7z.exe" /S  >nul 2>&1

if "%os%"=="Windows 11" (
    cls & echo !S_GREEN!Installing Timer Resolution Service
    "%WinDir%\NeptuneDir\Tools\TimerResolution.exe" -install >nul 2>&1
)

if "%os%"=="Windows 10" (
    cls & echo !S_GREEN!Installing Open Shell
    "%WinDir%\NeptuneDir\Prerequisites\openshell.exe" /qn ADDLOCAL=StartMenu >nul 2>&1

    cls & echo !S_GREEN!Configuring Open Shell
    %currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "Version" /t REG_DWORD /d "67371150" /f >nul 2>&1
    %currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkipMetro" /t REG_DWORD /d "1" /f >nul 2>&1
    %currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "MenuStyle" /t REG_SZ /d "Win7" /f >nul 2>&1
    %currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "ProgramsMenuDelay" /t REG_DWORD /d "99999999" /f >nul 2>&1
    %currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "StartScreenShortcut" /t REG_DWORD /d "0" /f >nul 2>&1
    %currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkinW7" /t REG_SZ /d "" /f >nul 2>&1
    %currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkinVariationW7" /t REG_SZ /d "" /f >nul 2>&1
    %currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkinOptionsW7" /t REG_MULTI_SZ /d "USER_IMAGE=1\0SMALL_ICONS=1\0THICK_BORDER=0\0SOLID_SELECTION=0" /f >nul 2>&1
    %currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "MenuItems7" /t REG_MULTI_SZ /d "Item1.Command=user_files\0Item1.Settings=NOEXPAND\0Item2.Command=user_documents\0Item2.Settings=NOEXPAND\0Item3.Command=user_pictures\0Item3.Settings=NOEXPAND\0Item4.Command=user_music\0Item4.Settings=NOEXPAND\0Item5.Command=user_videos\0Item5.Settings=ITEM_DISABLED\0Item6.Command=downloads\0Item6.Settings=ITEM_DISABLED\0Item7.Command=homegroup\0Item7.Settings=ITEM_DISABLED\0Item8.Command=separator\0Item9.Command=games\0Item9.Settings=TRACK_RECENT|NOEXPAND|ITEM_DISABLED\0Item10.Command=favorites\0Item10.Settings=ITEM_DISABLED\0Item11.Command=computer\0Item11.Settings=NOEXPAND\0Item12.Command=downloads\0Item12.Settings=NOEXPAND\0Item13.Command=network\0Item13.Settings=ITEM_DISABLED\0Item14.Command=network_connections\0Item14.Settings=ITEM_DISABLED\0Item15.Command=separator\0Item16.Command=control_panel\0Item16.Settings=TRACK_RECENT|NOEXPAND\0Item17.Command=pc_settings\0Item17.Settings=TRACK_RECENT\0Item18.Command=admin\0Item18.Settings=TRACK_RECENT|ITEM_DISABLED\0Item19.Command=devmgmt.msc\0Item19.Label=Device Manager\0Item19.Icon=C:\Windows\system32\devmgr.dll, 201\0Item19.Settings=NOEXPAND\0Item20.Command=defaults\0Item20.Settings=ITEM_DISABLED\0Item21.Command=help\0Item21.Settings=ITEM_DISABLED\0Item22.Command=run\0Item23.Command=apps\0Item23.Settings=ITEM_DISABLED\0Item24.Command=windows_security\0Item24.Settings=ITEM_DISABLED" /f >nul 2>&1
    %currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "ShiftRight" /t REG_DWORD /d "1" /f >nul 2>&1
    %currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "RecentPrograms" /t REG_SZ /d "None" /f >nul 2>&1
    %currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchTrack" /t REG_DWORD /d "0" /f >nul 2>&1
    %currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchAutoComplete" /t REG_DWORD /d "0" /f >nul 2>&1
    %currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchInternet" /t REG_DWORD /d "0" /f >nul 2>&1
    %currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "MainMenuAnimate" /t REG_DWORD /d "0" /f >nul 2>&1
    %currentuser% Reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "FontSmoothing" /t REG_SZ /d "Default" /f >nul 2>&1
)

cls & echo !S_GREEN!Finalizing Setup
:: Disable windows search and start menu on Windows 10
if "%os%"=="Windows 10" (
    ren SearchHost.exe SearchHost.old >nul 2>&1
    cd C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy >nul 2>&1
    takeown /f "StartMenuExperienceHost.exe" >nul 2>&1
    icacls "C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\StartMenuExperienceHost.exe" /grant Administrators:F >nul 2>&1
    ren StartMenuExperienceHost.exe StartMenuExperienceHost.old >nul 2>&1
    taskkill /f /im searchapp.exe >nul 2>&1
    taskkill /f /im SearchHost.exe >nul 2>&1
    taskkill /f /im StartMenuExperienceHost.exe >nul 2>&1
    cd C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy >nul 2>&1
    takeown /f "searchapp.exe" >nul 2>&1
    icacls "C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\searchapp.exe" /grant Administrators:F >nul 2>&1
    ren searchapp.exe searchapp.old >nul 2>&1
    cd C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy >nul 2>&1
    icacls "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe" /grant Administrators:F >nul 2>&1
    takeown /f "SearchHost.exe" >nul 2>&1
    taskkill /f /im TextInputHost.exe
    takeown /f "TextInputHost.exe" >nul 2>&1
    icacls "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\TextInputHost.exe" /grant Administrators:F >nul 2>&1
    ren TextInputHost.exe TextInputHost.old >nul 2>&1
    cd C:\Windows\System32
    taskkill /f /im RuntimeBroker.exe
    icacls "C:\Windows\System32\RuntimeBroker.exe" /grant Administrators:F >nul 2>&1
    takeown /f "RuntimeBroker.exe" >nul 2>&1
    ren RuntimeBroker.exe RuntimeBroker.old >nul 2>&1
)


:: Delete microcode
:: deleting this on 24H2 (build 25931) and up will cause boot device not found BSOD
:: if "%os%"=="Windows 10" (
::     takeown /f C:\Windows\System32\mcupdate_GenuineIntel.dll >nul 2>&1
::     takeown /f C:\Windows\System32\mcupdate_AuthenticAMD.dll >nul 2>&1
::     del C:\Windows\System32\mcupdate_GenuineIntel.dll /s /f /q >nul 2>&1
::     del C:\Windows\System32\mcupdate_AuthenticAMD.dll /s /f /q >nul 2>&1
:: )

:: Delete neptune setup files
del /f /q "%WinDir%\NeptuneDir\debloat.ps1" >nul 2>&1
del /f /q "%WinDir%\NeptuneDir\FullscreenCMD.vbs" >nul 2>&1
del /f /q "%WinDir%\NeptuneDir\power.pow" >nul 2>&1
del /f /q "%WinDir%\NeptuneDir\pnp-powersaving.ps1" >nul 2>&1
rmdir /s /q "%WinDir%\NeptuneDir\Prerequisites" >nul 2>&1
rmdir /s /q "%WinDir%\NeptuneDir\Packages" >nul 2>&1

:: Set notice text
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticecaption" /t REG_SZ /d "Welcome to NeptuneOS %version%. A custom OS catered towards gamers. " /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticetext" /t REG_SZ /d "https://discord.gg/4YTSkcK8b8" /f >nul 2>&1

:: Importing finalization script into RunOnce
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "Finalization" /t REG_SZ /d "%WinDir%\NeptuneDir\finalize.bat" /f >nul 2>&1

cls
echo !S_GRAY!This window has finished.
timeout /t 5 /nobreak >nul

































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
Reg query "HKLM\System\CurrentControlSet\Services\%1" >nul 2>&1 || (
    echo The specified service/driver %1 is not found. >> C:\Windows\NeptuneDir\neptune.txt
    exit /b 1 )
Reg add "HKLM\System\CurrentControlSet\Services\%1" /v "Start" /t Reg_DWORD /d "%2" /f > nul
echo Service/Driver %1 configured with startup



