:: Updated NeptuneOS Master Script created by Nyne on 8/4/2023 for NeptuneOS 2.0

:: Credit (in no order)
:: Atlas
:: CoutX
:: XOS (imribiy)


@echo off
setlocal EnableDelayedExpansion
set version=2.0
title NeptuneOS %version% Master Script
mode 120,40

:: set correct username variable of the currently logged in user
for /f "tokens=3 delims==\" %%a in ('wmic computersystem get username /value ^| find "="') do set "loggedinUsername=%%a"

:: script variables, do not touch
set "CMDLINE=RED=[31m,S_GRAY=[90m,S_RED=[91m,S_GREEN=[92m,S_YELLOW=[93m,S_MAGENTA=[95m,S_WHITE=[97m,B_BLACK=[40m,B_YELLOW=[43m,UNDERLINE=[4m,_UNDERLINE=[24m"
set "%CMDLINE:,=" & set "%"
set "PowerShell=%WinDir%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command"
set currentuser=%WinDir%\NeptuneDir\Tools\NSudoLG.exe -U:C -P:E -ShowWindowMode:Hide -Wait
set system=%WinDir%\NeptuneDir\Tools\NSudoLG.exe -U:T -P:E -ShowWindowMode:Hide -Wait
set DevMan="%WinDir%\NeptuneDir\Tools\dmv.exe"
set svc=call :setSvc

:: append any new labels/scripts here (with a comment)
:: anything in "" is a comment
:: it has to be the same as the batch labels here!

for %%a in (

"Post install script"
startup

"Test prompt"
test


) do (
    if "%~1"=="/%%a" (
        goto %%a
    )
)

:: if the first argument does not match any known scripts, fail
goto argumentFAIL

:argumentFAIL
echo The script had no arguements or invalid arguments passed to it.
echo Either you are launching atlas-config directly or the "%~nx0" script is broken.
pause & exit /b 1

:test
set /p c="Test with echo on?"
if %c% equ Y echo on
set /p argPrompt="Which script would you like to test? E.g. (:testScript)"
goto %argPrompt%
echo You should not reach this message!
pause & exit /b 1


:Art
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
goto :eof



:startup
call :Art
echo !S_GREEN!Installing Visual C++...
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

echo !S_GREEN!Installing DirectX...
"%WinDir%\NeptuneDir\Prerequisites\DirectX\DXSETUP.exe" /silent >nul 2>&1

echo !S_GREEN!Installing 7-Zip...
"%WinDir%\NeptuneDir\Prerequisites\7z.exe" /S  >nul 2>&1

echo !S_GREEN!Installing Timer Resolution Service...
"%WinDir%\NeptuneDir\Tools\TimerResolution.exe" -install >nul 2>&1

echo !S_GREEN!Installing Open Shell...
"%WinDir%\NeptuneDir\Prerequisites\openshell.exe" /qn ADDLOCAL=StartMenu >nul 2>&1

echo !S_GREEN!Importing Registry Profile...
Regedit.exe import "%WinDir%\NeptuneDir\neptune.reg" >nul 2>&1
%WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 %WinDir%\Regedit.exe import "%WinDir%\NeptuneDir\neptune.reg" >nul 2>&1


:: -- Registry Configuration -- ::
echo !S_GREEN!Configuring Registry...

:: BSOD Quality of Life
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "LogEvent" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl\StorageTelemetry" /v "DeviceDumpEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable tracing
Reg add "HKLM\SOFTWARE\Microsoft\Tracing" /v "EnableConsoleTracing" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Tracing" /v "EnableFileTracing" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Tracing" /v "EnableAutoFileTracing" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable CEIP
Reg add "HKLM\SOFTWARE\Policies\Microsoft\AppV\CEIP" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\VSCommon\15.0\SQM" /v "OptIn" /t REG_DWORD /d "0" /f >nul 2>&1

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
    %currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "%%~a" /t REG_DWORD /d "0" /f >nul 2>&1
)

:: Disable tips in immersive control panel
Reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowOnlineTips" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllowOnlineTips" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable program compatibility assistant
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableEngine" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d "1" /f >nul 2>&1

:: Clear Firewall Rules
Reg delete "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /f >nul 2>&1

:: Clear image file execution options
Reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" /f >nul 2>&1

:: Disable devicecensus.exe telemetry process
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\DeviceCensus.exe" /v "Debugger" /t REG_SZ /d "%WinDir%\System32\taskkill.exe" /f >nul 2>&1

:: Disable microsoft compatibility appraiser telemetry process
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\CompatTelRunner.exe" /v "Debugger" /t REG_SZ /d "%WinDir%\System32\taskkill.exe" /f >nul 2>&1

:: Disable speech model updates
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable sxs backups
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\SideBySide\Configuration" /v "DisableComponentBackups" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable online speech recognition 
Reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "AllowInputPersonalization" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable windows insider and build previews
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableConfigFlighting" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableExperimentation" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility" /v "HideInsiderPage" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable activity feed
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable windows spotlight features
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightFeatures" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable tips in immersive control panel
Reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowOnlineTips" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllowOnlineTips" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable suggest ways I can finish setting up my device
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable disk quota
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DiskQuota" /v "Enable" /t REG_DWORD /d "0" /f >nul 2>&1

:: Never use tablet mode
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "SignInMode" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable 'Open file' - security warning message
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1806" /t REG_DWORD /d "0" /f >nul 2>&1

:: Do not preserve zone information in file attachments
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable ink workspace
Reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" /v "AllowWindowsInkWorkspace" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable text/ink/handwriting telemetry
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable data collection
Reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowDeviceNameInTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disabling Remote Font Boot Cache
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\GRE_Initialize" /v "DisableRemoteFontBootCache" /t REG_DWORD /d "1" /f >nul 2>&1 
Reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\GRE_Initialize" /v "DisableRemoteFontBootCache" /t REG_DWORD /d "1" /f >nul 2>&1 
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\MUI\StringCacheSettings" /v "StringCacheGeneration" /t REG_DWORD /d "0" /f >nul 2>&1 

:: Disable recommended troubleshooting
Reg add "HKLM\SOFTWARE\Microsoft\WindowsMitigation" /v "UserPreference" /t REG_DWORD /d "2" /f >nul 2>&1

:: Configure app permissions/privacy
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1

:: Disable smartscreen
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "PreventOverride" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "ShellSmartScreenLevel" /f >nul 2>&1

:: Disable experimentation
Reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\System\AllowExperimentation" /v "Value" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable performance tracking
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}" /v "ScenarioExecutionEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Diagnostics\Performance" /v "DisableDiagnosticTracing" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable shared experiences
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v "CdpSessionUserAuthzPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v "RomeSdkChannelUserAuthzPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP\SettingsPage" /v "RomeSdkChannelUserAuthzPolicy" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable settings sync
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSyncOnPaidNetwork" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t REG_DWORD /d "5" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\AppSync" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\DesktopTheme" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\PackageState" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\StartLayout" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable windows feedback
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f >nul 2>&1 
%currentuser% Reg delete "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /f >nul 2>&1 >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f >nul 2>&1 
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable notifications and notification center
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable all lockscreen notifications
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "LockScreenToastEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable maintenance
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable background apps
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d "2" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable unnecessary autologgers
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

