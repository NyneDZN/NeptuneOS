@echo off
Reg.exe add "HKCU\Software\Microsoft\Lighting" /v "ControlledByForegroundApp" /t REG_DWORD /d "1" /f >nul 2>&1