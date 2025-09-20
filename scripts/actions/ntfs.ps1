# -------------------------------
# Optimize NTFS
# -------------------------------

# -------------------------------
# Disable Write Cache Buffer
# -------------------------------
$scsiKeys = Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Enum\SCSI" -ErrorAction SilentlyContinue -Recurse | Where-Object { $_.PSPath -match 'HKEY' }

foreach ($key in $scsiKeys) {
    $diskParams = Join-Path $key.PSPath "Device Parameters\Disk"
    if (Test-Path $diskParams) {
        Set-ItemProperty -Path $diskParams -Name "CacheIsPowerProtected" -Type DWord -Value 1 -Force
        Set-ItemProperty -Path $diskParams -Name "UserWriteCacheSetting" -Type DWord -Value 1 -Force
    }
}

# -------------------------------
# Disable HIPM, DIPM, and HDD Parking
# -------------------------------
$serviceKeys = Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services" -Recurse | Where-Object {
    Test-Path (Join-Path $_.PSPath "EnableHIPM")
} 

foreach ($key in $serviceKeys) {
    Set-ItemProperty -Path $key.PSPath -Name "EnableHIPM" -Type DWord -Value 0 -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $key.PSPath -Name "EnableDIPM" -Type DWord -Value 0 -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $key.PSPath -Name "EnableHDDParking" -Type DWord -Value 0 -Force -ErrorAction SilentlyContinue
}

# -------------------------------
# IOLATENCYCAP to 0
# -------------------------------
$ioLatencyKeys = Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services" -Recurse | Where-Object {
    Test-Path (Join-Path $_.PSPath "IoLatencyCap")
}

foreach ($key in $ioLatencyKeys) {
    Set-ItemProperty -Path $key.PSPath -Name "IoLatencyCap" -Type DWord -Value 0 -Force -ErrorAction SilentlyContinue
}

# -------------------------------
# Set Drive Label
# -------------------------------
Set-Volume -DriveLetter C -NewFileSystemLabel "NeptuneOS"
