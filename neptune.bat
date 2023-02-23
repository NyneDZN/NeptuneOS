:: Script created for NeptuneOS by nyne.#1431

:: - Credit given to
:: - AdamX
:: - amitxv (EVA) 
:: - AtlasOS (Xyueta)
:: - FoxOS (CatGamerOP
:: - DuckOS (AnhNguyen#7472, fikinoob#6487)
:: - EchoX
:: - ShDW



@echo off

:: Delayed Expansion
setlocal EnableDelayedExpansion

:: Enviornment Variables
set version=0.3
set network=0
set github=0

:: Functions
goto :FUNCTIONS

:Prep
:: Elevation Check
 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (  
	echo Your install of NeptuneOS %version% is corrupt. Please re-install.
)

:: Disable Mouse and Explorer
wscript "%NeptuneDir%FullscreenCMD.vbs"
%devmanview% /disable "HID-compliant mouse"
cls & echo Killed Explorer
echo Killed Mouse Control (Only to prevent pausing/closing the script. Keyboard control is active.)
timeout /5

:: Set Title
title Neptune %version%

:: Label Drive 
label C: NeptuneOS %version% 

:: Begin Log for debugging purposes
echo NeptuneOS Logs %date% %time% >%temp%\NeptuneDebugger.txt
echo NeptuneOS Error Logs %date% %time% >%temp%\NeptuneErrors.txt

:: Can we connect to the internet?
ping -n 1 1.1.1.1 | findstr Reply >NUL && set network=1

:: What about GitHub?
ping -n 1 raw.githubusercontent.com | findstr Reply >NUL && set github=1
cls


echo.
echo.
echo  Disclaimer:
echo  Do NOT close out of this Post Install script.
echo  This script will continue to setup NeptuneOS
echo  This may take between 2-5 minutes depending on your HDD/SSD speed.
echo  Please report any errors you may encounter in the OS or with this script.
echo  If you close this, please re-run it in C:\Windows\NEPTUNE.
echo  Press any key to continue the script.
echo.
echo.


timeout /t 300 > nul
cls
goto StartScript


:StartScript
:: Prerequisites
cls & echo Installing Visual C++
"%NeptuneDir%Prerequisites\vcredist2005_x86.exe" /q
"%NeptuneDir%Prerequisites\vcredist2005_x64.exe" /q
"%NeptuneDir%Prerequisites\vcredist2008_x86.exe" /qb
"%NeptuneDir%Prerequisites\vcredist2008_x64.exe" /qb
"%NeptuneDir%Prerequisites\vcredist2010_x86.exe" /passive /norestart
"%NeptuneDir%Prerequisites\vcredist2010_x64.exe" /passive /norestart
"%NeptuneDir%Prerequisites\vcredist2012_x86.exe" /passive /norestart
"%NeptuneDir%Prerequisites\vcredist2012_x64.exe" /passive /norestart
"%NeptuneDir%Prerequisites\vcredist2013_x86.exe" /passive /norestart
"%NeptuneDir%Prerequisites\vcredist2013_x64.exe" /passive /norestart
"%NeptuneDir%Prerequisites\vcredist2015_2017_2019_2022_x86.exe" /passive /norestart
"%NeptuneDir%Prerequisites\vcredist2015_2017_2019_2022_x64.exe" /passive /norestart
cls & echo Installing DirectX
"%NeptuneDir%Prerequisites\DirectX\DXSETUP.exe" /silent 
cls & echo Installing Media Player
"%NeptuneDir%Prerequisites\MPC.exe" /VERYSILENT /NORESTART
cls & echo Installing 7-Zip
"%NeptuneDir%Prerequisites\7z.exe" /S 
cls & echo Installing Open Shell
"%NeptuneDir%Prerequisites\openshell.exe" /qn ADDLOCAL=StartMenu 
cls & echo Installing Timer Resolution Service
"%NeptuneDir%Prerequisites\str.exe" -install

"%NeptuneDir%Tools\nircmd.exe shortcut "C:\POST INSTALL" "%userprofile%\Desktop" "Post-Install"

:: Registry
cls & echo Importing NEPTUNE %version% registry profile
Regedit.exe /s "%NeptuneDir%neptune.reg" 
PowerRun.exe /SW:0 regedit.exe /s "%NeptuneDir%neptune.reg"


:: Prepare DWM Script
cls & echo Preparing DWM Script

takeown /F "%windir%\System32\dwm.exe" /A & icacls "%windir%\System32\dwm.exe" /grant Administrators:(F)
takeown /F "%windir%\System32\UIRibbon.dll" /A & icacls "%windir%\System32\UIRibbon.dll" /grant Administrators:(F) 
takeown /F "%windir%\System32\UIRibbonRes.dll" /A & icacls "%windir%\System32\UIRibbonRes.dll" /grant Administrators:(F) 
takeown /F "%windir%\System32\Windows.UI.Logon.dll" /A & icacls "%windir%\System32\Windows.UI.Logon.dll" /grant Administrators:(F) 
takeown /F "%windir%\System32\RuntimeBroker.exe" /A & icacls "%windir%\System32\RuntimeBroker.exe" /grant Administrators:(F) 
takeown /F "%windir%\SystemApps\ShellExperienceHost_cw5n1h2txyewy" /A & icacls "%windir%\SystemApps\ShellExperienceHost_cw5n1h2txyewy" /grant Administrators:(F) 
copy /y "%windir%\System32\dwm.exe" "%NeptuneDir%Other\dwm\realdwm\dwm.exe"
copy /y "%windir%\System32\rundll32.exe" "%NeptuneDir%Other\dwm\fakedwm\dwm.exe"

:: Unhide Power Attributes
:: source: https://gist.github.com/Velocet/7ded4cd2f7e8c5fa475b8043b76561b5#file-unlock-powercfg-ps1
%PowerShell% "$PowerCfg = (Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings' -Recurse).Name -notmatch '\bDefaultPowerSchemeValues|(\\[0-9]|\b255)$';foreach ($item in $PowerCfg) { Set-ItemProperty -Path $item.Replace('HKEY_LOCAL_MACHINE','HKLM:') -Name 'Attributes' -Value 0 -Force}"

:: Disable Hibernation
cls & echo Disabling Hibernation
powercfg -h off

:: Powerplan Configuration
cls & echo Importing Power Plan

powercfg -import "%NeptuneDir%power.pow" 11111111-1111-1111-1111-111111111111
powercfg -setactive 11111111-1111-1111-1111-111111111111
powercfg -changename 11111111-1111-1111-1111-111111111111 "NeptuneOS Powerplan" "A powerplan created to achieve low latency and high 0.01% lows." 
powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a 
powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e 
powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 
powercfg -delete e9a42b02-d5df-448d-aa00-03f14749eb61

:: Disable Sleep States 
cls & echo Disabling Sleep States...

:: Disable Away Mode Policy
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 0
powercfg -setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 0
:: Disable Idle States
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0
powercfg -setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0
:: Disable Hybrid Sleep
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0
powercfg -setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0

cls & echo Configuring Power States...

:: Enable Hardware P-States
powercfg -setacvalueindex scheme_current sub_processor PERFAUTONOMOUS 1 
powercfg -setacvalueindex scheme_current sub_processor PERFAUTONOMOUSWINDOW 20000 
powercfg -setacvalueindex scheme_current sub_processor PERFCHECK 20
:: Configure C-States
powercfg -setacvalueindex scheme_current sub_processor IDLEPROMOTE 100 
powercfg -setacvalueindex scheme_current sub_processor IDLEDEMOTE 100 
powercfg -setacvalueindex scheme_current sub_processor IDLECHECK 20000 
:: Enable Turbo Boost
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTMODE 1 
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTPOL 100 

:: Set Active Scheme as Currnt
powercfg -setactive scheme_current

:: Disable Powersaving on Drivers
cls & echo Disable Powersaving

for /f "tokens=*" %%a in ('wmic path Win32_PnPEntity GET DeviceID ^| findstr "USB\VID_"') do (   
    for %%i in (
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
        Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "%%i" /t REG_DWORD /d "0" /f
    )
)

:: Disable PnP Powersaving
%PowerShell% "$usb_devices = @('Win32_USBController', 'Win32_USBControllerDevice', 'Win32_USBHub'); $power_device_enable = Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi; foreach ($power_device in $power_device_enable){$instance_name = $power_device.InstanceName.ToUpper(); foreach ($device in $usb_devices){foreach ($hub in Get-WmiObject $device){$pnp_id = $hub.PNPDeviceID; if ($instance_name -like \"*$pnp_id*\"){$power_device.enable = $False; $power_device.psbase.put()}}}}"

:: Disable Powersaving in UMDF (LMFAO) drivers
for %%a in (WakeEnabled WdkSelectiveSuspendEnable) do (
	for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class" /s /f "%%a" ^| findstr "HKEY"') do (
		Reg.exe add "%%b" /v "%%a" /t REG_DWORD /d "0" /f 
	)
)

:: Disable Powersaving on Network Adapter
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" /v "DefaultPnPCapabilities" /t REG_DWORD /d "24" /f

:: Disable StorPort Idle
for /f "tokens=*" %%s in ('reg query "HKLM\System\CurrentControlSet\Enum" /S /F "StorPort" ^| findstr /e "StorPort"') do Reg add "%%s" /v "EnableIdlePowerManagement" /t REG_DWORD /d "0" /f 

:: More Powersaving (?)
powershell "%WinDir%\NEPTUNE\pnp-powersaving.ps1" 

:: Disable Timer Coalescing 
:: https://en.wikipedia.org/wiki/Timer_coalescing
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f

:: Disable Powerthrottling
:: Intel CPUs, 6 generation or higher
:: https://blogs.windows.com/windows-insider/2017/04/18/introducing-power-throttling
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f

:: Disable Sleep Study
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f
wevtutil set-log "Microsoft-Windows-SleepStudy/Diagnostic" /e:false
wevtutil set-log "Microsoft-Windows-Kernel-Processor-Power/Diagnostic" /e:false
wevtutil set-log "Microsoft-Windows-UserModePowerService/Diagnostic" /e:false

:: Disable Energy Estimation
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f

:: Disable Energy Logging
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "DisableTaggedEnergyLogging" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxApplication" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxTagPerApplication" /t REG_DWORD /d "0" /f

:: Disable CPU Core Parking (?)
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoreParkingDisabled" /t REG_DWORD /d "0" /f

:: Disable Event Processor (?)
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f

:: Disable Battery Estimation (Laptops)
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PerfCalculateActualUtilization" /t REG_DWORD /d "0" /f

:: Disable IRQ Steering
:: https://www.computerhope.com/jargon/i/irqhold.htm#:~:text=PCI%20IRQ%20steering%20is%20a,also%20supported%20PCI%20IRQ%20Steering.
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "InterruptSteeringDisabled" /t REG_DWORD /d "1" /f 

:: Disable More Sleep Features (?)
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "SleepReliabilityDetailedDiagnostics" /t REG_DWORD /d "0" /f 

:: Disable Power Quality of Service (?)
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "QosManagesIdleProcessors" /t REG_DWORD /d "0" /f

:: Disable Watchdog Timer
:: https://www.analog.com/en/design-notes/disable-the-watchdog-timer-during-system-reboot.html
:: A watchdog timer continuously watches the execution of code and resets the system if the software hangs or no longer executes the correct sequence of code
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableSensorWatchdog" /t REG_DWORD /d "1" /f

:: Disable Fastboot
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d "0" /f

:: Win32PrioritySeperation (26 Hex)
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f

:: (?)
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableVsyncLatencyUpdate" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "MfBufferingThreshold" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "TimerRebaseThresholdOnDripsExit" /t REG_DWORD /d "30" /f 


:: File System Configuration
cls & echo Configuring The File System

FSUTIL behavior set allowextchar 0
FSUTIL behavior set Bugcheckoncorrupt 0
:: Disable 8.3 File Creation
:: https://ttcshelbyville.wordpress.com/2018/12/02/should-you-disable-8dot3-for-performance-and-security
FSUTIL behavior set disable8dot3 1 
:: Disable NTFS File Compression
FSUTIL behavior set disablecompression 1 
:: Disable NTFS File Encryption
FSUTIL behavior set disableencryption 1 
:: Disable Last Accessed Timestamp
FSUTIL behavior set disablelastaccess 1 
FSUTIL behavior set disablespotcorruptionhandling 1
:: Enable Trimming for SSD's
FSUTIL behavior set disabledeletenotify 0 
:: Don't Encrypt The Paging File
FSUTIL behavior set encryptpagingfile 0 
FSUTIL behavior set quotanotify 86400 
FSUTIL behavior set symlinkevaluation L2L:1 
:: Disable NTFS Self Repair
FSUTIL repair set C: 0


:: Disable Write Cache Buffer
	for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI"^| findstr "HKEY"') do (
		for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do Reg.exe add "%%a\Device Parameters\Disk" /v "CacheIsPowerProtected" /t REG_DWORD /d "1" /f 
	)
	for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI"^| findstr "HKEY"') do (
		for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do Reg.exe add "%%a\Device Parameters\Disk" /v "UserWriteCacheSetting" /t REG_DWORD /d "1" /f 
	)
)

