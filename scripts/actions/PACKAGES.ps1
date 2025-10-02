& "$([Environment]::GetFolderPath('Windows'))\NeptuneDir\Scripts\packageInstall.ps1" `
    -InstallPackages @(
        '*Z-Atlas-NoDefender-Package*',
        '*Z-Atlas-NoTelemetry-Package*'
    ) `
    -NoInteraction
