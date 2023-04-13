    :: Script compiled for NeptuneOS by nyne.#1431

:: - Credit:

:: - AtlasOS (Inspiration, Script Code, Registry)
:: - EchoX (Batch Functions)
:: - EVA (DWM Script)
:: - FoxOS (Post-Install Folder)
:: - KernelOS (Registry for Color Scheme)
:: - KirbyOS (Timer Resolution, LowAudioLatency)

:: TODO
:: Fix regpath consistencies 
:: Fix echo grammar mistakes
:: Remove placebo/useless tweaks
:: Complete script index



@echo off
setlocal EnableDelayedExpansion
call:Functions

:: Script Index

:: Post Install
if /i "%~1"=="/postinstall"  goto post
:: DWM
if /i "%~1"=="/dwmC"         goto dwmC
if /i "%~1"=="/dwmD"         goto dwmD
if /i "%~1"=="/dwmE"         goto dwmE
:: Idle
if /i "%~1"=="/idleD"        goto idleD
if /i "%~1"=="/idleE"        goto idleE
:: GPU Configuration
if /i "%~1"=="/amdcard"      goto amdC
if /i "%~1"=="/nvidiacard"   goto nvidiaC
:: EmptyStandbyList
if /i "%~1"=="/memory"       goto memoryC
:: debugging purposes only
if /i "%~1"=="/test"         goto testScript
:: no arguments
goto argumentFAIL

:argumentFAIL
echo !S_RED!NeptuneOS Error
echo !S_WHITE!You are either launching the script directly, or the "%~nx0" is broken.
pause & exit /b 1

:testScript
set /p c="Test with echo on?"
if %c% equ Y echo on
set /p argPrompt="Which script would you like to test? e.g. (:testScript)"
goto %argPrompt%
echo You should not reach this message!
pause
exit


:start
ver | findstr /i "Windows 10" > nul
if %errorlevel% == 0 set OSVersion=Windows 10

ver | findstr /i "Windows 11" > nul
if %errorlevel% == 0 set OSVersion=Windows 11

echo Operating system: %OSVersion%

if "%OSVersion%"=="Windows 10" (
    echo You are using the 1803 Version of NeptuneOS.
    echo Press any key to continue the script.
    pause>nul
) else if "%OSVersion%"=="Windows 11" (
    echo You are using the 22H2 Version of NeptuneOS.
    echo Press any key to continue the script.
    pause>nul
) else (
    echo You should not reach this.
)

mode 120,40
cls


echo  ___________________________________________________________________________________
echo.
echo  Disclaimer:
echo  Do NOT close out of this Post Install script.
echo  This script will continue to setup NeptuneOS
echo  This may take between 2-5 minutes depending on your HDD/SSD speed.
echo  Please report any errors you may encounter in the OS or with this script.
echo  If you close this, please re-run it in C:\Windows\NeptuneDir.
echo  Press any key to continue the script.
echo  ___________________________________________________________________________________
pause>nul
cls


echo.
echo !S_RED!888b    888                   888                               
echo !S_RED!8888b   888                   888                               
echo !S_RED!88888b  888                   888                               
echo !S_RED!888Y88b 888  .d88b.  88888b.  888888 888  888 88888b.   .d88b.  
echo !S_RED!888 Y88b888 d8P  Y8b 888 "88b 888    888  888 888 "88b d8P  Y8b 
echo !S_RED!888  Y88888 88888888 888  888 888    888  888 888  888 88888888 
echo !S_RED!888   Y8888 Y8b.     888 d88P Y88b.  Y88b 888 888  888 Y8b.     
echo !S_RED!888    Y888  "Y8888  88888P"   "Y888  "Y88888 888  888  "Y8888  
echo !S_RED!                     888                                        
echo !S_RED!                     888                                        
echo !S_RED!                     888                                        
echo.
goto:eof

:post
call:start

:: Prerequisites
echo !S_GREEN!Installing Prerequisites...

echo !S_GREEN!Importing Registry Profile...
Regedit.exe /s "%WinDir%\NeptuneDir\neptune.reg"
%WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 regedit.exe /s "%WinDir%\NeptuneDir\neptune.reg"

echo !S_GREEN!Installing Visual C++
"%WinDir%\NeptuneDir\Prerequisites\vcredist2005_x86.exe" /q >nul 2>&1
"%WinDir%\NeptuneDir\Prerequisites\vcredist2005_x64.exe" /q >nul 2>&1
"%WinDir%\NeptuneDir\Prerequisites\vcredist2008_x86.exe" /qb >nul 2>&1
"%WinDir%\NeptuneDir\Prerequisites\vcredist2008_x64.exe" /qb >nul 2>&1
"%WinDir%\NeptuneDir\Prerequisites\vcredist2010_x86.exe" /passive /norestart >nul 2>&1
"%WinDir%\NeptuneDir\Prerequisites\vcredist2010_x64.exe" /passive /norestart >nul 2>&1
"%WinDir%\NeptuneDir\Prerequisites\vcredist2012_x86.exe" /passive /norestart >nul 2>&1
"%WinDir%\NeptuneDir\Prerequisites\vcredist2012_x64.exe" /passive /norestart >nul 2>&1
"%WinDir%\NeptuneDir\Prerequisites\vcredist2013_x86.exe" /passive /norestart >nul 2>&1
"%WinDir%\NeptuneDir\Prerequisites\vcredist2013_x64.exe" /passive /norestart >nul 2>&1
"%WinDir%\NeptuneDir\Prerequisites\vcredist2015_2017_2019_2022_x86.exe" /passive /norestart >nul 2>&1
"%WinDir%\NeptuneDir\Prerequisites\vcredist2015_2017_2019_2022_x64.exe" /passive /norestart >nul 2>&1

echo !S_GREEN!Installing DirectX
"%WinDir%\NeptuneDir\Prerequisites\DirectX\DXSETUP.exe" /silent >nul 2>&1

echo !S_GREEN!Installing 7-Zip
"%WinDir%\NeptuneDir\Prerequisites\7z.exe" /S  >nul 2>&1

if "%OSVersion%"=="Windows 10" (
    echo !S_GREEN!Installing Open Shell
    "%WinDir%\NeptuneDir\Prerequisites\openshell.exe" /qn ADDLOCAL=StartMenu >nul 2>&1
)

echo !S_GREEN!Installing Timer Resolution Service
"%WinDir%\NeptuneDir\Tools\TimerResolution.exe" -install >nul 2>&1


:: Time Server Configuration
echo !S_GREEN!Changing NTP Server...

:: Switch to pool.ntp.org
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org" >nul 2>&1
:: Resync to pool.ntp.org
net start w32time >nul 2>&1
w32tm /config /update >nul 2>&1
w32tm /resync >nul 2>&1
%svc% W32Time 4 >nul 2>&1


:: Unhide Power Attributes
:: source: https://gist.github.com/Velocet/7ded4cd2f7e8c5fa475b8043b76561b5#file-unlock-powercfg-ps1
%PowerShell% "$PowerCfg = (Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings' -Recurse).Name -notmatch '\bDefaultPowerSchemeValues|(\\[0-9]|\b255)$';foreach ($item in $PowerCfg) { Set-ItemProperty -Path $item.Replace('HKEY_LOCAL_MACHINE','HKLM:') -Name 'Attributes' -Value 0 -Force}" >nul 2>&1

:: Powerplan Configuration
echo !S_GREEN!Importing Power Plan

powercfg -import "%WinDir%\NeptuneDir\Prerequisites\power.pow" 11111111-1111-1111-1111-111111111111 >nul 2>&1
powercfg -setactive 11111111-1111-1111-1111-111111111111 >nul 2>&1
powercfg -changename 11111111-1111-1111-1111-111111111111 "NeptuneOS Powerplan v2" "A powerplan created to achieve low latency and high 0.01% lows." >nul 2>&1
powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a >nul 2>&1
powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg -delete e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1

:: Disable Sleep States 
echo !S_GREEN!Disabling Sleep States...

:: Disable Away Mode Policy
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 0 >nul 2>&1
powercfg -setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 0 >nul 2>&1

:: Disable Idle States
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0 >nul 2>&1
powercfg -setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0 >nul 2>&1

:: Disable Hybrid Sleep
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0 >nul 2>&1
powercfg -setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0 >nul 2>&1

echo !S_GREEN!Configuring Power States...

:: Enable Hardware P-States
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor PERFAUTONOMOUS 1 >nul 2>&1
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor PERFAUTONOMOUSWINDOW 20000 >nul 2>&1
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor PERFCHECK 20 >nul 2>&1

:: Configure C-States
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor IDLEPROMOTE 100 >nul 2>&1
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor IDLEDEMOTE 100 >nul 2>&1
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor IDLECHECK 20000 >nul 2>&1

:: Enable Turbo Boost
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor PERFBOOSTMODE 1 >nul 2>&1
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 sub_processor PERFBOOSTPOL 100 >nul 2>&1

:: Set Active Scheme as Currnt
powercfg -setactive scheme_current >nul 2>&1

:: Disable Powersaving on Drivers
echo !S_GREEN!Disable Powersaving

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
        Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "%%i" /t REG_DWORD /d "0" /f >nul 2>&1
    )
)

:: Disable PnP Powersaving
%PowerShell% "$usb_devices = @('Win32_USBController', 'Win32_USBControllerDevice', 'Win32_USBHub'); $power_device_enable = Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi; foreach ($power_device in $power_device_enable){$instance_name = $power_device.InstanceName.ToUpper(); foreach ($device in $usb_devices){foreach ($hub in Get-WmiObject $device){$pnp_id = $hub.PNPDeviceID; if ($instance_name -like \"*$pnp_id*\"){$power_device.enable = $False; $power_device.psbase.put()}}}}" >nul 2>&1

:: Disable Powersaving in UMDF drivers
for %%a in (WakeEnabled WdkSelectiveSuspendEnable) do (
	for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class" /s /f "%%a" ^| findstr "HKEY"') do (
		Reg.exe add "%%b" /v "%%a" /t REG_DWORD /d "0" /f >nul 2>&1
	)
)

:: Disable Powersaving on Network Adapter
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" /v "DefaultPnPCapabilities" /t REG_DWORD /d "24" /f >nul 2>&1

:: Disable StorPort Idle
for /f "tokens=*" %%s in ('reg query "HKLM\System\CurrentControlSet\Enum" /S /F "StorPort" ^| findstr /e "StorPort"') do Reg add "%%s" /v "EnableIdlePowerManagement" /t REG_DWORD /d "0" /f >nul 2>&1

:: Untitled Powersaving
%PowerShell% "%WinDir%\NEPTUNE\pnp-powersaving.ps1" >nul 2>&1

:: Disable Timer Coalescing 
:: https://en.wikipedia.org/wiki/Timer_coalescing
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\ModernSleep" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Connected Standby
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Hibernation
powercfg -h off