:: Disable license telemetry
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable suggest ways I can finish setting up my device
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable automatically restart apps after sign in
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "RestartApps" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable fast user switching
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "HideFastUserSwitching" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable windows error reporting
Reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d "1" /f >nul 2>&1 
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f >nul 2>&1 
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultConsent" /t REG_DWORD /d "0" /f >nul 2>&1 
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultOverrideBehavior" /t REG_DWORD /d "1" /f >nul 2>&1 

:: Reduce the shutdown timer
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f >nul 2>&1 
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "8" /f >nul 2>&1 
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "0" /f >nul 2>&1 
Reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "1000" /f >nul 2>&1

:: Disable mouse acceleration
%currentuser% Reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "0" /f >nul 2>&1

:: Disable annoying keyboard features
%currentuser% Reg add "HKCU\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Keyboard" /v "KeyboardDelay" /t REG_SZ /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Keyboard" /v "KeyboardSpeed" /t REG_SZ /d "31" /f >nul 2>&1

:: Disable ease of access settings 
%currentuser% Reg add "HKCU\Control Panel\Accessibility\AudioDescription" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Accessibility\Blind Access" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Accessibility\HighContrast" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Accessibility\Keyboard Preference" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Accessibility\MouseKeys" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Accessibility\On" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Accessibility\ShowSounds" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Accessibility\SlateLaunch" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Accessibility\SoundSentry" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Accessibility\TimeOut" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable text/ink/handwriting telemetry
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable spell checking
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableSpellchecking" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableTextPrediction" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnablePredictionSpaceInsertion" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableDoubleTapSpace" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableAutocorrection" /t REG_DWORD /d "0" /f >nul 2>&1

:: Don't autohide scrollbar in UWP apps 
%currentuser% Reg add "HKCU\Control Panel\Accessibility" /v "DynamicScrollbars" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable dcom 
Reg add "HKLM\SOFTWARE\Microsoft\Ole" /v "EnableDCOM" /t REG_SZ /d "N" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Ole" /v "EnableDCOM" /t REG_SZ /d "N" /f >nul 2>&1

:: Disable ole
Reg add "HKLM\SOFTWARE\Microsoft\Ole" /v "ActivationFailureLoggingLevel" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Ole" /v "CallFailureLoggingLevel" /t REG_DWORD /d "2" /f >nul 2>&1

:: Enable Dark Mode
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Transparency
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Wide Context Menu
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\FlightedFeatures" /v "ImmersiveContextMenu" /t REG_DWORD /d "0" /f >nul 2>&1

:: Configure visual effect settings
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9012038010000000" /f >nul 2>&1

:: Disable animations via dwm
Reg add "HKLM\Software\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowFlip3d" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DWMWA_TRANSITIONS_FORCEDISABLED" /t REG_DWORD /d "1" /f >nul 2>&1 

:: Disable thumbnails
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d "0" /f >nul 2>&1

:: Enable window colorization
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableWindowColorization" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable aero peek
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable startup delay of running apps
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shutdown\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable the 'welcome' screen on logon, makes logging in faster
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DelayedDesktopSwitchTimeout" /t REG_DWORD /d "0" /f >nul 2>&1

:: Hide meet now button on taskbar
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f >nul 2>&1

:: Hide the teams icon on 22H2
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Chat" /v "ChatIcon" /t REG_DWORD /d "3" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v "ConfigureChatAutoInstall" /t REG_DWORD /d "0" /f >nul 2>&1

:: Hide people bar
%currentuser% Reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "HidePeopleBar" /t REG_DWORD /d "1" /f >nul 2>&1

:: Hide task view button on taskbar
%currentuser% Reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MultiTaskingView\AllUpView" /v "Enabled" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /D "0" /f >nul 2>&1

:: Disable autoplay and autorun
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v "DisableAutoplay" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d "255" /f >nul 2>&1 
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoAutoplayfornonVolume" /t REG_DWORD /d "1" /f >nul 2>&1

:: Show removable drives only in 'This PC' on the file explorer sidebar
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f >nul 2>&1

:: Disable network navigation pane in file explorer
Reg add "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2962489444" /f >nul 2>&1

:: Remove '- Shortcut' text added onto shortcuts
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d "00000000" /f >nul 2>&1

:: Disable desktop wallpaper import quality reduction
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d "100" /f >nul 2>&1

:: Set Wallpaper
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "Wallpaper" /t REG_SZ /d "C:\Windows\Web\Wallpaper\Windows\neptune.png" /f >nul 2>&1

:: Disable show window contents while dragging
%currentuser% Reg add "HKCU\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "0" /f >nul 2>&1

:: Do not allow themes to changes desktop iocns and mouse pointers
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes" /v "ThemeChangesMousePointers" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes" /v "ThemeChangesDesktopIcons" /t REG_DWORD /d "0" /f >nul 2>&1

:: Enable old alt tab
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "AltTabSettings" /t REG_DWORD /d "1" /f >nul 2>&1

:: Enable always show all icons and notifications on the taskbar
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d "0" /f >nul 2>&1

:: Hide frequently used files/folders in quick access
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d "0" /f >nul 2>&1

:: Hide recently used files/folders in quick access
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d "0" /f >nul 2>&1

:: Hide search from taskbar
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f >nul 2>&1

:: Hide recycle bin from desktop
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable dekstop peek
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisablePreviewDesktop" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable aero shake
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d "1" /f >nul 2>&1

:: Show command prompt on win+x menu
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DontUsePowerShellOnWinX" /t REG_DWORD /d "1" /f >nul 2>&1

:: Show file extensions in file explorer
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f >nul 2>&1

:: Open to this pc in file explorer
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable show translucent selection rectangle on desktop
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d "0" /f >nul 2>&1

:: Set alt tab to open windows only
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "MultiTaskingAltTabFilter" /t REG_DWORD /d "3" /f >nul 2>&1

:: Disable sharing wizard
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SharingWizardOn" /t REG_DWORD /d "0" /f >nul 2>&1

:: Configure snap settings
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "JointResize" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapAssist" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapFill" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable recent items and frequent places in file explorer
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable status bar
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowStatusBar" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable tooltips
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowInfoTip" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable sharing wizard
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SharingWizardOn" /t REG_DWORD /d "0" /f >nul 2>&1

:: Don't use OLED transparency
%currentuser% Reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseOLEDTaskbarTransparency" /f >nul 2>&1

:: Only show hidden files, don't show system files
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable app launch tracking
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable taskbar animations
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f >nul 2>&1

:: Hide badges on taskbar
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarBadges" /t REG_DWORD /d "0" /f >nul 2>&1

:: Show more details in file transfer dialog
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" /v "EnthusiastMode" /t REG_DWORD /d "1" /f >nul 2>&1

:: Clear history of recently opened documents on exit
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ClearRecentDocsOnExit" /t REG_DWORD /d "1" /f >nul 2>&1

