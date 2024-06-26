:: Forked from Atlas

@echo off

:: Call Administrator
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select 'Run as administrator'.
        pause & exit 1
    )
    exit 0
)

:: https://winaero.com/how-to-disable-windows-8-boot-logo-spining-icon-and-some-other-hidden-settings

echo This will disable boot messages during boot, such as "Please wait", "Updating registry - 10%" and so on.
echo Generally not recommended as they only show when they need to tell you something.
echo]
echo What would you like to do?
echo [1] Disable boot messages
echo [2] Enable boot messages (default)
echo]
choice /c 12 /n /m "Type 1 or 2: "
if %ERRORLEVEL% == 1 (
	goto disable
) else (
	goto enable
)

:disable
bcdedit /set {globalsettings} custom:16000068 true > nul
goto finish

:enable
bcdedit /deletevalue {globalsettings} custom:16000068 > nul 2>&1
goto finish

:finish
echo]
echo Finished, please reboot your device for changes to apply.
pause
exit /b