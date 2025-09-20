:: To call this script:
:: cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul
@echo off
cd /d "%~dp0"
for /f %%a in ('forfiles /m "%~nx0" /c "cmd /c echo 0x1B"') do set "ESC=%%a"
set "right=%ESC%[<x>C"
set "bullet= %ESC%[34m-%ESC%[0m"
set "CMDLINE=RED=[31m,S_GRAY=[90m,S_RED=[91m,S_GREEN=[92m,S_YELLOW=[93m,S_MAGENTA=[95m,S_WHITE=[97m,B_BLACK=[40m,B_YELLOW=[43m,UNDERLINE=[4m,_UNDERLINE=[24m"
set "%CMDLINE:,=" & set "%"
set neptlog=%WinDir%\NeptuneDir\neptune.txt
set userlog=%WinDir%\NeptuneDir\user.txt
set DevMan="%WinDir%\NeptuneDir\Tools\dmv.exe"
set svcF=call C:\Windows\NeptuneDir\Scripts\setSvc.cmd
set delf=del /f /s /q

:: Configure variables for determining winver
:: - %os% - Windows 10 or 11
:: - %releaseid% - release ID (21H2, 22H2)
:: - %build% - current build of Windows (like 10.0.19044.1889)
for /f "tokens=6 delims=[.] " %%a in ('ver') do (set "win_version=%%a")
if %win_version% lss 22000 (set os=Windows 10) else (set os=Windows 11)
for /f "tokens=3" %%a in ('Reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "DisplayVersion"') do (set releaseid=%%a)
for /f "tokens=4-7 delims=[.] " %%a in ('ver') do (set "build=%%a.%%b.%%c.%%d")