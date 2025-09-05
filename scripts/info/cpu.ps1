# cpu.ps1
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1 Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed

# Terminal output
Write-Host "CPU: $($cpu.Name)"
Write-Host "Cores: $($cpu.NumberOfCores), Threads: $($cpu.NumberOfLogicalProcessors)"
Write-Host "Max Clock Speed: $($cpu.MaxClockSpeed) MHz"

# Return structured JSON-ready data
return @{
    CPU = @{
        Name     = $cpu.Name
        Cores    = $cpu.NumberOfCores
        Threads  = $cpu.NumberOfLogicalProcessors
        ClockMHz = $cpu.MaxClockSpeed
    }
}
