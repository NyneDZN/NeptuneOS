@echo off

set "___args="%~f0" %*"
fltmc > nul 2>&1 || (
    echo Administrator privileges are required.
    powershell -c "Start-Process -Verb RunAs -FilePath 'cmd' -ArgumentList """/c $env:___args"""" 2> nul || (
        echo You must run this script as admin.
        if "%*"=="" pause
        exit /b 1
    )
    exit /b
)


if not "%~1"=="/silent" call "%windir%\NeptuneDir\Scripts\serviceWarning.cmd" %*

call "%windir%\NeptuneDir\Scripts\setSvc.cmd" KSecPkg 4
call "%windir%\NeptuneDir\Scripts\setSvc.cmd" LanmanServer 4
call "%windir%\NeptuneDir\Scripts\setSvc.cmd" LanmanWorkstation 4
call "%windir%\NeptuneDir\Scripts\setSvc.cmd" mrxsmb 4
call "%windir%\NeptuneDir\Scripts\setSvc.cmd" mrxsmb20 4
call "%windir%\NeptuneDir\Scripts\setSvc.cmd" rdbss 3
call "%windir%\NeptuneDir\Scripts\setSvc.cmd" srv2 4

DISM /Online /Disable-Feature /FeatureName:"SmbDirect" /NoRestart
if "%~1"=="/silent" exit /b

echo]
echo Finished, please reboot your device for changes to apply.
pause
exit /b