# Check if the script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # If not running as admin, relaunch the script with elevated privileges
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Define the path to the .cfg file
$filePath = "C:\secconfig.cfg"

# Export the initial configuration using secedit.exe
secedit.exe /export /cfg $filePath

# Define the text to search for and the replacement text
$searchPattern = "PasswordComplexity\s*=\s*1"
$replaceText = "PasswordComplexity = 0"

# Read the contents of the file
$fileContent = Get-Content $filePath

# Loop through each line in the file
for ($i = 0; $i -lt $fileContent.Count; $i++) {
    # If the line matches the search pattern, replace it with the new text
    if ($fileContent[$i] -match $searchPattern) {
        $fileContent[$i] = $replaceText
        break  # Exit the loop after replacing the text
    }
}

# Write the modified content back to the file
$fileContent | Set-Content $filePath

# Reimport the updated configuration using secedit.exe
secedit.exe /configure /db "%windir%\securitynew.sdb" /cfg $filePath /areas SECURITYPOLICY