:: Do not track shell shortcuts during roaming
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "LinkResolveIgnoreLinkInfo" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable user tracking
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInstrumentation" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable internet file association service
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetOpenWith" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable low disk space warning
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoLowDiskSpaceChecks" /t REG_DWORD /d "1" /f >nul 2>&1

:: Do not history of recently opened documents
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f >nul 2>&1

:: Do not use the search-based method when resolving shell shortcuts
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveSearch" /t REG_DWORD /d "1" /f >nul 2>&1

:: Do not use the tracking-based method when resolving shell shortcuts
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveTrack" /t REG_DWORD /d "1" /f >nul 2>&1

:: Do not allow pinning microsoft store app to taskbar
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoPinningStoreToTaskbar" /t REG_DWORD /d "1" /f >nul 2>&1

:: Do not display or track items in jump lists from remote locations
%currentuser% Reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoRemoteDestinations" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable automatic folder type discovery
%currentuser% Reg delete "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v "FolderType" /t REG_SZ /d "NotSpecified" /f >nul 2>&1

:: Set color scheme to 'gray'
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentColorMenu" /t REG_DWORD /d "4290756543" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "StartColorMenu" /t REG_DWORD /d "4289901234" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentPalette" /t REG_BINARY /d "9b9a9900848381006d6b6a004c4a4800363533002625240019191900107c1000" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\DWM" /v "ColorizationColor" /t REG_DWORD /d "3293334088" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\DWM" /v "ColorizationAfterglow" /t REG_DWORD /d "3293334088" /f >nul 2>&1

:: Search configuration
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "AutoWildCard" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "EnableNaturalQuerySyntax" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "WholeFileSystem" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "SystemFolders" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "ArchivedFiles" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "SearchOnly" /t REG_DWORD /d "1" /f >nul 2>&1

:: Show the full path in explorer
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v "Settings" /t REG_BINARY /d "0c0002000b01000060000000" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v "FullPath" /t REG_DWORD /d "1" /f >nul 2>&1

:: Show encrypted NTFS files in color
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowEncryptCompressedColor" /t REG_DWORD /d "1" /f >nul 2>&1

:: Enable verbose status
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "VerboseStatus" /t REG_DWORD /d "1" /f >nul 2>&1

:: Allow take ownership for more than 15+ files
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "MultipleInvokePromptMinimum" /t REG_DWORD /d "200" /f >nul 2>&1

:: Hide control panel applets
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisallowCPL" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Color Management" /t REG_SZ /d "Color Management" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Credential Manager" /t REG_SZ /d "Credential Manager" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Default Programs" /t REG_SZ /d "Default Programs" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Fonts" /t REG_SZ /d "Fonts" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Indexing Options" /t REG_SZ /d "Indexing Options" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Language" /t REG_SZ /d "Language" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Phone and Modem" /t REG_SZ /d "Phone and Modem" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Recovery" /t REG_SZ /d "Recovery" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Security and Maintenance" /t REG_SZ /d "Security and Maintenance" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Taskbar and Navigation" /t REG_SZ /d "Taskbar and Navigation" /f >nul 2>&1
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL" /v "Troubleshooting" /t REG_SZ /d "Troubleshooting" /f >nul 2>&1

:: Increase icon cache (51.2mb)
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "Max Cached Icons" /t REG_SZ /d "51200" /f >nul 2>&1

:: Show drive letters before drive name in file explorer
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowDriveLettersFirst" /t REG_DWORD /d "4" /f >nul 2>&1

:: Disable new app alert
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoNewAppAlert" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable desktop.ini file creation
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "UseDesktopIniCache" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable quick access
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "HubMode" /t REG_DWORD /d "1" /f >nul 2>&1

:: Attempt to fix icons misbehaving when switching out of fullscreen with 2 different resolution monitors
%currentuser% Reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "IconSpacing" /t REG_SZ /d "-1125" /f >nul 2>&1
%currentuser% Reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "IconVerticalSpacing" /t REG_SZ /d "-1125" /f >nul 2>&1

:: Disable thumbnail cache
%currentuser% Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisableThumbnailCache" /t REG_DWORD /d "1" /f >nul 2>&1

:: Never use tablet shell mode
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "SignInMode" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAppsVisibleInTabletMode" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "AppIconInTouchImprovement" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SearchBoxVisibleInTouchImprovement" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "FileExplorerInTouchImprovement" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable DWM Composition
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "Composition" /t REG_DWORD /d "0" /f >nul 2>&1 
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowComposition" /t REG_DWORD /d "1" /f >nul 2>&1

:: Enable the Legacy Photo Viewer
for %%i in (tif tiff bmp dib gif jfif jpe jpeg jpg jxr png) do (
    Reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".%%~i" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul 2>&1
)
:: Set Legacy Photo Viewer as Default
for %%i in (tif tiff bmp dib gif jfif jpe jpeg jpg jxr png) do (
    %currentuser% Reg add "HKCU\SOFTWARE\Classes\.%%~i" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul 2>&1
    %currentuser% Reg add "HKCU\SOFTWARE\Classes\.wdp" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f >nul 2>&1
)


:: Remove restore previous versions from context menu and file properties
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

:: Remove give access to from context menu
Reg delete "HKCR\*\shellex\ContextMenuHandlers\Sharing" /f >nul 2>&1 
Reg delete "HKCR\Directory\Background\shellex\ContextMenuHandlers\Sharing" /f >nul 2>&1 
Reg delete "HKCR\Directory\shellex\ContextMenuHandlers\Sharing" /f >nul 2>&1 
Reg delete "HKCR\Drive\shellex\ContextMenuHandlers\Sharing" /f >nul 2>&1 
Reg delete "HKCR\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing" /f >nul 2>&1 
Reg delete "HKCR\UserLibraryFolder\shellex\ContextMenuHandlers\Sharing" /f >nul 2>&1 

:: Remove cast to device from context menu
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" /t REG_SZ /d "" /f >nul 2>&1

:: Remove share in context menu
Reg delete "HKCR\*\shellex\ContextMenuHandlers\ModernSharing" /f >nul 2>&1 

:: Remove bitmap image from the 'New' context menu
Reg delete "HKCR\.bmp\ShellNew" /f >nul 2>&1 

:: Remove include in library context menu
Reg delete "HKCR\Folder\ShellEx\ContextMenuHandlers\Library Location" /f >nul 2>&1 
Reg delete "HKLM\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location" /f >nul 2>&1 

:: Remove troubleshooting compatibility from context menu
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{1d27f844-3a1f-4410-85ac-14651078412d}" /t REG_SZ /d "" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{1d27f844-3a1f-4410-85ac-14651078412d}" /t REG_SZ /d "" /f >nul 2>&1

:: Remove 'send to' context menu
Reg delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" /f >nul 2>&1
Reg delete "HKCR\UserLibraryFolder\shellex\ContextMenuHandlers\SendTo" /f >nul 2>&1

:: Remove print from context menu
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

:: Restore full context menu
Reg add "HKLM\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /ve /t REG_SZ /d "File Explorer Context Menu" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InProcServer32" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InProcServer32" /ve /t REG_SZ /d "" /f >nul 2>&1

