# Make sure Windows version info is collected
Get-SystemInfo "winver.ps1"

# Load version from systeminfo.json
try {
    $SystemInfo = Get-Content -Raw -Path (Join-Path $ScriptRoot "systeminfo.json") | ConvertFrom-Json
    $WinVerRaw = if ($SystemInfo.winver) { $SystemInfo.winver } else { "UnknownVersion" }

    # Map to simplified name
    switch -Wildcard ($WinVerRaw) {
        "*Windows 10*" { $BootName = "Neptune 10" }
        "*Windows 11*" { $BootName = "Neptune 11" }
        default        { $BootName = "NeptuneOS" }
    }

} catch {
    Write-Log "Failed to read systeminfo.json: $_" "ERROR"
    $BootName = "NeptuneOS"
}

$BCDCommands = @(
    "bcdedit /set bootmenupolicy legacy",
    "bcdedit /set hypervisorlaunchtype off",
    "bcdedit /set {current} recoveryenabled no",
    "bcdedit /set {current} description `"${BootName}`"",
    "bcdedit /set disabledynamictick yes",
    "bcdedit /set useplatformtick yes",
    "bcdedit /timeout 15",
    "bcdedit /set x2apicpolicy enable",
    "bcdedit /set uselegacyapicmode no",
    "bcdedit /set linearaddress57 OptOut",
    "bcdedit /set increaseuserva 268435328"
)

foreach ($cmd in $BCDCommands) {
    Write-Log "Executing: $cmd"
    try {
        & cmd.exe /c $cmd 2>&1 | ForEach-Object { Write-Log $_ }
        Write-Log "Command completed successfully."
    } catch {
        Write-Log "Command failed: $_" "ERROR"
    }
}

Write-Log "All BCDEdit tweaks completed."
