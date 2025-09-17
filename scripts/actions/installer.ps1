# Installer script for Neptune Project
# This script will handle the installation of necessary components and configurations.
param (
    [switch]$Silent
)

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

# Run installer prerequisites
Show-Section "Installing Prerequisites"
Invoke-ActionScript "install-prerequisites.bat"

# Services and Drivers configuration
Show-Section "Services and Drivers"
Invoke-ActionScript "services-drivers\backup-windows-default.cmd"
Invoke-ActionScript "services-drivers.ps1"
Invoke-ActionScript "services-drivers\filters.ps1"
Invoke-ActionScript "services-drivers\audio-service-split.bat"
Invoke-ActionScript "services-drivers\backup-neptune-default.cmd"

Show-Section "Performance Tweaks"
# Run-ActionScript "power-settings.ps1"
# Run-ActionScript "scheduler.ps1"
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

Show-Section "Security Tweaks"
Invoke-ActionScript "security\hardening.cmd"
Invoke-ActionScript "security\mitigations.cmd"

Show-Section "Cleanup"
# Run-ActionScript "remove-bloat.ps1"

Write-Log "Installer finished successfully."