:: Add .bat, .cmd, .reg and .ps1 to the 'New' context menu
Reg add "HKLM\SOFTWARE\Classes\.bat\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\System32\acppage.dll,-6002" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Classes\.bat\ShellNew" /v "NullFile" /t REG_SZ /d "" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Classes\.cmd\ShellNew" /v "NullFile" /t REG_SZ /d "" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Classes\.cmd\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\System32\acppage.dll,-6003" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Classes\.ps1\ShellNew" /v "NullFile" /t REG_SZ /d "" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Classes\.ps1\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "New file" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Classes\.reg\ShellNew" /v "NullFile" /t REG_SZ /d "" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Classes\.reg\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\regedit.exe,-309" /f >nul 2>&1

:: Add install cab to context menu
Reg delete "HKCR\CABFolder\Shell\RunAs" /f >nul 2>&1 >nul 2>&1
Reg add "HKCR\CABFolder\Shell\RunAs" /ve /t REG_SZ /d "Install" /f >nul 2>&1
Reg add "HKCR\CABFolder\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "" /f >nul 2>&1
Reg add "HKCR\CABFolder\Shell\RunAs\Command" /ve /t REG_SZ /d "cmd /k DISM /online /add-package /packagepath:\"%1\"" /f >nul 2>&1

:: Add 'send to' to context menu
Reg add "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\Copy To" /ve /t REG_SZ /d "{C2FBB630-2971-11D1-A18C-00C04FD75D13}" /f >nul 2>&1

:: Add 'move to' to context menu
Reg add "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\Move To" /ve /t REG_SZ /d "{C2FBB631-2971-11D1-A18C-00C04FD75D13}" /f >nul 2>&1

:: Add 'take ownership' to context menu
Reg add "HKCR\*\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f >nul 2>&1
Reg add "HKCR\*\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul 2>&1
Reg add "HKCR\*\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul 2>&1
Reg add "HKCR\*\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul 2>&1
Reg add "HKCR\Directory\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f >nul 2>&1
Reg add "HKCR\Directory\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul 2>&1
Reg add "HKCR\Directory\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f >nul 2>&1
Reg add "HKCR\Directory\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f >nul 2>&1

:: Merge as trusted installer for registry files
Reg add "HKCR\regfile\Shell\RunAs" /ve /t REG_SZ /d "Merge As TrustedInstaller" /f >nul 2>&1
Reg add "HKCR\regfile\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "1" /f >nul 2>&1
Reg add "HKCR\regfile\Shell\RunAs\Command" /ve /t REG_SZ /d "%WinDir%\NeptuneDir\Tools\NSudoLG.exe -U:T -P:E Reg import "%1"" /f >nul 2>&1

:: Double click to import power schemes
Reg add "HKLM\SOFTWARE\Classes\powerplan\DefaultIcon" /ve /t REG_SZ /d "C:\Windows\System32\powercpl.dll,1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Classes\powerplan\Shell\open\command" /ve /t REG_SZ /d "powercfg /import \"%1\"" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Classes\.pow" /ve /t REG_SZ /d "powerplan" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Classes\.pow" /v "FriendlyTypeName" /t REG_SZ /d "Power Plan" /f >nul 2>&1

:: Set Win32PrioritySeparation to short variable 1:1, no foreground boost
:: https://forums.blurbusters.com/viewtopic.php?t=8535
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "36" /f /f >nul 2>&1

:: Disable Exclusive Mode on Devices
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do %WinDir%\NeptuneDir\Tools\%system% /SW:0 Reg add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d 0 /f >nul 2>&1
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do %WinDir%\NeptuneDir\Tools\%system% /SW:0 Reg add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d 0 /f >nul 2>&1
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do %WinDir%\NeptuneDir\Tools\%system% /SW:0 Reg add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d 0 /f >nul 2>&1
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do %WinDir%\NeptuneDir\Tools\%system% /SW:0 Reg add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d 0 /f >nul 2>&1

:: Fix Volume Mixer
%currentuser% Reg add "HKCU\Software\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore" /f >nul 2>&1 

:: Don't Show Disconnected/Disabled Devices
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowDisconnectedDevices" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowHiddenDevices" /t REG_DWORD /d "0" /f >nul 2>&1

:: Set Audio Scheme to None
%currentuser% %PowerShell% "New-ItemProperty -Path 'HKCU:\AppEvents\Schemes' -Name '(Default)' -Value '.None' -Force | Out-Null" >nul 2>&1
%currentuser% %PowerShell% "Get-ChildItem -Path 'HKCU:\AppEvents\Schemes\Apps' | Get-ChildItem | Get-ChildItem | Where-Object {$_.PSChildName -eq '.Current'} | Set-ItemProperty -Name '(Default)' -Value ''" >nul 2>&1

:: Don't Reduce Sounds While In A Call
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d "3" /f >nul 2>&1

:: Force Contiguous DirectX Memory Allocation
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable V-SYNC Control (?)
:: https://learn.microsoft.com/en-us/windows-hardware/drivers/display/saving-energy-with-vsync-control
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "VsyncIdleTimeout" /t REG_DWORD /d "0" /f >nul 2>&1 

:: Disable GPU Debugging/Preemption
:: https://learn.microsoft.com/en-us/windows-hardware/drivers/display/changing-the-behavior-of-the-gpu-scheduler-for-debugging
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable game mode
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Set global fullscreen exclusive 
%currentuser% Reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f >nul 2>&1
%currentuser% Reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f >nul 2>&1
%currentuser% Reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f >nul 2>&1
%currentuser% Reg add "HKCU\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\System\GameConfigStore" /v "GameDVR_DSEBehavior" /t REG_DWORD /d "2" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "__COMPAT_LAYER" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" /f >nul 2>&1

:: Configure gamebar
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "GamePanelStartupTipIndex" /t REG_DWORD /d "3" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d "0" /f >nul 2>&1
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Configure multimedia class scheduler
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "10" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /t REG_DWORD /d "10000" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1 
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1

:: set Win32PrioritySeparation to short variable 1:1, no foreground boost
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "36" /f >nul 2>&1

:: Set split threshold to minimize svchost.exe processes
Reg add "HKLM\SYSTEM\ControlSet001\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "4294967295" /f >nul 2>&1

:: Background process priority to below normal
for %%i in (OriginWebHelperService.exe ShareX.exe EpicWebHelper.exe SocialClubHelper.exe steamwebhelper.exe StartMenu.exe ) do (
  Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "5" /f >nul 2>&1
)

:: System Processes priority to idle
for %%i in (fontdrvhost.exe lsass.exe WmiPrvSE.exe ) do (
  Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
  Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>&1
)

:: Set CSRSS priorty to realtime
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1

:: -- Powerplan Configuration -- ::

:: Unhide Power Attributes
:: source: https://gist.github.com/Velocet/7ded4cd2f7e8c5fa475b8043b76561b5#file-unlock-powercfg-ps1
%PowerShell% "$PowerCfg = (Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings' -Recurse).Name -notmatch '\bDefaultPowerSchemeValues|(\\[0-9]|\b255)$';foreach ($item in $PowerCfg) { Set-ItemProperty -Path $item.Replace('HKEY_LOCAL_MACHINE','HKLM:') -Name 'Attributes' -Value 0 -Force}" >nul 2>&1

