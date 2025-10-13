# Cleanup Script for NeptuneOS, parts forked from AtlasOS

# Remove startup notices
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -force -ea SilentlyContinue };
Remove-Item -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" -force;
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" -force -ea SilentlyContinue };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'legalnoticecaption' -Value '' -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'legalnoticetext' -Value '' -PropertyType String -Force -ea SilentlyContinue;

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
# vssadmin delete shadows /all /quiet

