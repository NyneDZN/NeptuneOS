# usersid.ps1

# Get the current Windows user
$user = [System.Security.Principal.WindowsIdentity]::GetCurrent()

# Store the SID as a global variable so it's available in the current session
$Global:SID = $user.User.Value

# Display it in the terminal
Write-Host "Windows SID: $Global:SID"

# Optional: return structured data (useful if capturing output)
@{
    WindowsUser = @{
        SID = $Global:SID
    }
}