:: Disable Powerthrottling
:: Intel CPUs, 6 generation or higher
:: https://blogs.windows.com/windows-insider/2017/04/18/introducing-power-throttling
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Sleep Study
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f >nul 2>&1
wevtutil set-log "Microsoft-Windows-SleepStudy/Diagnostic" /e:false >nul 2>&1
wevtutil set-log "Microsoft-Windows-Kernel-Processor-Power/Diagnostic" /e:false >nul 2>&1
wevtutil set-log "Microsoft-Windows-UserModePowerService/Diagnostic" /e:false >nul 2>&1

:: Disable Energy Estimation
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Energy Logging
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "DisableTaggedEnergyLogging" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxApplication" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxTagPerApplication" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable CPU Core Parking (?)
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoreParkingDisabled" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Event Processor (?)
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Battery Estimation (Laptops)
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PerfCalculateActualUtilization" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable IRQ Steering
:: https://www.computerhope.com/jargon/i/irqhold.htm#:~:text=PCI%20IRQ%20steering%20is%20a,also%20supported%20PCI%20IRQ%20Steering.
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "InterruptSteeringDisabled" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable More Sleep Features (?)
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "SleepReliabilityDetailedDiagnostics" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Power Quality of Service (?)
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "QosManagesIdleProcessors" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Watchdog Timer
:: https://www.analog.com/en/design-notes/disable-the-watchdog-timer-during-system-reboot.html
:: A watchdog timer continuously watches the execution of code and resets the system if the software hangs or no longer executes the correct sequence of code
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableSensorWatchdog" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Fastboot
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Unsorted Tweaks (?)
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableVsyncLatencyUpdate" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "MfBufferingThreshold" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "TimerRebaseThresholdOnDripsExit" /t REG_DWORD /d "30" /f >nul 2>&1


:: File System Configuration
echo !S_GREEN!Configuring File System...

:: Disallows characters from the extended character set to be used in 8.3 character-length short file names 
FSUTIL behavior set allowextchar 0 >nul 2>&1
:: Disallow generation of a bug check 
FSUTIL behavior set Bugcheckoncorrupt 0 >nul 2>&1
:: Disable 8.3 File Creation
:: https://ttcshelbyville.wordpress.com/2018/12/02/should-you-disable-8dot3-for-performance-and-security
FSUTIL behavior set disable8dot3 1 >nul 2>&1
:: Disable NTFS File Compression
FSUTIL behavior set disablecompression 1 >nul 2>&1
:: Disable NTFS File Encryption
FSUTIL behavior set disableencryption 1 >nul 2>&1
:: Disable Last Accessed Timestamp
FSUTIL behavior set disablelastaccess 1 >nul 2>&1
FSUTIL behavior set disablespotcorruptionhandling 1 >nul 2>&1
:: Enable Trimming for SSD's
FSUTIL behavior set disabledeletenotify 0 >nul 2>&1
:: Don't Encrypt The Paging File
FSUTIL behavior set encryptpagingfile 0 >nul 2>&1
FSUTIL behavior set quotanotify 86400 >nul 2>&1
FSUTIL behavior set symlinkevaluation L2L:1 >nul 2>&1
:: Disable NTFS Self Repair
FSUTIL repair set C: 0 >nul 2>&1

:: Disable Write Cache Buffer
	for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI"^| findstr "HKEY"') do (
		for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do Reg.exe add "%%a\Device Parameters\Disk" /v "CacheIsPowerProtected" /t REG_DWORD /d "1" /f >nul 2>&1
	)
	for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI"^| findstr "HKEY"') do (
		for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do Reg.exe add "%%a\Device Parameters\Disk" /v "UserWriteCacheSetting" /t REG_DWORD /d "1" /f >nul 2>&1
	)
)

:: Disable HIPM, DIPM, HDD Parking
FOR /F "eol=E" %%a in ('REG QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "EnableHIPM"^| FINDSTR /V "EnableHIPM"') DO (
	Reg.exe add "%%a" /F /V "EnableHIPM" /T REG_DWORD /d 0 >nul 2>&1
	Reg.exe add "%%a" /F /V "EnableDIPM" /T REG_DWORD /d 0 >nul 2>&1
	Reg.exe add "%%a" /F /V "EnableHDDParking" /T REG_DWORD /d 0 >nul 2>&1
)

:: IOLATENCYCAP 0
FOR /F "eol=E" %%a in ('REG QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "IoLatencyCap"^| FINDSTR /V "IoLatencyCap"') DO (
	Reg.exe add "%%a" /F /V "IoLatencyCap" /T REG_DWORD /d 0 >nul 2>&1
)


:: Explorer Configuration
echo !S_GREEN!Configuring Explorer...

:: Enable Dark Mode
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Transparency
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Wide Context Menu
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\FlightedFeatures" /v "ImmersiveContextMenu" /t REG_DWORD /d "0" /f >nul 2>&1

:: Configure visual effect settings
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9012038010000000" /f >nul 2>&1

:: Disable animations via dwm
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowFlip3d" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DWMWA_TRANSITIONS_FORCEDISABLED" /t REG_DWORD /d "1" /f >nul 2>&1 

:: Disable thumbnails
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable font smoothing
if "%OSVersion%"=="Windows 10" (
    %currentuser% Reg.exe add "HKCU\Control Panel\Desktop" /v "FontSmoothing" /t REG_SZ /d "0" /f >nul 2>&1
)

:: Enable window colorization
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableWindowColorization" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable aero peek
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable startup delay of running apps
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shutdown\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable the 'welcome' screen on logon, makes logging in faster
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DelayedDesktopSwitchTimeout" /t REG_DWORD /d "0" /f >nul 2>&1

:: Hide meet now button on taskbar
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f >nul 2>&1

:: Hide people bar
%currentuser% Reg.exe add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "HidePeopleBar" /t REG_DWORD /d "1" /f >nul 2>&1

:: Hide task view button on taskbar
%currentuser% Reg.exe delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MultiTaskingView\AllUpView" /v "Enabled" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /D "0" /f >nul 2>&1

:: Disable autoplay and autorun
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v "DisableAutoplay" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d "255" /f >nul 2>&1 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoAutoplayfornonVolume" /t REG_DWORD /d "1" /f >nul 2>&1

:: Show removable drives only in 'This PC' on the file explorer sidebar
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f >nul 2>&1
Reg.exe delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f >nul 2>&1

:: Disable network navigation pane in file explorer
Reg.exe add "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2962489444" /f >nul 2>&1

:: Remove '- Shortcut' text added onto shortcuts
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d "00000000" /f >nul 2>&1

:: Disable desktop wallpaper import quality reduction
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d "100" /f >nul 2>&1

:: Set Wallpaper
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop" /v "Wallpaper" /t REG_SZ /d "C:\Windows\Web\Wallpaper\Windows\1803.png" /f >nul 2>&1

:: Disable show window contents while dragging
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "0" /f >nul 2>&1

:: Do not allow themes to changes desktop iocns and mouse pointers
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes" /v "ThemeChangesMousePointers" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes" /v "ThemeChangesDesktopIcons" /t REG_DWORD /d "0" /f >nul 2>&1

:: Enable old alt tab
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "AltTabSettings" /t REG_DWORD /d "1" /f >nul 2>&1

:: Enable always show all icons and notifications on the taskbar
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d "0" /f >nul 2>&1

:: Hide frequently used files/folders in quick access
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d "0" /f >nul 2>&1

:: Hide recently used files/folders in quick access
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d "0" /f >nul 2>&1

:: Hide search from taskbar
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f >nul 2>&1

:: Hide recycle bin from desktop
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable dekstop peek
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisablePreviewDesktop" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable aero shake
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d "1" /f >nul 2>&1

:: Show command prompt on win+x menu
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DontUsePowerShellOnWinX" /t REG_DWORD /d "1" /f >nul 2>&1

:: Show file extensions in file explorer
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f >nul 2>&1

:: Open to this pc in file explorer
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable show translucent selection rectangle on desktop
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d "0" /f >nul 2>&1

:: Set alt tab to open windows only
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "MultiTaskingAltTabFilter" /t REG_DWORD /d "3" /f >nul 2>&1

:: Disable sharing wizard
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SharingWizardOn" /t REG_DWORD /d "0" /f >nul 2>&1

:: Configure snap settings
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "JointResize" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapAssist" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapFill" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable recent items and frequent places in file explorer
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable status bar
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowStatusBar" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable tooltips
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowInfoTip" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable sharing wizard
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SharingWizardOn" /t REG_DWORD /d "0" /f >nul 2>&1

:: Don't use OLED transparency
%currentuser% Reg.exe delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseOLEDTaskbarTransparency" /f >nul 2>&1

:: Only show hidden files, don't show system files
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable app launch tracking
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable taskbar animations
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f >nul 2>&1

:: Hide badges on taskbar
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarBadges" /t REG_DWORD /d "0" /f >nul 2>&1

:: Show more details in file transfer dialog
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" /v "EnthusiastMode" /t REG_DWORD /d "1" /f >nul 2>&1

:: Clear history of recently opened documents on exit
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ClearRecentDocsOnExit" /t REG_DWORD /d "1" /f >nul 2>&1

:: Do not track shell shortcuts during roaming
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "LinkResolveIgnoreLinkInfo" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable user tracking
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInstrumentation" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable internet file association service
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetOpenWith" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable low disk space warning
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoLowDiskSpaceChecks" /t REG_DWORD /d "1" /f >nul 2>&1

:: Do not history of recently opened documents
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f >nul 2>&1

:: Do not use the search-based method when resolving shell shortcuts
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveSearch" /t REG_DWORD /d "1" /f >nul 2>&1

:: Do not use the tracking-based method when resolving shell shortcuts
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveTrack" /t REG_DWORD /d "1" /f >nul 2>&1

:: Do not allow pinning microsoft store app to taskbar
%currentuser% Reg.exe add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoPinningStoreToTaskbar" /t REG_DWORD /d "1" /f >nul 2>&1

:: Do not display or track items in jump lists from remote locations
%currentuser% Reg.exe add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoRemoteDestinations" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable automatic folder type discovery
%currentuser% Reg.exe delete "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v "FolderType" /t REG_SZ /d "NotSpecified" /f >nul 2>&1

:: Set color scheme to 'gray'
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentColorMenu" /t REG_DWORD /d "4290756543" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "StartColorMenu" /t REG_DWORD /d "4289901234" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentPalette" /t REG_BINARY /d "9b9a9900848381006d6b6a004c4a4800363533002625240019191900107c1000" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\DWM" /v "ColorizationColor" /t REG_DWORD /d "3293334088" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\DWM" /v "ColorizationAfterglow" /t REG_DWORD /d "3293334088" /f >nul 2>&1

:: Search configuration
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "AutoWildCard" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "EnableNaturalQuerySyntax" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "WholeFileSystem" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "SystemFolders" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "ArchivedFiles" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "SearchOnly" /t REG_DWORD /d "1" /f >nul 2>&1

:: Show the full path in explorer
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v "Settings" /t REG_BINARY /d "0c0002000b01000060000000" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v "FullPath" /t REG_DWORD /d "1" /f >nul 2>&1

