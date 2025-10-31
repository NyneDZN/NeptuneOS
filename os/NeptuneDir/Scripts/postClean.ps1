# Cleanup Script for NeptuneOS, parts forked from AtlasOS

# Clear the system temp folder
$machine = [System.EnvironmentVariableTarget]::Machine
foreach ($path in @(
	[System.Environment]::GetEnvironmentVariable("Temp", $machine),
	[System.Environment]::GetEnvironmentVariable("Tmp", $machine),
	"$([Environment]::GetFolderPath('Windows'))\Temp"
)) {
	if (Test-Path $path -PathType Container) {
		$sysTemp = $path
		break
	}
}
if ($sysTemp) {
	Write-Output "Cleaning system TEMP folder..."
	Remove-Item -Path "$sysTemp\*" -Force -Recurse -EA 0
} else {
	Write-Error "System temp folder not found!"
}

# Delete installer files
Remove-Item -Path "C:\neptune-installer" -Force -Recurse -EA 0

# Clear restore points
vssadmin delete shadows /all /quiet

