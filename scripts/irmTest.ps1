# Neptune Installer via GitHub (run with irm | iex)

# Console title and header
$Host.UI.RawUI.WindowTitle = 'Neptune Installer'
Write-Host '=====================================' -ForegroundColor Cyan
Write-Host '         NeptuneOS Downloader        ' -ForegroundColor Cyan
Write-Host '=====================================' -ForegroundColor Cyan
Write-Host ''

# Paths
$tempZip  = "$env:TEMP\neptune-update.zip"
$destRoot = 'C:\'
$destPath = 'C:\neptune-installer'
$downloadUrl = 'https://github.com/NyneDZN/NeptuneOS/archive/refs/heads/neptune-update.zip'
$installScript = "$destPath\scripts\installmode.cmd"

# Step 1: Download
Write-Host '[1/3] Downloading Neptune Update...' -ForegroundColor Yellow
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($downloadUrl, $tempZip)

# Step 2: Remove old installer if present
Write-Progress -Activity 'Cleaning up old installer' -Status ('Removing ' + $destPath) -PercentComplete 30
if (Test-Path $destPath) {
    Remove-Item -Path $destPath -Recurse -Force
}

# Step 3: Extract
Write-Progress -Activity 'Extracting Files' -Status 'Unzipping archive...' -PercentComplete 60
Expand-Archive -Path $tempZip -DestinationPath $destRoot -Force

# Step 4: Rename
Write-Progress -Activity 'Finalizing' -Status 'Renaming extracted folder' -PercentComplete 80
Rename-Item -Path (Join-Path $destRoot 'NeptuneOS-neptune-update') -NewName 'neptune-installer' -Force

# Step 5: Launch Installer
Write-Progress -Activity 'Launching Installer' -Status 'Starting installmode.cmd' -PercentComplete 95
Start-Process cmd.exe -ArgumentList '/c', $installScript -Wait

Write-Host '`nDone. Installer launched.' -ForegroundColor Green
