param(
    [Parameter(Mandatory=$false)]
    [string]$hotfix
)

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