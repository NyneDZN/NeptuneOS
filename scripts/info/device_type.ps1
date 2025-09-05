# device_type.ps1
$chassis = Get-CimInstance Win32_SystemEnclosure | Select-Object -First 1 ChassisTypes
$type = if ($chassis.ChassisTypes -contains 8 -or $chassis.ChassisTypes -contains 9) { "Laptop" } else { "Desktop" }

# Terminal output
Write-Host "Device Type: $type"

# Return structured JSON-ready data
return @{
    Device = @{
        Type = $type
    }
}
