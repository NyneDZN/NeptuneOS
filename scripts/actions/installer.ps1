# Installer script for Neptune Project
# This script will handle the installation of necessary components and configurations.
Write-Log "Starting NeptuneOS Installer..."

# Nice section header
function Show-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host ("=" * 50) -ForegroundColor Cyan
    Write-Host ">>> $Title" -ForegroundColor Yellow
    Write-Host ("=" * 50) -ForegroundColor Cyan
    Write-Log "== $Title =="
}

# Initialize Neptune Environment
Move-Item -Path ".\os\NeptuneDir" -Destination "$env:WINDIR" -Force
Move-Item -Path ".\os\lockscreen.png" -Destination "$env:WINDIR\NeptuneDir" -Force
Move-Item -Path ".\os\user.png" -Destination "$env:WINDIR\NeptuneDir" -Force
Move-Item -Path ".\os\Desktop\Neptune.lnk" -Destination "$env:USERPROFILE\Desktop" -Force

# User icon
Start-Process takeown -ArgumentList '/f "C:\ProgramData\Microsoft\User Account Pictures" /r' -Wait -NoNewWindow
Start-Process icacls -ArgumentList '"C:\ProgramData\Microsoft\User Account Pictures" /grant administrators:F /T' -Wait -NoNewWindow
Remove-Item -Path "C:\ProgramData\Microsoft\User Account Pictures" -Recurse -Force
Move-Item -Path "C:\neptune-installer\os\ProgramData\Microsoft\User Account Pictures" -Destination "C:\ProgramData\Microsoft" -Force

# Set wallpaper
takeown /f "C:\Windows\Web" /r /d y
icacls "C:\Windows\Web" /grant administrators:F /t
Remove-Item -Path "C:\Windows\Web" -Recurse -Force
Move-Item -Path "C:\neptune-installer\os\Web" -Destination "C:\Windows\Web" -Force
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "Wallpaper" -Value "C:\Windows\Web\Wallpaper\Windows\NeptuneOS.png"

# Run installer prerequisites
Show-Section "Installing Prerequisites"
Invoke-ActionScript "install-prerequisites.bat"

# Windows Components
Show-Section "Windows Components"
Invoke-ActionScript "dism-capabilities.bat"
Invoke-ActionScript "packages.cmd"

# Chocolatey
Invoke-ActionScript "chocolatey.cmd"

# File System
Show-Section "File System Configuration"
Invoke-ActionScript "ntfs.ps1"
Invoke-ActionScript "ntfs\fsutil.ps1"

# Task Scheduler
Invoke-ActionScript "task-scheduler.ps1"

# Services and Drivers configuration
Show-Section "Services and Drivers"
Invoke-ActionScript "services-drivers\backup-windows-default.cmd"
Invoke-ActionScript "services-drivers.ps1"
Invoke-ActionScript "services-drivers\filters.ps1"
Invoke-ActionScript "services-drivers\audio-service-split.bat"
Invoke-ActionScript "services-drivers\backup-neptune-default.cmd"

# BCD
Show-Section "Boot Configuration Data (BCD)"
Invoke-ActionScript "bcdedit.ps1"

# Registry Tweaks
Show-Section "Registry Tweaks"
Invoke-ActionScript "registry\explorer.cmd"
Invoke-ActionScript "registry\misc.cmd"
Invoke-ActionScript "registry\privacy.cmd"
Invoke-ActionScript "registry\updates.cmd"

# Performance Tweaks
Show-Section "Performance Tweaks"
Invoke-ActionScript "\performance\audio.cmd"
Invoke-ActionScript "\performance\background-apps.cmd"
Invoke-ActionScript "\performance\disable-wbdt.cmd"
Invoke-ActionScript "\performance\fastboot.cmd"
Invoke-ActionScript "\performance\fso-gamebar.cmd"
Invoke-ActionScript "\performance\game-mode.cmd"
Invoke-ActionScript "\performance\gpu-scheduling.cmd"
Invoke-ActionScript "\performance\kernel.cmd"
Invoke-ActionScript "\performance\latency-tolerance.cmd"
Invoke-ActionScript "\performance\mmcss-configuration.cmd"
Invoke-ActionScript "\performance\msi-mode.cmd"
Invoke-ActionScript "\performance\power-configuration.cmd"
Invoke-ActionScript "\performance\process-priorities.cmd"
Invoke-ActionScript "\performance\svchost-split-threshold.cmd"
Invoke-ActionScript "\performance\timestamp-interval.cmd"
Invoke-ActionScript "\performance\win32-priority-seperation.cmd"
Invoke-ActionScript "\performance\windowed-optimizations-hdr.cmd"

# Security Tweaks
Show-Section "Security Tweaks"
Invoke-ActionScript "security\hardening.cmd"
Invoke-ActionScript "security\mitigations.cmd"

# Neptune Stuff
Show-Section "Neptune Customizations"
Invoke-ActionScript "lockscreen.ps1"

# Cleanup
Show-Section "Cleanup"
# Run-ActionScript "remove-bloat.ps1"

Write-Log "Installer finished successfully."
