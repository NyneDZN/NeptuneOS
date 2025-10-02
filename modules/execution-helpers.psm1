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

function Invoke-ActionScriptAsSystem {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$ScriptName,

        [Parameter(ValueFromRemainingArguments=$true)]
        $Args
    )

    # Resolve ScriptRoot (use existing $ScriptRoot if present, otherwise default to $PSScriptRoot)
    if (-not $ScriptRoot) { $ScriptRoot = $PSScriptRoot }

    $scriptPath = Join-Path $ScriptRoot "scripts\actions\$ScriptName"

    # NSudo location you specified
    $nsudoPath = Join-Path $env:WinDir "NeptuneDir\Tools\NSudoLG.exe"

    if (-not (Test-Path $scriptPath)) {
        Write-Log "Action script not found: $ScriptName" 'ERROR'
        return 1
    }

    if (-not (Test-Path $nsudoPath)) {
        Write-Log "NSudo not found at $nsudoPath" 'ERROR'
        return 2
    }

    Write-Log "Launching action script as SYSTEM via NSudo: $ScriptName"

    try {
        # create a temporary file for capturing combined stdout+stderr
        $tempOut = Join-Path $env:TEMP ("InvokeAction_{0}.log" -f ([guid]::NewGuid()))

        # Helper: escape single quotes for safe single-quoted PowerShell literal
        $escapeForSingleQuote = {
            param($s)
            if ($null -eq $s) { return "''" }
            return "'" + ($s -replace "'", "''") + "'"
        }

        # Build escaped argument string for the child PowerShell session
        $escapedArgs = @()
        if ($Args) {
            foreach ($a in $Args) {
                $escapedArgs += & $escapeForSingleQuote $a
            }
        }

        $argsString = if ($escapedArgs) { $escapedArgs -join ' ' } else { '' }

        # Build a PowerShell -Command that runs the script and redirects both streams to the temp file.
        # Using *>&1 or *>> requires PS 3+ (typical). We're using *> to redirect all streams into the file.
        # The inner & ensures invoking the script file path (not dot-sourcing).
        $psCommand = "& { & '$scriptPath' $argsString *> '$tempOut' }"

        # Build NSudo argument array:
        # -U:S  => run as System
        # -P:E  => enable all privileges (common useful flag; adjust if needed)
        # Then we call powershell.exe with our -Command
        $nsudoArgs = @(
            '-U:S',
            '-P:E',
            'powershell.exe',
            '-NoProfile',
            '-NonInteractive',
            '-ExecutionPolicy', 'Bypass',
            '-Command',
            $psCommand
        )

        # Start NSudo (which will start a child PowerShell). Wait for it to exit.
        $proc = Start-Process -FilePath $nsudoPath -ArgumentList $nsudoArgs -Wait -PassThru

        # Optionally check exit code from NSudo process
        if ($proc.ExitCode -ne 0) {
            Write-Log "NSudo process exited with code $($proc.ExitCode)." 'WARN'
        }

        # If output file exists, stream it into Write-Log, then remove it
        if (Test-Path $tempOut) {
            Get-Content $tempOut -ErrorAction SilentlyContinue | ForEach-Object { Write-Log $_ }
            Remove-Item $tempOut -ErrorAction SilentlyContinue
        } else {
            Write-Log "No output captured from $ScriptName (no temp file created)." 'WARN'
        }

        return 0
    } catch {
        Write-Log "Error while launching $ScriptName as SYSTEM: $_" 'ERROR'
        return 3
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
