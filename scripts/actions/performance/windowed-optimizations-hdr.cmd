call "C:\neptune-installer\variables.cmd"

:: Enable VRR and Windowed Mode Optimizations & Disable Auto HDR
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "VRROptimizeEnable=0;SwapEffectUpgradeEnable=1;AutoHDREnable=0;" /f