@echo off
setlocal DisableDelayedExpansion

:: ===================================================
:: NeptuneOS ANSI and Environment Variable Definitions
:: ===================================================

:: Safe way to get ESC (no forfiles dependency)
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

:: --- Formatting and color codes ---
set "RESET=%ESC%[0m"
set "UNDERLINE=%ESC%[4m"
set "_UNDERLINE=%ESC%[24m"

set "S_RED=%ESC%[91m"
set "S_GREEN=%ESC%[92m"
set "S_YELLOW=%ESC%[93m"
set "S_MAGENTA=%ESC%[95m"
set "S_WHITE=%ESC%[97m"
set "S_GRAY=%ESC%[90m"
set "RED=%ESC%[31m"

set "B_BLACK=%ESC%[40m"
set "B_YELLOW=%ESC%[43m"

set "right=%ESC%[<x>C"
set "bullet=%ESC%[34m-%ESC%[0m"

:: --- Neptune internal paths ---
set "INITneptdir=C:\neptune-installer"
set "prereqDir=C:\neptune-installer\prerequisites"
set "neptlog=%WinDir%\NeptuneDir\neptune.log"
set "neptdir=%WinDir%\NeptuneDir"
set "dmv=%WinDir%\NeptuneDir\Tools\dmv.exe"
set "svcF=call %WinDir%\NeptuneDir\Scripts\setSvc.cmd"
set "delf=del /f /s /q"
set "PowerShell=%WinDir%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProf -NonI -NoL -EP Bypass -C"
set "currentuser=C:\neptune-installer\tools\NSudoLG.exe -U:C -P:E -ShowWindowMode:Hide -Wait"

:: --- Determine Windows version ---
for /f "tokens=6 delims=[.] " %%a in ('ver') do set "win_version=%%a"
if %win_version% lss 22000 (
    set "os=Windows 10"
) else (
    set "os=Windows 11"
)
for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "DisplayVersion" 2^>nul') do set "releaseid=%%a"
for /f "tokens=4-7 delims=[.] " %%a in ('ver') do set "build=%%a.%%b.%%c.%%d"

:: --- Get current user SID ---
for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "(Get-CimInstance Win32_UserAccount | Where-Object { $_.Name -eq $env:USERNAME -and $_.LocalAccount }) | Select-Object -ExpandProperty SID"`) do set "SID=%%A"

:: ===================================================
:: Export all variables back to parent scope
:: ===================================================
(
    endlocal
    set "ESC=%ESC%"
    set "RESET=%RESET%"
    set "UNDERLINE=%UNDERLINE%"
    set "_UNDERLINE=%_UNDERLINE%"
    set "S_RED=%S_RED%"
    set "S_GREEN=%S_GREEN%"
    set "S_YELLOW=%S_YELLOW%"
    set "S_MAGENTA=%S_MAGENTA%"
    set "S_WHITE=%S_WHITE%"
    set "S_GRAY=%S_GRAY%"
    set "RED=%RED%"
    set "B_BLACK=%B_BLACK%"
    set "B_YELLOW=%B_YELLOW%"
    set "right=%right%"
    set "bullet=%bullet%"
    set "INITneptdir=%INITneptdir%"
    set "prereqDir=%prereqDir%"
    set "neptlog=%neptlog%"
    set "neptdir=%neptdir%"
    set "dmv=%dmv%"
    set "svcF=%svcF%"
    set "delf=%delf%"
    set "PowerShell=%PowerShell%"
    set "currentuser=%currentuser%"
    set "os=%os%"
    set "releaseid=%releaseid%"
    set "build=%build%"
    set "SID=%SID%"
)