:: Show encrypted NTFS files in color
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowEncryptCompressedColor" /t REG_DWORD /d "1" /f >nul 2>&1

:: Enable verbose status
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "VerboseStatus" /t REG_DWORD /d "1" /f >nul 2>&1

:: Allow take ownership for more than 15+ files
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "MultipleInvokePromptMinimum" /t REG_DWORD /d "200" /f >nul 2>&1

:: Hide control panel applets
if "%OSVersion%"=="Windows 10" (
    %currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisallowCPL" /t REG_DWORD /d "1" /f >nul 2>&1
    %currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Color Management" /t REG_SZ /d "Color Management" /f >nul 2>&1
    %currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Credential Manager" /t REG_SZ /d "Credential Manager" /f >nul 2>&1
    %currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Default Programs" /t REG_SZ /d "Default Programs" /f >nul 2>&1
    %currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Fonts" /t REG_SZ /d "Fonts" /f >nul 2>&1
    %currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Indexing Options" /t REG_SZ /d "Indexing Options" /f >nul 2>&1
    %currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Language" /t REG_SZ /d "Language" /f >nul 2>&1
    %currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Phone and Modem" /t REG_SZ /d "Phone and Modem" /f >nul 2>&1
    %currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Recovery" /t REG_SZ /d "Recovery" /f >nul 2>&1
    %currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Security and Maintenance" /t REG_SZ /d "Security and Maintenance" /f >nul 2>&1
    %currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Taskbar and Navigation" /t REG_SZ /d "Taskbar and Navigation" /f >nul 2>&1
    %currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Troubleshooting" /t REG_SZ /d "Troubleshooting" /f >nul 2>&1
)

:: Hide network icon from taskbar
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCANetwork" /t REG_DWORD /d "1" /f >nul 2>&1

:: Increase icon cache (51.2mb)
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "Max Cached Icons" /t REG_SZ /d "51200" /f >nul 2>&1

:: Show drive letters before drive name in file explorer
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowDriveLettersFirst" /t REG_DWORD /d "4" /f >nul 2>&1

:: Disable new app alert
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoNewAppAlert" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable desktop.ini file creation
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "UseDesktopIniCache" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable quick access
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "HubMode" /t REG_DWORD /d "1" /f >nul 2>&1

:: Attempt to fix icons misbehaving when switching out of fullscreen with 2 different resolution monitors
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop\WindowMetrics" /v "IconSpacing" /t REG_SZ /d "-1125" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop\WindowMetrics" /v "IconVerticalSpacing" /t REG_SZ /d "-1125" /f >nul 2>&1

:: Disable thumbnail cache
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisableThumbnailCache" /t REG_DWORD /d "1" /f >nul 2>&1

:: Never use tablet shell mode
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "SignInMode" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAppsVisibleInTabletMode" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "AppIconInTouchImprovement" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SearchBoxVisibleInTouchImprovement" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "FileExplorerInTouchImprovement" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable DWM Composition
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "Composition" /t REG_DWORD /d "0" /f >nul 2>&1 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowComposition" /t REG_DWORD /d "1" /f >nul 2>&1 

:: More DWM (?)
if "%OSVersion%"=="Windows 10" (
    Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "DwmInputUsesIoCompletionPort" /t REG_DWORD /d "0" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "EnableDwmInputProcessing" /t REG_DWORD /d "0" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "DisableDrawListCaching" /t REG_DWORD /d "1" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "DisallowNonDrawListRendering" /t REG_DWORD /d "1" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "EnableCpuClipping" /t REG_DWORD /d "0" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "EnableDrawToBackbuffer" /t REG_DWORD /d "1" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "EnableImageProcessing" /t REG_DWORD /d "1" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "EnableMPCPerfCounter" /t REG_DWORD /d "0" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d "5" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "TelemetryFramesSequenceMaximumPeriodMilliseconds" /t REG_DWORD /d "500" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "UseHWDrawListEntriesOnWARP" /t REG_DWORD /d "1" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm\ExtendedComposition" /v "ExclusiveModeFramerateAveragingPeriodMs" /t REG_DWORD /d "1000" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm\ExtendedComposition" /v "ExclusiveModeFramerateThresholdPercent" /t REG_DWORD /d "250" /f >nul 2>&1 
)

:: Remove restore previous versions from context menu and file properties
Reg.exe delete "HKCR\AllFilesystemObjects\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >nul 2>&1 
Reg.exe delete "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >nul 2>&1 
Reg.exe delete "HKCR\Directory\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >nul 2>&1 
Reg.exe delete "HKCR\Drive\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >nul 2>&1 
Reg.exe delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >nul 2>&1 
Reg.exe delete "HKCR\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >nul 2>&1 
Reg.exe delete "HKCR\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >nul 2>&1 
Reg.exe delete "HKCR\Drive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f >nul 2>&1 
%currentuser% Reg.exe delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "NoPreviousVersionsPage" /f >nul 2>&1 
%currentuser% Reg.exe delete "HKCU\SOFTWARE\Policies\Microsoft\PreviousVersions" /v "DisableLocalPage" /f >nul 2>&1

:: Remove give access to from context menu
Reg.exe delete "HKCR\*\shellex\ContextMenuHandlers\Sharing" /f >nul 2>&1 
Reg.exe delete "HKCR\Directory\Background\shellex\ContextMenuHandlers\Sharing" /f >nul 2>&1 
Reg.exe delete "HKCR\Directory\shellex\ContextMenuHandlers\Sharing" /f >nul 2>&1 
Reg.exe delete "HKCR\Drive\shellex\ContextMenuHandlers\Sharing" /f >nul 2>&1 
Reg.exe delete "HKCR\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing" /f >nul 2>&1 
Reg.exe delete "HKCR\UserLibraryFolder\shellex\ContextMenuHandlers\Sharing" /f >nul 2>&1 

:: Remove cast to device from context menu
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" /t REG_SZ /d "" /f >nul 2>&1

:: Remove share in context menu
Reg.exe delete "HKCR\*\shellex\ContextMenuHandlers\ModernSharing" /f >nul 2>&1 

:: Remove bitmap image from the 'New' context menu
Reg.exe delete "HKCR\.bmp\ShellNew" /f >nul 2>&1 

:: Remove include in library context menu
Reg.exe delete "HKCR\Folder\ShellEx\ContextMenuHandlers\Library Location" /f >nul 2>&1 
Reg.exe delete "HKLM\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location" /f >nul 2>&1 

:: Remove troubleshooting compatibility from context menu
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{1d27f844-3a1f-4410-85ac-14651078412d}" /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{1d27f844-3a1f-4410-85ac-14651078412d}" /t REG_SZ /d "" /f >nul 2>&1

:: Remove 'send to' context menu
Reg.exe delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" /f >nul 2>&1
Reg.exe delete "HKCR\UserLibraryFolder\shellex\ContextMenuHandlers\SendTo" /f >nul 2>&1

:: Remove print from context menu
Reg.exe add "HKCR\SystemFileAssociations\image\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f >nul 2>&1
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
    Reg.exe add "HKCR\%%~a\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f >nul 2>&1
)

:: Add .bat, .cmd, .reg and .ps1 to the 'New' context menu
Reg.exe add "HKLM\SOFTWARE\Classes\.bat\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\System32\acppage.dll,-6002" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.bat\ShellNew" /v "NullFile" /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.cmd\ShellNew" /v "NullFile" /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.cmd\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\System32\acppage.dll,-6003" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.ps1\ShellNew" /v "NullFile" /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.ps1\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "New file" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.reg\ShellNew" /v "NullFile" /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.reg\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\regedit.exe,-309" /f >nul 2>&1

:: Add install cab to context menu
Reg.exe delete "HKCR\CABFolder\Shell\RunAs" /f >nul 2>&1 >nul 2>&1
Reg.exe add "HKCR\CABFolder\Shell\RunAs" /ve /t REG_SZ /d "Install" /f >nul 2>&1
Reg.exe add "HKCR\CABFolder\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKCR\CABFolder\Shell\RunAs\Command" /ve /t REG_SZ /d "cmd /k DISM /online /add-package /packagepath:\"%1\"" /f >nul 2>&1

:: Add 'send to' to context menu
Reg.exe add "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\Copy To" /ve /t REG_SZ /d "{C2FBB630-2971-11D1-A18C-00C04FD75D13}" /f >nul 2>&1

:: Add 'move to' to context menu
Reg.exe add "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\Move To" /ve /t REG_SZ /d "{C2FBB631-2971-11D1-A18C-00C04FD75D13}" /f >nul 2>&1

:: Add 'take ownership' to context menu
Reg.exe add "HKCR\*\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f >nul 2>&1
Reg.exe add "HKCR\*\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKCR\*\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul 2>&1
Reg.exe add "HKCR\*\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul 2>&1
Reg.exe add "HKCR\Directory\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f >nul 2>&1
Reg.exe add "HKCR\Directory\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKCR\Directory\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f >nul 2>&1
Reg.exe add "HKCR\Directory\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f >nul 2>&1

:: Merge as trusted installer for registry files
Reg.exe add "HKCR\regfile\Shell\RunAs" /ve /t REG_SZ /d "Merge As TrustedInstaller" /f >nul 2>&1
Reg.exe add "HKCR\regfile\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "1" /f >nul 2>&1
Reg.exe add "HKCR\regfile\Shell\RunAs\Command" /ve /t REG_SZ /d "%WinDir%\NeptuneDir\Tools\NSudoLG.exe -U:T -P:E Reg.exe import "%1"" /f >nul 2>&1

:: Double click to import power schemes
Reg.exe add "HKLM\SOFTWARE\Classes\powerplan\DefaultIcon" /ve /t REG_SZ /d "C:\Windows\System32\powercpl.dll,1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\powerplan\Shell\open\command" /ve /t REG_SZ /d "powercfg /import \"%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.pow" /ve /t REG_SZ /d "powerplan" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.pow" /v "FriendlyTypeName" /t REG_SZ /d "Power Plan" /f >nul 2>&1

:: Registry Configuration
echo !S_GREEN!Configuring the Registry..

:: Disable Windows Update
if "%OSVersion%"=="Windows 10" (
    Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "UseWUServer" /t REG_DWORD /d "1" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "IncludeRecommendedUpdates" /t REG_DWORD /d "0" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DoNotConnectToWindowsUpdateInternetLocations" /t REG_DWORD /d "1" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "UpdateServiceUrlAlternate" /t REG_SZ /d "http://disableupdateserver.com/" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUServer" /t REG_SZ /d "http://disableupdateserver.com/" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUStatusServer" /t REG_SZ /d "http://disableupdateserver.com/" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "0" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate" /v "value" /t REG_DWORD /d "1" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate" /v "value" /t REG_DWORD /d "1" /f >nul 2>&1
    Reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgrade" /f >nul 2>&1
)

