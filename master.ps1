<#
.SYNOPSIS
  Master PowerShell script for Neptune Project. Acts as terminal and logger, launches action/info scripts.
.DESCRIPTION
  - DevMode = opens interactive command terminal
  - NeptuneInstall = runs install scripts automatically
  - No params = shows popup warning
#>

param (
    [switch]$DevMode,
    [switch]$NeptuneInstall
)

# ========================
# Paths & Files
# ========================
$ScriptRoot     = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
$SystemInfoFile = Join-Path $ScriptRoot "systeminfo.json"
$LogFile        = Join-Path $ScriptRoot "neptune.log"

# Ensure log file exists
if (-not (Test-Path $LogFile)) {
    New-Item -Path $LogFile -ItemType File -Force | Out-Null
}

# ========================
# Terminal Banner
# ========================

function Show-Banner {
    # Clear screen first
    # Clear-Host

    # Determine mode string
    $mode = if ($DevMode) { 'DEV MODE' } elseif ($NeptuneInstall) { 'INSTALL MODE' } else { 'UNKNOWN' }

    $bannerLines = @(
        "========================================================",
        "   NeptuneOS Master Script",
        "   Mode : $mode",
        "   Script Root: $ScriptRoot",
        "========================================================"
    )

    foreach ($line in $bannerLines) {
        Write-Host $line -ForegroundColor Cyan
    }

    Write-Host ""  # Blank line below banner
}




# ========================
# Global System Info
# ========================
if (Test-Path $SystemInfoFile) {
    try {
        $Global:SystemInfo = Get-Content $SystemInfoFile -Raw | ConvertFrom-Json
    } catch {
        Write-Output "Warning: JSON file invalid, reinitializing."
        $Global:SystemInfo = @{}
        $Global:SystemInfo | ConvertTo-Json -Depth 5 | Set-Content $SystemInfoFile -Force
    }
} else {
    $Global:SystemInfo = @{}
    $Global:SystemInfo | ConvertTo-Json -Depth 5 | Set-Content $SystemInfoFile -Force
}

function Update-SystemInfo {
    param (
        [string]$Key,
        [object]$Value
    )

    if (-not $Global:SystemInfo -or -not ($Global:SystemInfo -is [hashtable])) {
        $Global:SystemInfo = @{ }
    }

    if ($Value -is [hashtable]) {
        if ($Global:SystemInfo.ContainsKey($Key) -and ($Global:SystemInfo[$Key] -is [hashtable])) {
            foreach ($k in $Value.Keys) {
                $Global:SystemInfo[$Key][$k] = $Value[$k]
            }
        } else {
            $Global:SystemInfo[$Key] = $Value
        }
    } else {
        $Global:SystemInfo[$Key] = $Value
    }

    try {
        # ✅ Remove -Compress to get pretty, indented JSON
        $Global:SystemInfo | ConvertTo-Json -Depth 5 | Set-Content -Path $SystemInfoFile -Force
        Write-Log "System info updated: $Key"
    } catch {
        Write-Log "Failed to update system info: $($_.Exception.Message)" "ERROR"
    }
}



# ========================
# Logging
# ========================
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = 'INFO'
    )
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logEntry  = "[$timestamp] [$Level] $Message"
    
    # Always print to top pane
    Write-Host $logEntry
    Add-Content -Path $LogFile -Value $logEntry

    # If ERROR, also print in error pane
    if ($Level -eq 'ERROR') {
    Write-ErrorPane $Message
    }
}


# Capture unhandled errors
Register-EngineEvent PowerShell.OnError -Action {
    param($src, $evt)
    $err = $evt.SourceArgs[0] -as [System.Management.Automation.ErrorRecord]
    if ($err) {
        Write-Log "[$($err.CategoryInfo.Category)] $($err.Exception.Message)" "ERROR"
    }
}

