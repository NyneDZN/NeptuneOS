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
    Write-Output $logEntry
    Add-Content -Path $LogFile -Value $logEntry
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


# ========================
# Main Mode Selection
# ========================
if ($DevMode) {
    Write-Log "Master script started in DEV MODE."

    while ($true) {
        $userInput = Read-Host "Enter command (e.g., 'action example.ps1', 'info cpu.ps1', 'exit')"
        if ($userInput -eq "exit") { break }

        $parts  = $userInput.Split(" ", 2)
        $Action = $parts[0].ToLower()
        $Target = if ($parts.Count -gt 1) { $parts[1] } else { $null }

        switch ($Action) {
            "action" { Invoke-ActionScript $Target }
            "info"   { Get-SystemInfo $Target }
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
