@echo off
title Oculus VR

:: Init
call "%WinDir%\NeptuneDir\Scripts\envINIT.cmd"

:: Run as administrator
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

:: (Configuration snippet here)
%svcF% KSecPkg 4
%svcF% LanmanWorkstation 4
%svcF% mrxsmb 4
%svcF% mrxsmb20 4
%svcF% rdbss 4
%svcF% srv2 4
%svcF% QwaveDrv 4
%svcF% Qwave 3
%svcF% FontCache 4

:: Echo back to user
echo]
echo %S_GREEN%Disabled Oculus VR%S_GREEN%
echo]
echo %S_WHITE%Press any key to exit...%S_WHITE%
pause > nul
exit /b