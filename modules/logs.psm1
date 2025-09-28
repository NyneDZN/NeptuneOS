# Logging module for master.ps1

function Write-Log {
    param(
        [string]$Message,
        [string]$Level = 'INFO'
    )
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logEntry  = "[$timestamp] [$Level] $Message"
    
    # Always print to top pane
    Write-Host $logEntry
    Add-Content -Path $LogFile -Value $logEntry

    # If ERROR, also print visibly
    if ($Level -eq 'ERROR') {
        Write-Host "ERROR: $Message" -ForegroundColor Red
    }
}



# Capture unhandled errors
Register-EngineEvent PowerShell.OnError -Action {
    param($src, $evt)
    $err = $evt.SourceArgs[0] -as [System.Management.Automation.ErrorRecord]
    if ($err) {
        Write-Log "[$($err.CategoryInfo.Category)] $($err.Exception.Message)" "ERROR"
    }
}