:: Disable HIPM, DIPM, HDD Parking
FOR /F "eol=E" %%a in ('REG QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "EnableHIPM"^| FINDSTR /V "EnableHIPM"') DO (
	Reg.exe add "%%a" /F /V "EnableHIPM" /T REG_DWORD /d 0 
	Reg.exe add "%%a" /F /V "EnableDIPM" /T REG_DWORD /d 0 
	Reg.exe add "%%a" /F /V "EnableHDDParking" /T REG_DWORD /d 0 
)

:: IOLATENCYCAP 0
FOR /F "eol=E" %%a in ('REG QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "IoLatencyCap"^| FINDSTR /V "IoLatencyCap"') DO (
	Reg.exe add "%%a" /F /V "IoLatencyCap" /T REG_DWORD /d 0 
)



:: Time Server Configuration
cls & echo Changing NTP Server...

:: Switch to pool.ntp.org
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"
:: Resync to pool.ntp.org
net start w32time
w32tm /config /update
w32tm /resync
%setSvc% W32Time 4



:: Explorer Configuration
cls & echo Configuring Explorer...

:: Enable Dark Mode
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d "0" /f

:: Disable Transparency
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f

:: Disable Wide Context Menu
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\FlightedFeatures" /v "ImmersiveContextMenu" /t REG_DWORD /d "0" /f

