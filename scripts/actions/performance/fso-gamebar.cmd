:: // GAMEBAR

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

:: // FSO

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