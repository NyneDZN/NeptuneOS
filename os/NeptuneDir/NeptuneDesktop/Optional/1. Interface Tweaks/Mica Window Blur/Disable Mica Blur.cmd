@echo off

title Asking for administrator access
color F0
echo :::::::::::::::::::::::::::::::::::::
echo :: Requesting administrator access ::
echo :::::::::::::::::::::::::::::::::::::
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && ""%~s0"" %Apply%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
color
cls

title Uninstalling
call :isAdmin
if %errorlevel% == 0 (
	regsvr32 /u "%WinDir%\NeptuneDir\Tools\ExplorerMicaBlur\ExplorerBlurMica.dll"
    echo.
) else (
	echo Please run as Administrator
)

echo Restarting explorer
taskkill /F /IM explorer.exe >nul
start explorer.exe
echo .
echo title Success
echo Changes applied successfully
pause

:isAdmin
fsutil dirty query %systemdrive% >nul
exit /b %errorlevel%