@echo off
call :AGREED
if "%AGREED%" EQU "FALSE" (
	echo NOBODY IS RESPONSIBLE FOR DAMAGE CAUSED TO YOUR OPERATING SYSTEM OR COMPUTER. RUN AT YOUR OWN RISK
	echo.
	pause
	>> "%~f0" echo set AGREED=TRUE
)
cls
echo Disabling DWM...
pssuspend -r winlogon > NUL 2>&1
timeout 1 > NUL 2>&1
pssuspend winlogon > NUL 2>&1
timeout 1 > NUL 2>&1
taskkill /F /IM dwm.exe > NUL 2>&1
timeout 1 > NUL 2>&1
copy /y "%windir%\NeptuneDir\Other\dwm\fakedwm\dwm.exe" "%windir%\System32" > NUL 2>&1
REN "%windir%\System32\UIRibbon.dll" "UIRibbon.old" > NUL 2>&1
REN "%windir%\System32\UIRibbonRes.dll" "UIRibbonRes.old" > NUL 2>&1
REN "%windir%\System32\Windows.UI.Logon.dll" "Windows.UI.Logon.old" > NUL 2>&1
REN "%windir%\System32\RuntimeBroker.exe" "RuntimeBroker.old" > NUL 2>&1
REN "%windir%\SystemApps\ShellExperienceHost_cw5n1h2txyewy\ShellExperienceHost.exe" "ShellExperienceHost.old" > NUL 2>&1
pssuspend -r winlogon > NUL 2>&1
shutdown /r /f /t 0
exit /b

:AGREED
set AGREED=FALSEset AGREED=TRUE