echo !S_GREEN!Importing Power Plan...
powercfg -import "%WinDir%\NeptuneDir\Prerequisites\power.pow" 11111111-1111-1111-1111-111111111111 >nul 2>&1
powercfg -setactive 11111111-1111-1111-1111-111111111111 >nul 2>&1
powercfg -changename 11111111-1111-1111-1111-111111111111 "NeptuneOS Powerplan 2.0." "A powerplan created to achieve low latency and high 0.01% lows." >nul 2>&1
powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a >nul 2>&1
powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg -delete e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1

:: Disable Away Mode Policy
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 0 >nul 2>&1
powercfg -setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 0 >nul 2>&1

:: Disable Idle States
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0 >nul 2>&1
powercfg -setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0 >nul 2>&1

:: Disable Hybrid Sleep
powercfg -setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0 >nul 2>&1
powercfg -setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0 >nul 2>&1

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

powercfg -setactive scheme_current >nul 2>&1

:: Disable Powersaving on Drivers
echo !S_GREEN!Disable Powersaving...

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
        Reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters" /v "%%i" /t REG_DWORD /d "0" /f >nul 2>&1
    )
)

:: Disable PnP Powersaving
%PowerShell% "$usb_devices = @('Win32_USBController', 'Win32_USBControllerDevice', 'Win32_USBHub'); $power_device_enable = Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi; foreach ($power_device in $power_device_enable){$instance_name = $power_device.InstanceName.ToUpper(); foreach ($device in $usb_devices){foreach ($hub in Get-WmiObject $device){$pnp_id = $hub.PNPDeviceID; if ($instance_name -like \"*$pnp_id*\"){$power_device.enable = $False; $power_device.psbase.put()}}}}" >nul 2>&1

:: Disable Powersaving in UMDF drivers
for %%a in (WakeEnabled WdkSelectiveSuspendEnable) do (
	for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class" /s /f "%%a" ^| findstr "HKEY"') do (
		Reg add "%%b" /v "%%a" /t REG_DWORD /d "0" /f >nul 2>&1
	)
)

:: Disable Powersaving on Network Adapter
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" /v "DefaultPnPCapabilities" /t REG_DWORD /d "24" /f >nul 2>&1

:: Disable Timer Coalescing 
:: https://en.wikipedia.org/wiki/Timer_coalescing
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Connected Standby
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Hibernation
powercfg -h off

:: Disable Powerthrottling
:: Intel CPUs, 6 generation or higher
:: https://blogs.windows.com/windows-insider/2017/04/18/introducing-power-throttling
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Sleep Study
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f >nul 2>&1
wevtutil set-log "Microsoft-Windows-SleepStudy/Diagnostic" /e:false >nul 2>&1
wevtutil set-log "Microsoft-Windows-Kernel-Processor-Power/Diagnostic" /e:false >nul 2>&1
wevtutil set-log "Microsoft-Windows-UserModePowerService/Diagnostic" /e:false >nul 2>&1

:: Disable Energy Estimation
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Energy Logging
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "DisableTaggedEnergyLogging" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxApplication" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxTagPerApplication" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Event Processor (?)
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Battery Estimation (Laptops)
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PerfCalculateActualUtilization" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable IRQ Steering
:: https://www.computerhope.com/jargon/i/irqhold.htm#:~:text=PCI%20IRQ%20steering%20is%20a,also%20supported%20PCI%20IRQ%20Steering.
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "InterruptSteeringDisabled" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable More Sleep Features (?)
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "SleepReliabilityDetailedDiagnostics" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Power Quality of Service (?)
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "QosManagesIdleProcessors" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Watchdog Timer
:: https://www.analog.com/en/design-notes/disable-the-watchdog-timer-during-system-reboot.html
:: A watchdog timer continuously watches the execution of code and resets the system if the software hangs or no longer executes the correct sequence of code
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableSensorWatchdog" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Fastboot
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Unsorted Tweaks (?)
:: Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableVsyncLatencyUpdate" /t REG_DWORD /d "0" /f >nul 2>&1
:: Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "MfBufferingThreshold" /t REG_DWORD /d "0" /f >nul 2>&1
:: Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "TimerRebaseThresholdOnDripsExit" /t REG_DWORD /d "30" /f >nul 2>&1


:: -- Time Server Configuration -- ::
echo !S_GREEN!Changing NTP Server...

:: Switch to pool.ntp.org
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org" >nul 2>&1
:: Resync to pool.ntp.org
net start w32time >nul 2>&1
w32tm /config /update >nul 2>&1
w32tm /resync >nul 2>&1
%svc% W32Time 4 >nul 2>&1


:: -- File System Configuration -- ::
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
		for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do Reg add "%%a\Device Parameters\Disk" /v "CacheIsPowerProtected" /t REG_DWORD /d "1" /f >nul 2>&1
	)
	for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI"^| findstr "HKEY"') do (
		for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do Reg add "%%a\Device Parameters\Disk" /v "UserWriteCacheSetting" /t REG_DWORD /d "1" /f >nul 2>&1
	)
)

:: Disable HIPM, DIPM, HDD Parking
FOR /F "eol=E" %%a in ('REG QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "EnableHIPM"^| FINDSTR /V "EnableHIPM"') DO (
	Reg add "%%a" /F /V "EnableHIPM" /T REG_DWORD /d 0 >nul 2>&1
	Reg add "%%a" /F /V "EnableDIPM" /T REG_DWORD /d 0 >nul 2>&1
	Reg add "%%a" /F /V "EnableHDDParking" /T REG_DWORD /d 0 >nul 2>&1
)

:: IOLATENCYCAP 0
FOR /F "eol=E" %%a in ('REG QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "IoLatencyCap"^| FINDSTR /V "IoLatencyCap"') DO (
	Reg add "%%a" /F /V "IoLatencyCap" /T REG_DWORD /d 0 >nul 2>&1
)


:: -- Task Scheduler -- ::
echo !S_GREEN!Disabling Scheduled Tasks...

for %%a in (
    "\Microsoft\Windows\ApplicationData\appuriverifierdaily"
    "\Microsoft\Windows\ApplicationData\appuriverifierinstall"
    "\Microsoft\Windows\ApplicationData\DsSvcCleanup"
    "\Microsoft\Windows\Application Experience\PcaPatchDbTask"
    "\Microsoft\Windows\Application Experience\StartupAppTask"
    "\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask"
    "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
    "\Microsoft\Windows\Defrag\ScheduledDefrag"
    "\Microsoft\Windows\Device Setup\Metadata Refresh"
    "\Microsoft\Windows\Diagnosis\Scheduled"
    "\Microsoft\Windows\DiskCleanup\SilentCleanup"
    "\Microsoft\Windows\DiskFootprint\Diagnostics"
    "\Microsoft\Windows\InstallService\ScanForUpdates"
    "\Microsoft\Windows\InstallService\ScanForUpdatesAsUser"
    "\Microsoft\Windows\InstallService\SmartRetry"
    "\Microsoft\Windows\Management\Provisioning\Cellular"
    "\Microsoft\Windows\MUI\LPRemove"
    "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"
    "\Microsoft\Windows\Printing\EduPrintProv"
    "\Microsoft\Windows\PushToInstall\LoginCheck"
    "\Microsoft\Windows\Ras\MobilityManager"
    "\Microsoft\Windows\Registry\RegIdleBackup"
    "\Microsoft\Windows\RetailDemo\CleanupOfflineContent"
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
    "\Microsoft\Windows\WaaSMedic\PerformRemediation"
    "\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange"
    "\Microsoft\Windows\WindowsUpdate\Scheduled Start"
    "\Microsoft\Windows\Wininet\CacheTask"
    "\Microsoft\XblGameSave\XblGameSaveTask"
) do (
	schtasks /change /disable /TN %%a > nul
)

