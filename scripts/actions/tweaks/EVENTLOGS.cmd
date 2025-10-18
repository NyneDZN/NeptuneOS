@echo off
:: https://privacy.sexy — v0.13.8 — Thu, 02 Oct 2025 19:57:19 GMT
:: Initialize environment
setlocal EnableExtensions DisableDelayedExpansion


:: ----------------------------------------------------------
:: -------Clear event logs in Event Viewer application-------
:: ----------------------------------------------------------
echo --- Clear event logs in Event Viewer application
REM https://social.technet.microsoft.com/Forums/en-US/f6788f7d-7d04-41f1-a64e-3af9f700e4bd/failed-to-clear-log-microsoftwindowsliveidoperational-access-is-denied?forum=win10itprogeneral
wevtutil sl Microsoft-Windows-LiveId/Operational /ca:O:BAG:SYD:(A;;0x1;;;SY)(A;;0x5;;;BA)(A;;0x1;;;LA)
for /f "tokens=*" %%i in ('wevtutil.exe el') DO (
    echo Deleting event log: "%%i"
    wevtutil.exe cl %1 "%%i"
)
:: ----------------------------------------------------------

:: Restore previous environment settings
endlocal