$windir = [Environment]::GetFolderPath('Windows')

# Add PowerShell modules
$env:PSModulePath += ";$windir\NeptuneDir\Scripts\Modules"