:: Configure visual effect settings
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9012038010000000" /f

:: Disable startup delay of running apps
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f






:: Registry Configuration
cls & echo Configuring the Registry..

:: Disable Windows Update
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "UseWUServer" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "IncludeRecommendedUpdates" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DoNotConnectToWindowsUpdateInternetLocations" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "UpdateServiceUrlAlternate" /t REG_SZ /d "http://disableupdateserver.com/" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUServer" /t REG_SZ /d "http://disableupdateserver.com/" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUStatusServer" /t REG_SZ /d "http://disableupdateserver.com/" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate" /v "value" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate" /v "value" /t REG_DWORD /d "1" /f
Reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgrade" /f

:: BSOD Quality of Life
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "LogEvent" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl\StorageTelemetry" /v "DeviceDumpEnabled" /t REG_DWORD /d "0" /f

:: Disable CEIP
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\AppV\CEIP" /v "CEIPEnable" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\VSCommon\15.0\SQM" /v "OptIn" /t REG_DWORD /d "0" /f

:: Disable content delivery manager
:: Disable pre-installed apps
:: Disable windows welcome experience 
:: Disable suggested content in immersive control panel
:: Disable fun facts, tips, tricks on windows spotlight
:: Disable start menu suggestions
:: Disable get tips, tricks, and suggestions as you use windows
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
    "SubscribedContent-338388Enabled"
    "SystemPaneSuggestionsEnabled"
    "SubscribedContent-338389Enabled"
    "SoftLandingEnabled"
) do (
    %currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "%%~a" /t REG_DWORD /d "0" /f
)

:: Disable tips in immersive control panel
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowOnlineTips" /v "value" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllowOnlineTips" /t REG_DWORD /d "0" /f

:: Disable program compatibility assistant
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableEngine" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d "1" /f

:: Disable devicecensus.exe telemetry process
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\'DeviceCensus.exe'" /v "Debugger" /t REG_SZ /d "%WinDir%\System32\taskkill.exe" /f

:: Disable microsoft compatibility appraiser telemetry process
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\'CompatTelRunner.exe'" /v "Debugger" /t REG_SZ /d "%WinDir%\System32\taskkill.exe" /f

:: Disable unnecessary autologgers
for %%a in (
    "Circular Kernel Context Logger"
    "CloudExperienceHostOobe"
    "DefenderApiLogger"
    "DefenderAuditLogger"
    "Diagtrack-Listener"
    "Diaglog"
    "LwtNetLog"
    "Microsoft-Windows-Rdp-Graphics-RdpIdd-Trace"
    "NetCore"
    "NtfsLog"
    "RadioMgr"
    "RdrLog"
    "ReadyBoot"
    "SpoolerLogger"
    "UBPM"
    "WdiContextLog"
    "WiFiSession"
) do (
    Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\%%~a" /v "Start" /t REG_DWORD /d "0" /f
)

:: Disable speech model updates
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f

:: Disable online speech recognition 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "AllowInputPersonalization" /t REG_DWORD /d "0" /f

:: Disable windows insider and build previews
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableConfigFlighting" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableExperimentation" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility" /v "HideInsiderPage" /t REG_DWORD /d "1" /f

:: Disable activity feed
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d "0" /f

:: Disable windows spotlight features
%currentuser% Reg.exe add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightFeatures" /t REG_DWORD /d "1" /f

:: Disable tips in immersive control panel
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowOnlineTips" /v "value" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllowOnlineTips" /t REG_DWORD /d "0" /f

:: Disable suggest ways I can finish setting up my device
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d "0" /f

:: Disable automatically restart apps after sign in
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "RestartApps" /t REG_DWORD /d "0" /f

:: Disable disk quota
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DiskQuota" /v "Enable" /t REG_DWORD /d "0" /f

:: Never use tablet mode
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "SignInMode" /t REG_DWORD /d "1" /f

:: Disable 'Open file' - security warning message
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1806" /t REG_DWORD /d "0" /f

:: Do not preserve zone information in file attachments
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f

:: Disable text/ink/handwriting telemetry
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f

:: Disable data collection
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowDeviceNameInTelemetry" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f

:: Configure app permissions/privacy
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t Reg.exe_SZ /d "Deny" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /v "Value" /t Reg.exe_SZ /d "Deny" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t Reg.exe_SZ /d "Deny" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /v "Value" /t Reg.exe_SZ /d "Deny" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /v "Value" /t Reg.exe_SZ /d "Deny" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t Reg.exe_SZ /d "Deny" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /v "Value" /t Reg.exe_SZ /d "Deny" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /v "Value" /t Reg.exe_SZ /d "Deny" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" /v "Value" /t Reg.exe_SZ /d "Deny" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /v "Value" /t Reg.exe_SZ /d "Deny" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /v "Value" /t Reg.exe_SZ /d "Deny" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /v "Value" /t Reg.exe_SZ /d "Deny" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t Reg.exe_SZ /d "Deny" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /v "Value" /t Reg.exe_SZ /d "Deny" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /v "Value" /t Reg.exe_SZ /d "Deny" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /v "Value" /t Reg.exe_SZ /d "Deny" /f

:: Disable smartscreen
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "PreventOverride" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f
Reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "ShellSmartScreenLevel" /f

:: Disable experimentation
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\System\AllowExperimentation" /v "Value" /t REG_DWORD /d "0" /f

:: Disable performance tracking
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}" /v "ScenarioExecutionEnabled" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Diagnostics\Performance" /v "DisableDiagnosticTracing" /t REG_DWORD /d "1" /f

:: Disable settings sync
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSyncOnPaidNetwork" /t REG_DWORD /d "1" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t REG_DWORD /d "5" /f

:: Disable location tracking
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\FindMyDevice" /v "AllowFindMyDevice" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\FindMyDevice" /v "LocationSyncEnabled" /t REG_DWORD /d "0" /f

:: Disable advertising info
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f

:: Disable windows feedback
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f 
%currentuser% Reg.exe delete "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /f > nul 2>nul
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f

:: Disable notifications and notification center
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f

:: Disable all lockscreen notifications
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "LockScreenToastEnabled" /t REG_DWORD /d "0" /f

:: Disable maintenance
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f

:: Disable background apps
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d "2" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f

:: Disable license telemetry
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t REG_DWORD /d "1" /f

:: Disable suggest ways I can finish setting up my device
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d "0" /f

:: Disable automatically restart apps after sign in
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "RestartApps" /t REG_DWORD /d "0" /f

:: Disable fast user switching
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "HideFastUserSwitching" /t REG_DWORD /d "1" /f

:: Disable windows error reporting
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d "0 /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultConsent" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultOverrideBehavior" /t REG_DWORD /d "1" /f