if "%OSVersion%"=="Windows 11" (
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "SetAutoRestartDeadline" /t REG_DWORD /d "1" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "UpdateNotificationLevel" /t REG_DWORD /d "2" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "AutoRestartDeadlinePeriodInDaysForFeatureUpdates" /t REG_DWORD /d "30" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ActiveHoursEnd" /t REG_DWORD /d "1" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ActiveHoursStart" /t REG_DWORD /d "8" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "SetActiveHours" /t REG_DWORD /d "1" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "AutoRestartNotificationSchedule" /t REG_DWORD /d "240" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "AutoRestartDeadlinePeriodInDays" /t REG_DWORD /d "30" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "SetAutoRestartNotificationConfig" /t REG_DWORD /d "1" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "SetAutoRestartNotificationDisable" /t REG_DWORD /d "0" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "SetRestartWarningSchd" /t REG_DWORD /d "1" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ScheduleRestartWarning" /t REG_DWORD /d "24" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "SetUpdateNotificationLevel" /t REG_DWORD /d "1" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ScheduleImminentRestartWarning" /t REG_DWORD /d "60" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "IncludeRecommendedUpdates" /t REG_DWORD /d "0" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AutoInstallMinorUpdates" /t REG_DWORD /d "0" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d "1" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "RebootRelaunchTimeoutEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "RebootRelaunchTimeout" /t REG_DWORD /d "1440" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "RebootWarningTimeout" /t REG_DWORD /d "30" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "RebootWarningTimeoutEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
    Reg.exe add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate" /v "value" /t REG_DWORD /d "1" /f >nul 2>&1 
    Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate" /v "value" /t REG_DWORD /d "1" /f >nul 2>&1
    Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "0" /f >nul 2>&1
    Reg.exe add "HKLM\Software\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f >nul 2>&1
)

:: BSOD Quality of Life
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "LogEvent" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl\StorageTelemetry" /v "DeviceDumpEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable tracing
Reg.exe add "HKLM\SOFTWARE\Microsoft\Tracing" /v "EnableConsoleTracing" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Tracing" /v "EnableFileTracing" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Tracing" /v "EnableAutoFileTracing" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable CEIP
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\AppV\CEIP" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\VSCommon\15.0\SQM" /v "OptIn" /t REG_DWORD /d "0" /f >nul 2>&1

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
    %currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "%%~a" /t REG_DWORD /d "0" /f >nul 2>&1
)

:: Disable tips in immersive control panel
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowOnlineTips" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllowOnlineTips" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable program compatibility assistant
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableEngine" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d "1" /f >nul 2>&1

:: Clear Firewall Rules
Reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /f >nul 2>&1

:: Clear image file execution options
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" /f >nul 2>&1

:: Disable devicecensus.exe telemetry process
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\DeviceCensus.exe" /v "Debugger" /t REG_SZ /d "%WinDir%\System32\taskkill.exe" /f >nul 2>&1

:: Disable microsoft compatibility appraiser telemetry process
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\CompatTelRunner.exe" /v "Debugger" /t REG_SZ /d "%WinDir%\System32\taskkill.exe" /f >nul 2>&1

:: Disable unnecessary autologgers
if "%OSVersion%"=="Windows 10" (
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
        Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\%%~a" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
    )
)


:: Disable speech model updates
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable sxs backups
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\SideBySide\Configuration" /v "DisableComponentBackups" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable online speech recognition 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "AllowInputPersonalization" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable windows insider and build previews
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableConfigFlighting" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableExperimentation" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility" /v "HideInsiderPage" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable activity feed
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable windows spotlight features
%currentuser% Reg.exe add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightFeatures" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable tips in immersive control panel
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowOnlineTips" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllowOnlineTips" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable suggest ways I can finish setting up my device
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable disk quota
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DiskQuota" /v "Enable" /t REG_DWORD /d "0" /f >nul 2>&1

:: Never use tablet mode
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "SignInMode" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable 'Open file' - security warning message
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1806" /t REG_DWORD /d "0" /f >nul 2>&1

:: Do not preserve zone information in file attachments
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable ink workspace
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" /v "AllowWindowsInkWorkspace" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable text/ink/handwriting telemetry
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable data collection
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowDeviceNameInTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disabling Remote Font Boot Cache
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\GRE_Initialize" /v "DisableRemoteFontBootCache" /t REG_DWORD /d "1" /f >nul 2>&1 
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\GRE_Initialize" /v "DisableRemoteFontBootCache" /t REG_DWORD /d "1" /f >nul 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\MUI\StringCacheSettings" /v "StringCacheGeneration" /t REG_DWORD /d "0" /f >nul 2>&1 

:: Disable recommended troubleshooting
Reg.exe add "HKLM\SOFTWARE\Microsoft\WindowsMitigation" /v "UserPreference" /t REG_DWORD /d "2" /f >nul 2>&1

:: Configure app permissions/privacy
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Disable smartscreen
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "PreventOverride" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "ShellSmartScreenLevel" /f >nul 2>&1

:: Disable experimentation
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\System\AllowExperimentation" /v "Value" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable performance tracking
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}" /v "ScenarioExecutionEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Diagnostics\Performance" /v "DisableDiagnosticTracing" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable shared experiences
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v "CdpSessionUserAuthzPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v "RomeSdkChannelUserAuthzPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP\SettingsPage" /v "RomeSdkChannelUserAuthzPolicy" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable settings sync
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSyncOnPaidNetwork" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t REG_DWORD /d "5" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\AppSync" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\DesktopTheme" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\PackageState" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\StartLayout" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable location tracking
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\FindMyDevice" /v "AllowFindMyDevice" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\FindMyDevice" /v "LocationSyncEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable advertising info
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Id" /f >nul 2>&1

:: Disable 'use my sign-in info to finish setting up this device'
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableAutomaticRestartSignOn" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable usb errors
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Shell\USB" /v "NotifyOnUsbErrors" /t REG_DWORD /d "0" /f >nul 2>&1

:: Don't let windows manage my default printer
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "LegacyDefaultPrinterMode" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable typing insights
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Input\Settings" /v "InsightsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable setting sync
%currentuser% Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f >nul 2>&1
%currentuser% Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable windows feedback
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f >nul 2>&1 
%currentuser% Reg.exe delete "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /f >nul 2>&1 >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f >nul 2>&1 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable remote assistance
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowFullControl" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fEnableChatControl" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable location access
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location\NonPackaged" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Disable voice activation features
Reg.exe add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /v "AgentActivationEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /v "AgentActivationOnLockScreenEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /v "AgentActivationLastUsed" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable notifications and notification center
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable all lockscreen notifications
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "LockScreenToastEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable maintenance
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable background apps
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d "2" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable license telemetry
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable suggest ways I can finish setting up my device
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable automatically restart apps after sign in
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "RestartApps" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable fast user switching
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "HideFastUserSwitching" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable windows error reporting
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d "1" /f >nul 2>&1 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f >nul 2>&1 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultConsent" /t REG_DWORD /d "0" /f >nul 2>&1 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultOverrideBehavior" /t REG_DWORD /d "1" /f >nul 2>&1 

:: Legacy Photo Viewer
:: Enable the Photo Viewer
for %%i in (tif tiff bmp dib gif jfif jpe jpeg jpg jxr png) do (
    Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".%%~i" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul 2>&1
)
:: Set Photo Viewer as Default
for %%i in (tif tiff bmp dib gif jfif jpe jpeg jpg jxr png) do (
    %currentuser% Reg.exe add "HKCU\SOFTWARE\Classes\.%%~i" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul 2>&1
    %currentuser% Reg.exe add "HKCU\SOFTWARE\Classes\.wdp" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f >nul 2>&1
)

:: Ease of access configuration

:: Close apps instantly when shutting down, restarting or signing out
:: Reduce delay when opening context menus
:: Reduce time for an app to respond to the pc shutting down, restarting or signing out
:: Reduce the shutdown timer
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f >nul 2>&1 
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "8" /f >nul 2>&1 
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "0" /f >nul 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "1000" /f >nul 2>&1

:: Disable mouse acceleration
%currentuser% Reg.exe add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "0" /f >nul 2>&1

:: Disable annoying keyboard features
%currentuser% Reg.exe add "HKCU\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Control Panel\Keyboard" /v "KeyboardDelay" /t REG_SZ /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Control Panel\Keyboard" /v "KeyboardSpeed" /t REG_SZ /d "31" /f >nul 2>&1

:: Disable ease of access settings 
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\AudioDescription" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\Blind Access" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\HighContrast" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Preference" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\MouseKeys" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\On" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\ShowSounds" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\SlateLaunch" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\SoundSentry" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\TimeOut" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable text/ink/handwriting telemetry
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable spell checking
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableSpellchecking" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableTextPrediction" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnablePredictionSpaceInsertion" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableDoubleTapSpace" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableAutocorrection" /t REG_DWORD /d "0" /f >nul 2>&1

:: Don't autohide scrollbar in UWP apps 
%currentuser% Reg.exe add "HKCU\Control Panel\Accessibility" /v "DynamicScrollbars" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable game mode
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Set global fullscreen exclusive 
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_DSEBehavior" /t REG_DWORD /d "2" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "__COMPAT_LAYER" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" /f >nul 2>&1

:: Configure gamebar
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\GameBar" /v "GamePanelStartupTipIndex" /t REG_DWORD /d "3" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Win32PrioritySeperation (26 Hex)
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f >nul 2>&1

:: Disable gamebar presence writer
Reg.exe add "HKLM\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter" /v "ActivationType" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable V-SYNC Control (?)
:: https://learn.microsoft.com/en-us/windows-hardware/drivers/display/saving-energy-with-vsync-control
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "VsyncIdleTimeout" /t REG_DWORD /d "0" /f >nul 2>&1 

:: Disable GPU Debugging/Preemption
:: https://learn.microsoft.com/en-us/windows-hardware/drivers/display/changing-the-behavior-of-the-gpu-scheduler-for-debugging
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Variable Refresh Rate
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "VRROptimizeEnable=0;" /f >nul 2>&1 

:: Monitor Latency Tolerance (?)
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorLatencyTolerance" /t REG_DWORD /d "0" /f >nul 2>&1 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "0" /f >nul 2>&1

:: Force Contiguous DirectX Memory Allocation
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f >nul 2>&1

:: MMCSS Profile
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "4294967295" /f >nul 2>&1 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f >nul 2>&1 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "AlwaysOn" /t REG_DWORD /d "1" /f >nul 2>&1 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f >nul 2>&1 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1

