# gpu.ps1
$gpu = Get-CimInstance Win32_VideoController | Select-Object -First 1 Name, AdapterRAM, DriverVersion

Write-Host "GPU: $($gpu.Name)"
Write-Host "VRAM: $([math]::Round($gpu.AdapterRAM / 1MB)) MB"
Write-Host "Driver Version: $($gpu.DriverVersion)"

return @{
    GPU = @{
        Name          = $gpu.Name
        VRAM_MB       = [math]::Round($gpu.AdapterRAM / 1MB)
        DriverVersion = $gpu.DriverVersion
    }
}