:: Disable Scheduled Tasks
cls & echo Disabling Scheduled Tasks...

for %%i in (
	"\Microsoft\Windows\Application Experience\StartupAppTask"
	"\Microsoft\Windows\Autochk\Proxy"
	"\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask"
	"\Microsoft\Windows\Chkdsk\ProactiveScan"
	"\Microsoft\Windows\Chkdsk\SyspartRepair"
	"\Microsoft\Windows\Data Integrity Scan\Data Integrity Scan"
	"\Microsoft\Windows\Data Integrity Scan\Data Integrity Scan for Crash Recovery"
	"\Microsoft\Windows\Defrag\ScheduledDefrag"
	"\Microsoft\Windows\DiskCleanup\SilentCleanup"
	"\Microsoft\Windows\DiskFootPrint\Diagnostics"
	"\Microsoft\Windows\DiskFootPrint\StorageSense"
	"\Microsoft\Windows\LanguageComponentsInstaller\Uninstallation"
	"\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents"
	"\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic"
	"\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"
	"\Microsoft\Windows\Registry\RegIdleBackup"
	"\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime"
	"\Microsoft\Windows\Time Synchronization\SynchronizeTime"
	"\Microsoft\Windows\Time Zone\SynchronizeTimeZone"
	"\Microsoft\Windows\UpdateOrchestrator\Reboot"
	"\Microsoft\Windows\UpdateOrchestrator\Schedule Scan"
	"\Microsoft\Windows\UpdateOrchestrator\USO_Broker_Display"
	"\Microsoft\Windows\UPnP\UPnPHostConfig"
	"\Microsoft\Windows\User Profile Service\HiveUploadTask"
	"\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange"
	"\Microsoft\Windows\WindowsUpdate\Scheduled Start"
	"\Microsoft\Windows\WindowsUpdate\sih"
	"\Microsoft\Windows\Wininet\CacheTask"
) do (
	Schtasks.exe /Change /Disable /TN %%i 
	%NeptuneDir%Tools\powerrun.exe /SW:0 schtasks.exe /Change /Disable /TN %%i
)

:: DWM Configuration
cls & echo Configuring Desktop Window Manager...

:: Enable Window Colorization
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableWindowColorization" /t REG_DWORD /d "1" /f
:: Disable Aero Peek
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f 
:: Disable Windows Animations
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DWMWA_TRANSITIONS_FORCEDISABLED" /t REG_DWORD /d "1" /f 
:: Disable DWM Composition
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "Composition" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowComposition" /t REG_DWORD /d "1" /f 
:: More DWM (?)
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "DisableDrawListCaching" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "DisallowNonDrawListRendering" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "EnableCpuClipping" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "EnableDrawToBackbuffer" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "EnableImageProcessing" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "EnableMPCPerfCounter" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "TelemetryFramesSequenceMaximumPeriodMilliseconds" /t REG_DWORD /d "500" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "UseHWDrawListEntriesOnWARP" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d "5" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "DwmInputUsesIoCompletionPort" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "EnableDwmInputProcessing" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm\ExtendedComposition" /v "ExclusiveModeFramerateAveragingPeriodMs" /t REG_DWORD /d "1000" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm\ExtendedComposition" /v "ExclusiveModeFramerateThresholdPercent" /t REG_DWORD /d "250" /f 

:: Optimize Hung Apps and Shutdown Times
cls & echo Optimize Hung Apps and Shutdown Times
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f 
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "8" /f 
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "1000" /f 
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop" /v "LowLevelHooksTimeout" /t REG_SZ /d "1000" /f 
Reg.exe add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "100" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "1000" /f

:: Disable Mouse Acceleration
cls & echo Configuring Keyboard and Mouse
%currentuser% Reg.exe add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "0" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d "0" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Keyboard" /v "KeyboardDelay" /t REG_SZ /d "0" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Keyboard" /v "KeyboardSpeed" /t REG_SZ /d "31" /f

:: Disable Ease of Access Settings
cls & echo Configuring Ease of Access Settings
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\AudioDescription" /v "Flags" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\Blind Access" /v "Flags" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\HighContrast" /v "Flags" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Preference" /v "Flags" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\MouseKeys" /v "Flags" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\On" /v "Flags" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\ShowSounds" /v "Flags" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\SlateLaunch" /v "Flags" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\SoundSentry" /v "Flags" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\TimeOut" /v "Flags" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_DWORD /d "0" /f


:: Audio Configuration
cls & echo Configuring Audio Settings...

:: Disable Exclusive Mode on Devices
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do %NeptuneDir%Tools\PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d 0 /f
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do %NeptuneDir%Tools\PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d 0 /f
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do %NeptuneDir%Tools\PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d 0 /f
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do %NeptuneDir%Tools\PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d 0 /f

:: Legacy Volume Control
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" /v "EnableMtcUvc" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Multimedia\Audio\DeviceCpl" /v "VolumeUnits" /t REG_DWORD /d "0" /f
:: Fix Volume Mixer
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore" /f 
:: Don't Show Disconnected/Disabled Devices
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowDisconnectedDevices" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowHiddenDevices" /t REG_DWORD /d "0" /f
:: Set Audio Scheme to None
%currentuser% %PowerShell% "New-ItemProperty -Path 'HKCU:\AppEvents\Schemes' -Name '(Default)' -Value '.None' -Force | Out-Null"
%currentuser% %PowerShell% "Get-ChildItem -Path 'HKCU:\AppEvents\Schemes\Apps' | Get-ChildItem | Get-ChildItem | Where-Object {$_.PSChildName -eq '.Current'} | Set-ItemProperty -Name '(Default)' -Value ''"
:: Don't Reduce Sounds While In A Call
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d "3" /f

:: Split Audio Services
copy /y "%windir%\System32\svchost.exe" "%windir%\System32\audiosvchost.exe"
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv" /v "ImagePath" /t REG_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalServiceNetworkRestricted -p" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\AudioEndpointBuilder" /v "ImagePath" /t REG_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalSystemNetworkRestricted -p" /f 


:: Legacy Photo Viewer
cls & echo Reviving Legacy Photo Viewer...

:: Enable the Photo Viewer
for %%i in (tif tiff bmp dib gif jfif jpe jpeg jpg jxr png) do (
    Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".%%~i" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f
)
:: Set Photo Viewer as Default
for %%i in (tif tiff bmp dib gif jfif jpe jpeg jpg jxr png) do (
    %currentuser% Reg.exe add "HKCU\SOFTWARE\Classes\.%%~i" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f
    %currentuser% Reg.exe add "HKCU\SOFTWARE\Classes\.wdp" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f
)


:: Boot Configuration Data
cls & echo Configuring BCDEdit...

