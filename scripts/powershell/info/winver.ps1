# winver.ps1
$os = Get-CimInstance Win32_OperatingSystem
$isServer = $os.ProductType -eq 3

# Terminal output
Write-Host "Windows Version: $($os.Caption) Build $($os.BuildNumber)"
Write-Host "Version: $($os.Version)"
Write-Host "Is Server: $isServer"

# Return structured JSON-ready data
return @{
    Windows = @{
        Caption     = $os.Caption
        BuildNumber = $os.BuildNumber
        Version     = $os.Version
        IsServer    = $isServer
    }
}
