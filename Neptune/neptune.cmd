@echo off

:: Call Administrator
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select 'Run as administrator'.
        pause & exit 1
    )
    exit 0
)

:: Window Configuration
mode con: cols=80 lines=30
title "NeptuneOS Installer | Created by @NyneDZN"

:: PowerShell Variables
set sudo="C:\NeptuneOS-installer-dev\Neptune\PowerRun_x64.exe" /SW:0 /SYS
set currentuser="C:\NeptuneOS-installer-dev\Neptune\PowerRun_x64.exe" /SW:0
:: NSUDO Variables
:: set sudo="C:\NeptuneOS-installer-dev\Neptune\nsudo.exe" -U:T -P:E -ShowWindowMode:Hide -Wait
:: set currentuser="C:\NeptuneOS-installer-dev\Neptune\nsudo.exe" -U:C -ShowWindowMode:Hide -Wait

:: Path Variables
set neptunemain=C:\NeptuneOS-installer\Neptune\
set neptunedev=C:\NeptuneOS-installer-dev\Neptune\

:: Set ANSI escape characters (AtlasOS)
cd /d "%~dp0"
for /f %%a in ('forfiles /m "%~nx0" /c "cmd /c echo 0x1B"') do set "ESC=%%a"
set "right=%ESC%[<x>C"
set "bullet= %ESC%[34m-%ESC%[0m"
set "CMDLINE=RED=[31m,S_GRAY=[90m,S_RED=[91m,S_GREEN=[92m,S_YELLOW=[93m,S_MAGENTA=[95m,S_WHITE=[97m,B_BLACK=[40m,B_YELLOW=[43m,UNDERLINE=[4m,_UNDERLINE=[24m"
set "%CMDLINE:,=" & set "%"


echo %ESC%[4mBy running the NeptuneOS installer, you allow it to make changes to your PC.%ESC%[0m

set /p userInput=Please type 'yes' to continue.: 
if /i "%userInput%"=="yes" (goto Menu) else (goto NotAccepted)
    
:NotAccepted
echo You did not type 'yes'
echo Closing...
exit /b

:menu
cls & mode con: cols=60 lines=20
echo]
echo    %ESC%[7mNeptuneOS Installer.%ESC%[0m
echo]
echo %bullet% 1. Install NeptuneOS
echo %bullet% 2. Exit
echo]
echo]
echo %bullet% https://discord.gg/4YTSkcK8b8
choice /c 12 /n /m "Select a choice:"

if errorlevel 2 (
    goto Nope
) else (
    if errorlevel 1 (
        goto NeptuneInstall
    )
)



:NeptuneInstall
mode con: cols=40 lines=20
title "Please wait..."
setlocal EnableDelayedExpansion
cls & echo !S_YELLOW!This will take a moment.
echo !S_YELLOW!We are disabling defender.
echo]
echo]
echo !S_YELLOW! We will restart when this is done.
del "%temp%\installer.zip"

:: UAC Permissionss
%WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "0" /f > nul
%WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "0" /f > nul
%WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d "0" /f > nul

:: Install Chocolatey
PowerShell Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) >nul

:: Refresh Enviornment
call "%neptdev%RefreshEnv.cmd"

:: Disable Global Confirmation in Chocolatey
choco feature enable -n allowGlobalConfirmation > nul

:: Disable Hash Checking in Chocolatey
:: This is due to it causing errors, if you need to check the hashes, please do this manually
choco feature disable -n checksumFiles > nul

:: Remove Server Manager from Startup on Servers
if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Server Manager.lnk" (%WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Server\ServerManager" /v "DoNotOpenAtLogon" /t REG_DWORD /d "1" /f >nul 2>&1)

:: Remove OneDrive
if exist "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" (taskkill /f /im OneDrive.exe >nul 2>&1)
if exist "C:\" ("%WINDIR%\System32\OneDriveSetup.exe" /uninstall >nul 2>&1) else ("%WINDIR%\SysWOW64\OneDriveSetup.exe" /uninstall >nul 2>&1) 
%WinDir%\System32\Reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1

