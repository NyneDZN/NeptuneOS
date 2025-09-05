# Load RAM info
Get-SystemInfo "info\ram.ps1"
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

# -------------------------
# NTFS and File System Settings
# -------------------------
fsutil behavior set allowextchar 0                     # Disallow extended chars in 8.3 names
fsutil behavior set bugcheckoncorrupt 0               # Disallow bug check on corruption
fsutil behavior set disable8dot3 1                    # Disable 8.3 File Creation
fsutil behavior set disablecompression 1              # Disable NTFS File Compression
# fsutil behavior set disableencryption 1             # Disable NTFS Encryption (Breaks Xbox Functionality)
fsutil behavior set disablelastaccess 1               # Disable Last Accessed Timestamp
fsutil behavior set disablespotcorruptionhandling 1   # Disable Spot Corruption Handling
fsutil behavior set disabledeletenotify 0             # Enable TRIM for SSD
fsutil behavior set encryptpagingfile 0               # Disable paging file encryption
fsutil behavior set quotanotify 86400                 # Quota notification interval
fsutil behavior set symlinkevaluation L2L:1           # Local to local symbolic link evaluation
fsutil repair set C: 0                                # Disable self-repair on boot drive
