# usersid.ps1
$user = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$sid  = $user.User.Value

# Terminal output
Write-Host "Windows SID: $sid"

# Return structured JSON-ready data
return @{
    WindowsUser = @{
        SID = $sid
    }
}
