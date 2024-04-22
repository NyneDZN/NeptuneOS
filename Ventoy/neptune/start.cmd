:: Ventoy Config for NeptuneOS by Nyne
:: Inspiration from ReviOS

@echo off

::
::  ▐ ▄ ▄▄▄ . ▄▄▄·▄▄▄▄▄▄• ▄▌ ▐ ▄ ▄▄▄ .     ▌ ▐·▄▄▄ . ▐ ▄ ▄▄▄▄▄       ▄· ▄▌
:: •█▌▐█▀▄.▀·▐█ ▄█•██  █▪██▌•█▌▐█▀▄.▀·    ▪█·█▌▀▄.▀·•█▌▐█•██  ▪     ▐█▪██▌
:: ▐█▐▐▌▐▀▀▪▄ ██▀· ▐█.▪█▌▐█▌▐█▐▐▌▐▀▀▪▄    ▐█▐█•▐▀▀▪▄▐█▐▐▌ ▐█.▪ ▄█▀▄ ▐█▌▐█▪
:: ██▐█▌▐█▄▄▌▐█▪·• ▐█▌·▐█▄█▌██▐█▌▐█▄▄▌     ███ ▐█▄▄▌██▐█▌ ▐█▌·▐█▌.▐▌ ▐█▀·.
:: ▀▀ █▪ ▀▀▀ .▀    ▀▀▀  ▀▀▀ ▀▀ █▪ ▀▀▀     . ▀   ▀▀▀ ▀▀ █▪ ▀▀▀  ▀█▄▀▪  ▀ • 
:: 

:: Disable auto install of Teams, Outlook and DevHome
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler\DevHomeUpdate" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler\OutlookUpdate" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v "ConfigureChatAutoInstall" /t REG_DWORD /d "0" /f >nul

:: Disable automatic device encryption
:: https://learn.microsoft.com/en-us/windows/security/information-protection/bitlocker/bitlocker-device-encryption-overview-windows-10#bitlocker-device-encryption
Reg add "HKLM\SYSTEM\ControlSet001\Control\BitLocker" /v "PreventDeviceEncryption" /t REG_DWORD /d "1" /f

:: Disable automatic driver updates
Reg add "HKCU\Software\Policies\Microsoft\Windows\DriverSearching" /v "DontPromptForWindowsUpdate" /t REG_DWORD /d "1" /f
Reg add "HKLM\Software\Policies\Microsoft\Windows\DriverSearching" /v "DontPromptForWindowsUpdate" /t REG_DWORD /d "1" /f
Reg add "HKLM\Software\Policies\Microsoft\Windows\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d 0 /f
Reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f
Reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f

:: Disable automatic updates
:: Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUServer" /t REG_SZ /d "0.0.0.0" /f
:: Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUStatusServer" /t REG_SZ /d "0.0.0.0" /f
:: Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "UpdateServiceUrlAlternate" /t REG_SZ /d "0.0.0.0" /f
:: Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "SetProxyBehaviorForUpdateDetection" /t REG_DWORD /d "0" /f
:: Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "SetDisableUXWUAccess" /t REG_DWORD /d "1" /f
:: Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DoNotConnectToWindowsUpdateInternetLocations" /t REG_DWORD /d "1" /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f
:: Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "UseWUServer" /t REG_DWORD /d "1" /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t "REG_DWORD" /d "2" /f
:: Reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "HideMCTLink" /t REG_DWORD /d "1" /f
:: Reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "IsExpedited" /t REG_DWORD /d "0" /f
:: Reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "RestartNotificationsAllowed2" /t REG_DWORD /d "0" /f
:: Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "0" /f
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "OptInOOBE" /t REG_DWORD /d "0" /f
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /v "AutoDownload" /t REG_DWORD /d "2" /f 

:: Disable MRT updates
Reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f

:: Disable Data Collection
Reg add "HKLM\SYSTEM\ControlSet001\Services\DiagTrack" /v "Start" /t REG_DWORD /d "4" /f
Reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f

:: Disable BitLocker
Reg add "HKLM\SYSTEM\ControlSet001\Control\BitLocker" /v "PreventDeviceEncryption" /t REG_DWORD /d "1" /f

:: Disable first logon animation
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "EnableFirstLogonAnimation" /t REG_DWORD /d "0" /f

:: Disable Defender Drivers
:: Reg add "HKLM\System\ControlSet001\Services\MsSecCore" /v "Start" /t Reg_DWORD /d "4" /f
:: Reg add "HKLM\System\ControlSet001\Services\SecurityHealthService" /v "Start" /t Reg_DWORD /d "4" /f
:: Reg add "HKLM\System\ControlSet001\Services\Sense" /v "Start" /t Reg_DWORD /d "4" /f
:: Reg add "HKLM\System\ControlSet001\Services\WdBoot" /v "Start" /t Reg_DWORD /d "4" /f
:: Reg add "HKLM\System\ControlSet001\Services\WdFilter" /v "Start" /t Reg_DWORD /d "4" /f
:: Reg add "HKLM\System\ControlSet001\Services\WdNisDrv" /v "Start" /t Reg_DWORD /d "4" /f
:: Reg add "HKLM\System\ControlSet001\Services\WdNisSvc" /v "Start" /t Reg_DWORD /d "4" /f
:: Reg add "HKLM\System\ControlSet001\Services\WinDefend" /v "Start" /t Reg_DWORD /d "4" /f
:: Reg add "HKLM\System\ControlSet001\Services\webthreatdefsvc" /v "Start" /t Reg_DWORD /d "4" /f
:: Reg add "HKLM\System\ControlSet001\Services\webthreatdefusersvc" /v "Start" /t Reg_DWORD /d "4" /f

:: Remove OneDrive Setup
if exist "C:\" (del /f "%SYSTEMROOT%\System32\OneDriveSetup.exe") else (del /f "C:\Windows\SysWOW64\OneDriveSetup.exe")

:: Exit
exit