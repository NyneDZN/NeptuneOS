# actions/power-settings.ps1
# NeptuneOS Power Settings Optimizer v1.0
# Converts original batch powercfg tweaks to PowerShell

# -----------------------
# Unhide Hidden Power Settings
# -----------------------
Write-Log "Unhiding hidden power settings..."
$PowerCfgKeys = Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings' -Recurse |
                Where-Object { $_.Name -notmatch '\bDefaultPowerSchemeValues|(\\[0-9]|\b255)$' }

foreach ($item in $PowerCfgKeys) {
    try { Set-ItemProperty -Path $item.PSPath -Name 'Attributes' -Value 0 -Force } 
    catch { Write-Log "Failed to unhide $($item.PSPath): $_" "ERROR" }
}

# -----------------------
# Import and Activate NeptuneOS Power Plan
# -----------------------
$PlanGuid = "11111111-1111-1111-1111-111111111111"
$PowerPlanPath = "$env:WinDir\NeptuneDir\Prerequisites\power.pow"

Write-Log "Importing NeptuneOS power plan..."
powercfg -import $PowerPlanPath $PlanGuid | ForEach-Object { Write-Log $_ }

Write-Log "Setting NeptuneOS power plan as active..."
powercfg -setactive $PlanGuid | ForEach-Object { Write-Log $_ }

Write-Log "Renaming NeptuneOS power plan..."
powercfg -changename $PlanGuid "NeptuneOS Powerplan 4.0." "A powerplan created to achieve low latency and high 0.01% lows." | ForEach-Object { Write-Log $_ }

# -----------------------
# Remove Stock Windows Power Plans
# -----------------------
$StockPlans = @(
    "a1841308-3541-4fab-bc81-f71556f20b4a",
    "381b4222-f694-41f0-9685-ff5bb260df2e",
    "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c",
    "e9a42b02-d5df-448d-aa00-03f14749eb61"
)
foreach ($plan in $StockPlans) {
    Write-Log "Deleting stock power plan $plan..."
    powercfg -delete $plan | ForEach-Object { Write-Log $_ }
}

# -----------------------
# Hard Disk & NVMe Settings
# -----------------------
Write-Log "Configuring hard disk and NVMe idle timeouts..."
$HardDiskGuid = "0012ee47-9041-4b5d-9b77-535fba8b1442"
$PrimaryNvme  = "d639518a-e56d-4345-8af2-b9f32fb26109"
$SecondaryNvme= "d3d55efd-c1ff-424e-9dc3-441be7833010"
$NvmeNopPme   = "fc7372b6-ab2d-43ee-8797-15e9841f2cca"

powercfg -setacvalueindex $PlanGuid $HardDiskGuid 6738e2c4-e8a5-4a42-b16a-e040e769756e 0 | ForEach-Object { Write-Log $_ }
powercfg -setacvalueindex $PlanGuid $HardDiskGuid $SecondaryNvme 0 | ForEach-Object { Write-Log $_ }
powercfg -setacvalueindex $PlanGuid $HardDiskGuid $PrimaryNvme 0 | ForEach-Object { Write-Log $_ }
powercfg -setacvalueindex $PlanGuid $HardDiskGuid $NvmeNopPme 0 | ForEach-Object { Write-Log $_ }

# -----------------------
# USB & Sleep Settings
# -----------------------
Write-Log "Configuring USB and sleep settings..."
$UsbGuid      = "2a737441-1930-4402-8d77-b2bebba308a3"
$HubSuspend   = "0853a681-27c8-4100-a2fd-82013e970683"
$UsbSuspend   = "48e6b7a6-50f5-4782-a5d4-53bb8f07e226"
$Usb3Perf     = "d4e98f31-5ffe-4ce1-be31-1b38b384c009"
$DeepSleep    = "d502f7ee-1dc7-4efd-a55d-f04b6f5c0545"
$AwayMode     = "25dfa149-5dd1-4736-b5ab-e8a37b5b8187"
$IdleStates   = "abfc2519-3608-4c2a-94ea-171b0ed546ab"
$HybridSleep  = "94ac6d29-73ce-41a6-809f-6363ba21b47e"
$Unattended   = "7bc4a2f9-d8fc-4469-b07b-33eb785aaca0"
$WakeTimers   = "bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d"
$SleepPlanGuid= "238c9fa8-0aad-41ed-83f4-97be242c8f20"