:: Resource Policy Store (?)
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\HardCap0" /v "CapPercentage" /t REG_DWORD /d "0" /f  >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\HardCap0" /v "SchedulingType" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\Paused" /v "CapPercentage" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\Paused" /v "SchedulingType" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapFull" /v "CapPercentage" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapFull" /v "SchedulingType" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapFullAboveNormal" /v "CapPercentage" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapFullAboveNormal" /v "PriorityClass" /t REG_DWORD /d "32" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapFullAboveNormal" /v "SchedulingType" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapLow" /v "CapPercentage" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapLow" /v "SchedulingType" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapLowBackgroundBegin" /v "CapPercentage" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapLowBackgroundBegin" /v "PriorityClass" /t REG_DWORD /d "32" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapLowBackgroundBegin" /v "SchedulingType" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\UnmanagedAboveNormal" /v "CapPercentage" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\UnmanagedAboveNormal" /v "PriorityClass" /t REG_DWORD /d "32" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\UnmanagedAboveNormal" /v "SchedulingType" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\BackgroundDefault" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\Frozen" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\FrozenDNCS" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\FrozenDNK" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\FrozenPPLE" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\Paused" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\PausedDNK" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\Pausing" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\PrelaunchForeground" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\ThrottleGPUInterference" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Critical" /v "BasePriority" /t REG_DWORD /d "130" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Critical" /v "OverTargetPriority" /t REG_DWORD /d "80" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\CriticalNoUi" /v "BasePriority" /t REG_DWORD /d "130" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\CriticalNoUi" /v "OverTargetPriority" /t REG_DWORD /d "80" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\EmptyHostPPLE" /v "BasePriority" /t REG_DWORD /d "130" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\EmptyHostPPLE" /v "OverTargetPriority" /t REG_DWORD /d "80" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\High" /v "BasePriority" /t REG_DWORD /d "130" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\High" /v "OverTargetPriority" /t REG_DWORD /d "80" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Low" /v "BasePriority" /t REG_DWORD /d "130" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Low" /v "OverTargetPriority" /t REG_DWORD /d "80" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Lowest" /v "BasePriority" /t REG_DWORD /d "130" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Lowest" /v "OverTargetPriority" /t REG_DWORD /d "80" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Medium" /v "BasePriority" /t REG_DWORD /d "130" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Medium" /v "OverTargetPriority" /t REG_DWORD /d "80" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\MediumHigh" /v "BasePriority" /t REG_DWORD /d "130" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\MediumHigh" /v "OverTargetPriority" /t REG_DWORD /d "80" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\StartHost" /v "BasePriority" /t REG_DWORD /d "130" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\StartHost" /v "OverTargetPriority" /t REG_DWORD /d "80" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryHigh" /v "BasePriority" /t REG_DWORD /d "130" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryHigh" /v "OverTargetPriority" /t REG_DWORD /d "80" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryLow" /v "BasePriority" /t REG_DWORD /d "130" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryLow" /v "OverTargetPriority" /t REG_DWORD /d "80" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\IO\NoCap" /v "IOBandwidth" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Memory\NoCap" /v "CommitLimit" /t REG_DWORD /d "4294967295" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Memory\NoCap" /v "CommitTarget" /t REG_DWORD /d "4294967295" /f >nul 2>&1

:: Enable timer distribution
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DistributeTimers" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable foreground priority decay
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\KernelVelocity" /v "DisableFGBoostDecay" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable DPC Watchdog
:: Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DpcWatchdogProfileOffset" /t REG_DWORD /d "0" /f >nul 2>&1
:: Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DpcTimeout" /t REG_DWORD /d "0" /f >nul 2>&1
:: Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DpcWatchdogPeriod" /t REG_DWORD /d "0" /f >nul 2>&1

:: Reliable timestamp
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Reliability" /v "TimeStampInterval" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Reliability" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1

:: Disable fault tolerant heap
Reg.exe add "HKLM\SOFTWARE\Microsoft\FTH" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable font providers
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableFontProviders" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable component based servicing & delta expander logs
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing" /v "EnableLog" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing" /v "EnableDpxLog" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Component Based Servicing" /v "EnableLog" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Component Based Servicing" /v "EnableDpxLog" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable dcom 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Ole" /v "EnableDCOM" /t REG_SZ /d "N" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Ole" /v "EnableDCOM" /t REG_SZ /d "N" /f >nul 2>&1

:: Disable ole
Reg.exe add "HKLM\SOFTWARE\Microsoft\Ole" /v "ActivationFailureLoggingLevel" /t REG_DWORD /d "2" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Ole" /v "CallFailureLoggingLevel" /t REG_DWORD /d "2" /f >nul 2>&1

:: Disable reliability analysis (wmi provider)
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Reliability Analysis\WMI" /v "WMIEnable" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable metadata retrieval
%currentuser% Reg.exe add "HKCU\Software\Policies\Microsoft\WindowsMediaPlayer" /v "PreventCDDVDMetadataRetrieval" /t REG_DWORD /d 1 /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Software\Policies\Microsoft\WindowsMediaPlayer" /v "PreventMusicFileMetadataRetrieval" /t REG_DWORD /d 1 /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Software\Policies\Microsoft\WindowsMediaPlayer" /v "PreventRadioPresetsRetrieval" /t REG_DWORD /d 1 /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\WMDRM" /v "DisableOnline" /t REG_DWORD /d 1 /f >nul 2>&1

:: Configure user account control
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d "0" /f >nul 2>&1 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable automatic map updates
Reg.exe add "HKLM\SYSTEM\Maps" /v "AutoUpdateEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Allow use of .MSI files in safe mode
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal\MSIServer" /ve /t REG_SZ /d "Service" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\MSIServer" /ve /t REG_SZ /d "Service" /f >nul 2>&1

:: Allegedly increases cursor responsiveness (?)
:: Reg.exe add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v "CursorSensitivity" /t REG_DWORD /d "10000" /f >nul 2>&1
:: Reg.exe add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v "CursorUpdateInterval" /t REG_DWORD /d "1" /f >nul 2>&1
:: Reg.exe add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v "IRRemoteNavigationDelta" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable smartscreen
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f >nul 2>&1

:: Don't recognize slow connections
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "SlowLinkDetectEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable resultant set of policy logging
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "RSoPLogging" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable sync activities
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable activity feed
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable clipboard history
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "AllowClipboardHistory" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Exclusive Mode on Devices
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do %WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d 0 /f >nul 2>&1
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do %WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d 0 /f >nul 2>&1
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do %WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d 0 /f >nul 2>&1
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do %WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d 0 /f >nul 2>&1

:: Legacy Volume Control
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" /v "EnableMtcUvc" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Multimedia\Audio\DeviceCpl" /v "VolumeUnits" /t REG_DWORD /d "0" /f >nul 2>&1

:: Fix Volume Mixer
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore" /f >nul 2>&1 

:: Don't Show Disconnected/Disabled Devices
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowDisconnectedDevices" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowHiddenDevices" /t REG_DWORD /d "0" /f >nul 2>&1

:: Set Audio Scheme to None
%currentuser% %PowerShell% "New-ItemProperty -Path 'HKCU:\AppEvents\Schemes' -Name '(Default)' -Value '.None' -Force | Out-Null" >nul 2>&1
%currentuser% %PowerShell% "Get-ChildItem -Path 'HKCU:\AppEvents\Schemes\Apps' | Get-ChildItem | Get-ChildItem | Where-Object {$_.PSChildName -eq '.Current'} | Set-ItemProperty -Name '(Default)' -Value ''" >nul 2>&1

:: Don't Reduce Sounds While In A Call
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d "3" /f >nul 2>&1

:: Disable Scheduled Tasks
if "%OSVersion%"=="Windows 10" (
    echo !S_GREEN!Disabling Scheduled Tasks...
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
        schtasks.exe /Change /Disable /TN %%i >nul 2>&1
        %WinDir%\NeptuneDir\Tools\powerrun.exe /SW:0 schtasks.exe /Change /Disable /TN %%i >nul 2>&1
    )
)

:: Boot Configuration Data
echo !S_GREEN!Configuring BCDEdit...

:: Disable Boot Graphics
bcdedit /set bootux disabled >nul 2>&1
:: Legacy Boot Menu
bcdedit /set bootmenupolicy legacy >nul 2>&1
:: Disable Hyper-V
bcdedit /set hypervisorlaunchtype off >nul 2>&1
:: Disable TPM
bcdedit /set tpmbootentropy ForceDisable >nul 2>&1
:: Enable Quiet Boot
bcdedit /set quietboot yes >nul 2>&1
:: Disable Boot Logo
bcdedit /set {globalsettings} custom:16000067 true >nul 2>&1
:: Disable The Boot Animation
bcdedit /set {globalsettings} custom:16000069 true >nul 2>&1
:: Disable Boot Messages
bcdedit /set {globalsettings} custom:16000068 true >nul 2>&1
:: Disable Automatic Repair
bcdedit /set {current} recoveryenabled no >nul 2>&1
:: Set Boot Label
if "%OSVersion%"=="Windows 10" (
    bcdedit /set {current} description "NeptuneOS 1803 %Version%" >nul 2>&1
)
if "%OSVersion%"=="Windows 11" (
    bcdedit /set {current} description "NeptuneOS 22H2 %Version%" >nul 2>&1
)
:: Disable DEP
bcdedit /set nx AlwaysOff >nul 2>&1
:: Use Synthetic Timers
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set useplatformtick Yes >nul 2>&1
bcdedit /deletevalue useplatformclock >nul 2>&1
:: 15 Second Timeout for Dualboot
bcdedit /timeout 15 >nul 2>&1
:: Disable Emergency Management Services
bcdedit /set ems No >nul 2>&1
bcdedit /set bootems No >nul 2>&1
:: Disable Kernel Debugging
bcdedit /set debug No >nul 2>&1
:: Stop using uncontiguous portions of low-memory
:: https://sites.google.com/view/melodystweaks/basictweaks
bcdedit /set firstmegabytepolicy UseAll >nul 2>&1
bcdedit /set avoidlowmemory 0x8000000 >nul 2>&1
bcdedit /set nolowmem Yes >nul 2>&1
:: Disable DMA Memory Protection and Core Isolation
bcdedit /set vm No >nul 2>&1
bcdedit /set vsmlaunchtype Off >nul 2>&1
:: Disable Memory Mitigations
bcdedit /set allowedinmemorysettings 0x0 >nul 2>&1


:: Disable Devices
echo !S_GREEN!Disabling Devices...

