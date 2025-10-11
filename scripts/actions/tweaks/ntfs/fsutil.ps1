# Load RAM info
Get-SystemInfo ".\ram.ps1"
# $TotalMemory should be set by ram.ps1 in MB or bytes; adjust logic accordingly

# Convert bytes to MB if necessary
$TotalMemoryMB = [math]::Round($TotalMemory / 1MB)

# -------------------------
# Configure MFT and Memory Usage
# -------------------------
if ($TotalMemoryMB -lt 8000) {
    fsutil behavior set memoryusage 1
    fsutil behavior set mftzone 1
} elseif ($TotalMemoryMB -lt 16000) {
    fsutil behavior set memoryusage 1
    fsutil behavior set mftzone 2
} else {
    fsutil behavior set memoryusage 2
    fsutil behavior set mftzone 2
}
