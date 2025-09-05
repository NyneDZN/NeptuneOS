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