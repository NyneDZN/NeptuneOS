$windir = [Environment]::GetFolderPath('Windows')
& "$windir\NeptuneDir\initPowerShell.ps1"
& "$windir\NeptuneDir\Scripts\wingetCheck.cmd"
if ($LASTEXITCODE -ne 0) { exit 1 }

Clear-Host
$ErrorActionPreference = 'SilentlyContinue'

[int] $global:column = 0
[int] $separate = 30
[int] $global:lastPos = 50
[int] $global:item_count = 0
[int] $global:index = 0
[array] $global:items = @()
[bool] $global:install = $false

function init_item{
    param(
        [string]$checkboxText,
        [string]$package
    )
    $global:items += , @($checkboxText, $package)
}

function generate_checkbox {
    param(
        [string]$checkboxText,
        [string]$package,
        [bool]$enabled = $true
    )
    $checkbox = new-object System.Windows.Forms.checkbox
    if($global:index -eq [math]::Ceiling($global:item_count / 2)){
        $global:column = 1
        $global:lastPos = 50
    }
    if($global:column -eq 0){
        $checkbox.Location = new-object System.Drawing.Size(30, $global:lastPos)
    }
    else{
        $checkbox.Location = new-object System.Drawing.Size(($global:column * 300), $global:lastPos)
    }
    $global:lastPos += $separate
    $checkbox.Size = new-object System.Drawing.Size(250, 18)
    $checkbox.Text = $checkboxText
    $checkbox.Name = $package
    $checkbox.Enabled = $enabled

    $checkbox
}

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

# Set the size of the form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Install Software | Neptune" # Titlebar
$Form.ShowIcon = $false
$Form.MaximizeBox = $false
$Form.MinimizeBox = $false
$Form.Size = New-Object System.Drawing.Size(600, 210)
$Form.AutoSizeMode = 0
$Form.KeyPreview = $True
$Form.SizeGripStyle = 2

# Label
$Label = New-Object System.Windows.Forms.label
$Label.Location = New-Object System.Drawing.Size(11, 15)
$Label.Size = New-Object System.Drawing.Size(255, 15)
$Label.Text = "Download and install software using WinGet:"
$Form.Controls.Add($Label)

# Add disclaimer at the bottom
$Disclaimer = New-Object System.Windows.Forms.Label
$Disclaimer.Text = "Forked from and created by the AtlasOS team. Small modifications made by NYN9.
Note: Some applications may require you to update directly from the application, such as discord."
#$Disclaimer.AutoSize = $true
$Disclaimer.Size = New-Object System.Drawing.Size(500, 25)
$Disclaimer.Location = New-Object System.Drawing.Point(11, 650)
$Disclaimer.ForeColor = [System.Drawing.Color]::White
$Form.Controls.Add($Disclaimer)



# https://winstall.app/apps/eloston.ungoogled-chromium
init_item "Ungoogled Chromium" "eloston.ungoogled-chromium"

# https://winstall.app/apps/Mozilla.Firefox
init_item "Mozilla Firefox" "Mozilla.Firefox"

# https://winstall.app/apps/Waterfox.Waterfox
init_item "Waterfox" "Waterfox.Waterfox"

# https://winstall.app/apps/Brave.brave
init_item "Brave Browser" "Brave.Brave"

# https://winstall.app/apps/Google.Chrome
init_item "Google Chrome" "Google.Chrome"

# https://winstall.app/apps/LibreWolf.LibreWolf
init_item "LibreWolf" "LibreWolf.LibreWolf"

# https://winstall.app/apps/TorProject.TorBrowser
init_item "Tor Browser" "TorProject.TorBrowser"

# https://winstall.app/apps/Alex313031.Thorium.AVX2
init_item "Thorium Browser (AVX2)" "Alex313031.Thorium.AVX2"

# https://winstall.app/apps/Discord.Discord
init_item "Discord" "Discord.Discord"

# https://winstall.app/apps/Valve.Steam
init_item "Steam" "Valve.Steam"

# https://winstall.app/apps/HeroicGamesLauncher.HeroicGamesLauncher
init_item "Heroic" "HeroicGamesLauncher.HeroicGamesLauncher"

# https://winstall.app/apps/voidtools.Everything
init_item "Everything" "voidtools.Everything"

# https://winstall.app/apps/Mozilla.Thunderbird
init_item "Mozilla Thunderbird" "Mozilla.Thunderbird"

# https://winstall.app/apps/PeterPawlowski.foobar2000
init_item "foobar2000" "PeterPawlowski.foobar2000"

# https://winstall.app/apps/mpv.net
init_item "MPV Player" "mpv.net"