# ========================
# Script Execution Helpers
# ========================
function Invoke-ActionScript {
    param([string]$ScriptName)
    $scriptPath = Join-Path $ScriptRoot "scripts\powershell\actions\$ScriptName"

    if (Test-Path $scriptPath) {
        Write-Log "Launching action script: $ScriptName"
        try {
            # Dot-source so script runs inside master session (keeps elevation + globals)
            . $scriptPath | ForEach-Object { Write-Log $_ }
        } catch {
            Write-Log "Error while running $ScriptName $_" 'ERROR'
        }
    } else {
        Write-Log "Action script not found: $ScriptName" 'ERROR'
    }
}

function Get-SystemInfo {
    param([string]$InfoScript)
    $scriptPath = Join-Path $ScriptRoot "scripts\powershell\info\$InfoScript"
    if (Test-Path $scriptPath) {
        Write-Log "Gathering info using: $InfoScript"
        
        $info = & $scriptPath
        
        if ($info -is [hashtable]) {
            foreach ($key in $info.Keys) {
                Update-SystemInfo -Key $key -Value $info[$key]
            }
        } else {
            Write-Log "Info script did not return a hashtable" "ERROR"
        }
    } else {
        Write-Log "Info script not found: $InfoScript" 'ERROR'
    }
}

function Invoke-TrustedInstallerScript {
    param(
        [Parameter(Mandatory=$true)][string]$ScriptName
    )

    $scriptPath = Join-Path $ScriptRoot "scripts\powershell\actions\$ScriptName"
    $powerRunExe = Join-Path $ScriptRoot "tools\PowerRun.exe"

    if (-not (Test-Path $scriptPath)) {
        Write-Log "TrustedInstaller script not found: $ScriptName" 'ERROR'
        return
    }

    if (-not (Test-Path $powerRunExe)) {
        Write-Log "PowerRun.exe not found at $powerRunExe. Cannot run TrustedInstaller scripts." 'ERROR'
        return
    }

    Write-Log "Launching TrustedInstaller script: $ScriptName"

    $arguments = "-exefile `"$PSHome\powershell.exe`" -args `"-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"`""

    try {
        $proc = Start-Process -FilePath $powerRunExe -ArgumentList $arguments -Wait -PassThru
        if ($proc.ExitCode -eq 0) {
            Write-Log "TrustedInstaller script completed successfully: $ScriptName"
        } else {
            Write-Log "TrustedInstaller script finished with exit code $($proc.ExitCode): $ScriptName" 'ERROR'
        }
    } catch {
        Write-Log "Error launching TrustedInstaller script: $($_.Exception.Message)" 'ERROR'
    }
}

# ========================
# Main Mode Selection
# ========================
if ($DevMode) {
    Show-Banner
    Write-Log "Master script started in DEV MODE."
    Get-SystemInfo "cpu.ps1"
    Get-SystemInfo "gpu.ps1"
    Get-SystemInfo "ram.ps1"
    Get-SystemInfo "device_type.ps1"
    Get-SystemInfo "username.ps1"
    Get-SystemInfo "usersid.ps1"
    Get-SystemInfo "winver.ps1"
    Clear-Host
    Show-Banner

    while ($true) {
        $userInput = Read-Host "Enter command (e.g., 'action example.ps1', 'info cpu.ps1', 'exit')"
        if ($userInput -eq "exit") { break }

        $parts  = $userInput.Split(" ", 2)
        $Action = $parts[0].ToLower()
        $Target = if ($parts.Count -gt 1) { $parts[1] } else { $null }

        switch ($Action) {
            "action" { Invoke-ActionScript $Target }
            "info"   { Get-SystemInfo $Target }
            "ti"     { Invoke-TrustedInstallerScript $Target }
            "clear"  { Clear-Host }
            default  { Write-Log "Unknown command: $Action" "ERROR" }
        }
    }

    Write-Log "Master script finished (DEV MODE)."
}
elseif ($NeptuneInstall) {
    Write-Log "Master script started in INSTALL MODE."

    # Example: launch installer script
    Invoke-ActionScript 'installer.ps1'

    Write-Log "Master script finished (INSTALL MODE)."
}
else {
    # Show popup error if no parameters
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show(
        "Neptune Master Script was launched without parameters.`n`nUse -DevMode or -NeptuneInstall.",
        "NeptuneOS Master Script",
        "OK",
        "Error"
    ) | Out-Null
}