:: System Devices (Windows 10)
if "%OSVersion%"=="Windows 10" (
    %DevMan% /disable "ACPI Processor Aggregator" >nul 2>&1
    %DevMan% /disable "ACPI Wake Alarm" >nul 2>&1
    %DevMan% /disable "Composite Bus Enumerator" >nul 2>&1
    %DevMan% /disable "Direct memory access controller" >nul 2>&1
    %DevMan% /disable "High precision event timer" >nul 2>&1
    %DevMan% /disable "Microsoft Device Association Root Enumerator" >nul 2>&1
    %DevMan% /disable "Microsoft GS Wavetable Synth" >nul 2>&1
    %DevMan% /disable "Microsoft Hyper-V Virtualization Infrastructure Driver" >nul 2>&1
    %DevMan% /disable "Microsoft Kernel Debug Network Adapter" >nul 2>&1
    %DevMan% /disable "Microsoft RRAS Root Enumerator" >nul 2>&1
    %DevMan% /disable "Microsoft System Management BIOS Driver" >nul 2>&1
    %DevMan% /disable "Microsoft Virtual Drive Enumerator" >nul 2>&1
    %DevMan% /disable "Microsoft Windows Management Interface for ACPI" >nul 2>&1
    %DevMan% /disable "Motherboard resources" >nul 2>&1
    %DevMan% /disable "NDIS Virtual Network Adapter Enumerator" >nul 2>&1
    %DevMan% /disable "Numeric data processor" >nul 2>&1
    %DevMan% /disable "PCI Data Acquisition and Signal Processing Controller" >nul 2>&1
    %DevMan% /disable "PCI Device" >nul 2>&1
    %DevMan% /disable "PCI Memory Controller" >nul 2>&1
    %DevMan% /disable "PCI Simple Communications Controller" >nul 2>&1
    %DevMan% /disable "PCI Simple Communications Controller" >nul 2>&1
    %DevMan% /disable "PCI standard RAM Controller" >nul 2>&1
    %DevMan% /disable "Plug and Play Software Device Enumerator" >nul 2>&1
    %DevMan% /disable "Programmable interrupt controller" >nul 2>&1
    %DevMan% /disable "Root Print Queue" >nul 2>&1
    %DevMan% /disable "SM Bus Controller" >nul 2>&1
    %DevMan% /disable "System board" >nul 2>&1
    %DevMan% /disable "System CMOS/real time clock" >nul 2>&1
    %DevMan% /disable "System Speaker" >nul 2>&1
    %DevMan% /disable "System Timer" >nul 2>&1
    %DevMan% /disable "UMBus Root Bus Enumerator" >nul 2>&1
    %DevMan% /disable "Unknown Device" >nul 2>&1
    %DevMan% /disable "USB Video Device" >nul 2>&1
)

:: System Devices (Windows 11)
if "%OSVersion%"=="Windows 11" (
    %DevMan% /disable "ACPI Processor Aggregator" >nul 2>&1
    %DevMan% /disable "ACPI Wake Alarm" >nul 2>&1
    %DevMan% /disable "Composite Bus Enumerator" >nul 2>&1
    %DevMan% /disable "Direct memory access controller" >nul 2>&1
    %DevMan% /disable "High precision event timer" >nul 2>&1
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
    %DevMan% /disable "System board" >nul 2>&1
    %DevMan% /disable "System Speaker" >nul 2>&1
    %DevMan% /disable "System Timer" >nul 2>&1
)

:: Network Adapters
if "%OSVersion%"=="Windows 10" (
    %DevMan% /disable "WAN Miniport (IKEv2)" >nul 2>&1
    %DevMan% /disable "WAN Miniport (IP)" >nul 2>&1
    %DevMan% /disable "WAN Miniport (IPv6)" >nul 2>&1
    %DevMan% /disable "WAN Miniport (L2TP)" >nul 2>&1
    %DevMan% /disable "WAN Miniport (Network Monitor)" >nul 2>&1
    %DevMan% /disable "WAN Miniport (PPPOE)" >nul 2>&1
    %DevMan% /disable "WAN Miniport (PPTP)" >nul 2>&1
    %DevMan% /disable "WAN Miniport (SSTP)" >nul 2>&1
)

:: Memory Optimization
echo !S_GREEN!Configuring Memory Management...

:: Superfetch and Prefetch
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 0 /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d 0 /f >nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableBootTrace" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "SfTracingState" /t REG_DWORD /d "0" /f >nul 2>&1

:: 4GB Paging File
Reg.exe add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Memory Management" /v "PagingFiles" /t REG_MULTI_SZ /d "?:\pagefile.sys 4096 4096" /f >nul 2>&1

:: 64GB SVCHost Split Threshold
Reg.exe add "HKLM\SYSTEM\ControlSet001\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "4294967295" /f >nul 2>&1

:: Enable Large System Cache 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disallow Paging Drivers
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Page Combining 
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePageCombining" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\currentcontrolset\control\session manager\Memory Management" /v "DisablePagingCombining" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Swapfile
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SwapfileControl" /t REG_DWORD /d "0" /f >nul 2>&1

:: Memory Heap Tweaks
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager" /v "HeapDeCommitFreeBlockThreshold" /t REG_DWORD /d "262144" /f >nul 2>&1

:: Paged Pool Memory Tweaks (?)
:: Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "NonPagedPoolSize" /t REG_DWORD /d "192" /f >nul 2>&1
:: Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagedPoolSize" /t REG_DWORD /d "192" /f >nul 2>&1
:: Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PoolUsageMaximum" /t REG_DWORD /d "192" /f >nul 2>&1

:: Disable Memory Compression
%PowerShell% "Disable-MMAgent -MemoryCompression" >nul 2>&1


:: MSI and IRQ Priority
echo !S_GREEN!Enabling MSI Mode...

:: Enable MSI Mode and set priorities to 'undefined'
for %%a in (
    Win32_USBController, 
    Win32_VideoController, 
    Win32_NetworkAdapter, 
    Win32_IDEController
) do (
    for /f %%i in ('wmic path %%a get PNPDeviceID ^| findstr /l "PCI\VEN_"') do (
        Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f >nul 2>&1
        Reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>&1
    )
)


:: Hardening and Mitigations
echo !S_GREEN!Configuring Mitigations...

:: Disable Spectre and Meltdown
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f >nul 2>&1

:: Disable ASLR
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "MoveImages" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable CFG
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f >nul 2>&1

:: NTFS Mitigations
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable DMA Remapping
:: https://docs.microsoft.com/en-us/windows-hardware/drivers/pci/enabling-dma-remapping-for-device-drivers
for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f "DmaRemappingCompatible" ^| find /i "Services\" ') do (
	Reg.exe add "%%a" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f >nul 2>&1
)

:: Disable SEHOP
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
:: Disable TSX 
Reg.exe add "HKLM\SYSTEM\currentcontrolset\control\session manager\Kernel" /v "DisableTsx" /t REG_DWORD /d "1" /f >nul 2>&1

:: Mitigate HiveNightmare and SeriousSAM
icacls %WinDir%\system32\config\*.* /inheritance:e >nul 2>&1

:: Harden LSASS
Reg.exe add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe" /v "AuditLevel" /t REG_DWORD /d "8" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\CredentialsDelegation" /v "AllowProtectedCreds" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdminOutboundCreds" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdmin" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Lsa" /v "RunAsPPL" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\SecurityProviders\WDigest" /v "Negotiate" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\SecurityProviders\WDigest" /v "UseLogonCredential" /t REG_DWORD /d "0" /f >nul 2>&1

:: Delete Adobe Font Type Manager
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Font Drivers" /v "Adobe Type Manager" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "DisableATMFD" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disale Hyper-V and Virtualization
:: https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Windows.DeviceGuard::VirtualizationBasedSecuritye
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "EnableVirtualizationBasedSecurity" /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "RequirePlatformSecurityFeatures" /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HypervisorEnforcedCodeIntegrity" /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HVCIMATRequired" /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "LsaCfgFlags" /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "ConfigureSystemGuardLaunch" /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequireMicrosoftSignedBootChain" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Mitigate NBT-NS poisoning attacks
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" /v "NodeType" /t REG_DWORD /d "2" /f >nul 2>&1

:: Block Eneumeration of Anonymous SAM accounts
:: https://www.stigviewer.com/stig/windows_10/2021-03-10/finding/V-220929
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RestrictAnonymousSAM" /t REG_DWORD /d "1" /f >nul 2>&1

:: System Mitigations
%powershell% "Set-ProcessMitigation -System -Disable DEP, EmulateAtlThunks, SEHOP, ForceRelocateImages, RequireInfo, BottomUp, HighEntropy, StrictHandle, DisableWin32kSystemCalls, AuditSystemCall, DisableExtensionPoints, BlockDynamicCode, AllowThreadsToOptOut, AuditDynamicCode, CFG, SuppressExports, StrictCFG, MicrosoftSignedOnly, AllowStoreSignedBinaries, AuditMicrosoftSigned, AuditStoreSigned, EnforceModuleDependencySigning, DisableNonSystemFonts, AuditFont, BlockRemoteImageLoads, BlockLowLabelImageLoads, PreferSystem32, AuditRemoteImageLoads, AuditLowLabelImageLoads, AuditPreferSystem32, EnableExportAddressFilter, AuditEnableExportAddressFilter, EnableExportAddressFilterPlus, AuditEnableExportAddressFilterPlus, EnableImportAddressFilter, AuditEnableImportAddressFilter, EnableRopStackPivot, AuditEnableRopStackPivot, EnableRopCallerCheck, AuditEnableRopCallerCheck, EnableRopSimExec, AuditEnableRopSimExec, SEHOP, AuditSEHOP, SEHOPTelemetry, TerminateOnError, DisallowChildProcessCreation, AuditChildProcess" >nul 2>&1

:: VALORANT Mitigation Patch
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vgc.exe" /v "MitigationOptions" /t REG_BINARY /d "00000000000100000000000000000000" /f >nul 2>&1

:: Disable Reserved Storage
DISM /Online /Set-ReservedStorageState /State:Disabled >nul 2>&1

:: Disable PowerShell Telemetry
:: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_telemetry?view=powershell-7.3
setx POWERSHELL_TELEMETRY_OPTOUT 1 >nul 2>&1

:: Set Strong Cryptography on 64 bit and 32 bit .NET Framework 
:: https://github.com/ScoopInstaller/Scoop/issues/2040#issuecomment-369686748
Reg.exe add "HKLM\SOFTWARE\Microsoft\.NetFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "1" /f >nul 2>&1

:: Restrict Anonymous Enumeration of Shares
:: https://www.stigviewer.com/stig/windows_10/2021-03-10/finding/V-220930
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RestrictAnonymous" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Process Mitigations (Credit: XOS)
for /f "tokens=3 skip=2" %%a in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions"') do set mitigation_mask=%%a
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
	Reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%a" /v "MitigationOptions" /t REG_BINARY /d "!mitigation_mask!" /f >nul 2>&1
	Reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%a" /v "MitigationAuditOptions" /t REG_BINARY /d "!mitigation_mask!" /f >nul 2>&1
)

Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_BINARY /d "!mitigation_mask!" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions" /t REG_BINARY /d "!mitigation_mask!" /f >nul 2>&1


:: Network Configuration
echo !S_GREEN!Configuring Network Settings... 

:: TCP Configuration
netsh int isatap set state disable >nul 2>&1
netsh int 6to4 set state disabled >nul 2>&1
netsh int teredo set state disabled >nul 2>&1
netsh winsock reset >nul 2>&1
netsh int ip set global defaultcurhoplimit=255 >nul 2>&1
netsh int ip set global dhcpmediasense=disabled >nul 2>&1
netsh int ip set global neighborcachelimit=4096 >nul 2>&1
netsh int ip set global taskoffload=enabled >nul 2>&1
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global chimney=disabled >nul 2>&1
netsh int tcp set global congestionprovider=ctcp >nul 2>&1
netsh int tcp set global dca=enabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
netsh int tcp set global fastopen=enabled >nul 2>&1
netsh int tcp set global initialRto=2000 >nul 2>&1
netsh int tcp set global maxsynretransmissions=2 >nul 2>&1
netsh int tcp set global netdma=enabled >nul 2>&1
netsh int tcp set global nonsackrttresiliency=disabled >nul 2>&1
netsh int tcp set global rsc=disabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set heuristics disabled >nul 2>&1
netsh int tcp set security mpp=disabled >nul 2>&1
netsh int tcp set security profiles=disabled >nul 2>&1
netsh int tcp set supplemental Internet congestionprovider=ctcp >nul 2>&1
netsh int tcp set supplemental template=custom icw=10 >nul 2>&1
netsh int ip set interface "Ethernet" metric=60 >nul 2>&1
netsh int ipv4 set subinterface "Ethernet" mtu=1500 store=persistent >nul 2>&1
netsh int ipv4 set subinterface "Wi-Fi" mtu=1500 store=persistent >nul 2>&1

