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
echo.  Disabling msisadrv will break laptop mice and keyboards.
echo]
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
%svcF% msisadrv 4
%DevMan% /disable "PCI standard ISA bridge"
exit

:enable
%svcF% msisadrv 0
%DevMan% /enable "PCI standard ISA bridge"
exit