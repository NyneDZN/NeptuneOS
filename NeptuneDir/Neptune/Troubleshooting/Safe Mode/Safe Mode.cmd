@echo off

:: Call Administrator
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select 'Run as administrator'.
        pause & exit 1
    )
    exit 0
)

bcdedit /set {current} safeboot minimal

echo Safe Boot Enabled. Restart your device to apply changes.
timeout /t 3 /nobreak >nul