:: -- Boot Configuration Data -- ::
echo !S_GREEN!Configuring BCDEdit...

:: Legacy Boot Menu
bcdedit /set bootmenupolicy legacy >nul 2>&1
:: Disable Hyper-V
bcdedit /set hypervisorlaunchtype off >nul 2>&1
:: Disable Automatic Repair
bcdedit /set {current} recoveryenabled no >nul 2>&1
:: Set Boot Label
bcdedit /set {current} description "NeptuneOS %Version%" >nul 2>&1
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
:: Use X2APIC
bcdedit /set x2apicpolicy enable 
bcdedit /set uselegacyapicmode no


:: -- Device Manager -- ::
echo !S_GREEN!Disabling Devices...

:: System Devices 
%DevMan% /disable "ACPI Processor Aggregator" >nul 2>&1
%DevMan% /disable "ACPI Wake Alarm" >nul 2>&1
%DevMan% /disable "Composite Bus Enumerator" >nul 2>&1
%DevMan% /disable "Direct memory access controller" >nul 2>&1
%DevMan% /disable "High precision event timer" >nul 2>&1
%DevMan% /disable "Microsoft GS Wavetable Synth" >nul 2>&1
%DevMan% /disable "Microsoft Hyper-V Virtualization Infrastructure Driver" >nul 2>&1
%DevMan% /disable "Microsoft Kernel Debug Network Adapter" >nul 2>&1
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
%DevMan% /disable "Programmable interrupt controller" >nul 2>&1
%DevMan% /disable "System Speaker" >nul 2>&1
%DevMan% /disable "System Timer" >nul 2>&1
%DevMan% /disable "System board" >nul 2>&1
%DevMan% /disable "UMBus Root Bus Enumerator" >nul 2>&1

:: -- MSI Mode -- ::
echo !S_GREEN! Enabling MSI Mode...

:: enable MSI mode on USB, GPU, SATA controllers and network adapters
:: deleting DevicePriority sets the priority to undefined
for %%a in (
    Win32_USBController, 
    Win32_VideoController, 
    Win32_NetworkAdapter, 
    Win32_IDEController
) do (
    for /f %%i in ('wmic path %%a get PNPDeviceID ^| findstr /L "PCI\VEN_"') do (
        Reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f > nul 2>nul
        Reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f > nul 2>nul
    )
)

:: if e.g. VMWare is used, set network adapter to normal priority as undefined on some virtual machines may break internet connection
wmic computersystem get manufacturer /format:value | findstr /i /C:VMWare && (
    for /f %%a in ('wmic path Win32_NetworkAdapter get PNPDeviceID ^| findstr /L "PCI\VEN_"') do (
        Reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "2"  /f > nul 2>nul
    )
)


:: -- Security and Hardening -- ::
echo !S_GREEN!Disabling Mitigations...

:: Disable Spectre and Meltdown
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f >nul 2>&1

:: Disable ASLR
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "MoveImages" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable CFG
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f >nul 2>&1

:: NTFS Mitigations
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable DMA Remapping
:: https://docs.microsoft.com/en-us/windows-hardware/drivers/pci/enabling-dma-remapping-for-device-drivers
for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f "DmaRemappingCompatible" ^| find /i "Services\" ') do (
	Reg add "%%a" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f >nul 2>&1
)

:: Disable SEHOP
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable TSX 
Reg add "HKLM\SYSTEM\currentcontrolset\control\session manager\Kernel" /v "DisableTsx" /t REG_DWORD /d "1" /f >nul 2>&1

:: Mitigate HiveNightmare and SeriousSAM
icacls %WinDir%\system32\config\*.* /inheritance:e >nul 2>&1

:: Harden LSASS
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe" /v "AuditLevel" /t REG_DWORD /d "8" /f >nul 2>&1
Reg add "HKLM\Software\Policies\Microsoft\Windows\CredentialsDelegation" /v "AllowProtectedCreds" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdminOutboundCreds" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdmin" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "RunAsPPL" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\SecurityProviders\WDigest" /v "Negotiate" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\SecurityProviders\WDigest" /v "UseLogonCredential" /t REG_DWORD /d "0" /f >nul 2>&1

:: Delete Adobe Font Type Manager
Reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Font Drivers" /v "Adobe Type Manager" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "DisableATMFD" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disale Hyper-V and Virtualization
:: https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Windows.DeviceGuard::VirtualizationBasedSecuritye
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "EnableVirtualizationBasedSecurity" /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "RequirePlatformSecurityFeatures" /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HypervisorEnforcedCodeIntegrity" /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HVCIMATRequired" /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "LsaCfgFlags" /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "ConfigureSystemGuardLaunch" /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequireMicrosoftSignedBootChain" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1

:: Mitigate NBT-NS poisoning attacks
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" /v "NodeType" /t REG_DWORD /d "2" /f >nul 2>&1

:: Block Eneumeration of Anonymous SAM accounts
:: https://www.stigviewer.com/stig/windows_10/2021-03-10/finding/V-220929
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RestrictAnonymousSAM" /t REG_DWORD /d "1" /f >nul 2>&1

:: System Mitigations
%powershell% "Set-ProcessMitigation -System -Disable DEP, EmulateAtlThunks, SEHOP, ForceRelocateImages, RequireInfo, BottomUp, HighEntropy, StrictHandle, DisableWin32kSystemCalls, AuditSystemCall, DisableExtensionPoints, BlockDynamicCode, AllowThreadsToOptOut, AuditDynamicCode, CFG, SuppressExports, StrictCFG, MicrosoftSignedOnly, AllowStoreSignedBinaries, AuditMicrosoftSigned, AuditStoreSigned, EnforceModuleDependencySigning, DisableNonSystemFonts, AuditFont, BlockRemoteImageLoads, BlockLowLabelImageLoads, PreferSystem32, AuditRemoteImageLoads, AuditLowLabelImageLoads, AuditPreferSystem32, EnableExportAddressFilter, AuditEnableExportAddressFilter, EnableExportAddressFilterPlus, AuditEnableExportAddressFilterPlus, EnableImportAddressFilter, AuditEnableImportAddressFilter, EnableRopStackPivot, AuditEnableRopStackPivot, EnableRopCallerCheck, AuditEnableRopCallerCheck, EnableRopSimExec, AuditEnableRopSimExec, SEHOP, AuditSEHOP, SEHOPTelemetry, TerminateOnError, DisallowChildProcessCreation, AuditChildProcess" >nul 2>&1

