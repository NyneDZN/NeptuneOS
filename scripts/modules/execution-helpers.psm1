# Execution helper functions for master.ps1

function Invoke-ActionScript {
    param(
        [string]$ScriptName,
        [Parameter(ValueFromRemainingArguments=$true)]
        $Args
    )
    
    $scriptPath = Join-Path $ScriptRoot "scripts\actions\$ScriptName"

    if (Test-Path $scriptPath) {
        Write-Log "Launching action script: $ScriptName"
        try {
            # Dot-source with arguments
            . $scriptPath @Args | ForEach-Object { Write-Log $_ }
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

        # Dot-source the script so variables persist in this session
        $info = . $scriptPath

        if ($info -is [hashtable]) {
            foreach ($key in $info.Keys) {
                # Update central system info table
                Update-SystemInfo -Key $key -Value $info[$key]

                # Also create session-global variables for easy access
                foreach ($subKey in $info[$key].Keys) {
                    $varName = $subKey
                    $varValue = $info[$key][$subKey]

                    # Assign variable in the current session
                    Set-Variable -Name $varName -Value $varValue -Scope Global
                }
            }
        } else {
            Write-Log "Info script did not return a hashtable" "ERROR"
        }
    } else {
        Write-Log "Info script not found: $InfoScript" 'ERROR'
    }
}