:: Disable Boot Graphics
bcdedit /set bootux disabled 
:: Legacy Boot Menu
bcdedit /set bootmenupolicy legacy
:: Disable Hyper-V
bcdedit /set hypervisorlaunchtype off 
:: Disable TPM
bcdedit /set tpmbootentropy ForceDisable 
:: Enable Quiet Boot
bcdedit /set quietboot yes 
:: Disable Boot Logo
bcdedit /set {globalsettings} custom:16000067 true 
:: Disable The Boot Animation
bcdedit /set {globalsettings} custom:16000069 true 
:: Disable Boot Messages
bcdedit /set {globalsettings} custom:16000068 true 
:: Disable Automatic Repair
bcdedit /set {current} recoveryenabled no
:: Set Boot Label
bcdedit /set {current} description "NeptuneOS %version%"
:: Disable DEP
bcdedit /set nx AlwaysOff
:: Use Synthetic Timers
bcdedit /set disabledynamictick yes 
bcdedit /set useplatformtick Yes 
bcdedit /deletevalue useplatformclock 
:: 15 Second Timeout for Dualboot
bcdedit /timeout 15
:: Disable Emergency Management Services
bcdedit /set ems No 
bcdedit /set bootems No 
:: Disable Kernel Debugging
bcdedit /set debug No 
:: Stop using uncontiguous portions of low-memory
:: https://sites.google.com/view/melodystweaks/basictweaks
bcdedit /set firstmegabytepolicy UseAll 
bcdedit /set avoidlowmemory 0x8000000 
bcdedit /set nolowmem Yes
:: Disable DMA Memory Protection and Core Isolation
bcdedit /set vm No 
bcdedit /set vsmlaunchtype Off 
:: Disable Memory Mitigations
bcdedit /set allowedinmemorysettings 0x0

 

:: Disable Devices
cls & echo Disabling Devices...

%devman% /disable "ACPI Processor Aggregator" 
%devman% /disable "ACPI Wake Alarm" 
%devman% /disable "Composite Bus Enumerator"
%devman% /disable "Direct memory access controller" 
%devman% /disable "High precision event timer"
%devman% /disable "Microsoft Device Association Root Enumerator" 
%devman% /disable "Microsoft GS Wavetable Synth" 
%devman% /disable "Microsoft Hyper-V Virtualization Infrastructure Driver" 
%devman% /disable "Microsoft Kernel Debug Network Adapter" 
%devman% /disable "Microsoft RRAS Root Enumerator" 
%devman% /disable "Microsoft System Management BIOS Driver"
%devman% /disable "Microsoft Virtual Drive Enumerator" 
%devman% /disable "Microsoft Windows Management Interface for ACPI"
%devman% /disable "Motherboard resources" 
%devman% /disable "NDIS Virtual Network Adapter Enumerator" 
%devman% /disable "Numeric data processor" 
%devman% /disable "PCI Data Acquisition and Signal Processing Controller" 
%devman% /disable "PCI Device" 
%devman% /disable "PCI Memory Controller" 
%devman% /disable "PCI Simple Communications Controller" 
%devman% /disable "PCI Simple Communications Controller" 
%devman% /disable "PCI standard RAM Controller" 
%devman% /disable "Plug and Play Software Device Enumerator"
%devman% /disable "Programmable interrupt controller" 
%devman% /disable "Root Print Queue" 
%devman% /disable "SM Bus Controller" 
%devman% /disable "System board" 
%devman% /disable "System CMOS/real time clock"
%devman% /disable "System Speaker" 
%devman% /disable "System Timer" 
%devman% /disable "UMBus Root Bus Enumerator" 
%devman% /disable "Unknown Device" 
%devman% /disable "USB Video Device"

:: Network Adapters
%devman% /disable "WAN Miniport (IKEv2)" 
%devman% /disable "WAN Miniport (IP)" 
%devman% /disable "WAN Miniport (IPv6)" 
%devman% /disable "WAN Miniport (L2TP)" 
%devman% /disable "WAN Miniport (Network Monitor)" 
%devman% /disable "WAN Miniport (PPPOE)" 
%devman% /disable "WAN Miniport (PPTP)" 
%devman% /disable "WAN Miniport (SSTP)"



:: Memory Optimization
cls & echo Configuring Memory Management...

:: Superfetch and Prefetch
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 0 /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d 0 /f 
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableBootTrace" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "SfTracingState" /t REG_DWORD /d "0" /f
:: 2GB Paging File
Reg.exe add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Memory Management" /v "PagingFiles" /t REG_MULTI_SZ /d "?:\pagefile.sys 4096 4096" /f 
:: 64GB SVCHost Split Threshold
Reg.exe add "HKLM\SYSTEM\ControlSet001\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "4294967295" /f 
:: Enable Large System Cache 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "1" /f 
:: Disallow Paging Drivers
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f 
:: Disable Page Combining 
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePageCombining" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\currentcontrolset\control\session manager\Memory Management" /v "DisablePagingCombining" /t REG_DWORD /d "1" /f 
:: Disable Swapfile
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SwapfileControl" /t REG_DWORD /d "0" /f 

:: Memory Heap Tweaks
:: Reg add "HKLM\System\CurrentControlSet\Control\Session Manager" /v "HeapDeCommitFreeBlockThreshold" /t REG_DWORD /d "262144" /f 

:: Disable Memory Compression
%PowerShell% "Disable-MMAgent -MemoryCompression"



:: Gaming/GPU Configuration
cls & echo Configuring GPU...
:: Global Fullscreen Exclusive
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\GameBar" /v "GamePanelStartupTipIndex" /t REG_DWORD /d "3" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "1" /f
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_DSEBehavior" /t REG_DWORD /d "2" /f
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "__COMPAT_LAYER" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" /f

:: Disable V-SYNC Control (?)
:: https://learn.microsoft.com/en-us/windows-hardware/drivers/display/saving-energy-with-vsync-control
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "VsyncIdleTimeout" /t REG_DWORD /d "0" /f 
:: Disable GPU Debugging/Preemption
:: https://learn.microsoft.com/en-us/windows-hardware/drivers/display/changing-the-behavior-of-the-gpu-scheduler-for-debugging
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d "0" /f

:: Disable Variable Refresh Rate
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "VRROptimizeEnable=0;" /f 

:: Monitor Latency Tolerance (?)
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorLatencyTolerance" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "0" /f

:: Force Contiguous DirectX Memory Allocation
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f

:: MMCSS Profile
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "AlwaysOn" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "ffffffff" /f 
Reg.exe add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Latency Sensitive" /t REG_SZ /d "True" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f


:: MSI and IRQ Priority
cls & echo Enabling MSI Mode...

:: Enable MSI Mode and set priorities to 'undefined'
for %%a in (
    Win32_USBController, 
    Win32_VideoController, 
    Win32_NetworkAdapter, 
    Win32_IDEController
) do (
    for /f %%i in ('wmic path %%a get PNPDeviceID ^| findstr /l "PCI\VEN_"') do (
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f > nul 2>nul
        reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f > nul 2>nul
    )
)


:: Hardening and Mitigations
cls & echo Configuring Mitigations...

:: Disable Spectre and Meltdown
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f

:: Disable ASLR
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "MoveImages" /t REG_DWORD /d "0" /f 
:: Disable CFG
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f 
:: NTFS Mitigations
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f

:: Disable DMA Remapping
:: https://docs.microsoft.com/en-us/windows-hardware/drivers/pci/enabling-dma-remapping-for-device-drivers
for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f "DmaRemappingCompatible" ^| find /i "Services\" ') do (
	Reg.exe add "%%a" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f
)

