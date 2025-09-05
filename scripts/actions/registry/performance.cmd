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