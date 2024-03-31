@echo off

:: Check if script is escelated
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if %errorlevel% neq 0 (
    echo You are about to be prompted with the UAC. Please click yes when prompted.
) ELSE (
    goto admin
)

:prompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\prompt.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\prompt.vbs"
    "%temp%\prompt.vbs"
    exit /B

:admin
:: Delete prompt script
if exist "%temp%\prompt.vbs" ( del "%temp%\prompt.vbs" )

:: Enable Microsoft Store
sc config InstallService start=demand
sc config mpssvc start=auto
sc config wlidsvc start=demand
sc config AppXSvc start=demand
sc config BFE start=auto
sc config TokenBroker start=demand
sc config LicenseManager start=demand
sc config wuauserv start=demand
sc config AppXSVC start=demand
sc config ClipSVC start=demand
sc config FileInfo start=boot
sc config FileCrypt start=system
sc config usosvc start=auto
%WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "2" /f 
%WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\mpsdrv" /v "Start" /t REG_DWORD /d "3" /f 
%WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "2" /f 
%WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d "2" /f 
cls
echo The store has been enabled. Please restart.
pause