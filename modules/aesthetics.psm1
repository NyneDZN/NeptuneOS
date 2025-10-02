# Makes the master.ps1 script look prettier

function Show-Banner {

    $mode = if ($DevMode) { 'DEV MODE' } elseif ($NeptuneInstall) { 'INSTALL MODE' } else { 'UNKNOWN' }

    $bannerLines = @(
        "========================================================",
        "   NeptuneOS Master Script",
        "   Mode : $mode",
        "   Script Root: $ScriptRoot",
        "   Created by: NYN9",
        "========================================================"
    )

    foreach ($line in $bannerLines) {
        Write-Host $line -ForegroundColor Cyan
    }

    Write-Host ""  # Blank line below banner
}

function Show-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host ("=" * 50) -ForegroundColor Cyan
    Write-Host ">>> $Title" -ForegroundColor Yellow
    Write-Host ("=" * 50) -ForegroundColor Cyan
    Write-Log "== $Title =="
}