$UsbSleepSettings = @(
    @{Guid=$HubSuspend; Value=0},
    @{Guid=$UsbSuspend; Value=0},
    @{Guid=$Usb3Perf; Value=0}
)
foreach ($s in $UsbSleepSettings) {
    powercfg -setacvalueindex $PlanGuid $UsbGuid $($s.Guid) $($s.Value) | ForEach-Object { Write-Log $_ }
}

$SleepSettings = @(
    @{Guid=$DeepSleep; Value=0},
    @{Guid=$AwayMode; Value=0},
    @{Guid=$IdleStates; Value=0},
    @{Guid=$HybridSleep; Value=0},
    @{Guid=$Unattended; Value=0},
    @{Guid=$WakeTimers; Value=0}
)
foreach ($s in $SleepSettings) {
    powercfg -setacvalueindex $PlanGuid $SleepPlanGuid $($s.Guid) $($s.Value) | ForEach-Object { Write-Log $_ }
    powercfg -setdcvalueindex $PlanGuid $SleepPlanGuid $($s.Guid) $($s.Value) | ForEach-Object { Write-Log $_ }
}

# -----------------------
# Display & Battery Settings
# -----------------------
Write-Log "Configuring display and battery..."
$DisplayGuid  = "7516b95f-f776-4464-8c53-06167f40cc99"
$DisplayOff   = "3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e"
$BatteryGuid  = "e73a048d-bf27-4f12-9731-8b2076e8891f"
$BatterySettings = @(
    @{Guid="5dbb7c9f-38e9-40d2-9749-4f8a0e9f640f"; Value=0},
    @{Guid="637ea02f-bbcb-4015-8e2c-a1c7b9c0b546"; Value=0},
    @{Guid="8183ba9a-e910-48da-8769-14ae6dc1170a"; Value=0},
    @{Guid="9a66d8d7-4ff7-4ef9-b5a2-5a326ca2a469"; Value=0},
    @{Guid="bcded951-187b-4d05-bccc-f7e51960c258"; Value=0},
    @{Guid="f3c5027d-cd16-4930-aa6b-90db844a8f00"; Value=0}
)

powercfg -setacvalueindex $PlanGuid $DisplayGuid $DisplayOff 0 | ForEach-Object { Write-Log $_ }
foreach ($b in $BatterySettings) {
    powercfg -setacvalueindex $PlanGuid $BatteryGuid $($b.Guid) $($b.Value) | ForEach-Object { Write-Log $_ }
}

# -----------------------
# Processor & Performance Settings
# -----------------------
Write-Log "Configuring CPU performance..."
$ProcessorGuid = "sub_processor"
$CpuSettings = @(
    @{Sub="PROCTHROTTLEMIN"; Value=100},
    @{Sub="PROCTHROTTLEMAX"; Value=100},
    @{Sub="06cadf0e-64ed-448a-8927-ce7bf90eb35d"; Value=1},
    @{Sub="12a0ab44-fe28-4fa9-b3bd-4b64f44960a6"; Value=1},
    @{Sub="7b224883-b3cc-4d79-819f-8374152cbe7c"; Value=100},
    @{Sub="4b92d758-5a24-4851-a470-815d78aee119"; Value=100},
    @{Sub="PERFBOOSTMODE"; Value=2},
    @{Sub="PERFBOOSTPOL"; Value=100},
    @{Sub="SHORTSCHEDPOLICY"; Value=2}
)  
