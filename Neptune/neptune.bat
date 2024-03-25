@echo off
:: Check if script is escelated
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if %errorlevel% neq 0 (
    echo You are about to be prompted with the UAC. Please click yes when prompted.
) ELSE (
    goto admin
)

:prompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\prompt.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\prompt.vbs"
    "%temp%\prompt.vbs"
    exit /B

:admin
:: Delete prompt script
if exist "%temp%\prompt.vbs" ( del "%temp%\prompt.vbs" )

mode 70,30
color f1
set sudo="C:\NeptuneOS-installer-dev\Neptune\nsudo.exe" -U:T -P:E -ShowWindowMode:Hide -Wait
set currentuser="C:\NeptuneOS-installer-dev\Neptune\nsudo.exe" -U:C -ShowWindowMode:Hide -Wait

:menu
cls
echo ========================
echo NeptuneOS Installer.
echo ========================
echo 1. Install NeptuneOS
echo 2. Disable Automatic Driver Installation
echo ========================
choice /c 12 /n /m "Select a choice: "

if errorlevel 2 goto DisableAutoDriver
if errorlevel 1 goto NeptuneInstall


:NeptuneInstall
cls & echo This will take a moment.
echo We are disabling defender.
del "%temp%\installer.zip"
:: taskkill /f /im powershell.exe >nul 2>&1
:: start "" C:\NeptuneOS-installer-dev\Neptune\Scripts\phase1.bat

:: UAC Permissions
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "0" /f > nul
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "0" /f > nul
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d "0" /f > nul

:: Remove Server Manager from Startup on Servers
if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Server Manager.lnk" (Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Server\ServerManager" /v "DoNotOpenAtLogon" /t REG_DWORD /d "1" /f > nul)

:: Remove OneDrive
if exist "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" (taskkill /f /im OneDrive.exe >nul 2>&1)
if exist "C:\" ("%WINDIR%\System32\OneDriveSetup.exe" /uninstall >nul 2>&1) else ("%WINDIR%\SysWOW64\OneDriveSetup.exe" /uninstall >nul 2>&1) 
Reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1

