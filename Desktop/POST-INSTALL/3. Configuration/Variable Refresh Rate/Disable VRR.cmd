@echo off
reg delete "HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d >nul 2>&1 
echo VRR has been disabled.
pause>nul