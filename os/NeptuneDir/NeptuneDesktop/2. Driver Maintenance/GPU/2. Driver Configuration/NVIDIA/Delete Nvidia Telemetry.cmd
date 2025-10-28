@echo off
setlocal EnableDelayedExpansion & cd "%WinDir%\NeptuneDir\Scripts" >nul && if exist ansi.cmd call ansi.cmd >nul



rmdir /s /q "C:\Windows\System32\drivers\NVIDIA Corporation" >nul 2>&1
cd /d "C:\Windows\System32\DriverStore\FileRepository\" >nul 2>&1
dir NvTelemetry64.dll /a /b /s >nul 2>&1
del NvTelemetry64.dll /a /s >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /d 0 /f  >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup" /v "SendTelemetryData" /t REG_DWORD /d 0 /f >nul 2>&1
rd /s /q "C:\Program Files\NVIDIA Corporation\Display.NvContainer\plugins\LocalSystem\DisplayDriverRAS" >nul 2>&1
rd /s /q "C:\Program Files\NVIDIA Corporation\DisplayDriverRAS" >nul 2>&1
rd /s /q "C:\ProgramData\NVIDIA Corporation\DisplayDriverRAS" >nul 2>&1

cls & echo !S_GREEN!NVIDIA Telemetry deleted.!S_GREEN!
timeout /t 2 /nobreak>nul