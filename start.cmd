@echo off
SETLOCAL EnableDelayedExpansion
echo DO NOT CLOSE THIS WINDOW. PLEASE WAIT UNTIL YOUR PC RESTARTS.

:start
set success=
%WinDir%\NeptuneDir\Tools\NSudoLG.exe -U:T -P:E -Wait %WinDir%\NeptuneDir\neptune-master.cmd /postinstall

:: read from success file
set /p success= < C:\Users\Public\success.txt

:: check if script is finished
if %success% equ true goto success

:: if not, restart script
echo POST INSTALL SCRIPT CLOSED^^!
echo Relaunching...
goto start

:success
del /f /q "C:\Users\Public\success.txt"
shutdown /r /f /t 10 /c "POST-INSTALL: Reboot is required..."
DEL "%~f0"
exit