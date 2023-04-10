@echo off
call :AGREED
if "%AGREED%" EQU "FALSE" (
	echo NOBODY IS RESPONSIBLE FOR DAMAGE CAUSED TO YOUR OPERATING SYSTEM OR COMPUTER. RUN AT YOUR OWN RISK
	echo.
	pause
	>> "%~f0" echo set AGREED=TRUE
)
cls
echo Enabling DWM...
pssuspend -r winlogon > NUL 2>&1
copy /y "%windir%\NeptuneDir\Other\dwm\realdwm\dwm.exe" "%windir%\System32" > NUL 2>&1
timeout 1 > NUL 2>&1
REN "%windir%\System32\UIRibbon.old" "UIRibbon.dll" > NUL 2>&1
REN "%windir%\System32\UIRibbonRes.old" "UIRibbonRes.dll" > NUL 2>&1
REN "%windir%\System32\Windows.UI.Logon.old" "Windows.UI.Logon.dll" > NUL 2>&1
shutdown /r /f /t 0
exit /b

:AGREED
set AGREED=FALSE
set AGREED=TRUE
