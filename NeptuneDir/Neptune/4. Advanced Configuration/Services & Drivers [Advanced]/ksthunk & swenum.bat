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
echo.  Disabling ksthunk & swenum will break Webcams.
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
reg add "HKLM\SYSTEM\CurrentControlSet\services\swenum" /v "Start" /t REG_DWORD /d "4" /f
reg delete "HKLM\System\CurrentControlSet\Control\Class\{4D36E96C-E325-11CE-BFC1-08002BE10318}" /v "UpperFilters" /f
reg delete "HKLM\System\CurrentControlSet\Control\Class\{6BDD1FC6-810F-11D0-BEC7-08002BE2092F}" /v "UpperFilters" /f
reg add "HKLM\System\CurrentControlSet\services\ksthunk" /v "Start" /t REG_DWORD /d "4" /f
%DevMan%  /disable "Plug and Play Software Device Enumerator"
exit

:enable
@echo off
reg add "HKLM\SYSTEM\CurrentControlSet\services\swenum" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\System\CurrentControlSet\Control\Class\{4D36E96C-E325-11CE-BFC1-08002BE10318}" /v "UpperFilters" /t REG_MULTI_SZ /d "ksthunk" /f
reg add "HKLM\System\CurrentControlSet\Control\Class\{6BDD1FC6-810F-11D0-BEC7-08002BE2092F}" /v "UpperFilters" /t REG_MULTI_SZ /d "ksthunk" /f
reg add "HKLM\System\CurrentControlSet\services\ksthunk" /v "Start" /t REG_DWORD /d "3" /f
%DevMan% /enable "Plug and Play Software Device Enumerator"
exit