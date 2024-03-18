@echo off
set svc=call :setSvc

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


echo. Please open the README.txt if you have not already.
echo. If you accidentally applied this, please open the Neptune folder and run "Troubleshooting\windows-default-services.Reg"


echo.   Press 1 to Apply
echo.   Press 2 to Exit
echo.
set /p c="Enter your answer: "
if /i %c% equ 1 goto :go
if /i %c% equ 2 goto :closed

:go
%svc% 3ware 4
%svc% acpipagr 4
%svc% ADP80XX 4
%svc% amdgpio2 4
%svc% AmdK8 4
%svc% AsyncMac 4
%svc% BDESVC 4
%svc% Beep 4
%svc% bindflt 4
%svc% BITS 4
%svc% BluetoothUserService 4
%svc% iaStorAVC 4
%svc% vsmraid 4
%svc% b06bdrv 4
%svc% BTAGService 4
%svc% BthA2dp 4
%svc% BthAvctpSvc 4
%svc% BthEnum 4
%svc% BthHFEnum 4
%svc% bthleenum 4
%svc% BTHMODEM 4
%svc% bthserv 4
%svc% cdrom 4
%svc% CLFS 4
%svc% dam 4
%svc% Dfsc 4
%svc% diagsvc 4
%svc% DiagTrack 4
%svc% DispBrokerDesktopSvc 4
%svc% DisplayEnhancementService 4
%svc% DPS 4
%svc% DusmSvc 4
%svc% edgeupdate 4
%svc% edgeupdatem 4
%svc% EventLog 4
%svc% EventSystem 4
%svc% flpydisk 4
%svc% FontCache 4
%svc% FontCache3.0.0.0 4
%svc% GPIOClx0101 4
%svc% GpuEnergyDrv 4
%svc% HvHost 4
%svc% IKEEXT 4
%svc% IntelPMT 4
%svc% iphlpsvc 4
%svc% KSecPkg 4
%svc% LanManServer 4
%svc% LanmanWorkstation 4
%svc% lfsvc 4
%svc% lltdio 4
%svc% lmhosts 4
%svc% MapsBroker 4
%svc% microsoft_bluetooth_avrcptransport 4
%svc% mrxsmb 4
%svc% mrxsmb20 4
%svc% MSDTC 4
%svc% MsLldp 4
%svc% MsSecCore 4
%svc% NdisCap 4
%svc% NdisTapi 4
%svc% NdisWan 4
%svc% ndiswanlegacy 4
%svc% Ndu 4
%svc% NetBIOS 4
%svc% NetBT 4
%svc% npsvctrig 4
%svc% PEAUTH 4
%svc% PptpMiniport 4
%svc% PrintNotify 4
%svc% PRM 4
%svc% RasAgileVpn 4
%svc% Rasl2tp 4
%svc% RasMan 4
%svc% RasPppoe 4
%svc% RasSstp 4
%svc% rdyboost 4
%svc% RFCOMM 4
%svc% RmSvc 4
%svc% rspndr 4
%svc% Schedule 4
%svc% SecurityHealthService 4
%svc% Sense 4
%svc% SgrmAgent 4
%svc% SgrmBroker 4
%svc% ShellHWDetection 4
%svc% spaceport 4
%svc% Spooler 4
%svc% srv2 4
%svc% srvnet 4
%svc% storqosflt 4
%svc% swenum 4
%svc% SysMain 4
%svc% SystemEventsBroker 4
%svc% tcpipReg 4
%svc% tdx 4
%svc% Telemetry 4
%svc% TimeBrokerSvc 4
%svc% TrkWks 4
%svc% UEFI 4
%svc% uhssvc 4
%svc% UnionFS 4
%svc% vdrvroot 4
%svc% vmicguestinterface 4
%svc% vmicheartbeat 4
%svc% vmickvpexchange 4
%svc% vmicrdv 4
%svc% vmicshutdown 4
%svc% vmictimesync 4
%svc% vmicvmsession 4
%svc% vmicvss 4
%svc% volmgrx 4
%svc% W32Time 4
%svc% WaaSMedicSvc 4
%svc% wanarp 4
%svc% wanarpv6 4
%svc% WarpJITSvc 4
%svc% WdBoot 4
%svc% WdFilter 4
%svc% WdiServiceHost 4
%svc% WdNisDrv 4
%svc% WdNisSvc 4
%svc% webthreatdefusersvc 4
%svc% WerSvc 4
%svc% WinDefend 4
%svc% WindowsTrustedRT 4
%svc% WindowsTrustedRTProxy 4
%svc% WinHttpAutoProxySvc 4 
%svc% WPDBusEnum 4
%svc% WpnService 4
%svc% WpnUserService 4
%svc% WSearch 4
%svc% CldFlt 4
%svc% wcifs 4
%svc% savdrv 4
%svc% Wof 4
%svc% mpsdrv 4
%svc% bam 4
%svc% FileCrypt 4
%svc% rdbss 4

:closed
exit


pause>nul

:setSvc
:: %svc% (service name) (0-4)
if "%1"=="" (
    echo You need to run this with a service to disable. 
    echo You need to run this with an argument ^(1-4^) to configure the service's startup.
    exit /b 1)
if "%2"=="" (
    echo You need to run this with an argument ^(1-4^) to configure the service's startup. 
    exit /b 1 )
if %2 LSS 0 (
    echo Invalid configuration. 
    exit /b 1 )
if %2 GTR 4 (
    echo Invalid configuration. 
    exit /b 1 )
Reg query "HKLM\System\CurrentControlSet\Services\%1" >nul 2>&1 || (
    echo The specified service/driver %1 is not found. >> C:\service_log.txt
    exit /b 1 )
Reg add "HKLM\System\CurrentControlSet\Services\%1" /v "Start" /t Reg_DWORD /d "%2" /f > nul
echo Service/Driver %1 configured with startup



