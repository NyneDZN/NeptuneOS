PowerShell Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

:: Refresh Enviornment
call "RefreshEnv.cmd"

:: Disable Global Confirmation in Chocolatey
choco feature enable -n allowGlobalConfirmation

:: Disable Hash Checking in Chocolatey
choco feature disable -n checksumFiles
