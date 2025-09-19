# Makes the master.ps1 script look prettier

function Show-Banner {

    $mode = if ($DevMode) { 'DEV MODE' } elseif ($NeptuneInstall) { 'INSTALL MODE' } else { 'UNKNOWN' }

    $bannerLines = @(
        "========================================================",
        "   NeptuneOS Master Script",
        "   Mode : $mode",
        "   Script Root: $ScriptRoot",
        "========================================================"
    )

    foreach ($line in $bannerLines) {
        Write-Host $line -ForegroundColor Cyan
    }

    Write-Host ""  # Blank line below banner
}
