# ===========================
# Remove Specific Driver Filters
# ===========================

# Drivers to remove
$driversToRemove = @("rdyboost")  # <-- add more if needed

# Registry base path
$regBase = "HKLM:\SYSTEM\CurrentControlSet\Control\Class"

# Get all class subkeys
$subkeys = Get-ChildItem $regBase

foreach ($subkey in $subkeys) {
    foreach ($filterName in @("UpperFilters","LowerFilters")) {
        try {
            $filters = (Get-ItemProperty -Path $subkey.PSPath -Name $filterName -ErrorAction SilentlyContinue).$filterName
            if ($filters) {
                # Normalize to array
                if ($filters -is [string]) {
                    $filters = @($filters)
                }

                # Check if any match removal list
                $updated = $filters | Where-Object { $driversToRemove -notcontains $_ }

                if ($updated.Count -ne $filters.Count) {
                    # Write back updated list
                    Set-ItemProperty -Path $subkey.PSPath -Name $filterName -Value $updated -Type MultiString
                    Write-Host "Removed [$($driversToRemove -join ', ')] from $filterName in $($subkey.PSChildName)"
                }
            }
        } catch {
            Write-Warning "Could not process $filterName in $($subkey.PSPath): $_"
        }
    }
}
