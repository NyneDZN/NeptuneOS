@echo off
Reg.exe add "HKCU\Control Panel\Desktop" /v "FontSmoothing" /t REG_SZ /d "2" /f >nul 2>&1
echo Font Smoothing has been enabled.
pause>nul