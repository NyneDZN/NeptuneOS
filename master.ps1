param (
    [switch]$DevMode,
    [switch]$NeptuneInstall
)

# ========================
# Import Module Scripts
# ========================
Import-Module "$PSScriptRoot\scripts\modules\aesthetics.psm1"
Import-Module "$PSScriptRoot\scripts\modules\execution-helpers.psm1"
Import-Module "$PSScriptRoot\scripts\modules\logs.psm1"
Import-Module "$PSSCriptRoot\scripts\modules\update-info.psm1"

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

# ========================
# Main Mode Selection
# ========================
if ($DevMode) {
    Clear-Host
    Write-Log "Master script started in DEV MODE."
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
            "debug"  { Invoke-DebugScript $Target }
            "ti"     { Invoke-TrustedInstallerScript $Target }
            "clear"  { Clear-Host }
            "ps"     { 
                Write-Host "[INFO] Launching real PowerShell session..."
                Start-Process powershell.exe -ArgumentList "-NoExit", "-Command", "Set-Location '$ScriptRoot'" 
            }
            "help"   { Write-Host "Commands: action <script>, info <script>, debug <script>, ti <script>, clear, cmd, help, exit" }
            default  { Write-Log "Unknown command: $Action" "ERROR" }
        }
    }

    Write-Log "Master script finished (DEV MODE)."
}
elseif ($NeptuneInstall) {
    Write-Log "Master script started in INSTALL MODE."
    # Set global root path so batch doesn't feel left out
    $env:ROOTPATH = $PSScriptRoot

    # Example: launch installer script
    # Begin ngen asap to improve powershell speeds
    Invoke-ActionScript "ngen.ps1"
    Get-SystemInfo "cpu.ps1"
    Get-SystemInfo "gpu.ps1"
    Get-SystemInfo "ram.ps1"
    Get-SystemInfo "device_type.ps1"
    Get-SystemInfo "username.ps1"
    Get-SystemInfo "usersid.ps1"
    Get-SystemInfo "winver.ps1"
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
