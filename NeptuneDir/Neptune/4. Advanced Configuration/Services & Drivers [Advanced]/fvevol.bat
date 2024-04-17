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


echo.  Disabling fvevol will break MSConfig and Disk Management.
echo]
echo]
echo.  Use this with caution.


echo.	Press 1 to Enable
echo.	Press 2 to Disable
echo.
set /p c="Enter your answer: "
if /i %c% equ 1 goto :enable
if /i %c% equ 2 goto :disable

:disable
reg delete "HKLM\System\ControlSet001\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /f
%svcF% fvevol 4
exit


:enable
reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ /d "fvevol" /f
reg add "HKLM\SYSTEM\ControlSet001\Services\fvevol" /v "Start" /t REG_DWORD /d "0" /f
exit
