@echo off
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul
setlocal EnableDelayedExpansion

:: Call Administrator
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select 'Run as administrator'.
        pause & exit 1
    )
    exit 0
)


echo.  Disabling the Microsoft System Management BIOS will cause certain applications to misbehave.
echo]
echo]
echo.  GTA 5 will not work.


echo.	Press 1 to Enable
echo.	Press 2 to Disable
echo.
set /p c="Enter your answer: "
if /i %c% equ 1 goto :enable
if /i %c% equ 2 goto :disable

:disable
%WinDir%\neptunedir\tools\dmv.exe /disable "Microsoft System Management BIOS Driver" > nul
%svcF% mssmbios 4

:enable
%WinDir%\neptunedir\tools\dmv.exe /enable "Microsoft System Management BIOS Driver" > nul
%svcF% mssmbios 1