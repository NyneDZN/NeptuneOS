# Forked from AtlasOS Repository
# https://github.com/Atlas-OS
# Small modifications made by NYNE for NeptuneOS such as:
# Adjusting file paths


Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile((Get-Item 'C:\Windows\NeptuneDir\user.png'))

$resolutions = @{
    "user.png" = 448
    "user.bmp" = 448
    "guest.png" = 448
    "guest.bmp" = 448
    "user-192.png" = 192
    "user-48.png" = 48
    "user-40.png" = 40
    "user-32.png" = 32
}

# Set default profile pictures
foreach ($image in $resolutions.Keys) {
    $resolution = $resolutions[$image]

    $a = New-Object System.Drawing.Bitmap($resolution, $resolution)
    $graph = [System.Drawing.Graphics]::FromImage($a)
    $graph.DrawImage($img, 0, 0, $resolution, $resolution)
    $a.Save("$([Environment]::GetFolderPath('CommonApplicationData'))\Microsoft\User Account Pictures\$image")
}