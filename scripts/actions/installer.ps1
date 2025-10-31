# Installer script for NeptuneOS
# This script will handle the installation of necessary components and configurations.
Write-Log "Starting NeptuneOS Installer..."

# Kill explorer
taskkill /f /im explorer.exe

# Clear terminal
Clear-Host

# NGEN to speed-up powershell
Invoke-ActionScript "ngen.ps1"

# Chocolatey
Invoke-ActionScript ".\tweaks\CHOCOLATEY.cmd"

# Clear event logs
# Invoke-ActionScript ".\tweaks\EVENTLOGS.cmd"

# Initialize Neptune Environment
Move-Item -Path ".\os\NeptuneDir" -Destination "$env:WINDIR" -Force
Move-Item -Path ".\os\Neptune.lnk" -Destination "$env:USERPROFILE\Desktop" -Force
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
# Invoke-ActionScript ".\tweaks\THEMES.cmd"

# Initialize nepthost.exe
Invoke-ActionScript ".\tweaks\NEPTHOST.cmd"
Invoke-ActionScript ".\tweaks\FIREWALL.cmd"

# Run installer prerequisites
Show-Section "Installing Prerequisites"
Invoke-ActionScript ".\components\install-prerequisites.cmd"
Invoke-ActionScript ".\components\7z.cmd"
Invoke-ActionScript ".\components\open-shell.cmd"
#Invoke-ActionScript ".\tweaks\explorer-patcher.cmd"

# Windows Components
Show-Section "Windows Components"
# Invoke-ActionScript ".\components\dism-optional-features.cmd"
Invoke-ActionScript ".\components\binary-removal.cmd"
Invoke-ActionScriptAsSystem ".\PACKAGES.PS1"
Invoke-ActionScript ".\tweaks\CLIENTCBS.ps1"
Invoke-ActionScript ".\components\deprovisioned-apps.cmd"
Invoke-ActionScript ".\tweaks\SFCDEPLOY.cmd"

# File System
Show-Section "File System Configuration"
Invoke-ActionScript ".\tweaks\ntfs\NTFS.cmd"
Invoke-ActionScript ".\tweaks\ntfs\fsutil.ps1"

# Task Scheduler
Invoke-ActionScript ".\tweaks\TASKS.ps1"

# Device Manager
Invoke-ActionScript ".\tweaks\DEVMGMT.CMD"

# Services and Drivers configuration
Show-Section "Services and Drivers"
Invoke-ActionScript ".\tweaks\services-drivers\backup-windows-default.cmd"
Invoke-ActionScript ".\tweaks\services-drivers\audio-service-split.cmd"
Invoke-ActionScript ".\tweaks\services-drivers\filters.ps1"
Invoke-ActionScriptAsSystem ".\tweaks\SERVICES-DRIVERS.ps1"
Invoke-ActionScript ".\tweaks\services-drivers\backup-neptune-default.cmd"
Invoke-ActionScript ".\tweaks\services-drivers\SVCSPLIT.ps1"

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
Invoke-ActionScript ".\tweaks\registry\color.ps1"

# Network Tweaks
Invoke-ActionScript ".\tweaks\network\hosts-file.cmd"
Invoke-ActionScript ".\tweaks\network\network.cmd"

# Performance Tweaks
Show-Section "Performance Tweaks"
Invoke-ActionScript ".\tweaks\performance\audio.cmd"
Invoke-ActionScript ".\tweaks\performance\background-apps.cmd"
Invoke-ActionScript ".\tweaks\performance\disable-wbdt.cmd"
Invoke-ActionScript ".\tweaks\performance\fastboot.cmd"
Invoke-ActionScript ".\tweaks\performance\fso-gamebar.cmd"
Invoke-ActionScript ".\tweaks\performance\gpu-scheduling.cmd"
Invoke-ActionScript ".\tweaks\performance\kernel.cmd"
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
# Move log and systeminfo and run cleanup
Move-Item -Path "C:\neptune-installer\systeminfo.json" -Destination "$env:WINDIR\NeptuneDir" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" -Name "Finalization" -PropertyType String -Value "$env:WinDir\NeptuneDir\Scripts\FINALIZE.cmd" -Force
Move-Item -Path "C:\neptune-installer\neptune.log" -Destination "$env:WINDIR\NeptuneDir\Logs" -Force

# Finish
Write-Log "Installer finished successfully."
Start-Sleep -Seconds 1
Restart-Computer -Force