# https://winstall.app/apps/IrfanSkiljan.IrfanView
init_item "IrfanView" "IrfanSkiljan.IrfanView"

# https://winstall.app/apps/Git.Git
init_item "Git" "Git.Git"

# https://winstall.app/apps/VideoLAN.VLC
init_item "VLC" "VideoLAN.VLC"

# https://winstall.app/apps/PuTTY.PuTTY
init_item "PuTTY" "PuTTY.PuTTY"

# https://winstall.app/apps/Ditto.Ditto
init_item "Ditto" "Ditto.Ditto"

# https://winstall.app/apps/7zip.7zip
init_item "7-Zip" "7zip.7zip"

# https://winstall.app/apps/TeamSpeakSystems.TeamSpeakClient
init_item "Teamspeak" "TeamSpeakSystems.TeamSpeakClient"

# https://winstall.app/apps/Spotify.Spotify
init_item "Spotify" "Spotify.Spotify"

# https://winstall.app/apps/OBSProject.OBSStudio
init_item "OBS Studio" "OBSProject.OBSStudio"

# https://winstall.app/apps/Guru3D.Afterburner
init_item "MSI Afterburner" "Guru3D.Afterburner"

# https://winstall.app/apps/CPUID.CPU-Z
init_item "CPU-Z" "CPUID.CPU-Z"

# https://winstall.app/apps/TechPowerUp.GPU-Z
init_item "GPU-Z" "TechPowerUp.GPU-Z"

# https://winstall.app/apps/Notepad++.Notepad++
init_item "Notepad++" "Notepad++.Notepad++"

# https://winstall.app/apps/Microsoft.VisualStudioCode
init_item "VSCode" "Microsoft.VisualStudioCode"

# https://winstall.app/apps/VSCodium.VSCodium
init_item "VSCodium" "VSCodium.VSCodium"

# https://winstall.app/apps/Klocman.BulkCrapUninstaller
init_item "BCUninstaller" "Klocman.BulkCrapUninstaller"

# https://winstall.app/apps/REALiX.HWiNFO
init_item "HWiNFO" "REALiX.HWiNFO"

# https://winstall.app/apps/Skillbrains.Lightshot
init_item "Lightshot" "Skillbrains.Lightshot"

# https://winstall.app/apps/ShareX.ShareX
init_item "ShareX" "ShareX.ShareX"

# https://winstall.app/apps/valinet.ExplorerPatcher
init_item "ExplorerPatcher" "valinet.ExplorerPatcher"

# https://winstall.app/apps/Microsoft.PowerShell
init_item "Powershell 7" "Microsoft.PowerShell"

#https://winstall.app/apps/MartiCliment.UniGetUI
init_item "UniGetUI (WinGetUI)" "MartiCliment.UniGetUI"

if ([System.Environment]::OSVersion.Version.Build -ge 22000) {
    # https://winget.run/pkg/StartIsBack/StartAllBack
    init_item "StartAllBack" "StartIsBack.StartAllBack"
} else {
    # https://winget.run/pkg/StartIsBack/StartAllBack
    init_item "StartIsBack" "StartIsBack.StartIsBack"
}

$global:item_count = $global:items.Length

# Getting the index for splitting into two columns
foreach($item in $global:items){
    if($global:index -eq ($global:item_count / 2)){
        $global:column = 1
    }
    $Form.Controls.Add((generate_checkbox $item[0] $item[1]))
    $global:index ++
}

if ($global:column -ne 0) {
    $global:lastPos += $separate
}

$Form.height = $global:lastPos + 80


# Dark Mode/Light Mode Toggle
$ToggleBtn = New-Object System.Windows.Forms.Button
$ToggleBtn.Location = New-Object System.Drawing.Point(500, 20)
$ToggleBtn.Size = New-Object System.Drawing.Size(80, 23)
$ToggleBtn.Add_Click({
if ($this.Text -eq "Dark Mode") {
    $this.Text = "Light Mode"
    dark_mode
} else {
    $this.Text = "Dark Mode"
    light_mode
}
})
# Changed into functions
function dark_mode {
    $Form.BackColor = [System.Drawing.Color]::FromArgb(26, 26, 26)
    $Form.ForeColor = [System.Drawing.Color]::White
    foreach ($control in $Form.Controls) {
        if ($control.GetType().Name -eq "Checkbox") {
            $control.BackColor = [System.Drawing.Color]::FromArgb(26, 26, 26)
            $control.ForeColor = [System.Drawing.Color]::White
        }
    }
}
function light_mode {
    $Form.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
    $Form.ForeColor = [System.Drawing.Color]::Black
    foreach ($control in $Form.Controls) {
        if ($control.GetType().Name -eq "Checkbox") {
            $control.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
            $control.ForeColor = [System.Drawing.Color]::Black
        }
    }
}
# Checks the system "app" color (light or dark)
$registryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize\"
$keyName = "AppsUseLightTheme"
function check_system_theme{
    if(((Get-ItemProperty -Path $registryPath -Name $keyName).$keyName) -eq 0){
        dark_mode
        $ToggleBtn.Text = "Light Mode"
    }
    else{
        light_mode
        $ToggleBtn.Text = "Dark Mode"
    }
}
check_system_theme