:: Disable SEHOP
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f 
:: Disable TSX 
Reg.exe add "HKLM\SYSTEM\currentcontrolset\control\session manager\Kernel" /v "DisableTsx" /t REG_DWORD /d "1" /f

:: Mitigate HiveNightmare and SeriousSAM
icacls %WinDir%\system32\config\*.* /inheritance:e

:: Harden LSASS
Reg.exe add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe" /v "AuditLevel" /t REG_DWORD /d "8" /f 
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\CredentialsDelegation" /v "AllowProtectedCreds" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\System\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdminOutboundCreds" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\System\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdmin" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\System\CurrentControlSet\Control\Lsa" /v "RunAsPPL" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\System\CurrentControlSet\Control\SecurityProviders\WDigest" /v "Negotiate" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\System\CurrentControlSet\Control\SecurityProviders\WDigest" /v "UseLogonCredential" /t REG_DWORD /d "0" /f 

:: Delete Adobe Font Type Manager
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Font Drivers" /v "Adobe Type Manager" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "DisableATMFD" /t REG_DWORD /d "1" /f

:: Disale Hyper-V and Virtualization
:: https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Windows.DeviceGuard::VirtualizationBasedSecuritye
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "EnableVirtualizationBasedSecurity" /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "RequirePlatformSecurityFeatures" /d "1" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HypervisorEnforcedCodeIntegrity" /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HVCIMATRequired" /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "LsaCfgFlags" /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "ConfigureSystemGuardLaunch" /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequireMicrosoftSignedBootChain" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f

:: Mitigate NBT-NS poisoning attacks
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" /v "NodeType" /t REG_DWORD /d "2" /f

:: Block Eneumeration of Anonymous SAM accounts
:: https://www.stigviewer.com/stig/windows_10/2021-03-10/finding/V-220929
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RestrictAnonymousSAM" /t REG_DWORD /d "1" /f

:: System Mitigations
%powershell% "Set-ProcessMitigation -System -Disable DEP, EmulateAtlThunks, SEHOP, ForceRelocateImages, RequireInfo, BottomUp, HighEntropy, StrictHandle, DisableWin32kSystemCalls, AuditSystemCall, DisableExtensionPoints, BlockDynamicCode, AllowThreadsToOptOut, AuditDynamicCode, CFG, SuppressExports, StrictCFG, MicrosoftSignedOnly, AllowStoreSignedBinaries, AuditMicrosoftSigned, AuditStoreSigned, EnforceModuleDependencySigning, DisableNonSystemFonts, AuditFont, BlockRemoteImageLoads, BlockLowLabelImageLoads, PreferSystem32, AuditRemoteImageLoads, AuditLowLabelImageLoads, AuditPreferSystem32, EnableExportAddressFilter, AuditEnableExportAddressFilter, EnableExportAddressFilterPlus, AuditEnableExportAddressFilterPlus, EnableImportAddressFilter, AuditEnableImportAddressFilter, EnableRopStackPivot, AuditEnableRopStackPivot, EnableRopCallerCheck, AuditEnableRopCallerCheck, EnableRopSimExec, AuditEnableRopSimExec, SEHOP, AuditSEHOP, SEHOPTelemetry, TerminateOnError, DisallowChildProcessCreation, AuditChildProcess"

:: VALORANT Mitigation Patch
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vgc.exe" /v "MitigationOptions" /t REG_BINARY /d "00000000000100000000000000000000" /f

:: Disable Reserved Storage
DISM /Online /Set-ReservedStorageState /State:Disabled

:: Disable PowerShell Telemetry
:: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_telemetry?view=powershell-7.3
setx POWERSHELL_TELEMETRY_OPTOUT 1

:: Set Strong Cryptography on 64 bit and 32 bit .NET Framework 
:: https://github.com/ScoopInstaller/Scoop/issues/2040#issuecomment-369686748
Reg.exe add "HKLM\SOFTWARE\Microsoft\.NetFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "1" /f

:: Restrict Anonymous Enumeration of Shares
:: https://www.stigviewer.com/stig/windows_10/2021-03-10/finding/V-220930
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RestrictAnonymous" /t REG_DWORD /d "1" /f

:: Clear Firewall Rules
Reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /f


:: Network Configuration
cls & echo Configuring Network Settings... 

:: TCP Configuration
netsh int ip set glob defaultcurhoplimit=255
netsh int ip set interface "Ethernet" metric=60
netsh int ipv4 set subinterface "Ethernet" mtu=1500 store=persistent
netsh interface ipv4 set subinterface "Wi-Fi" mtu=1500 store=persistent
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global chimney=disabled
netsh int tcp set global congestionprovider=ctcp 
netsh int tcp set global dca=enable
netsh int tcp set global ecncapability=disabled
netsh int tcp set global fastopen=enabled
netsh int tcp set global initialRto=2000
netsh int tcp set global maxsynretransmissions=2
netsh int tcp set global netdma=disabled
netsh int tcp set global nonsackrttresiliency=disabled
netsh int tcp set global rsc=disabled
netsh int tcp set global rss=enabled
netsh int tcp set global timestamps=enabled
netsh int tcp set heuristics enabled
netsh int tcp set supplemental Internet congestionprovider=ctcp
netsh int tcp set supplemental template=custom icw=10

:: Disable Bandwith Preservation
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t reg_DWORD /d "1" /f 
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t reg_DWORD /d "00000000" /f 
Reg.exe add "HKLM\Software\WOW6432Node\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t reg_DWORD /d "0" /f 

:: Disable Network Level Authentication
Reg.exe add "HKLM\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_SZ /d "1" /f 
:: Max Port to 65534
Reg.exe add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "65534" /f 
:: Reduce TIME_WAIT
Reg.exe add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d "30" /f 
:: Reduce Time to Live
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d "64" /f 
:: Duplicate ACKS
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t REG_DWORD /d "2" /f 
:: Disable SACKS
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t REG_DWORD /d "0" /f 
:: Disable MultiCast
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t reg_DWORD /d "0" /f 
:: Enable TCP Extensions
Reg.exe add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t reg_DWORD /d "00000001" /f

:: Disable Nagle's Algorithm
:: https://en.wikipedia.org/wiki/Nagle%27s_algorithm
for /f %%a in ('wmic path Win32_NetworkAdapter get GUID ^| findstr "{"') do (
    Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%a" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f
    Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%a" /v "TcpDelAckTicks" /t REG_DWORD /d "0" /f
    Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%a" /v "TCPNoDelay" /t REG_DWORD /d "1" /f
)

:: Disable NetBIOS over TCP
for /f "delims=" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces" /s /f "NetbiosOptions" ^| findstr "HKEY"') do (
    Reg.exe add "%%a" /v "NetbiosOptions" /t REG_DWORD /d "2" /f
)

:: Disable Network Adapters
%PowerShell% "Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6, ms_msclient, ms_server, ms_lldp, ms_lltdio, ms_rspndr"

