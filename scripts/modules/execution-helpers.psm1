# Execution helper functions for master.ps1

function Invoke-ActionScript {
    param([string]$ScriptName)
    $scriptPath = Join-Path $ScriptRoot "scripts\actions\$ScriptName"

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
    $scriptPath = Join-Path $ScriptRoot "scripts\info\$InfoScript"
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