:: Disable Reserved Storage
DISM /Online /Set-ReservedStorageState /State:Disabled >nul 2>&1

:: Disable PowerShell Telemetry
:: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_telemetry?view=powershell-7.3
setx POWERSHELL_TELEMETRY_OPTOUT 1 >nul 2>&1

:: Set Strong Cryptography on 64 bit and 32 bit .NET Framework 
:: https://github.com/ScoopInstaller/Scoop/issues/2040#issuecomment-369686748
Reg add "HKLM\SOFTWARE\Microsoft\.NetFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "1" /f >nul 2>&1

:: Restrict Anonymous Enumeration of Shares
:: https://www.stigviewer.com/stig/windows_10/2021-03-10/finding/V-220930
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RestrictAnonymous" /t REG_DWORD /d "1" /f >nul 2>&1

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
	Reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%a" /v "MitigationOptions" /t REG_BINARY /d "!mitigation_mask!" /f >nul 2>&1
	Reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%a" /v "MitigationAuditOptions" /t REG_BINARY /d "!mitigation_mask!" /f >nul 2>&1
)

Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_BINARY /d "!mitigation_mask!" /f >nul 2>&1
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions" /t REG_BINARY /d "!mitigation_mask!" /f >nul 2>&1


:: -- Network Configuration -- ::
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
Reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t reg_DWORD /d "00000000" /f >nul 2>&1
Reg add "HKLM\Software\WOW6432Node\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t reg_DWORD /d "0" /f >nul 2>&1

:: Disable Network Level Authentication
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_SZ /d "1" /f >nul 2>&1

:: No TCP Connection Limit
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxConnectionsPerServer" /t REG_DWORD /d "0" /f >nul 2>&1

:: Max Port to 65534
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "65534" /f >nul 2>&1

:: Reduce TIME_WAIT
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d "32" /f >nul 2>&1

:: Reduce Time to Live
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d "64" /f >nul 2>&1

:: Duplicate ACKS
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t REG_DWORD /d "2" /f >nul 2>&1

:: Disable SACKS
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable MultiCast
Reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t reg_DWORD /d "0" /f >nul 2>&1

:: Disable TCP Extensions
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t reg_DWORD /d "0" /f >nul 2>&1

:: Allow ICMP redirects to override OSPF generated routes
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableICMPRedirect" /t REG_DWORD /d "1" /f >nul 2>&1

:: TCP Window Size
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t REG_DWORD /d "8760" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpWindowSize" /t REG_DWORD /d "8760" /f >nul 2>&1

:: Disable network discovery
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" /f >nul 2>&1

:: Enable DNS over HTTPS
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableAutoDoh" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeSOACacheTime" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NetFailureCacheTime" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable LLMNR
Reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Administrative Shares
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "AutoShareWks" /t REG_DWORD /d "0" /f >nul 2>&1

:: Enable the Network Adapter's Onboard Processor
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableTaskOffload" /t reg_DWORD /d "0" /f >nul 2>&1

:: Disable the TCP Autotuning Diagnostic Tool
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableWsd" /t reg_DWORD /d "0" /f >nul 2>&1

:: Host Resolution Priority
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t REG_DWORD /d "6" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t REG_DWORD /d "5" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t REG_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t REG_DWORD /d "7" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "Class" /t REG_DWORD /d "8" /f >nul 2>&1

:: TCP Congestion Control/Avoidance Algorithm
Reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "0200" /t reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "1700" /t reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f >nul 2>&1

:: Detect Congestion Failure
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPCongestionControl" /t reg_DWORD /d "00000001" /f >nul 2>&1

:: Disable SYN-DOS protection
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SynAttackProtect" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock" /v "UseDelayedAcceptance" /t REG_DWORD /d "0" /f >nul 2>&1

:: Prevent unwanted NIC resets
Reg add "HKLM\SYSTEM\CurrentControlSet\services\NDIS\Parameters" /v "DisableNDISWatchDog" /t REG_DWORD /d "1" /f >nul 2>&1

:: Disable Nagle's Algorithm
:: https://en.wikipedia.org/wiki/Nagle%27s_algorithm
for /f %%a in ('wmic path Win32_NetworkAdapter get GUID ^| findstr "{"') do (
    Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%a" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f >nul 2>&1
    Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%a" /v "TcpDelAckTicks" /t REG_DWORD /d "0" /f >nul 2>&1
    Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%a" /v "TCPNoDelay" /t REG_DWORD /d "1" /f >nul 2>&1
)

:: Disable NetBIOS over TCP
for /f "delims=" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces" /s /f "NetbiosOptions" ^| findstr "HKEY"') do (
    Reg add "%%a" /v "NetbiosOptions" /t REG_DWORD /d "2" /f >nul 2>&1
)

:: Disable Network Adapters
%PowerShell% "Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6, ms_msclient, ms_server, ms_lldp, ms_lltdio, ms_rspndr" >nul 2>&1


:: -- Drivers and Services -- ::
echo !S_GREEN!Disabling Drivers and Services...

:: Driver dependencies
Reg add "HKLM\System\CurrentControlSet\Services\Audiosrv" /v "DependOnService" /t REG_MULTI_SZ /d "" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dhcp" /v "DependOnService" /t REG_MULTI_SZ /d "NSI\0Afd" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache" /v "DependOnService" /t REG_MULTI_SZ /d "nsi" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc" /v "DependOnService" /t REG_MULTI_SZ /d "NSI\0RpcSs\0TcpIp" /f >nul 2>&1

:: Delete driver filters
:: rdyboost
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ /d "fvevol\0iorate" /f >nul 2>&1

:: Split audio services to improve cycles count
copy /y "%windir%\System32\svchost.exe" "%windir%\System32\audiosvchost.exe" >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv" /v "ImagePath" /t REG_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalServiceNetworkRestricted -p" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AudioEndpointBuilder" /v "ImagePath" /t REG_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalSystemNetworkRestricted -p" /f >nul 2>&1

:: Backing up default windows service and drivers (imribiy)
set BACKUP="%HOMEPATH%\Desktop\\POST-INSTALL\Troubleshooting\windows-default-services.reg"
echo Windows Registry Editor Version 5.00 >>%BACKUP%
for /f "delims=" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services"') do (
	for /f "tokens=3" %%b in ('reg query "%%~a" /v "Start" 2^>nul') do (
		for /l %%c in (0,1,4) do (
			if "%%b"=="0x%%c" (
				echo. >>%BACKUP%
				echo [%%~a] >>%BACKUP%
				echo "Start"=dword:0000000%%c >>%BACKUP%
			) 
		) 
	) 
) >nul 2>&1

