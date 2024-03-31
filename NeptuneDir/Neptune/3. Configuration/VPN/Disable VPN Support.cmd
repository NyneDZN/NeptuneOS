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

:: Disabling VPN
%WinDir%\NeptuneDir\Tools\dmv.exe /disable "WAN Miniport (IKEv2)" >nul 2>&1 
%WinDir%\NeptuneDir\Tools\dmv.exe /disable "WAN Miniport (IP)" >nul 2>&1 
%WinDir%\NeptuneDir\Tools\dmv.exe /disable "WAN Miniport (IPv6)" >nul 2>&1 
%WinDir%\NeptuneDir\Tools\dmv.exe /disable "WAN Miniport (L2TP)" >nul 2>&1 
%WinDir%\NeptuneDir\Tools\dmv.exe /disable "WAN Miniport (Network Monitor)" >nul 2>&1 
%WinDir%\NeptuneDir\Tools\dmv.exe /disable "WAN Miniport (PPPOE)" >nul 2>&1 
%WinDir%\NeptuneDir\Tools\dmv.exe /disable "WAN Miniport (PPTP)" >nul 2>&1 
%WinDir%\NeptuneDir\Tools\dmv.exe /disable "WAN Miniport (SSTP)" >nul 2>&1 
%WinDir%\NeptuneDir\Tools\dmv.exe /disable "NDIS Virtual Network Adapter Enumerator" >nul 2>&1 
%WinDir%\NeptuneDir\Tools\dmv.exe /disable "Microsoft RRAS Root Enumerator" >nul 2>&1 

%WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Services\IKEEXT" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1 
%WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Services\WinHttpAutoProxySv" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1 
%WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Services\RasMan" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1 
%WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Services\SstpSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1 
%WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Services\iphlpsvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1 
%WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Services\NdisVirtualBus" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1 
%WinDir%\NeptuneDir\Tools\PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Services\Eaphost" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1 
echo VPN Support disabled.
pause>nul

