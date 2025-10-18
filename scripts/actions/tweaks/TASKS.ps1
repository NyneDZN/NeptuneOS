# ========================
# Task Scheduling Cleanup
# ========================

# List of scheduled tasks to disable
$TasksToDisable = @(
    ""
    "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
    "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319"
    "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64"
    "\Microsoft\Windows\Application Experience\PcaPatchDbTask"
    "\Microsoft\Windows\Application Experience\StartupAppTask"
    "\Microsoft\Windows\ApplicationData\appuriverifierdaily"
    "\Microsoft\Windows\ApplicationData\appuriverifierinstall"
    "\Microsoft\Windows\ApplicationData\DsSvcCleanup"
    "\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask"
    "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
    "\Microsoft\Windows\Defrag\ScheduledDefrag"
    "\Microsoft\Windows\Device Setup\Metadata Refresh"
    "\Microsoft\Windows\Diagnosis\Scheduled"
    "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
    "\Microsoft\Windows\DiskFootprint\Diagnostics"
    "\Microsoft\Windows\InstallService\ScanForUpdates"
    "\Microsoft\Windows\InstallService\ScanForUpdatesAsUser"
    "\Microsoft\Windows\InstallService\SmartRetry"
    "\Microsoft\Windows\International\Synchronize Language Settings"
    "\Microsoft\Windows\Maintenance\WinSAT"
    "\Microsoft\Windows\Management\Provisioning\Cellular"
    "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic"
    "\Microsoft\Windows\MUI\LPRemove"
    "\Microsoft\Windows\PI\Sqm-Tasks"
    "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"
    "\Microsoft\Windows\Printing\EduPrintProv"
    "\Microsoft\Windows\PushToInstall\LoginCheck"
    "\Microsoft\Windows\Ras\MobilityManager"
    "\Microsoft\Windows\Registry\RegIdleBackup"
    "\Microsoft\Windows\RetailDemo\CleanupOfflineContent"
    "\Microsoft\Windows\Shell\FamilySafetyMonitor"
    "\Microsoft\Windows\Shell\FamilySafetyRefresh"
    "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance"
    "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskNetwork"
    "\Microsoft\Windows\StateRepository\MaintenanceTasks"
    "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime"
    "\Microsoft\Windows\Time Synchronization\SynchronizeTime"
    "\Microsoft\Windows\Time Zone\SynchronizeTimeZone"
    "\Microsoft\Windows\UpdateOrchestrator\Report policies"
    "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task"
    "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan"
    "\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker"
    "\Microsoft\Windows\UPnP\UPnPHostConfig"
    "\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange"
    "\Microsoft\Windows\WindowsUpdate\Scheduled Start"
    "\Microsoft\Windows\Wininet\CacheTask"
    "\Microsoft\XblGameSave\XblGameSaveTask"
    "\Microsoft\Windows\ExploitGuard\ExploitGuard MDM policy Refresh"
    "\MicrosoftEdgeUpdateTaskMachineUA"
    "\MicrosoftEdgeUpdateTaskMachineCore"
)

# Disable all tasks in the list
foreach ($taskPath in $TasksToDisable) {
    try {
        if ($taskPath -eq "") { continue }  # Skip empty entries
        Write-Log "Disabling scheduled task: $taskPath"
        schtasks.exe /change /disable /TN $taskPath | Out-Null
    } catch {
        Write-Log "Failed to disable task $taskPath $($_.Exception.Message)" "ERROR"
    }
}

# Enable Storage Sense
try {
    Write-Log "Enabling Storage Sense task"
    schtasks.exe /change /enable /TN "\Microsoft\Windows\DiskCleanup\SilentCleanup" | Out-Null
} catch {
    Write-Log "Failed to enable Storage Sense task: $($_.Exception.Message)" "ERROR"
}

# Disable OneDrive Tasks using pattern matching
$OneDrivePatterns = @(
    "OneDrive Reporting Task-*",
    "OneDrive Standalone Update Task-*",
    "OneDrive Per-Machine Standalone Update"
)

foreach ($pattern in $OneDrivePatterns) {
    $tasks = Get-ScheduledTask -TaskPath '\' -TaskName $pattern -ErrorAction SilentlyContinue
    if (-not $tasks) {
        Write-Log "Skipping, no tasks matching pattern '$pattern' found."
        continue
    }

    foreach ($task in $tasks) {
        if ($task.State -eq 'Disabled') {
            Write-Log "Task '$($task.TaskName)' already disabled."
            continue
        }

        try {
            Disable-ScheduledTask -InputObject $task -ErrorAction Stop
            Write-Log "Successfully disabled task '$($task.TaskName)'."
        } catch {
            Write-Log "Failed to disable task '$($task.TaskName)': $($_.Exception.Message)" "ERROR"
        }
    }
}
