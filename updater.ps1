param(
    [Parameter(Mandatory=$false)]
    [string]$hotfix,
    [switch]$Update
)

function Get-RemoteVersion {
    $url = "https://raw.githubusercontent.com/NyneDZN/NeptuneOS/refs/heads/updater/version.txt"
    try {
        $remoteVersion = Invoke-RestMethod -Uri $url -UseBasicParsing
        return $remoteVersion.Trim()
    } catch {
        Write-Host "Failed to fetch remote version information."
        return $null
    }
}

function Get-LocalVersion {
    try {
        $reg = Get-ItemProperty -Path "HKLM:\SOFTWARE\NeptuneOS" -Name "HotfixVersion" -ErrorAction Stop
        return $reg.HotfixVersion
    } catch {
        return $null
    }
}

if ($Update) {
    $remoteVersion = Get-RemoteVersion
    if (-not $remoteVersion) { exit 1 }

    $localVersion = Get-LocalVersion
    if (-not $localVersion) {
        Write-Host "Local hotfix version not found in registry."
        exit 1
    }

    # Compare as version numbers
    try {
        $remoteVerObj = [version]$remoteVersion
        $localVerObj = [version]$localVersion
    } catch {
        Write-Host "Version format error. Remote: $remoteVersion, Local: $localVersion"
        exit 1
    }

    if ($remoteVerObj -gt $localVerObj) {
        Write-Host "A newer hotfix ($remoteVersion) is available. Please download the latest hotfix from the Discord server."
    } else {
        Write-Host "You are running the latest hotfix version ($localVersion)."
    }
    exit 0
}

if ($hotfix) {
    $hotfixDir = Join-Path -Path "$env:WinDir\NeptuneDir\Updates\hotfixes" -ChildPath $hotfix
    $hotfixScript = Join-Path -Path $hotfixDir -ChildPath "hotfix_$hotfix.cmd"

    if (Test-Path $hotfixDir) {
        if (Test-Path $hotfixScript) {
            Write-Host "Applying hotfix version $hotfix..."
            Push-Location $hotfixDir
            & $hotfixScript
            Pop-Location
        } else {
            Write-Host "Hotfix script 'hotfix_$hotfix.cmd' not found in $hotfixDir."
        }
    } else {
        Write-Host "Hotfix folder '$hotfixDir' does not exist."
    }
} else {
    Write-Host "No hotfix version specified. Use -hotfix <version>."
}