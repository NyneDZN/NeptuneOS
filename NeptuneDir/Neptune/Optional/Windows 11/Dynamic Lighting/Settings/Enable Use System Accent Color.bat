@echo off
Reg.exe add "HKCU\Software\Microsoft\Lighting" /v "UseSystemAccentColor" /t REG_DWORD /d "1" /f >nul 2>&1