:: Configure Network Interface Card (NIC) 
for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class" /v "*WakeOnMagicPacket" /s ^| findstr "HKEY"') do (
    for %%i in (
        "*EEE"
        "*FlowControl"
        "*LsoV2IPv4"
        "*LsoV2IPv6"
        "*SelectiveSuspend"
        "*WakeOnMagicPacket"
        "*WakeOnPattern"
        "AdvancedEEE"
        "AutoDisableGigabit"
        "AutoPowerSaveModeEnabled"
        "EnableConnectedPowerGating"
        "EnableDynamicPowerGating"
        "EnableGreenEthernet"
        "EnableModernStandby"
        "EnablePME"
        "EnablePowerManagement"
        "EnableSavePowerNow"
        "GigaLite"
        "PowerSavingMode"
        "ReduceSpeedOnPowerDown"
        "ULPMode"
        "WakeOnLink"
        "WakeOnSlot"
        "WakeUpModeCap"
    ) do (
        for /f %%j in ('reg query "%%a" /v "%%~i" ^| findstr "HKEY"') do (
            reg add "%%j" /v "%%~i" /t REG_SZ /d "0" /f
        )
    )
)



:: Enable DNS over HTTPS
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableAutoDoh" /t REG_DWORD /d "2" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeSOACacheTime" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NetFailureCacheTime" /t REG_DWORD /d "0" /f 

:: Disable LLMNR
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d "0" /f 
:: Disable Administrative Shares
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "AutoShareWks" /t REG_DWORD /d "0" /f 
:: Enable the Network Adapter's Onboard Processor
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableTaskOffload" /t reg_DWORD /d "0" /f 
:: Disable the TCP Autotuning Diagnostic Tool
Reg.exe add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableWsd" /t reg_DWORD /d "00000000" /f 

:: Host Resolution Priority
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t REG_DWORD /d "6" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t REG_DWORD /d "5" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t REG_DWORD /d "4" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t REG_DWORD /d "7" /f 

:: TCP Congestion Control/Avoidance Algorithm
Reg.exe add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "0200" /t reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f
Reg.exe add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "1700" /t reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f
:: Detect Congestion Failure
Reg.exe add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPCongestionControl" /t reg_DWORD /d "00000001" /f







:: Process Priorities
cls & echo Configuring Process Priorities...

:: Background Applications to Below Normal
for %%i in (OriginWebHelperService.exe ShareX.exe EpicWebHelper.exe SocialClubHelper.exe steamwebhelper.exe StartMenu.exe ) do (
  Reg.exe add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "5" /f
)

:: Background Applications to Idle
for %%i in (fontdrvhost.exe lsass.exe svchost.exe WmiPrvSE.exe    ) do (
  Reg.exe add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f
  Reg.exe add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f
)

:: CSRSS to Realtime
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f




:: Drivers and Services
cls & echo Disabling Drivers and Services...

:: Deleting Driver Dependencies to prevent BSOD
:: FVEVOL (Bitlocker Leftover)
Reg.exe delete "HKLM\System\ControlSet001\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /f
Reg.exe add "HKLM\System\CurrentControlSet\Services\fvevol" /v "ErrorControl" /t REG_DWORD /d "0" /f
:: ksthunk (Webcam)
Reg.exe delete "HKLM\System\CurrentControlSet\Control\Class\{4D36E96C-E325-11CE-BFC1-08002BE10318}" /v "UpperFilters" /f
Reg.exe delete "HKLM\System\CurrentControlSet\Control\Class\{6BDD1FC6-810F-11D0-BEC7-08002BE2092F}" /v "UpperFilters" /f
:: volsnap (Volume Shadow Copy)
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "UpperFilters" /t REG_MULTI_SZ /d "" /f
:: Dependencies
Reg.exe add "HKLM\System\CurrentControlSet\Services\Audiosrv" /v "DependOnService" /t REG_MULTI_SZ /d "" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Dhcp" /v "DependOnService" /t REG_MULTI_SZ /d "NSI\0Afd" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache" /v "DependOnService" /t REG_MULTI_SZ /d "nsi" /f


:: Drivers
%svc% 3ware 4
%svc% AmdK8 4
%svc% AppID 4
%svc% ADP80XX 4
%svc% AppID 4
%svc% applockerfltr 4
%svc% arcsas 4
%svc% Beep 4
%svc% bowser 4
%svc% bttflt 4
%svc% cdrom 4
%svc% CldFlt 4
%svc% CLFS 4
%svc% CompositeBus 4
%svc% condrv 4
%svc% Dfsc 4
%svc% FileCrypt 4
%svc% FileCrypt 4
%svc% fvevol 4
%svc% GpuEnergyDrv 4
%svc% HTTP 4
%svc% KSecPkg 4
%svc% ksthunk 4
%svc% luafv 4
%svc% mpsdrv 4
%svc% mrxsmb 4
%svc% mrxsmb20 4
%svc% MSKSSRV 4
%svc% MSPCLOCK 4
%svc% MSPQM 4
%svc% mssmbios 4
%svc% MSTEE 4
%svc% NdisTapi 4
%svc% NdisVirtualBus 4
%svc% NdisWan 4
%svc% ndiswanlegacy 4
%svc% NetBIOS 4
%svc% NetBT 4
%svc% PEAUTH 4
%svc% QWAVEdrv 4
%svc% RasAcd 4
%svc% RasPppoe 4
%svc% SiSRaid2 4
%svc% SiSRaid4 4
%svc% srv2 4
%svc% storqosflt 4
%svc% swenum 4
%svc% Tcpip6 4
%svc% tcpipreg 4
%svc% tdx 4
%svc% umbus 4
%svc% vdrvroot 4
%svc% volmgrx 4
%svc% volsnap 4
%svc% WacomPen 4
%svc% wanarp 4
%svc% wanarpv6 4
%svc% wcifs 4
%svc% WindowsTrustedRTProxy 4


:: Services
%svc% AppXSvc 3
%svc% BcastDVRUserService 4
%svc% BFE 4
%svc% BITS 4
%svc% BthAvctpSvc 4
%svc% CDPUserSvc 4
%svc% ClipSVC 4
%svc% CryptSvc 3
%svc% diagnosticshub.standardcollector.service 4
%svc% diagsvc 4
%svc% DoSvc 4
%svc% DPS 4
%svc% FontCache 4
%svc% FontCache3.0.0.0 4
%svc% FrameServer 4
%svc% gpsvc 4
%svc% hidserv 4
%svc% HvHost 4
%svc% icssvc 4
%svc% IKEEXT 4
%svc% InstallService 4
%svc% iphlpsvc 4
%svc% KtmRm 4
%svc% LanmanServer 4
%svc% LanmanWorkstation 4
%svc% lmhosts 4
%svc% mpssvc 4
%svc% NgcCtnrSvc 4
%svc% PcaSvc 4
%svc% PhoneSvc 4
%svc% QWAVE 4
%svc% SENS 4
%svc% SharedAccess 4
%svc% ShellHWDetection 4
%svc% sppsvc 3
%svc% stisvc 4
%svc% stisvc 4
%svc% STR 2
%svc% TabletInputService 4
%svc% TapiSrv 4
%svc% Themes 4
%svc% UsoSvc 4
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
%svc% WdiServiceHost 4
%svc% WdiSystemHost 4
%svc% WinHttpAutoProxySvc 4
%svc% Winmgmt 3
%svc% wlidsvc 4
%svc% WPDBusEnum 4
%svc% WpnService 4
%svc% WSearch 4
%svc% wuauserv 4
%svc% XblAuthManager 4
%svc% XblGameSave 4
%svc% XboxGipSvc 4



