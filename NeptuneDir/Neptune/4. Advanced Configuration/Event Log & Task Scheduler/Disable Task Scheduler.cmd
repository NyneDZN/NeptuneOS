@echo off
setlocal EnableDelayedExpansion
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul

:: Call Administrator
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select 'Run as administrator'.
        pause & exit 1
    )
    exit 0
)

echo !S_YELLOW!Disclaimer:
echo]
echo !S_RED!Disabling Task Scheduler will break MSI Afterburner startup and numerous other things.
choice /C YN /M "Are you sure you want to continue?"
if errorlevel 2 (
    goto Nope
) else (
    goto DisableTaskSched
)




:DisableTaskSched
%svcF% Schedule 4
exit


:Nope
exit