$Form.Controls.Add($ToggleBtn)

# Add Update button
$UpdateButton = New-Object System.Windows.Forms.Button
$UpdateButton.Location = New-Object System.Drawing.Size(400, 20)
$UpdateButton.Size = New-Object System.Drawing.Size(80, 23)
$UpdateButton.Text = "Update"
$UpdateButton.Add_Click({
    $checkedBoxes = $Form.Controls | Where-Object { $_ -is [System.Windows.Forms.Checkbox] -and $_.Checked }
    if ($checkedBoxes.Count -eq 0) {
        Read-MessageBox -Title "No package selected" -Body 'Please select at least one software package to update' -Icon Information -Buttons Ok | Out-Null
    }
    else {
        $global:update = $true
        $Form.Close()
    }
})
$Form.Controls.Add($UpdateButton)

# Add Install button
$InstallButton = New-Object System.Windows.Forms.Button
$InstallButton.Location = New-Object System.Drawing.Size(300, 20)
$InstallButton.Size = New-Object System.Drawing.Size(80, 23)
$InstallButton.Text = "Install"
$InstallButton.Add_Click({
    $checkedBoxes = $Form.Controls | Where-Object { $_ -is [System.Windows.Forms.Checkbox] -and $_.Checked }
    if ($checkedBoxes.Count -eq 0) {
        Read-MessageBox -Title "No package selected" -Body 'Please select at least one software package to install' -Icon Information -Buttons Ok | Out-Null
    }
    else {
        $global:install = $true
        $Form.Close()
    }
})
$Form.Controls.Add($InstallButton)

# Activate the form once
$Form.Add_Shown({ $Form.Activate() })
[void] $Form.ShowDialog()

# Reset some global flags
$global:update = $false
$global:install = $false

# Loop to keep the GUI open
do {
    # Reset flags each loop
    $global:update = $false
    $global:install = $false

    # Show the form
    [void] $Form.ShowDialog()

    # Handle updates
    if ($global:update) {
        $updatePackages = [System.Collections.ArrayList]::new()
        $Form.Controls | Where-Object { $_ -is [System.Windows.Forms.Checkbox] -and $_.Checked } | ForEach-Object {
            [void]$updatePackages.Add($_.Name)
        }

        if ($updatePackages.Count -ne 0) {
            Write-Host "Updating: " -ForegroundColor Yellow
            foreach ($a in $updatePackages) {
                Write-Host "- " -NoNewline -ForegroundColor Blue
                Write-Host "$a"
            }
            Start-Sleep 1
            foreach ($package in $updatePackages) {
                & winget upgrade -e --id $package --accept-package-agreements --accept-source-agreements --disable-interactivity -h
            }
            Read-MessageBox -Title "Update complete" -Body 'Selected packages have been updated' -Icon Information -Buttons Ok | Out-Null
        }
    }

    # Handle installs
    if ($global:install) {
        $installPackages = [System.Collections.ArrayList]::new()
        $Form.Controls | Where-Object { $_ -is [System.Windows.Forms.Checkbox] -and $_.Checked } | ForEach-Object {
            [void]$installPackages.Add($_.Name)
        }

        if ($installPackages.Count -ne 0) {
            Write-Host "Installing: " -ForegroundColor Yellow
            foreach ($a in $installPackages) {
                Write-Host "- " -NoNewline -ForegroundColor Blue
                Write-Host "$a"
            }
            Start-Sleep 1
            foreach ($package in $installPackages) {
                & winget install -e --id $package --accept-package-agreements --accept-source-agreements --disable-interactivity --force -h
            }
            Read-MessageBox -Title "Install complete" -Body 'Selected packages have been installed' -Icon Information -Buttons Ok | Out-Null
        }
    }

    # Reset all checkboxes for next round
    foreach ($cb in $Form.Controls | Where-Object { $_ -is [System.Windows.Forms.Checkbox] }) { $cb.Checked = $false }

} while ($true)