:: Operating System Cleanup
cls & echo Cleaning the OS...
:: Remove Obsolete Registry Keys
Reg.exe delete "HKLM\Software\Microsoft\Windows\CurrentVersion\HotStart" /f 
Reg.exe delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Sidebar" /f 
Reg.exe delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Telephony" /f 
Reg.exe delete "HKLM\SYSTEM\ControlSet001\Control\Print" /f 
%currentuser% Reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Screensavers" /f 
%currentuser% Reg.exe delete "HKCU\Printers" /f

:: Delete Leftover NTLITE Components
takeown /f "%WinDir%\System32\GameBarPresenceWriter.exe" /a
icacls "%WinDir%\System32\GameBarPresenceWriter.exe" /grant:r Administrators:F /c
taskkill /im GameBarPresenceWriter.exe /f
takeown /f "%WinDir%\System32\bcastdvr.exe" /a
icacls "%WinDir%\System32\bcastdvr.exe" /grant:r Administrators:F /c
taskkill /im bcastdvr.exe /f
del /f /q "%WinDir%\System32\bcastdvr.exe"
del /f /q "%WinDir%\System32\GameBarPresenceWriter.exe"

:: Disable Default Start Menu
taskkill /f /im ShellExperienceHost.exe
takeown /f "C:\Windows\SystemApps\ShellExperienceHost_cw5n1h2txyewy\ShellExperienceHost.exe"
ren "C:\Windows\SystemApps\ShellExperienceHost_cw5n1h2txyewy\ShellExperienceHost.exe" Shellhostold.exe

:: Delete Microcode Updates
takeown /f C:\Windows\System32\mcupdate_GenuineIntel.dll
takeown /f C:\Windows\System32\mcupdate_AuthenticAMD.dll
del C:\Windows\System32\mcupdate_GenuineIntel.dll /s /f /q
del C:\Windows\System32\mcupdate_AuthenticAMD.dll /s /f /q

:: Notice Text
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticecaption" /t REG_SZ /d "Welcome to NeptuneOS %version%. A custom OS catered towards gamers. " /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticetext" /t REG_SZ /d "http://discord.gg/MEh7MMRKDD" /f
goto Finish






:::::::::::::::::::::::
::: Batch Functions :::
:::::::::::::::::::::::


:FUNCTIONS
:: Colors
set S_CYAN=[36m
set S_WHITE=[37m
set S_GREEN=[32m
set S_RED=[31m
:: Neptune Directories
set NeptuneDir=%windir%\NeptuneDir\
set Tools=%NeptuneDir%Tools
set Apps=%NeptuneDir%Apps
:: NSudo
set currentuser=%NeptuneDir%\Tools\NSudoLG.exe -U:C -P:E -ShowWindowMode:Hide -Wait
set system=%NeptuneDir%\Tools\NSudoLG.exe -U:T -P:E -ShowWindowMode:Hide -Wait
:: SetSVC
set svc=call :setSvc
:: Powershell
set "PowerShell=%WinDir%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command"
:: DevManView
set devman="%NeptuneDir%Tools\DevManView.exe"
:: Logs
set logs=call:ECHOX
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set datetime=%%I
set datetime=!datetime:~0,8!-!datetime:~8,6!
goto :Prep

:setSvc
:: %svc% (service name) (0-4)
if "%1"=="" (echo You need to run this with a service to disable. && exit /b 1)
if "%2"=="" (echo You need to run this with an argument ^(1-4^) to configure the service's startup. && exit /b 1)
if %2 LSS 0 (echo Invalid configuration. && exit /b 1)
if %2 GTR 4 (echo Invalid configuration. && exit /b 1)
reg query "HKLM\System\CurrentControlSet\Services\%1" >nul 2>&1 || (echo The specified service/driver is not found. && exit /b 1)
reg add "HKLM\System\CurrentControlSet\Services\%1" /v "Start" /t REG_DWORD /d "%2" /f > nul
exit /b 0

:POWERSHELL
chcp 437 >nul 2>&1 & powershell -nop -noni -exec bypass -c %* >nul 2>&1 & chcp 65001 >nul 2>&1
exit /b 0

:firewallBlockExe
:: usage: %fireBlockExe% "[NAME]" "[EXE]"
:: example: %fireBlockExe% "Calculator" "%WinDir%\System32\calc.exe"
netsh advfirewall firewall delete rule name="Block %~1" protocol=any dir=in 
netsh advfirewall firewall delete rule name="Block %~1" protocol=any dir=out 
netsh advfirewall firewall add rule name="Block %~1" program=%2 protocol=any dir=in enable=yes action=block profile=any > nul
netsh advfirewall firewall add rule name="Block %~1" program=%2 protocol=any dir=out enable=yes action=block profile=any > nul
exit /b

:LOG
echo !S_WHITE!%time:~0,8% [!S_RED!INFO!S_WHITE!]: %*
echo %time:~0,8% [INFO]: %* >>"logs\log_!datetime!.txt"


:UNZIP [FilePath] [DestinationPath]
call:POWERSHELL "Expand-Archive -Path '%~1' -DestinationPath '%~2'"
exit /b 0

:MSGBOX [Text] [Argument] [Title]
echo WScript.Quit Msgbox(Replace("%~1","\n",vbCrLf),%~2,"%~3") >"%TMP%\msgbox.vbs"
cscript /nologo "%TMP%\msgbox.vbs"
set "exitCode=!ERRORLEVEL!" & del /f /q "%TMP%\msgbox.vbs" >nul 2>&1
exit /b %exitCode%


:Finish
echo Finishing up installation and restarting. Enjoy NeptuneOS.
echo Please report any bugs you may find to the discord, or to the github. Thank you for your support.
Reg.exe delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "POST INSTALL" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "POST INSTALL" /t REG_SZ /d "explorer \"C:\POST INSTALL\"" /f 
%devmanview% /enable "HID-compliant mouse" 
del /f /q "%NeptuneDir%neptune.reg" 
del /f /q "%NeptuneDir%FullscreenCMD.vbs" 
del /f /q "%NeptuneDir%power.pow"
del /f /q "%NeptuneDir%pnp-powersaving.ps1"
del /f /q "%NeptuneDir%Prerequisites\Open Shell.exe" 
del /f /q "%NeptuneDir%Prerequisites\MPC.exe" 
del /f /q "%NeptuneDir%Prerequisites\vcredist"
del /f /q "%NeptuneDir%Prerequisites\7z.exe"
del /f /q "%NeptuneDir%Prerequisites\Open-Shell.exe"
rmdir /s /q "%NeptuneDir%Prerequisites\DirectX" 

shutdown /r /f -t 5 /c "Setup Complete: Enjoy NeptuneOS"
del "%~f0"