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

:: Enable VR services and drivers
%svcF% KSecPkg 0
%svcF% LanmanWorkstation 2
%svcF% mrxsmb 3
%svcF% mrxsmb20 3
%svcF% rdbss 1
%svcF% srv2 3
%svcF% QwaveDrv 3
%svcF% Qwave 3
%svcF% FontCache 2

:: Echo back to user
echo]
echo %S_GREEN%Enabled Oculus VR%S_GREEN%
echo]
echo %S_WHITE%Press any key to exit...%S_WHITE%
pause > nul
exit /b