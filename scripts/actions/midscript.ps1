function Install-GoogleChrome {
        Write-Host "Installing Google Chrome.."
        choco feature enable -n allowGlobalConfirmation
        choco install googlechrome --force
}

function Install-Firefox {
    Write-Host "Installing Firefox.."
    choco feature enable -n allowGlobalConfirmation
    choco install firefox --force
}

Write-Host "Before NeptuneOS starts configuring your machine, would you like to install your drivers?" - ForegroundColor Cyan
Write-Host "This is highly recommended." - ForegroundColor Yellow
$godrivers = Read-Host "Install drivers? (Y/N)"

if ($godrivers -eq 'Y' -or $godrivers -eq 'y') {

    $valid = $false
    do {
        $browser = (Read-Host "Which browser would you like to install?").ToLower()

        if ($browser -eq 'chrome') {
            Install-GoogleChrome
            $valid = $true
        } elseif ($browser -eq 'firefox') {
            Install-Firefox
            $valid = $true
        } else {
            Write-Host "Unknown browser choice. Please try again."
            $valid = $false
        }
    } while (-not $valid)

}
