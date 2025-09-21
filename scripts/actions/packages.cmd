:: Disable Defender and Telemetry via Cab
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\neptune-installer\scripts\packageInstall.ps1" -InstallPackages "C:\neptune-installer\packages\NoDefender.cab","C:\neptune-installer\packages\NoTelemetry.cab"
