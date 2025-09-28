function Update-SystemInfo {
    param (
        [string]$Key,
        [object]$Value
    )

    if (-not $Global:SystemInfo -or -not ($Global:SystemInfo -is [hashtable])) {
        $Global:SystemInfo = @{ }
    }

    if ($Value -is [hashtable]) {
        if ($Global:SystemInfo.ContainsKey($Key) -and ($Global:SystemInfo[$Key] -is [hashtable])) {
            foreach ($k in $Value.Keys) {
                $Global:SystemInfo[$Key][$k] = $Value[$k]
            }
        } else {
            $Global:SystemInfo[$Key] = $Value
        }
    } else {
        $Global:SystemInfo[$Key] = $Value
    }

    try {
        $Global:SystemInfo | ConvertTo-Json -Depth 5 | Set-Content -Path $SystemInfoFile -Force
        Write-Log "System info updated: $Key"
    } catch {
        Write-Log "Failed to update system info: $($_.Exception.Message)" "ERROR"
    }
}