# ram.ps1
$ramModules = Get-CimInstance Win32_PhysicalMemory
$TotalMemory = [math]::Round(($ramModules | Measure-Object Capacity -Sum).Sum / 1GB, 2)

# Terminal output
Write-Host "Total RAM: $TotalMemory GB"
Write-Host "Modules: $($ramModules.Count)"
$ramModules | ForEach-Object {
    Write-Host "- $([math]::Round($_.Capacity / 1GB, 2)) GB, $($_.Speed) MHz, $($_.Manufacturer)"
}

# Return structured JSON-ready data
$modules = $ramModules | ForEach-Object {
    @{
        CapacityGB   = [math]::Round($_.Capacity / 1GB, 2)
        SpeedMHz     = $_.Speed
        Manufacturer = $_.Manufacturer
    }
}

return @{
    RAM = @{
        TotalGB = $totalRAMGB
        Modules = $modules
    }
}
