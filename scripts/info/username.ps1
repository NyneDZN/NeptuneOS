# username.ps1
$user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

# Terminal output
Write-Host "Username: $user"

# Return structured JSON-ready data
return @{
    WindowsUser = @{
        Username = $user
    }
}
