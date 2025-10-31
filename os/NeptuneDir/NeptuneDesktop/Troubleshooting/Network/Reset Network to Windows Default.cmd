@echo off
title Windows Default Network

:: Init
call "%WinDir%\NeptuneDir\Scripts\envINIT.cmd"

:: Call Administrator
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select 'Run as administrator'.
        pause & exit 1
    )
    exit 0
)

echo Resetting network settings to Windows defaults...

(
	netsh int ip reset
	netsh interface ipv4 reset
	netsh interface ipv6 reset
	netsh interface tcp reset
	netsh winsock reset
) > nul


echo %S_GREEN%Finished, please reboot your device for changes to apply.%S_GREEN%
echo]
pause