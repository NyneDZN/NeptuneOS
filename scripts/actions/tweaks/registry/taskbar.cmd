:: ==================================
:: === Taskbar Related (add rest) ===
:: ==================================

:: Unpin "Cast"
reg add "HKCU\Control Panel\Quick Actions\Control Center\Unpinned" /v "Microsoft.QuickAction.Cast" /t REG_NONE /f

:: Unpin "Near Share"
reg add "HKCU\Control Panel\Quick Actions\Control Center\Unpinned" /v "Microsoft.QuickAction.NearShare" /t REG_NONE /f

:: Set toggles state
reg add "HKCU\Control Panel\Quick Actions\Control Center\QuickActionsStateCapture" /v "Toggles" /t REG_SZ /d "Toggles,Microsoft.QuickAction.BlueLightReduction:false,Microsoft.QuickAction.Accessibility:false,Microsoft.QuickAction.ProjectL2:false" /f
