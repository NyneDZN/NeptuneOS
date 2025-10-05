<#
    NeptuneOS Updater Script
    ------------------------
    This script runs all hotfix scripts in order from the "hotfixes" directory.
    Each hotfix should be a valid PowerShell script (.ps1) named in the format:
        001-firstfix.ps1, 002-somechange.ps1, etc.

    Logs are written to: NeptuneDir\updates.log
#>

# --- SETTINGS ---
$HotfixDir = $PSScriptRoot\hotfixes
$LogDir = Join-Path $HotfixDir "C:\Windows\NeptuneDir"
$LogFile = Join-Path $LogDir ("updates.log")

# --- FUNCTIONS ---
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $entry = "[$timestamp][$Level] $Message"
    Write-Host $entry
    Add-Content -Path $LogFile -Value $entry
}

Write-Host "=== NeptuneOS Hotfix Updater ===" -ForegroundColor Cyan

# --- GET HOTFIXES ---
$HotfixFiles = Get-ChildItem -Path $HotfixDir -Filter "*.ps1" | 
    Where-Object { $_.Name -ne "updater.ps1" } |
    Sort-Object Name

if ($HotfixFiles.Count -eq 0) {
    Write-Log "No hotfix scripts found. Exiting."
    exit
}

# --- RUN HOTFIXES ---
foreach ($Hotfix in $HotfixFiles) {
    Write-Host "`n--- Running hotfix: $($Hotfix.Name) ---" -ForegroundColor Yellow
    Write-Log "Running hotfix: $($Hotfix.Name)"
    
    try {
        & $Hotfix.FullName
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Hotfix $($Hotfix.Name) completed successfully."
        } else {
            Write-Log "Hotfix $($Hotfix.Name) returned exit code $LASTEXITCODE." "WARN"
        }
    } catch {
        Write-Log "Error running $($Hotfix.Name): $_" "ERROR"
    }
}

Write-Host "`nAll hotfixes completed." -ForegroundColor Green
Write-Log "Updater finished."