:: Disable Bandwith Preservation
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t reg_DWORD /d "00000000" /f >nul 2>&1
Reg.exe add "HKLM\Software\WOW6432Node\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t reg_DWORD /d "0" /f >nul 2>&1

:: Disable Network Level Authentication
Reg.exe add "HKLM\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_SZ /d "1" /f >nul 2>&1

:: No TCP Connection Limit
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxConnectionsPerServer" /t REG_DWORD /d "0" /f >nul 2>&1

:: Max Port to 65534
Reg.exe add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "65534" /f >nul 2>&1

:: Reduce TIME_WAIT
Reg.exe add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d "32" /f >nul 2>&1

:: Reduce Time to Live
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d "64" /f >nul 2>&1

:: Duplicate ACKS
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t REG_DWORD /d "2" /f >nul 2>&1

:: Disable SACKS
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable MultiCast
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t reg_DWORD /d "0" /f >nul 2>&1

:: Disable TCP Extensions
Reg.exe add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t reg_DWORD /d "0" /f >nul 2>&1

:: Allow ICMP redirects to override OSPF generated routes
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableICMPRedirect" /t REG_DWORD /d "1" /f >nul 2>&1

:: TCP Window Size
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t REG_DWORD /d "8760" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpWindowSize" /t REG_DWORD /d "8760" /f >nul 2>&1

:: Disable network discovery
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" /f >nul 2>&1

:: Enable DNS over HTTPS
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableAutoDoh" /t REG_DWORD /d "2" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeSOACacheTime" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NetFailureCacheTime" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable LLMNR
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Administrative Shares
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "AutoShareWks" /t REG_DWORD /d "0" /f >nul 2>&1

:: Enable the Network Adapter's Onboard Processor
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableTaskOffload" /t reg_DWORD /d "0" /f >nul 2>&1

:: Disable the TCP Autotuning Diagnostic Tool
Reg.exe add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableWsd" /t reg_DWORD /d "0" /f >nul 2>&1

:: Host Resolution Priority
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t REG_DWORD /d "6" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t REG_DWORD /d "5" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t REG_DWORD /d "7" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "Class" /t REG_DWORD /d "8" /f >nul 2>&1

:: TCP Congestion Control/Avoidance Algorithm
Reg.exe add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "0200" /t reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f >nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "1700" /t reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f >nul 2>&1

:: Detect Congestion Failure
Reg.exe add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPCongestionControl" /t reg_DWORD /d "00000001" /f >nul 2>&1

:: Disable SYN-DOS protection
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SynAttackProtect" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock" /v "UseDelayedAcceptance" /t REG_DWORD /d "0" /f >nul 2>&1

:: Prevent unwanted NIC resets
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\services\NDIS\Parameters" /v "DisableNDISWatchDog" /t REG_DWORD /d "1" /f >nul 2>&1



:: Disable Nagle's Algorithm
:: https://en.wikipedia.org/wiki/Nagle%27s_algorithm
for /f %%a in ('wmic path Win32_NetworkAdapter get GUID ^| findstr "{"') do (
    Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%a" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f >nul 2>&1
    Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%a" /v "TcpDelAckTicks" /t REG_DWORD /d "0" /f >nul 2>&1
    Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%a" /v "TCPNoDelay" /t REG_DWORD /d "1" /f >nul 2>&1
)

:: Disable NetBIOS over TCP
for /f "delims=" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces" /s /f "NetbiosOptions" ^| findstr "HKEY"') do (
    Reg.exe add "%%a" /v "NetbiosOptions" /t REG_DWORD /d "2" /f >nul 2>&1
)

:: Disable Network Adapters
%PowerShell% "Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6, ms_msclient, ms_server, ms_lldp, ms_lltdio, ms_rspndr" >nul 2>&1

:: Configure Network Interface Card (NIC) 
:: for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class" /v "*WakeOnMagicPacket" /s ^| findstr "HKEY"') do (
::     for %%i in (
::         "*EEE"
::         "*FlowControl"
::         "*LsoV2IPv4"
::         "*LsoV2IPv6"
::         "*SelectiveSuspend"
::         "*WakeOnMagicPacket"
::         "*WakeOnPattern"
::         "AdvancedEEE"
::         "AutoDisableGigabit"
::         "AutoPowerSaveModeEnabled"
::         "EnableConnectedPowerGating"
::         "EnableDynamicPowerGating"
::         "EnableGreenEthernet"
::         "EnableModernStandby"
::         "EnablePME"
::         "EnablePowerManagement"
::         "EnableSavePowerNow"
::         "GigaLite"
::         "PowerSavingMode"
::         "ReduceSpeedOnPowerDown"
::         "ULPMode"
::         "WakeOnLink"
::         "WakeOnSlot"
::         "WakeUpModeCap"
::     ) do (
::         for /f %%j in ('reg query "%%a" /v "%%~i" ^| findstr "HKEY"') do (
::             reg add "%%j" /v "%%~i" /t REG_SZ /d "0" /f >nul 2>&1
::         )
::     )
:: )


:: Process Priorities
echo !S_GREEN!Configuring Process Priorities...

:: Background Processes > Below normal
for %%i in (OriginWebHelperService.exe ShareX.exe EpicWebHelper.exe SocialClubHelper.exe steamwebhelper.exe StartMenu.exe ) do (
  Reg.exe add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "5" /f >nul 2>&1
)

:: System Processes > Idle
for %%i in (fontdrvhost.exe lsass.exe WmiPrvSE.exe ) do (
  Reg.exe add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
  Reg.exe add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>&1
)

:: CSRSS > High
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "3" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1

:: ntoskrnl.exe > Realtime (EXPERIMENTAL)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1


:: Drivers and Services
echo !S_GREEN!Disabling Drivers and Services...

:: Deleting Driver Filters to prevent BSOD
:: ksthunk (Webcam)
if "%OSVersion%"=="Windows 10" (
    Reg.exe delete "HKLM\System\CurrentControlSet\Control\Class\{4D36E96C-E325-11CE-BFC1-08002BE10318}" /v "UpperFilters" /f >nul 2>&1
    Reg.exe delete "HKLM\System\CurrentControlSet\Control\Class\{6BDD1FC6-810F-11D0-BEC7-08002BE2092F}" /v "UpperFilters" /f >nul 2>&1
)

:: Dependencies
Reg.exe add "HKLM\System\CurrentControlSet\Services\Audiosrv" /v "DependOnService" /t REG_MULTI_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Dhcp" /v "DependOnService" /t REG_MULTI_SZ /d "NSI\0Afd" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache" /v "DependOnService" /t REG_MULTI_SZ /d "nsi" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc" /v "DependOnService" /t REG_MULTI_SZ /d "NSI\0RpcSs\0TcpIp" /f >nul 2>&1

:: Trigger Info
:: Reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Services\AppIDSvc\TriggerInfo" /f >nul 2>&1
:: Reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Services\Appinfo\TriggerInfo" /f >nul 2>&1
:: Reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\TriggerInfo" /f >nul 2>&1
:: Reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Services\gpsvc\TriggerInfo" /f >nul 2>&1
:: Reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Services\SystemEventsBroker\TriggerInfo" /f >nul 2>&1
:: Reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Services\UserManager\TriggerInfo" /f >nul 2>&1

:: Split Audio Services
:: copy /y "%windir%\System32\svchost.exe" "%windir%\System32\audiosvchost.exe" >nul 2>&1
:: Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv" /v "ImagePath" /t REG_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalServiceNetworkRestricted -p" /f >nul 2>&1
:: Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\AudioEndpointBuilder" /v "ImagePath" /t REG_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalSystemNetworkRestricted -p" /f >nul 2>&1

:: Drivers and Services
if "%OSVersion%"=="Windows 10" (
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
    %svc% CaptureService 4
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
    %svc% WpnUserService 4
    %svc% WSearch 4
    %svc% wuauserv 4
    %svc% XblAuthManager 4
    %svc% XblGameSave 4
    %svc% XboxGipSvc 4
)