:: Disable Defender
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f > nul
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "1" /f > nul
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRawWriteNotification" /t REG_DWORD /d "1" /f > nul
:: - > Disable Defender Services
%sudo% Reg add "HKLM\System\CurrentControlSet\Services\MsSecCore" /v "Start" /t Reg_DWORD /d "4" /f > nul
%sudo% Reg add "HKLM\System\CurrentControlSet\Services\SecurityHealthService" /v "Start" /t Reg_DWORD /d "4" /f > nul
%sudo% Reg add "HKLM\System\CurrentControlSet\Services\Sense" /v "Start" /t Reg_DWORD /d "4" /f > nul
%sudo% Reg add "HKLM\System\CurrentControlSet\Services\WdBoot" /v "Start" /t Reg_DWORD /d "4" /f > nul
%sudo% Reg add "HKLM\System\CurrentControlSet\Services\WdFilter" /v "Start" /t Reg_DWORD /d "4" /f > nul
%sudo% Reg add "HKLM\System\CurrentControlSet\Services\WdNisDrv" /v "Start" /t Reg_DWORD /d "4" /f > nul
%sudo% Reg add "HKLM\System\CurrentControlSet\Services\WdNisSvc" /v "Start" /t Reg_DWORD /d "4" /f > nul
%sudo% Reg add "HKLM\System\CurrentControlSet\Services\WinDefend" /v "Start" /t Reg_DWORD /d "4" /f > nul
:: - > Disable Windows Defender
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f > nul
:: - > Disable always running antimalware service
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "ServiceKeepAlive" /t REG_DWORD /d "1" /f > nul
:: - > Disable file hash computation feature
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine" /v "EnableFileHashComputation" /t REG_DWORD /d "0" /f > nul
:: - > Disable tamper protection
%sudo% Reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d "4" /f > nul
%sudo% Reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtectionSource" /t REG_DWORD /d "2" /f > nul
:: - > Disable Auto-Exclusions
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Exclusions" /v "DisableAutoExclusions" /t REG_DWORD /d "1" /f > nul
:: - > Disable always running antimalware service
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "ServiceKeepAlive" /t REG_DWORD /d "1" /f > nul
:: - > Disable file hash computation feature
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine" /v "EnableFileHashComputation" /t REG_DWORD /d "0" /f > nul
:: - > Disable Potentially Unwanted Application (PUA) feature
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "PUAProtection" /t REG_DWORD /d "0" /f > nul
:: ^ - > For legacy versions: Windows 10 v1809 and Windows Server 2019
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine" /v "MpEnablePus" /t REG_DWORD /d "0" /f > nul
:: - > Disable Microsoft Defender Antimalware user interface
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\UX Configuration" /v "UILockdown" /t REG_DWORD /d "1" /f > nul
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Firewall and network protection" /v "UILockdown" /t REG_DWORD /d "1" /f > nul
:: - > Disable block at first sight
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\SpyNet" /v "DisableBlockAtFirstSeen" /t REG_DWORD /d "1" /f > nul
:: - > Maximize time for extended cloud check timeout
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\MpEngine" /v "MpBafsExtendedTimeout" /t REG_DWORD /d "50" /f > nul
:: - > Minimize cloud protection level
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\MpEngine" /v "MpCloudBlockLevel" /t REG_DWORD /d "0" /f > nul
:: - > Disable SpyNet Reporting
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpynetReporting" /t REG_DWORD /d "0" /f > nul
:: - > Disable notifications to turn off security intelligence
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "SignatureDisableNotification" /t REG_DWORD /d "0" /f > nul
:: - > Disable sending file samples for further analysis
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f > nul
:: - > Disable "Malicious Software Reporting" tool diagnostic data
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f > nul
:: - > Disable uploading files for threat analysis in real-time
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "RealtimeSignatureDelivery" /t REG_DWORD /d "0" /f > nul
:: - > Disable prevention of users and apps from accessing dangerous websites
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection" /v "EnableNetworkProtection" /t REG_DWORD /d "1" /f > nul
:: - > Disable controlled folder access
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access" /v "EnableControlledFolderAccess" /t REG_DWORD /d "0" /f > nul
:: - > Disable protocol recognition
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\NIS" /v "DisableProtocolRecognition" /t REG_DWORD /d "1" /f > nul
:: - > Disable definition retirement
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\NIS\Consumers\IPS" /v "DisableSignatureRetirement" /t REG_DWORD /d "1" /f > nul
:: - > Minimize rate of detection events
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\NIS\Consumers\IPS" /v "ThrottleDetectionEventsRate" /t REG_DWORD /d "10000000" /f > nul
:: - > Disable behavior monitoring
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "1" /f > nul
:: - > Disable sending raw write notifications to behavior monitoring
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRawWriteNotification" /t REG_DWORD /d "1" /f > nul
:: - > Disable scanning of all downloaded files and attachments
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d "1" /f > nul
:: - > Disable scanning files larger than 1 KB (minimum possible)
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "IOAVMaxSize" /t REG_DWORD /d "1" /f > nul
:: - > Disable file and program activity monitoring
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d "1" /f > nul
:: - > Disable bidirectional scan for incoming and outgoing file and program activities
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "RealTimeScanDirection" /t REG_DWORD /d "1" /f > nul
:: - > Disable real-time monitoring
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f > nul
:: - > Disable intrusion prevention system (IPS)
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIntrusionPreventionSystem" /t REG_DWORD /d "1" /f > nul
:: - > Disable Information Protection Control (IPC)
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableInformationProtectionControl" /t REG_DWORD /d "1" /f > nul
:: - > Disable real-time protection process scanning
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d "1" /f > nul
:: - > Disable routine remediation
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d "1" /f > nul
:: - > Disable running scheduled auto-remediation
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Remediation" /v "Scan_ScheduleDay" /t REG_DWORD /d "8" /f > nul
:: - > Disable remediation actions
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Threats" /v "Threats_ThreatSeverityDefaultAction" /t "REG_DWORD" /d "1" /f > nul
:: 1: Clean, 2: Quarantine, 3: Remove, 6: Allow, 8: Ask user, 9: No action, 10: Block, NULL: default (based on the update definition)
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "5" /t "REG_SZ" /d "9" /f > nul
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "4" /t "REG_SZ" /d "9" /f > nul
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "3" /t "REG_SZ" /d "9" /f > nul
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "2" /t "REG_SZ" /d "9" /f > nul
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "1" /t "REG_SZ" /d "9" /f > nul
:: - > Enable automatically purging items from quarantine folder
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Quarantine" /v "PurgeItemsAfterDelay" /t REG_DWORD /d "1" /f > nul
:: - > Disable signature verification before scanning
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "CheckForSignaturesBeforeRunningScan" /t REG_DWORD /d "0" /f > nul
:: - > Disable creation of daily system restore points
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableRestorePoint" /t REG_DWORD /d "1" /f > nul
:: - > Minimize retention time for files in scan history
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "PurgeItemsAfterDelay" /t REG_DWORD /d "1" /f > nul
:: - > Maximize days until mandatory catch-up scan
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "MissedScheduledScanCountBeforeCatchup" /t REG_DWORD /d "20" /f > nul
:: - > Disable catch-up full scans
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableCatchupFullScan" /t REG_DWORD /d "1" /f > nul
:: - > Disable catch-up quick scans
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableCatchupQuickScan" /t REG_DWORD /d "1" /f > nul
:: - > Minimize CPU usage during scans
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "AvgCPULoadFactor" /t REG_DWORD /d "1" /f > nul
:: - > Minimize CPU usage during idle scans
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableCpuThrottleOnIdleScans" /t REG_DWORD /d "0" /f > nul
:: - > Disable scan heuristics
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableHeuristics" /t REG_DWORD /d "1" /f > nul
:: - > Disable scanning when not idle
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "ScanOnlyIfIdle" /t REG_DWORD /d "1" /f > nul
:: - > Disable scheduled anti-malware scanner (MRT)
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f > nul
:: - > Disable scanning archive files
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableArchiveScanning" /t REG_DWORD /d "1" /f > nul
:: - > Minimize scanning depth of archive files
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "ArchiveMaxDepth" /t REG_DWORD /d "0" /f > nul
:: - > Minimize file size for scanning archive files
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "ArchiveMaxSize" /t REG_DWORD /d "1" /f > nul
:: - > Disable e-mail scanning
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableEmailScanning" /t REG_DWORD /d "1" /f > nul
:: - > Disable script scanning
:: - > Disable reparse point scanning
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableReparsePointScanning" /t REG_DWORD /d "1" /f > nul
:: - > Disable scanning mapped network drives during full scan
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableScanningMappedNetworkDrivesForFullScan" /t REG_DWORD /d "1" /f > nul
:: - > Disable network file scanning
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableScanningNetworkFiles" /t REG_DWORD /d "1" /f > nul
:: - > Disable scanning packed executables
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisablePackedExeScanning" /t REG_DWORD /d "1" /f > nul
:: - > Disable scanning removable drives
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableRemovableDriveScanning" /t REG_DWORD /d "1" /f > nul
:: - > Disable scheduled scans
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "ScheduleDay" /t REG_DWORD /d "8" /f > nul
:: - > Disable randomizing scheduled task times
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "RandomizeScheduleTaskTimes" /t REG_DWORD /d "0" /f > nul
:: - > Disable scheduled full-scans
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "ScanParameters" /t REG_DWORD /d "1" /f > nul
:: - > Minimize daily quick scan frequency
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "QuickScanInterval" /t REG_DWORD /d "24" /f > nul
:: - > Disable scanning after security intelligence (signature) update
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "DisableScanOnUpdate" /t REG_DWORD /d "1" /f > nul
:: - > Disable definition updates via WSUS and Microsoft Malware Protection Center
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "CheckAlternateHttpLocation" /t REG_DWORD /d "0" /f > nul
::  - > Disable definition updates through both WSUS and Windows Update
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "CheckAlternateDownloadLocation" /t REG_DWORD /d "0" /f > nul
:: - > Disable forced security intelligence (signature) updates from Microsoft Update
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "ForceUpdateFromMU" /t REG_DWORD /d "1" /f > nul
::  - > Disable security intelligence (signature) updates when running on battery power
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "DisableScheduledSignatureUpdateOnBattery" /t REG_DWORD /d "1" /f > nul
::  - > Disable startup check for latest virus and spyware security intelligence (signature)
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "UpdateOnStartUp" /t REG_DWORD /d "1" /f > nul
:: - > Disable catch-up security intelligence (signature) updates
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "SignatureUpdateCatchupInterval" /t REG_DWORD /d "0" /f > nul
:: - > Minimize spyware security intelligence (signature) updates
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "ASSignatureDue" /t REG_DWORD /d "4294967295" /f > nul
:: - > Minimize virus security intelligence (signature) updates
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "AVSignatureDue" /t REG_DWORD /d "4294967295" /f > nul
:: - > Disable security intelligence (signature) update on startup
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "DisableUpdateOnStartupWithoutEngine" /t REG_DWORD /d "1" /f > nul
:: - > Disable automatic checks for security intelligence (signature) updates
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "ScheduleDay" /t REG_DWORD /d "8" /f > nul
:: - > Minimize checks for security intelligence (signature) updates
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "SignatureUpdateInterval" /t REG_DWORD /d "24" /f > nul
:: - > Disable Defender logging
%sudo% Reg add "HKLM\System\CurrentControlSet\Control\WMI\Autologger\DefenderApiLogger" /v "Start" /t REG_DWORD /d "0" /f > nul
%sudo% Reg add "HKLM\System\CurrentControlSet\Control\WMI\Autologger\DefenderAuditLogger" /v "Start" /t REG_DWORD /d "0" /f > nul
:: - > Disable Microsoft Defender ETW provider (Windows Event Logs)
%sudo% Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Windows Defender/Operational" /v "Enabled" /t Reg_DWORD /d "0" /f > nul
%sudo% Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Windows Defender/WHC" /v "Enabled" /t Reg_DWORD /d "0" /f > nul
:: - > Disable sending Watson events
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "DisableGenericRePorts" /t REG_DWORD /d "1" /f > nul
:: - > Minimize Windows software trace preprocessor (WPP Software Tracing)
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "WppTracingLevel" /t REG_DWORD /d "1" /f > nul
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\AppHVSI" /v "AuditApplicationGuard" /t REG_DWORD /d "0" /f > nul
:: - > Disable "Device security" section in "Windows Security"
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" /v "UILockdown" /t REG_DWORD /d "1" /f > nul
:: - > Disable "Clear TPM" button in "Windows Security"
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" /v "DisableClearTpmButton" /t REG_DWORD /d "1" /f > nul
:: - > Disable "Secure boot" button in "Windows Security" 
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" /v "HideSecureBoot" /t REG_DWORD /d "1" /f > nul
:: - > Disable "Security processor (TPM) troubleshooter" page in "Windows Security"
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" /v "HideTPMTroubleshooting" /t REG_DWORD /d "1" /f > nul
:: - > Disable "TPM Firmware Update" recommendation in "Windows Security"
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" /v "DisableTpmFirmwareUpdateWarning" /t REG_DWORD /d "1" /f > nul
:: - > Disable "Virus and threat protection" section in "Windows Security"
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Virus and threat protection" /v "UILockdown" /t REG_DWORD /d "1" /f > nul
:: - > Disable "Ransomware data recovery" section in "Windows Security" 
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Virus and threat protection" /v "HideRansomwareRecovery" /t REG_DWORD /d "1" /f > nul
:: - > Disable "Family options" section in "Windows Security"
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Family options" /v "UILockdown" /t REG_DWORD /d "1" /f > nul
:: - > Disable "Device performance and health" section in "Windows Security"
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device performance and health" /v "UILockdown" /t REG_DWORD /d "1" /f > nul
:: - > Disable "Account protection" section in "Windows Security"
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Account protection" /v "UILockdown" /t REG_DWORD /d "1" /f > nul
:: - > Disable "App and browser control" section in "Windows Security" 
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection" /v "UILockdown" /t REG_DWORD /d "1" /f > nul
:: - > Disable all Defender notifications
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v "DisableNotifications" /t REG_DWORD /d "1" /f > nul
%sudo% Reg add "HKLM\SOFTWARE\Microsoft\Windows Defender Security Center\Notifications" /v "DisableNotifications" /t REG_DWORD /d "1" /f > nul
:: - > Disable non-critical Defender notifications
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f > nul
%sudo% Reg add "HKLM\SOFTWARE\Microsoft\Windows Defender Security Center\Notifications" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f > nul
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Reporting" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f > nul
:: - > Disable notifications from Windows Action Center for security and maintenance
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" /v "Enabled" /t REG_DWORD /d "0" /f > nul
:: - > Disable all Defender Antivirus notifications
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows Defender\UX Configuration" /v "Notification_Suppress" /t REG_DWORD /d "1" /f > nul
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows Defender\UX Configuration" /v "Notification_Suppress" /t REG_DWORD /d "1" /f > nul
:: - > Disable Defender reboot notifications
%sudo% Reg add "HKLM\Software\Policies\Microsoft\Windows Defender\UX Configuration" /v "SuppressRebootNotification" /t REG_DWORD /d "1" /f > nul
:: - > Remove "Windows Security" system tray icon
%sudo% Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Systray" /v "HideSystray" /t REG_DWORD /d "1" /f > nul
:: Disable "ExploitGuard MDM policy Refresh" task
PowerShell -ExecutionPolicy Unrestricted -Command "$taskPathPattern='\Microsoft\Windows\ExploitGuard\'; $taskNamePattern='ExploitGuard MDM policy Refresh'; Write-Output "^""Disabling tasks matching pattern `"^""$taskNamePattern`"^""."^""; $tasks = @(Get-ScheduledTask -TaskPath $taskPathPattern -TaskName $taskNamePattern -ErrorAction Ignore); if (-Not $tasks) {; Write-Output "^""Skipping, no tasks matching pattern `"^""$taskNamePattern`"^"" found, no action needed."^""; exit 0; }; $operationFailed = $false; foreach ($task in $tasks) {; $taskName = $task.TaskName; if ($task.State -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.ScheduledTask.StateEnum]::Disabled) {; Write-Output "^""Skipping, task `"^""$taskName`"^"" is already disabled, no action needed."^""; continue; }; try {; $task | Disable-ScheduledTask -ErrorAction Stop | Out-Null; Write-Output "^""Successfully disabled task `"^""$taskName`"^""."^""; } catch {; Write-Error "^""Failed to disable task `"^""$taskName`"^"": $($_.Exception.Message)"^""; $operationFailed = $true; }; }; if ($operationFailed) {; Write-Output 'Failed to disable some tasks. Check error messages above.'; exit 1; }" > nul
:: Disable scheduled task(s): `\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance`
PowerShell -ExecutionPolicy Unrestricted -Command "$taskPathPattern='\Microsoft\Windows\Windows Defender\'; $taskNamePattern='Windows Defender Cache Maintenance'; Write-Output "^""Disabling tasks matching pattern `"^""$taskNamePattern`"^""."^""; $tasks = @(Get-ScheduledTask -TaskPath $taskPathPattern -TaskName $taskNamePattern -ErrorAction Ignore); if (-Not $tasks) {; Write-Output "^""Skipping, no tasks matching pattern `"^""$taskNamePattern`"^"" found, no action needed."^""; exit 0; }; $operationFailed = $false; foreach ($task in $tasks) {; $taskName = $task.TaskName; if ($task.State -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.ScheduledTask.StateEnum]::Disabled) {; Write-Output "^""Skipping, task `"^""$taskName`"^"" is already disabled, no action needed."^""; continue; }; try {; $task | Disable-ScheduledTask -ErrorAction Stop | Out-Null; Write-Output "^""Successfully disabled task `"^""$taskName`"^""."^""; } catch {; Write-Error "^""Failed to disable task `"^""$taskName`"^"": $($_.Exception.Message)"^""; $operationFailed = $true; }; }; if ($operationFailed) {; Write-Output 'Failed to disable some tasks. Check error messages above.'; exit 1; }" > nul
:: Disable scheduled task(s): `\Microsoft\Windows\Windows Defender\Windows Defender Cleanup`
PowerShell -ExecutionPolicy Unrestricted -Command "$taskPathPattern='\Microsoft\Windows\Windows Defender\'; $taskNamePattern='Windows Defender Cleanup'; Write-Output "^""Disabling tasks matching pattern `"^""$taskNamePattern`"^""."^""; $tasks = @(Get-ScheduledTask -TaskPath $taskPathPattern -TaskName $taskNamePattern -ErrorAction Ignore); if (-Not $tasks) {; Write-Output "^""Skipping, no tasks matching pattern `"^""$taskNamePattern`"^"" found, no action needed."^""; exit 0; }; $operationFailed = $false; foreach ($task in $tasks) {; $taskName = $task.TaskName; if ($task.State -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.ScheduledTask.StateEnum]::Disabled) {; Write-Output "^""Skipping, task `"^""$taskName`"^"" is already disabled, no action needed."^""; continue; }; try {; $task | Disable-ScheduledTask -ErrorAction Stop | Out-Null; Write-Output "^""Successfully disabled task `"^""$taskName`"^""."^""; } catch {; Write-Error "^""Failed to disable task `"^""$taskName`"^"": $($_.Exception.Message)"^""; $operationFailed = $true; }; }; if ($operationFailed) {; Write-Output 'Failed to disable some tasks. Check error messages above.'; exit 1; }" > nul
:: Disable scheduled task(s): `\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan`
PowerShell -ExecutionPolicy Unrestricted -Command "$taskPathPattern='\Microsoft\Windows\Windows Defender\'; $taskNamePattern='Windows Defender Scheduled Scan'; Write-Output "^""Disabling tasks matching pattern `"^""$taskNamePattern`"^""."^""; $tasks = @(Get-ScheduledTask -TaskPath $taskPathPattern -TaskName $taskNamePattern -ErrorAction Ignore); if (-Not $tasks) {; Write-Output "^""Skipping, no tasks matching pattern `"^""$taskNamePattern`"^"" found, no action needed."^""; exit 0; }; $operationFailed = $false; foreach ($task in $tasks) {; $taskName = $task.TaskName; if ($task.State -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.ScheduledTask.StateEnum]::Disabled) {; Write-Output "^""Skipping, task `"^""$taskName`"^"" is already disabled, no action needed."^""; continue; }; try {; $task | Disable-ScheduledTask -ErrorAction Stop | Out-Null; Write-Output "^""Successfully disabled task `"^""$taskName`"^""."^""; } catch {; Write-Error "^""Failed to disable task `"^""$taskName`"^"": $($_.Exception.Message)"^""; $operationFailed = $true; }; }; if ($operationFailed) {; Write-Output 'Failed to disable some tasks. Check error messages above.'; exit 1; }" > nul
:: Disable scheduled task(s): `\Microsoft\Windows\Windows Defender\Windows Defender Verification`
PowerShell -ExecutionPolicy Unrestricted -Command "$taskPathPattern='\Microsoft\Windows\Windows Defender\'; $taskNamePattern='Windows Defender Verification'; Write-Output "^""Disabling tasks matching pattern `"^""$taskNamePattern`"^""."^""; $tasks = @(Get-ScheduledTask -TaskPath $taskPathPattern -TaskName $taskNamePattern -ErrorAction Ignore); if (-Not $tasks) {; Write-Output "^""Skipping, no tasks matching pattern `"^""$taskNamePattern`"^"" found, no action needed."^""; exit 0; }; $operationFailed = $false; foreach ($task in $tasks) {; $taskName = $task.TaskName; if ($task.State -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.ScheduledTask.StateEnum]::Disabled) {; Write-Output "^""Skipping, task `"^""$taskName`"^"" is already disabled, no action needed."^""; continue; }; try {; $task | Disable-ScheduledTask -ErrorAction Stop | Out-Null; Write-Output "^""Successfully disabled task `"^""$taskName`"^""."^""; } catch {; Write-Error "^""Failed to disable task `"^""$taskName`"^"": $($_.Exception.Message)"^""; $operationFailed = $true; }; }; if ($operationFailed) {; Write-Output 'Failed to disable some tasks. Check error messages above.'; exit 1; }" > nul

:: RunOnce Phase 2
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "Neptune" /t REG_SZ /d "C:\NeptuneOS-installer-dev\Neptune\Scripts\phase2.bat" /f > nul

:: Finalize
cls & echo Restarting...
timeout /t 1 > nul
shutdown /f /r /t 0
"C:\NeptuneOS-installer-dev\Neptune\nsudo.exe"




:DisableAutoDriver
cls
echo.
echo ===========================
echo    Disabling Automatic Driver Installation...
echo ===========================
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Update" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f > nul
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f > nul
Reg.exe add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f > nul
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f > nul
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate" /v "value" /t REG_DWORD /d "1" /f > nul 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f > nul
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "0" /f > nul
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v "DontSearchWindowsUpdate" /t REG_DWORD /d "1" /f  > nul
cls & echo Done
timeout /t 1 >nul
goto menu
