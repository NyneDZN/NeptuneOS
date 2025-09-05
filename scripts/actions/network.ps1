# registry.ps1 - main registry action loader

# Path to registry sub-scripts folder
$RegistryScriptsPath = Join-Path $PSScriptRoot "\scripts\actions\network"

# ========================
# Helper function
# ========================
function Set-RegistryValue {
    param(
        [string]$Path,
        [string]$Name,
        [object]$Value,
        [ValidateSet("String","DWord","QWord","MultiString","ExpandString")]
        [string]$Type = "String"
    )

    try {
        # Ensure the key exists
        if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }

        # Set or update value
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type

        # Logging with ${} to avoid colon parsing issues
        Write-Log "Registry updated: ${Path}\${Name} = $Value ($Type)"
    } catch {
        Write-Log "Failed to update registry ${Path}\${Name}: $($_.Exception.Message)" "ERROR"
    }
}

# ========================
# Manual execution order
# ========================
$RegistryScriptsOrder = @(
    "hosts-file.cmd",
    "netsh.cmd",
    "network-registry.cmd"
)

foreach ($scriptName in $RegistryScriptsOrder) {
    $scriptPath = Join-Path $RegistryScriptsPath $scriptName
    if (Test-Path $scriptPath) {
        try {
            Write-Log "Running registry sub-script: $scriptName"
            & $scriptPath
        } catch {
            Write-Log "Sub-script $scriptName failed: $($_.Exception.Message)" "ERROR"
        }
    } else {
        Write-Log "Registry sub-script not found: $scriptName" "ERROR"
    }
}

# ========================
# Auto-load any extra scripts not in the manual list
# ========================
# $allScripts = Get-ChildItem -Path $RegistryScriptsPath -Filter *.ps1 | Select-Object -ExpandProperty Name
# $extraScripts = $allScripts | Where-Object { $_ -notin $RegistryScriptsOrder }

# foreach ($scriptName in $extraScripts) {
#     $scriptPath = Join-Path $RegistryScriptsPath $scriptName
#     try {
#        Write-Log "Running extra registry sub-script (not in manual order): $scriptName"
#         & $scriptPath
#     } catch {
#         Write-Log "Extra sub-script $scriptName failed: $($_.Exception.Message)" "ERROR"
#     }
# }
