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


# Services and Drivers configuration
Show-Section "Services and Drivers"
Run-ActionScript "services-drivers.ps1"
Run-ActionScript "services-drivers\filters.ps1"

Show-Section "Performance Tweaks"
# Run-ActionScript "power-settings.ps1"
# Run-ActionScript "scheduler.ps1"

Show-Section "Cleanup"
# Run-ActionScript "remove-bloat.ps1"

Write-Log "Installer finished successfully."