:: Remove Azure Arc Setup from Startup on Servers
if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Server Manager.lnk" (%WinDir%\System32\Reg.exe delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "AzureArcSetup" /f >nul 2>&1)

:: Disable Defender
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "1" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRawWriteNotification" /t REG_DWORD /d "1" /f > nul
:: - > Disable Defender Services
%sudo% %WinDir%\System32\Reg.exe add "HKLM\System\CurrentControlSet\Services\MsSecCore" /v "Start" /t Reg_DWORD /d "4" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\System\CurrentControlSet\Services\SecurityHealthService" /v "Start" /t Reg_DWORD /d "4" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\System\CurrentControlSet\Services\Sense" /v "Start" /t Reg_DWORD /d "4" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\System\CurrentControlSet\Services\WdBoot" /v "Start" /t Reg_DWORD /d "4" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\System\CurrentControlSet\Services\WdFilter" /v "Start" /t Reg_DWORD /d "4" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\System\CurrentControlSet\Services\WdNisDrv" /v "Start" /t Reg_DWORD /d "4" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\System\CurrentControlSet\Services\WdNisSvc" /v "Start" /t Reg_DWORD /d "4" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\System\CurrentControlSet\Services\WinDefend" /v "Start" /t Reg_DWORD /d "4" /f > nul
:: - > Remove Security Health Icon from Startup
Reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f >nul 2>&1
:: - > Disable Windows Defender
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f > nul
:: - > Disable always running antimalware service
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "ServiceKeepAlive" /t REG_DWORD /d "1" /f > nul
:: - > Disable file hash computation feature
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine" /v "EnableFileHashComputation" /t REG_DWORD /d "0" /f > nul
:: - > Disable tamper protection
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d "4" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtectionSource" /t REG_DWORD /d "2" /f > nul
:: - > Disable Auto-Exclusions
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Exclusions" /v "DisableAutoExclusions" /t REG_DWORD /d "1" /f > nul
:: - > Disable always running antimalware service
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "ServiceKeepAlive" /t REG_DWORD /d "1" /f > nul
:: - > Disable file hash computation feature
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine" /v "EnableFileHashComputation" /t REG_DWORD /d "0" /f > nul
:: - > Disable Potentially Unwanted Application (PUA) feature
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "PUAProtection" /t REG_DWORD /d "0" /f > nul
:: ^ - > For legacy versions: Windows 10 v1809 and Windows Server 2019
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine" /v "MpEnablePus" /t REG_DWORD /d "0" /f > nul
:: - > Disable Microsoft Defender Antimalware user interface
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\UX Configuration" /v "UILockdown" /t REG_DWORD /d "1" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Firewall and network protection" /v "UILockdown" /t REG_DWORD /d "1" /f > nul
:: - > Disable block at first sight
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\SpyNet" /v "DisableBlockAtFirstSeen" /t REG_DWORD /d "1" /f > nul
:: - > Maximize time for extended cloud check timeout
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\MpEngine" /v "MpBafsExtendedTimeout" /t REG_DWORD /d "50" /f > nul
:: - > Minimize cloud protection level
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\MpEngine" /v "MpCloudBlockLevel" /t REG_DWORD /d "0" /f > nul
:: - > Disable SpyNet Reporting
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpynetReporting" /t REG_DWORD /d "0" /f > nul
:: - > Disable notifications to turn off security intelligence
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "SignatureDisableNotification" /t REG_DWORD /d "0" /f > nul
:: - > Disable sending file samples for further analysis
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f > nul
:: - > Disable "Malicious Software Reporting" tool diagnostic data
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f > nul
:: - > Disable uploading files for threat analysis in real-time
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "RealtimeSignatureDelivery" /t REG_DWORD /d "0" /f > nul
:: - > Disable prevention of users and apps from accessing dangerous websites
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection" /v "EnableNetworkProtection" /t REG_DWORD /d "1" /f > nul
:: - > Disable controlled folder access
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access" /v "EnableControlledFolderAccess" /t REG_DWORD /d "0" /f > nul
:: - > Disable protocol recognition
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\NIS" /v "DisableProtocolRecognition" /t REG_DWORD /d "1" /f > nul
:: - > Disable definition retirement
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\NIS\Consumers\IPS" /v "DisableSignatureRetirement" /t REG_DWORD /d "1" /f > nul
:: - > Minimize rate of detection events
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\NIS\Consumers\IPS" /v "ThrottleDetectionEventsRate" /t REG_DWORD /d "10000000" /f > nul
:: - > Disable behavior monitoring
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "1" /f > nul
:: - > Disable sending raw write notifications to behavior monitoring
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRawWriteNotification" /t REG_DWORD /d "1" /f > nul
:: - > Disable scanning of all downloaded files and attachments
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d "1" /f > nul
:: - > Disable scanning files larger than 1 KB (minimum possible)
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "IOAVMaxSize" /t REG_DWORD /d "1" /f > nul
:: - > Disable file and program activity monitoring
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d "1" /f > nul
:: - > Disable bidirectional scan for incoming and outgoing file and program activities
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "RealTimeScanDirection" /t REG_DWORD /d "1" /f > nul
:: - > Disable real-time monitoring
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f > nul
:: - > Disable intrusion prevention system (IPS)
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIntrusionPreventionSystem" /t REG_DWORD /d "1" /f > nul
:: - > Disable Information Protection Control (IPC)
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableInformationProtectionControl" /t REG_DWORD /d "1" /f > nul
:: - > Disable real-time protection process scanning
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d "1" /f > nul
:: - > Disable routine remediation
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d "1" /f > nul
:: - > Disable running scheduled auto-remediation
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Remediation" /v "Scan_ScheduleDay" /t REG_DWORD /d "8" /f > nul
:: - > Disable remediation actions
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Threats" /v "Threats_ThreatSeverityDefaultAction" /t "REG_DWORD" /d "1" /f > nul
:: 1: Clean, 2: Quarantine, 3: Remove, 6: Allow, 8: Ask user, 9: No action, 10: Block, NULL: default (based on the update definition)
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "5" /t "REG_SZ" /d "9" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "4" /t "REG_SZ" /d "9" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "3" /t "REG_SZ" /d "9" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "2" /t "REG_SZ" /d "9" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "1" /t "REG_SZ" /d "9" /f > nul
:: - > Enable automatically purging items from quarantine folder
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Quarantine" /v "PurgeItemsAfterDelay" /t REG_DWORD /d "1" /f > nul
:: - > Disable signature verification before scanning
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "CheckForSignaturesBeforeRunningScan" /t REG_DWORD /d "0" /f > nul
:: - > Disable creation of daily system restore points
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableRestorePoint" /t REG_DWORD /d "1" /f > nul
:: - > Minimize retention time for files in scan history
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "PurgeItemsAfterDelay" /t REG_DWORD /d "1" /f > nul
:: - > Maximize days until mandatory catch-up scan
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "MissedScheduledScanCountBeforeCatchup" /t REG_DWORD /d "20" /f > nul
:: - > Disable catch-up full scans
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableCatchupFullScan" /t REG_DWORD /d "1" /f > nul
:: - > Disable catch-up quick scans
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableCatchupQuickScan" /t REG_DWORD /d "1" /f > nul
:: - > Minimize CPU usage during scans
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "AvgCPULoadFactor" /t REG_DWORD /d "1" /f > nul
:: - > Minimize CPU usage during idle scans
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableCpuThrottleOnIdleScans" /t REG_DWORD /d "0" /f > nul
:: - > Disable scan heuristics
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableHeuristics" /t REG_DWORD /d "1" /f > nul
:: - > Disable scanning when not idle
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "ScanOnlyIfIdle" /t REG_DWORD /d "1" /f > nul
:: - > Disable scheduled anti-malware scanner (MRT)
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f > nul
:: - > Disable scanning archive files
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableArchiveScanning" /t REG_DWORD /d "1" /f > nul
:: - > Minimize scanning depth of archive files
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "ArchiveMaxDepth" /t REG_DWORD /d "0" /f > nul
:: - > Minimize file size for scanning archive files
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "ArchiveMaxSize" /t REG_DWORD /d "1" /f > nul
:: - > Disable e-mail scanning
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableEmailScanning" /t REG_DWORD /d "1" /f > nul
:: - > Disable script scanning
:: - > Disable reparse point scanning
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableReparsePointScanning" /t REG_DWORD /d "1" /f > nul
:: - > Disable scanning mapped network drives during full scan
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableScanningMappedNetworkDrivesForFullScan" /t REG_DWORD /d "1" /f > nul
:: - > Disable network file scanning
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableScanningNetworkFiles" /t REG_DWORD /d "1" /f > nul
:: - > Disable scanning packed executables
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisablePackedExeScanning" /t REG_DWORD /d "1" /f > nul
:: - > Disable scanning removable drives
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableRemovableDriveScanning" /t REG_DWORD /d "1" /f > nul
:: - > Disable scheduled scans
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "ScheduleDay" /t REG_DWORD /d "8" /f > nul
:: - > Disable randomizing scheduled task times
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "RandomizeScheduleTaskTimes" /t REG_DWORD /d "0" /f > nul
:: - > Disable scheduled full-scans
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "ScanParameters" /t REG_DWORD /d "1" /f > nul
:: - > Minimize daily quick scan frequency
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "QuickScanInterval" /t REG_DWORD /d "24" /f > nul
:: - > Disable scanning after security intelligence (signature) update
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "DisableScanOnUpdate" /t REG_DWORD /d "1" /f > nul
:: - > Disable definition updates via WSUS and Microsoft Malware Protection Center
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "CheckAlternateHttpLocation" /t REG_DWORD /d "0" /f > nul
::  - > Disable definition updates through both WSUS and Windows Update
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "CheckAlternateDownloadLocation" /t REG_DWORD /d "0" /f > nul
:: - > Disable forced security intelligence (signature) updates from Microsoft Update
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "ForceUpdateFromMU" /t REG_DWORD /d "1" /f > nul
::  - > Disable security intelligence (signature) updates when running on battery power
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "DisableScheduledSignatureUpdateOnBattery" /t REG_DWORD /d "1" /f > nul
::  - > Disable startup check for latest virus and spyware security intelligence (signature)
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "UpdateOnStartUp" /t REG_DWORD /d "1" /f > nul
:: - > Disable catch-up security intelligence (signature) updates
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "SignatureUpdateCatchupInterval" /t REG_DWORD /d "0" /f > nul
:: - > Minimize spyware security intelligence (signature) updates
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "ASSignatureDue" /t REG_DWORD /d "4294967295" /f > nul
:: - > Minimize virus security intelligence (signature) updates
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "AVSignatureDue" /t REG_DWORD /d "4294967295" /f > nul
:: - > Disable security intelligence (signature) update on startup
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "DisableUpdateOnStartupWithoutEngine" /t REG_DWORD /d "1" /f > nul
:: - > Disable automatic checks for security intelligence (signature) updates
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "ScheduleDay" /t REG_DWORD /d "8" /f > nul
:: - > Minimize checks for security intelligence (signature) updates
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "SignatureUpdateInterval" /t REG_DWORD /d "24" /f > nul
:: - > Disable Defender logging
%sudo% %WinDir%\System32\Reg.exe add "HKLM\System\CurrentControlSet\Control\WMI\Autologger\DefenderApiLogger" /v "Start" /t REG_DWORD /d "0" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\System\CurrentControlSet\Control\WMI\Autologger\DefenderAuditLogger" /v "Start" /t REG_DWORD /d "0" /f > nul
:: - > Disable Microsoft Defender ETW provider (Windows Event Logs)
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Windows Defender/Operational" /v "Enabled" /t Reg_DWORD /d "0" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Windows Defender/WHC" /v "Enabled" /t Reg_DWORD /d "0" /f > nul
:: - > Disable sending Watson events
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "DisableGenericRePorts" /t REG_DWORD /d "1" /f > nul
:: - > Minimize Windows software trace preprocessor (WPP Software Tracing)
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "WppTracingLevel" /t REG_DWORD /d "1" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\AppHVSI" /v "AuditApplicationGuard" /t REG_DWORD /d "0" /f > nul
:: - > Disable "Device security" section in "Windows Security"
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" /v "UILockdown" /t REG_DWORD /d "1" /f > nul
:: - > Disable "Clear TPM" button in "Windows Security"
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" /v "DisableClearTpmButton" /t REG_DWORD /d "1" /f > nul
:: - > Disable "Secure boot" button in "Windows Security" 
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" /v "HideSecureBoot" /t REG_DWORD /d "1" /f > nul
:: - > Disable "Security processor (TPM) troubleshooter" page in "Windows Security"
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" /v "HideTPMTroubleshooting" /t REG_DWORD /d "1" /f > nul
:: - > Disable "TPM Firmware Update" recommendation in "Windows Security"
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" /v "DisableTpmFirmwareUpdateWarning" /t REG_DWORD /d "1" /f > nul
:: - > Disable "Virus and threat protection" section in "Windows Security"
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Virus and threat protection" /v "UILockdown" /t REG_DWORD /d "1" /f > nul
:: - > Disable "Ransomware data recovery" section in "Windows Security" 
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Virus and threat protection" /v "HideRansomwareRecovery" /t REG_DWORD /d "1" /f > nul
:: - > Disable "Family options" section in "Windows Security"
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Family options" /v "UILockdown" /t REG_DWORD /d "1" /f > nul
:: - > Disable "Device performance and health" section in "Windows Security"
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device performance and health" /v "UILockdown" /t REG_DWORD /d "1" /f > nul
:: - > Disable "Account protection" section in "Windows Security"
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Account protection" /v "UILockdown" /t REG_DWORD /d "1" /f > nul
:: - > Disable "App and browser control" section in "Windows Security" 
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection" /v "UILockdown" /t REG_DWORD /d "1" /f > nul
:: - > Disable all Defender notifications
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v "DisableNotifications" /t REG_DWORD /d "1" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows Defender Security Center\Notifications" /v "DisableNotifications" /t REG_DWORD /d "1" /f > nul
:: - > Disable non-critical Defender notifications
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows Defender Security Center\Notifications" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f > nul
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Reporting" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f > nul
:: - > Disable notifications from Windows Action Center for security and maintenance
%currentuser% %WinDir%\System32\Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" /v "Enabled" /t REG_DWORD /d "0" /f > nul
:: - > Disable all Defender Antivirus notifications
%currentuser% %WinDir%\System32\Reg.exe add "HKCU\SOFTWARE\Policies\Microsoft\Windows Defender\UX Configuration" /v "Notification_Suppress" /t REG_DWORD /d "1" /f > nul
%currentuser% %WinDir%\System32\Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows Defender\UX Configuration" /v "Notification_Suppress" /t REG_DWORD /d "1" /f > nul
:: - > Disable Defender reboot notifications
%sudo% %WinDir%\System32\Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\UX Configuration" /v "SuppressRebootNotification" /t REG_DWORD /d "1" /f > nul
:: - > Remove "Windows Security" system tray icon
%sudo% %WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Systray" /v "HideSystray" /t REG_DWORD /d "1" /f > nul
:: - > Disable Defender Tasks
schtasks /change /TN "\Microsoft\Windows\ExploitGuard\ExploitGuard MDM policy Refresh" /disable > nul
schtasks /change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /disable > nul
schtasks /change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /disable > nul
schtasks /change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /disable > nul
schtasks /change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Verification" /disable > nul
:: RunOnce Neptune2
%WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "Neptune" /t REG_SZ /d "C:\NeptuneOS-installer-dev\Neptune\neptune2.cmd" /f > nul

:: Finalize
cls & echo Restarting...
timeout /t 1 > nul
shutdown /f /r /t 0
exit /b




:Nope
cls
echo]
echo Exiting...
rmdir /s /q "C:\NeptuneOS-installer-dev"
timeout /t 2 >nul
exit /b