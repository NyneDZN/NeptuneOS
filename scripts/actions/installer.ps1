# Installer script for Neptune Project
# This script will handle the installation of necessary components and configurations.
Write-Log "Starting NeptuneOS Installer..."

# Kill explorer
taskkill /f /im explorer.exe

# Clear terminal
Clear-Host

# NGEN
Invoke-ActionScript "ngen.ps1"

# Clear event logs
# Invoke-ActionScript ".\tweaks\EVENTLOGS.cmd"

# Initialize Neptune Environment
Move-Item -Path ".\os\NeptuneDir" -Destination "$env:WINDIR" -Force
Move-Item -Path ".\os\lockscreen.png" -Destination "$env:WINDIR\NeptuneDir" -Force
Move-Item -Path ".\os\user.png" -Destination "$env:WINDIR\NeptuneDir" -Force
Move-Item -Path ".\os\Desktop\Neptune.lnk" -Destination "$env:USERPROFILE\Desktop" -Force
Move-Item -Path ".\tools" -Destination "$env:WINDIR\NeptuneDir" -Force
Move-Item -path "$env:WINDIR\NeptuneDir\Tools\regjump.exe" -Destination "$env:WINDIR" -Force
Move-Item -path "$env:WINDIR\NeptuneDir\Tools\serviwin.exe" -Destination "$env:WINDIR" -Force

# Set wallpaper
takeown /f "C:\Windows\Web" /r /d y
icacls "C:\Windows\Web" /grant administrators:F /t
Remove-Item -Path "C:\Windows\Web" -Recurse -Force
Move-Item -Path "C:\neptune-installer\os\Web" -Destination "C:\Windows\Web" -Force
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "Wallpaper" -Value "C:\Windows\Web\Wallpaper\Windows\NeptuneOS.png"

# Set lockscreen
Invoke-ActionScript ".\tweaks\LOCKSCREEN.ps1"

# Set user icon
Invoke-ActionScript ".\tweaks\PFP.ps1"

# Set NeptuneOS themes
Invoke-ActionScript ".\tweaks\THEMES.cmd"

# Run installer prerequisites
Show-Section "Installing Prerequisites"
Invoke-ActionScript ".\components\install-prerequisites.bat"

# Windows Components
Show-Section "Windows Components"
# Invoke-ActionScript ".\components\dism-capabilities.cmd" (commented out for now as they are disabled already)
Invoke-ActionScript ".\components\binary-removal.cmd"
Invoke-ActionScriptAsSystem ".\PACKAGES.PS1"
Invoke-ActionScript ".\tweaks\CLIENTCBS.ps1"
Invoke-ActionScript ".\components\deprovisioned-apps.cmd"

# Chocolatey
Invoke-ActionScript ".\tweaks\CHOCOLATEY.cmd"

# File System
Show-Section "File System Configuration"
Invoke-ActionScript ".\tweaks\ntfs\NTFS.CMD"
Invoke-ActionScript ".\tweaks\ntfs\fsutil.ps1"

# Task Scheduler
Invoke-ActionScript ".\tweaks\TASKS.ps1"

# Device Manager
Invoke-ActionScript ".\tweaks\DEVMGMT.CMD"

# Services and Drivers configuration
Show-Section "Services and Drivers"
Invoke-ActionScript ".\tweaks\services-drivers\backup-windows-default.cmd"
Invoke-ActionScript ".\tweaks\services-drivers\audio-service-split.bat"
Invoke-ActionScript ".\tweaks\services-drivers\filters.ps1"
Invoke-ActionScript ".\tweaks\SERVICES-DRIVERS.ps1"
Invoke-ActionScript ".\tweaks\services-drivers\backup-neptune-default.cmd"

# BCD
Show-Section "Boot Configuration Data (BCD)"
Invoke-ActionScript ".\tweaks\BCD.ps1"

# Registry Tweaks
Show-Section "Registry Tweaks"
Invoke-ActionScript ".\tweaks\registry\explorer.cmd"
Invoke-ActionScript ".\tweaks\registry\misc.cmd"
Invoke-ActionScript ".\tweaks\registry\privacy.cmd"
Invoke-ActionScript ".\tweaks\registry\updates.cmd"
Invoke-ActionScript ".\tweaks\registry\photo-viewer.cmd"
Invoke-ActionScript ".\tweaks\registry\taskbar.cmd"

# Network Tweaks
Invoke-ActionScript ".\tweaks\network\hosts-file.cmd"
#Invoke-ActionScript ".\tweaks\network\netsh.cmd"
Invoke-ActionScript ".\tweaks\network\network.cmd"
Invoke-ActionScript ".\tweaks\network\network-registry.cmd"

# Performance Tweaks
Show-Section "Performance Tweaks"
Invoke-ActionScript ".\tweaks\performance\audio.cmd"
Invoke-ActionScript ".\tweaks\performance\background-apps.cmd"
Invoke-ActionScript ".\tweaks\performance\disable-wbdt.cmd"
Invoke-ActionScript ".\tweaks\performance\fastboot.cmd"
Invoke-ActionScript ".\tweaks\performance\fso-gamebar.cmd"
Invoke-ActionScript ".\tweaks\performance\gpu-scheduling.cmd"
Invoke-ActionScript ".\tweaks\performance\kernel.cmd"
Invoke-ActionScript ".\tweaks\performance\latency-tolerance.cmd"
Invoke-ActionScript ".\tweaks\performance\mmcss-configuration.cmd"
Invoke-ActionScript ".\tweaks\performance\msi-mode.cmd"
Invoke-ActionScript ".\tweaks\performance\power-configuration.cmd"
Invoke-ActionScript ".\tweaks\performance\process-priorities.cmd"
Invoke-ActionScript ".\tweaks\performance\svchost-split-threshold.cmd"
Invoke-ActionScript ".\tweaks\performance\timestamp-interval.cmd"
Invoke-ActionScript ".\tweaks\performance\win32-priority-seperation.cmd"
Invoke-ActionScript ".\tweaks\performance\windowed-optimizations-hdr.cmd"
Invoke-ActionScript ".\tweaks\performance\timer-resolution.cmd"

# Security Tweaks
Show-Section "Security Tweaks"
Invoke-ActionScript ".\tweaks\security\hardening.cmd"
Invoke-ActionScript ".\tweaks\security\mitigations.cmd"

# Misc
Show-Section "Misc Configuration"
Invoke-ActionScript ".\tweaks\etc\msi-installer-safe-mode.cmd"

# Cleanup
Show-Section "Cleanup"
# Run-ActionScript "remove-bloat.ps1"
# Move log and systeminfo and run cleanup
Move-Item -Path "C:\neptune-installer\systeminfo.json" -Destination "$env:WINDIR\NeptuneDir" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" -Name "Finalization" -PropertyType String -Value "$env:WinDir\NeptuneDir\Scripts\FINAL.cmd" -Force

# powershell.exe -ExecutionPolicy Bypass -File "$env:WINDIR\NeptuneDir\Scripts\cleanup.ps1"


Write-Log "Installer finished successfully."
Write-Log "Restarting PC in 5 seconds"
Move-Item -Path "C:\neptune-installer\neptune.log" -Destination "$env:WINDIR\NeptuneDir" -Force
Start-Sleep -Seconds 5
Restart-Computer -Force