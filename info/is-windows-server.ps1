# Check if Windows Server
if (Test-Path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Server Manager.lnk') {
    Write-Output "yes"
} else {
    Write-Output "no"
}