:: Disable drivers and services
%svc% 3ware 4
%svc% ADP80XX 4
%svc% AmdK8 4
%svc% Beep 4
%svc% BTAGService 4
%svc% BthA2dp 4
%svc% BthAvctpSvc 4
%svc% BthEnum 4
%svc% BthHFEnum 4
%svc% bthleenum 4
%svc% BTHMODEM 4
%svc% cdrom 4
%svc% flpydisk 4
%svc% GpuEnergyDrv 4
%svc% luafv 4
%svc% mrxsmb 4
%svc% mrxsmb20 4
%svc% NdisCap 4
%svc% NdisTapi 4
%svc% NdisWan 4
%svc% ndiswanlegacy 4
%svc% NetBIOS 4
%svc% NetBT 4
%svc% QWAVEdrv 4
%svc% RasAgileVpn 4
%svc% Rasl2tp 4
%svc% RasPppoe 4
%svc% RasSstp 4
%svc% srv2 4
%svc% srvnet 4
%svc% tcpipreg 4
%svc% tdx 4
%svc% Telemetry 4
%svc% wanarp 4
%svc% wanarpv6 4
::
%svc% BluetoothUserService 4
%svc% bthserv 4
%svc% DispBrokerDesktopSvc 4
%svc% edgeupdate 4
%svc% edgeupdatem 4
%svc% FontCache 4
%svc% HvHost 4
%svc% IKEEXT 4
%svc% LanManServer 4
%svc% microsoft_bluetooth_avrcptransport 4
%svc% PrintNotify 4
%svc% rdyboost 4
%svc% RFCOMM 4
%svc% Spooler 4
%svc% SysMain 4
%svc% vmicguestinterface 4
%svc% vmicheartbeat 4
%svc% vmickvpexchange 4
%svc% vmicrdv 4
%svc% vmicshutdown 4
%svc% vmictimesync 4
%svc% vmicvmsession 4
%svc% vmicvss 4
%svc% WaaSMedicSvc 4
%svc% WarpJITSvc 4
%svc% WPDBusEnum 4
%svc% WSearch 4


:: Backing up default neptune services and drivers
set BACKUP="%HOMEPATH%\Desktop\POST-INSTALL\Troubleshooting\neptune-default-services.reg"
echo Windows Registry Editor Version 5.00 >>%BACKUP%

for /f "delims=" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services"') do (
	for /f "tokens=3" %%b in ('reg query "%%~a" /v "Start" 2^>nul') do (
		for /l %%c in (0,1,4) do (
			if "%%b"=="0x%%c" (
				echo. >>%BACKUP%
				echo [%%~a] >>%BACKUP%
				echo "Start"=dword:0000000%%c >>%BACKUP%
			) 
		) 
	) 
) >nul 2>&1

:: Check if battery information is available to determine system type
:: If this method ends up being unreliable it will be replaced
wmic path Win32_Battery get BatteryStatus > nul 2>&1
if %errorlevel% equ 0 (
    set SystemType=Desktop
) else (
    set SystemType=Laptop
)
if "%SystemType%"=="Laptop" (
    echo Running Laptop Configuration...
    %svc% serenum 3
    %svc% sermouse 3
    %svc% serial 3
    %svc% i8042prt 3
    %svc% wlansvc 2
    %svc% wmiacpi 2
    Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "0" /f >nul 2>&1
    %DevMan% /enable "Communications Port (COM1)" >nul 2>&1
    %DevMan% /enable "Communications Port (COM2)" >nul 2>&1
    %DevMan% /enable "Communications Port (SER1)" >nul 2>&1
    %DevMan% /enable "Communications Port (SER2)" >nul 2>&1
) else (
    %svc% acpiex 4
    %svc% acpipagr 4
    %svc% acpimi 4
    %svc% acpipmi 4
    %svc% acpitime 4
    %svc% iaLPSS2i_GPIO2 4
    %svc% iaLPSS2i_I2C 4
    %svc% iaLPSSi_GPIO 4
    %svc% iaLPSSi_I2C 4
    %svc% sermouse 4
    %svc% serial 4
    %svc% i8042prt 4
)

:: -- Finishing Up -- ::
echo !S_GREEN! Finishing Up...

:: Disable windows search and start menu
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im searchapp.exe >nul 2>&1
taskkill /f /im SearchHost.exe >nul 2>&1
taskkill /f /im StartMenuExperienceHost.exe >nul 2>&1
cd C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy >nul 2>&1
takeown /f "searchapp.exe" >nul 2>&1
icacls "C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\searchapp.exe" /grant Administrators:F >nul 2>&1
ren searchapp.exe searchapp.old >nul 2>&1
cd C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy >nul 2>&1
takeown /f "SearchHost.exe" >nul 2>&1
icacls "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe" /grant Administrators:F >nul 2>&1
ren SearchHost.exe SearchHost.old >nul 2>&1
cd C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy >nul 2>&1
takeown /f "StartMenuExperienceHost.exe" >nul 2>&1
icacls "C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\StartMenuExperienceHost.exe" /grant Administrators:F >nul 2>&1
ren StartMenuExperienceHost.exe StartMenuExperienceHost.old >nul 2>&1

:: Delete microcode
takeown /f C:\Windows\System32\mcupdate_GenuineIntel.dll >nul 2>&1
takeown /f C:\Windows\System32\mcupdate_AuthenticAMD.dll >nul 2>&1
del C:\Windows\System32\mcupdate_GenuineIntel.dll /s /f /q >nul 2>&1
del C:\Windows\System32\mcupdate_AuthenticAMD.dll /s /f /q >nul 2>&1

:: Import registry file a second time for good measures
%WinDir%\Regedit.exe import "%WinDir%\NeptuneDir\neptune.reg" >nul 2>&1
%WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 %WinDir%\Regedit.exe import "%WinDir%\NeptuneDir\neptune.reg" >nul 2>&1

:: Delete neptune setup files
del /f /q "%WinDir%\NeptuneDir\neptune.reg" >nul 2>&1
del /f /q "%WinDir%\NeptuneDir\FullscreenCMD.vbs" >nul 2>&1
del /f /q "%WinDir%\NeptuneDir\power.pow" >nul 2>&1
del /f /q "%WinDir%\NeptuneDir\pnp-powersaving.ps1" >nul 2>&1
rmdir /s /q "%WinDir%\NeptuneDir\Prerequisites" >nul 2>&1

:: Set notice text
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticecaption" /t REG_SZ /d "Welcome to NeptuneOS %version%. A custom OS catered towards gamers. " /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticetext" /t REG_SZ /d "http://discord.gg/MEh7MMRKDD" /f >nul 2>&1

cls
echo !S_GREY!Finishing up installation and restarting. Enjoy NeptuneOS.
echo !S_GREY!Please report any bugs you may find to the discord, or to the github. Thank you for your support.
echo !S_GREY!Press any key to let the system reboot.
pause>nul

shutdown /f /r /t 0













:::::::::::::::::::::::
::: Batch Functions :::
:::::::::::::::::::::::

:setSvc
:: %svc% (service name) (0-4)
if "%1"=="" (echo You need to run this with a service to disable. && exit /b 1)
if "%2"=="" (echo You need to run this with an argument ^(1-4^) to configure the service's startup. && exit /b 1)
if %2 LSS 0 (echo Invalid configuration. && exit /b 1)
if %2 GTR 4 (echo Invalid configuration. && exit /b 1)
reg query "HKLM\System\CurrentControlSet\Services\%1" >nul 2>&1 || (echo The specified service/driver is not found. && exit /b 1)
Reg add "HKLM\System\CurrentControlSet\Services\%1" /v "Start" /t REG_DWORD /d "%2" /f > nul
exit /b 0