#
#
#
# ---  This script will update the Default Services registry file for Hotfix 1.1 ---
#
#
#

# --- Placeholder file paths ---
$regFile = "C:\Windows\NeptuneDir\Neptune\Troubleshooting\Default Services and Drivers\Neptune Default.reg"
$backupFile = "$regFile.bak"

# --- Backup first ---
Copy-Item $regFile $backupFile -Force

# --- Read the .reg file ---
$lines = Get-Content $regFile

# --- Target services ---
$services = @(
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WpnService",
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WpnUserService",
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DisplayEnhancementService"
)

# --- Track which service section we are in ---
$currentService = ""

# --- Modify lines ---
$modifiedLines = $lines | ForEach-Object {
    $line = $_

    # Check if this line is a service header
    foreach ($service in $services) {
        if ($line -eq "[$service]") {
            $currentService = $service
        }
    }

    # If we are in a target service section, modify the Start value
    if ($currentService -and $line -match '^"Start"=dword:') {
        $line = '"Start"=dword:00000002'  # 2 = Automatic
        $currentService = ""  # reset after changing
    }

    $line
}

# --- Save changes back to the .reg file ---
$modifiedLines | Set-Content $regFile -Encoding Unicode

Write-Host "Hotfix applied successfully. Original file backed up as $backupFile"