if "%OSVersion%"=="Windows 11" (
    :: Drivers
    %svc% Beep 4
    %svc% Ndu 4

    :: Services
    %svc% BthAvctpSvc 4
    %svc% DiagTrack 4
    %svc% DispBrokerDesktopSvc 4
    %svc% DPS 4
    %svc% FontCache 4
    %svc% LanmanWorkstation 4
    %svc% LanmanWorkstation 4
    %svc% lmhosts 4
    %svc% MapsBroker 4
    %svc% RmSvc 4
    %svc% ShellHWDetection 4
    %svc% Spooler 4
    %svc% WdiSystemHost 4
    %svc% WinHttpAutoProxySvc 4
    %svc% Winmgmt 3
    %svc% WpnService 4


:: Operating System Cleanup
echo !S_GREEN!Cleaning the OS...
:: Remove Obsolete Registry Keys
Reg.exe delete "HKLM\Software\Microsoft\Windows\CurrentVersion\HotStart" /f >nul 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Sidebar" /f >nul 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Telephony" /f >nul 2>&1
Reg.exe delete "HKLM\SYSTEM\ControlSet001\Control\Print" /f >nul 2>&1
%currentuser% Reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Screensavers" /f >nul 2>&1
%currentuser% Reg.exe delete "HKCU\Printers" /f >nul 2>&1

:: Delete Files
if "%OSVersion%"=="Windows 10" (
    takeown /f "%WinDir%\System32\GameBarPresenceWriter.exe" /a >nul 2>&1
    icacls "%WinDir%\System32\GameBarPresenceWriter.exe" /grant:r Administrators:F /c >nul 2>&1
    taskkill /im GameBarPresenceWriter.exe /f >nul 2>&1
    takeown /f "%WinDir%\System32\bcastdvr.exe" /a >nul 2>&1
    icacls "%WinDir%\System32\bcastdvr.exe" /grant:r Administrators:F /c >nul 2>&1
    taskkill /im bcastdvr.exe /f >nul 2>&1
    del /f /q "%WinDir%\System32\bcastdvr.exe" >nul 2>&1
    del /f /q "%WinDir%\System32\GameBarPresenceWriter.exe" >nul 2>&1
)

takeown /f C:\Windows\System32\mcupdate_GenuineIntel.dll >nul 2>&1
takeown /f C:\Windows\System32\mcupdate_AuthenticAMD.dll >nul 2>&1
del C:\Windows\System32\mcupdate_GenuineIntel.dll /s /f /q >nul 2>&1
del C:\Windows\System32\mcupdate_AuthenticAMD.dll /s /f /q >nul 2>&1
del /f /q "%WinDir%\NeptuneDir\neptune.reg" >nul 2>&1
del /f /q "%WinDir%\NeptuneDir\FullscreenCMD.vbs" >nul 2>&1
del /f /q "%WinDir%\NeptuneDir\power.pow" >nul 2>&1
del /f /q "%WinDir%\NeptuneDir\pnp-powersaving.ps1" >nul 2>&1
rmdir /s /q "%WinDir%\NeptuneDir\Prerequisites" >nul 2>&1

:: Disable Default Start Menu
if "%OSVersion%"=="Windows 10" (
    taskkill /f /im ShellExperienceHost.exe
    takeown /f "C:\Windows\SystemApps\ShellExperienceHost_cw5n1h2txyewy\ShellExperienceHost.exe" >nul 2>&1
    ren "C:\Windows\SystemApps\ShellExperienceHost_cw5n1h2txyewy\ShellExperienceHost.exe" Shellhostold.exe >nul 2>&1
)

:: Notice Text
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticecaption" /t REG_SZ /d "Welcome to NeptuneOS %version%. A custom OS catered towards gamers. " /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticetext" /t REG_SZ /d "http://discord.gg/MEh7MMRKDD" /f >nul 2>&1

echo !S_GREY!Finishing up installation and restarting. Enjoy NeptuneOS.
echo !S_GREY!Please report any bugs you may find to the discord, or to the github. Thank you for your support.
Reg.exe delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "POST INSTALL" /f >nul 2>&1

shutdown /f /r /t 5
exit










:::::::::::::::::::::::
:::  Configuration  :::
:::::::::::::::::::::::

:clean
del /s /f /q %windir%\temp\*.*
del /s /f /q %windir%\Prefetch\*.*
del /s /f /q %temp%\*.*
rd /s /q %WINDIR%\Logs
del /q %userprofile%\AppData\Local\Microsoft\Windows\INetCache\IE\*.*
del /q %WINDIR%\Downloaded Program Files\*.*
rd /s /q %SYSTEMDRIVE%\$RECYCLE.BIN
del /f /s /q %appdata%\Listary\UserData
del /f /q %ProgramFiles(x86)%\Steam\Dumps
del /f /q %ProgramFiles(x86)%\Steam\Traces
del /f /q %ProgramFiles(x86)%\Steam\appcache\*.log
rd /s /q "%AppData%\vstelemetry"
rd /s /q "%LocalAppData%\Microsoft\VSApplicationInsights"
rd /s /q "%ProgramData%\Microsoft\VSApplicationInsights"
rd /s /q "%temp%\Microsoft\VSApplicationInsights"
rd /s /q "%temp%\VSFaultInfo"
rd /s /q "%temp%\VSFeedbackPerfWatsonData"
rd /s /q "%temp%\VSFeedbackVSRTCLogs"
rd /s /q "%temp%\VSRemoteControl"
rd /s /q "%temp%\VSTelem"
rd /s /q "%Temp%\VSTelem.Out"
rd /s /q "%AppData%\Sun\Java\Deployment\cache"
rd /s /q "%AppData%\Macromedia\Flash Player"
rd /s /q "%USERPROFILE%\.dotnet\TelemetryStorageService"
reg delete "HKCU\Software\Adobe\MediaBrowser\MRU" /va /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List" /va /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU" /va /f
reg delete "HKCU\Software\Microsoft\Search Assistant\ACMru" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /va /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /va /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSaveMRU" /va /f
reg delete "HKCU\Software\Microsoft\Direct3D\MostRecentApplication" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\Direct3D\MostRecentApplication" /va /f
del /f /s /q /a %LocalAppData%\Microsoft\Windows\Explorer\*.db
goto :eof

:dwmC
echo !S_GREEN!Preparing DWM Script
takeown /F "%windir%\System32\dwm.exe" /A & icacls "%windir%\System32\dwm.exe" /grant Administrators:(F) >nul 2>&1
takeown /F "%windir%\System32\UIRibbon.dll" /A & icacls "%windir%\System32\UIRibbon.dll" /grant Administrators:(F) >nul 2>&1
takeown /F "%windir%\System32\UIRibbonRes.dll" /A & icacls "%windir%\System32\UIRibbonRes.dll" /grant Administrators:(F) >nul 2>&1
takeown /F "%windir%\System32\Windows.UI.Logon.dll" /A & icacls "%windir%\System32\Windows.UI.Logon.dll" /grant Administrators:(F) >nul 2>&1
takeown /F "%windir%\System32\RuntimeBroker.exe" /A & icacls "%windir%\System32\RuntimeBroker.exe" /grant Administrators:(F) >nul 2>&1
takeown /F "%windir%\SystemApps\ShellExperienceHost_cw5n1h2txyewy" /A & icacls "%windir%\SystemApps\ShellExperienceHost_cw5n1h2txyewy" /grant Administrators:(F) >nul 2>&1
copy /y "%windir%\System32\dwm.exe" "%WinDir%\NeptuneDir\Other\dwm\realdwm\dwm.exe" >nul 2>&1
copy /y "%windir%\System32\rundll32.exe" "%WinDir%\NeptuneDir\Other\dwm\fakedwm\dwm.exe" >nul 2>&1
goto:eof


:dwmD
echo !S_GREEN!Disabling DWM...
call:dwmC
%WinDir%\NeptuneDir%\Tools\pssuspend -r winlogon >nul 2>&1
timeout 1 >nul 2>&1
%WinDir%\NeptuneDir%\Tools\pssuspend winlogon >nul 2>&1
timeout 1 >nul 2>&1
taskkill /F /IM dwm.exe >nul 2>&1
timeout 1 >nul 2>&1
copy /y "%windir%\NeptuneDir\Other\dwm\fakedwm\dwm.exe" "%windir%\System32" >nul 2>&1
REN "%windir%\System32\UIRibbon.dll" "UIRibbon.old" >nul 2>&1
REN "%windir%\System32\UIRibbonRes.dll" "UIRibbonRes.old" >nul 2>&1
REN "%windir%\System32\Windows.UI.Logon.dll" "Windows.UI.Logon.old" >nul 2>&1
REN "%windir%\System32\RuntimeBroker.exe" "RuntimeBroker.old" >nul 2>&1
REN "%windir%\SystemApps\ShellExperienceHost_cw5n1h2txyewy\ShellExperienceHost.exe" "ShellExperienceHost.old" >nul 2>&1
%WinDir%\NeptuneDir%\Tools\pssuspend -r winlogon >nul 2>&1
shutdown /r /f /t 0
exit /b


:dwmE
echo Enabling DWM...
%WinDir%\NeptuneDir%\Tools\pssuspend -r winlogon >nul 2>&1
copy /y "%windir%\NeptuneDir\Other\dwm\realdwm\dwm.exe" "%windir%\System32" >nul 2>&1
timeout 1 >nul 2>&1
REN "%windir%\System32\UIRibbon.old" "UIRibbon.dll" >nul 2>&1
REN "%windir%\System32\UIRibbonRes.old" "UIRibbonRes.dll" >>nul 2>&1
REN "%windir%\System32\Windows.UI.Logon.old" "Windows.UI.Logon.dll" >nul 2>&1
shutdown /r /f /t 0
exit /b

:idleD
echo THIS WILL CAUSE YOUR CPU USAGE TO *DISPLAY* AS 100% IN TASK MANAGER. ENABLE IDLE IF THIS IS AN ISSUE.
powercfg -setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 1
powercfg -setactive scheme_current
goto finishNRB

:idleE
powercfg -setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 0
powercfg -setactive scheme_current
goto finishNRB

:dscp
echo "Please select the game you play."

for /f "tokens=* delims=\" %%i in ('C:\Windows\NeptuneDir\Tools\filepicker.exe exe') do (
    if "%%i"=="cancelled by user" exit
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Application Name" /t REG_SZ /d "%%~ni%%~xi" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Version" /t REG_SZ /d "1.0" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Protocol" /t REG_SZ /d "*" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Local Port" /t REG_SZ /d "*" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Local IP" /t REG_SZ /d "*" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Local IP Prefix Length" /t REG_SZ /d "*" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Remote Port" /t REG_SZ /d "*" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Remote IP" /t REG_SZ /d "*" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Remote IP Prefix Length" /t REG_SZ /d "*" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "DSCP Value" /t REG_SZ /d "46" /f >nul 2>&1
    Reg.exe add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Throttle Rate" /t REG_SZ /d "-1" /f >nul 2>&1
    Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%%i" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE HIGHDPIAWARE" /f >nul 2>&1 
)
goto finishNRB

:memoryC
set "ESL=%WinDir%\NeptuneDir\Tools\EmptyStandbyList.exe
%ESL% workingsets
%ESL% modifiedpagelist
%ESL% priority0standbylist
%ESL% standbylist
echo RAM cleaned.
pause>nul












:::::::::::::::::::::::
::: Batch Functions :::
:::::::::::::::::::::::

:Functions
set "CMDLINE=RED=[31m,S_GRAY=[90m,S_RED=[91m,S_GREEN=[92m,S_YELLOW=[93m,S_MAGENTA=[95m,S_WHITE=[97m,B_BLACK=[40m,B_YELLOW=[43m,UNDERLINE=[4m,_UNDERLINE=[24m"
set "%CMDLINE:,=" & set "%"
set "PowerShell=%WinDir%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command"
set "POWER_GUID=%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%-%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%-%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%-%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%-%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%"
set currentuser=%WinDir%\NeptuneDir\Tools\NSudoLG.exe -U:C -P:E -ShowWindowMode:Hide -Wait
set system=%WinDir%\NeptuneDir\Tools\NSudoLG.exe -U:T -P:E -ShowWindowMode:Hide -Wait
set DevMan="%WinDir%\NeptuneDir\Tools\dmv.exe"
set svc=call :setSvc
:: Script configuration
set version=0.5
title NeptuneOS %version% Configuration Script
cls
goto:eof

:setSvc
:: %svc% (service name) (0-4)
if "%1"=="" (echo You need to run this with a service to disable. && exit /b 1)
if "%2"=="" (echo You need to run this with an argument ^(1-4^) to configure the service's startup. && exit /b 1)
if %2 LSS 0 (echo Invalid configuration. && exit /b 1)
if %2 GTR 4 (echo Invalid configuration. && exit /b 1)
reg query "HKLM\System\CurrentControlSet\Services\%1" >nul 2>&1 || (echo The specified service/driver is not found. && exit /b 1)
Reg.exe add "HKLM\System\CurrentControlSet\Services\%1" /v "Start" /t REG_DWORD /d "%2" /f > nul
exit /b 0

:permFAIL
	echo Permission grants failed. Please try again by launching the script through the respected scripts, which will give it the correct permissions.
	pause & exit /b 1
:finish
	echo Finished, please reboot for changes to apply.
	pause & exit /b
:finishNRB
	echo Finished, changes have been applied.
	pause & exit /b