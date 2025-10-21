:: Release 2.0
:: https://discord.gg/dptDHp9p9k
:: https://tinyurl.com/NetworkDocu
:: https://github.com/UnLovedCookie/Network
@echo off
cd %temp%
set Pwsh=^>nul powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command
setlocal EnableDelayedExpansion

rem Run as Trusted Installer via MinSudo
dism>nul || (where MinSudo >nul 2>&1 || (
curl -L "https://github.com/M2Team/NanaRun/releases/download/1.0.92.0/NanaRun_1.0_Preview3_1.0.92.0.zip" -o "NanaRun.zip" -s || ^
echo Failed to download MinSudo, run this script as an administrator. && pause && exit
%Pwsh% "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('NanaRun.zip', '.\NanaRun');"
move /y .\NanaRun\x64\MinSudo.exe MinSudo.exe >nul
del /f NanaRun.zip
rmdir /s /q NanaRun
) & MinSudo -NoL -TI -P "%~f0" && exit)
cls

rem Reset TCP/IP Stack
netsh interface tcp reset >nul
netsh winhttp reset proxy >nul
netsh winsock reset >nul
netsh int ip reset >nul
echo Reset TCP/IP Stack

rem Set Optimal MTU
for /f "tokens=4*" %%a in ('netsh interface show interface ^| findstr /I "connected"') do netsh interface ipv4 set subinterface "%%a" mtu=1500 store=persistent >nul
set /a MTU = 1501
:MTU
set /a MTU -= 1
for /f "tokens=10" %%a in ('ping google.com -f -n 1 -4 -l %MTU% ^| findstr /I "Lost"') do if %%a neq 0 goto :MTU
for /f "tokens=10" %%a in ('ping google.com -f -4 -l %MTU% ^| findstr /I "Lost"') do if %%a neq 0 goto :MTU
set /a MTU += 28
for /f "tokens=4*" %%a in ('netsh interface show interface ^| findstr /I "connected"') do netsh interface ipv4 set subinterface "%%a" mtu=%MTU% store=persistent >nul
echo Set MTU To %MTU%

rem Set Max Receive Buffers
for /f "tokens=4*" %%a in ('netsh interface show interface ^| findstr /I "connected"') do ^
for %%a in (128, 256, 512, 1024, 2048, 4096, 8184, 8192) do (
	%Pwsh% Set-NetAdapterAdvancedProperty -Name '%%b' -DisplayName 'Receive Buffers' -DisplayValue '%%a'
	if !errorlevel! neq 0 goto ReceiveBufferFound
)
:ReceiveBufferFound
echo Set Max Receive Buffers

rem Set Max Transmit Buffers
for /f "tokens=4*" %%a in ('netsh interface show interface ^| findstr /I "connected"') do ^
for %%a in (128, 256, 512, 1024, 2048, 4096, 8184, 8192) do (
	%Pwsh% Set-NetAdapterAdvancedProperty -Name '%%b' -DisplayName 'Transmit Buffers' -DisplayValue '%%a'
	if !errorlevel! neq 0 goto TransmitBufferFound
)
:TransmitBufferFound
echo Set Max Transmit Buffers

rem Disable IPsec Task Offload and TCP Chimney Offload
%Pwsh% Disable-NetAdapterIPsecOffload -Name *
Netsh int tcp set global chimney=disabled >nul
call :NICSetting "IPsecOffloadV1IPv4" "0"
call :NICSetting "IPsecOffloadV2" "0"
call :NICSetting "IPsecOffloadV2IPv4" "0"
echo Disable IPsec Task Offload and TCP Chimney Offload

rem Enable UDP and TCP Checksums
%Pwsh% Enable-NetAdapterChecksumOffload -Name *
call :NICSetting "TCPUDPChecksumOffloadIPv4" "3"
call :NICSetting "TCPUDPChecksumOffloadIPv6" "3"
call :NICSetting "UDPChecksumOffloadIPv4" "3"
call :NICSetting "UDPChecksumOffloadIPv6" "3"
call :NICSetting "TCPChecksumOffloadIPv4" "3"
call :NICSetting "TCPChecksumOffloadIPv6" "3"
call :NICSetting "IPChecksumOffloadIPv4" "3"
echo Enable UDP and TCP Checksums

rem Enable Large Send Offload (LSO)
%Pwsh% Enable-NetAdapterLso -Name *
call :NICSetting "LsoV1IPv4" "1"
call :NICSetting "LsoV2IPv4" "1"
call :NICSetting "LsoV2IPv6" "1"
echo Enable Large Send Offload (LSO)

rem Disable Flow Control
call :NICSetting "*FlowControl" "0"
echo Disable Flow Control

rem Increase Maximum Outstanding Network Requests
Reg add HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters /v MaxMpxCt /t REG_DWORD /d 800 /f >nul
echo Increase Maximum Outstanding Network Requests

rem Increase IRPStackSize
Reg add HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters /v IRPStackSize /t REG_DWORD /d 32 /f >nul
echo Increase IRPStackSize

rem Improving Live Migration
Reg add HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters /v RequireSecuritySignature /t REG_DWORD /d 0 /f >nul
echo Improving Live Migration

rem Disable Interrupt Moderation
call :NICSetting "*InterruptModeration" "0"
echo Disable Interrupt Moderation

rem Low Latency Interrupt Moderation Profile
call :NICSetting "TxIntModerationProfile" "0"
call :NICSetting "RxIntModerationProfile" "0"
echo Low Latency Interrupt Moderation Profile

rem Receive Completion Method: Polling
call :NICSetting "RecvCompletionMethod" "0"
echo Receive Completion Method: Polling

rem Disable Buffer List Tracking
Reg add HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters /v TrackNblOwner /t REG_DWORD /d 0 /f >nul
echo Disable Buffer List Tracking

rem Enable Fast Send Datagram
Reg add HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters /v FastSendDatagramThreshold /t REG_DWORD /d 409600 /f >nul
echo Enable Fast Send Datagram

rem Set the maximum number of concurrent connections (per server endpoint) allowed when making requests using an HttpClient object.
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPerServer" /t REG_DWORD /d "16" /f >nul
rem Maximum number of HTTP 1.0 connections to a Web server
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPer1_0Server" /t REG_DWORD /d "16" /f >nul
rem Increase Concurrent Connections on Explorer
Reg add "HKLM\Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v explorer.exe /t REG_DWORD /d 10 /f >nul
Reg add "HKLM\Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v iexplore.exe /t REG_DWORD /d 10 /f >nul
Reg add "HKLM\Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER" /v explorer.exe /t REG_DWORD /d 10 /f >nul
Reg add "HKLM\Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER" /v iexplore.exe /t REG_DWORD /d 10 /f >nul
echo Increase Concurrent Connections Limit

rem Lower Initial Retransmission Timer (RTO)
netsh int tcp set global initialRto=2000 >nul
call :TCPIP HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces TcpInitialRTT 2000
echo Lower Initial Retransmission Timer (RTO)

rem Disable RTT resiliency for non SACK clients
Netsh int tcp set global nonsackrttresiliency=disabled >nul
echo Disable RTT resiliency for non SACK clients

rem Lower Max SYN Retransmissions
netsh int tcp set global maxsynretransmissions=2 >nul
echo Lower Max SYN Retransmissions

rem Enable Transfers Larger Than 64KB
Reg add HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters /v DisableLargeMTU /t REG_DWORD /d 0 /f >nul

rem Enable Large System Cache
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v Size /t REG_DWORD /d 3 /f >nul
echo Enable Large System Cache

rem Enable Auto-Tuning
Netsh winsock set autotuning on >nul
Netsh int tcp set global autotuninglevel=normal >nul
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp" /v TcpAutotuning /t REG_DWORD /d 1 /f >nul
%Pwsh% Set-NetTCPSetting -AutoTuningLevelLocal Normal
echo Enable Auto-Tuning

rem Disable Receive Segment Coalescing State (RSC)
%Pwsh% Disable-NetAdapterRsc -Name *
%Pwsh% Set-NetOffloadGlobalSetting -ReceiveSegmentCoalescing Disabled
%Pwsh% Set-NetAdapterAdvancedProperty -Name * -RegistryKeyword '*RscIPv4' -RegistryValue 0
%Pwsh% Set-NetAdapterAdvancedProperty -Name * -RegistryKeyword '*RscIPv6' -RegistryValue 0
netsh int tcp set global rsc=disabled >nul
echo Disable Receive Segment Coalescing State (RSC)

rem Disable Direct Memory Access (DMA) Coalescing
call :NICSetting "DMACoalescing" "0"
echo Disable Direct Memory Access (DMA) Coalescing

rem Disable Packet Coalescing
%Pwsh% Set-NetOffloadGlobalSetting -PacketCoalescingFilter disabled
echo Disable Packet Coalescing

rem Enable Direct Cache Access (DCA)
Netsh int tcp set global dca=enabled >nul
echo Enable Direct Cache Access (DCA)

rem Disable Connected Standby
Reg add HKLM\System\CurrentControlSet\Control\Power /v EnforceDisconnectedStandby /t REG_DWORD /d 0 /f >nul
powercfg /setacvalueindex scheme_current sub_none connectivityinstandby 0
powercfg /s scheme_current
echo Disable Connected Standby

rem Enable Weak Host Model
for /f "tokens=1" %%a in ('netsh interface ip show interface ^| findstr /I "connected"') do (
netsh int ipv4 set int %%a weakhostreceive=enabled weakhostsend=enabled
netsh int ipv6 set int %%a weakhostreceive=enabled weakhostsend=enabled
) >nul
echo Enable Weak Host Model

rem Enable Explicit Congestion Notification (ECN)
netsh int tcp set global ecn=enabled >nul
netsh int tcp set global ecncapability=enabled >nul
echo Enable Explicit Congestion Notification (ECN)

rem Set Congestion Provider To BBR2/NewReno
for /f "tokens=7" %%a in ('netsh int tcp show supplemental ^| findstr /I "template"') do wmic os get Caption | find "11" >nul && (
netsh int tcp set supplemental %%a CongestionProvider=bbr2 >nul
echo Set Congestion Provider To BBR2
) || (
netsh int tcp set supplemental %%a CongestionProvider=newreno >nul
echo Set Congestion Provider To NewReno
)

rem Increase the TCP Initial Congestion Window
for /f "tokens=7" %%a in ('netsh int tcp show supplemental ^| findstr /I "template"') do Netsh int tcp set supplemental %%a icw=10 >nul
echo Increase the TCP Initial Congestion Window

rem Disable Network Power Savings
%Pwsh% Disable-NetAdapterPowerManagement -Name *
echo Disable Network Power Savings

rem Disable Delivery Optimization (peer-to-peer functionality)
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings" /v "DownloadMode" /t REG_DWORD /d "0" /f >nul
sc config DoSvc start=disabled >nul
sc stop "DoSvc" >nul
echo Disable Delivery Optimization

rem Disable Network Throttling
Reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched /v NonBestEffortLimit /t REG_DWORD /d 0 /f >nul
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 10 /f >nul
echo Disable Network Throttling

rem Reduce Time To Live
call :TCPIP HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters DefaultTTL 64
echo Reduce Time To Live

rem Disable Window Scaling Heuristics
call :TCPIP HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters EnableWsd 0
call :TCPIP HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters EnableHeuristics 0
netsh int tcp set heuristics disabled >nul
%Pwsh% Set-NetTCPSetting -ScalingHeuristics disabled
echo Disable Window Scaling Heuristics

rem Increase Network Priority
call :TCPIP HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider LocalPriority 4
call :TCPIP HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider HostsPriority 5
call :TCPIP HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider DnsPriority 6
call :TCPIP HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider NetBtPriority 7
call :TCPIP HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider Class 8
echo Increase Network Priority

rem Decrease TIME_WAIT Length
call :TCPIP HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters TcpTimedWaitDelay 30
echo Decrease TIME_WAIT Length

rem Enable TCP Selective Acks
call :TCPIP HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters SackOpts 1
echo Enable TCP Selective Acks

rem Enable Path Maximum Transfer Unit (PMTU)
call :TCPIP HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters EnablePMTUDiscovery 1
echo Enable Path Maximum Transfer Unit (PMTU)

rem Enable Path Maximum Transfer Unit (PMTU) Black Hole Detection
call :TCPIP HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters EnablePMTUBHDetect 1
echo Enable Path Maximum Transfer Unit (PMTU) Black Hole Detection

rem Remove TCP Connection Limit
call :TCPIP HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters EnableConnectionRateLimiting 0
echo Remove TCP Connection Limit

rem Set Dynamic Port Range to Maximum
netsh int ip set dynamicport tcp start=1024 num=64511 store=persistent >nul
call :TCPIP HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters MaxUserPort 65534
echo Set Dynamic Port Range to Maximum

rem Enable Network Direct Memory Access (NetDMA)
netsh int tcp set global netdma=enabled >nul
call :TCPIP HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters EnableTCPA 1
echo Enable NetDMA

rem Disable TCP 1323 Timestamps
Netsh int tcp set global timestamps=disabled >nul
call :TCPIP HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters Tcp1323Opts 0
echo Disable TCP 1323 Timestamps

rem Disable Nagle's Algorithm
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v TCPNoDelay /t REG_DWORD /d 1 /f >nul
Reg add "HKLM\Software\Microsoft\MSMQ\Parameters" /v "TCPNoDelay" /t REG_DWORD /d "1" /f >nul
for /f %%i in ('wmic path win32_networkadapter get GUID ^| findstr "{"') do (
	call :TCPIP "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" TCPNoDelay 1
	call :TCPIP "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" TcpAckFrequency 1
) >nul
echo Disable Nagle's Algorithm

rem Enable Network Task Offloading
Netsh int ip set global taskoffload=enabled >nul 2>&1
call :TCPIP "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" DisableTaskOffload 0
Reg add HKLM\System\CurrentControlSet\Services\Ipsec /v EnabledOffload /t REG_DWORD /d 1 /f >nul
echo Enable Network Task Offloading

rem Disable NetBIOS
Reg add HKLM\System\CurrentControlSet\Services\NetBT\Parameters\Interfaces /v NetBiosOptions /t REG_DWORD /d 2 /f >nul
sc config netbt start=disabled >nul
sc stop netbt >nul
sc config lmhosts start=disabled >nul
sc stop lmhosts >nul
%Pwsh% Disable-NetAdapterBinding -Name * -ComponentID ms_netbios
rem If NetBIOS manages to become enabled, protect against NBT-NS poisoning attacks
Reg add HKLM\System\CurrentControlSet\Services\NetBT\Parameters /v NodeType /t REG_DWORD /d 2 /f >nul
echo Disable NetBIOS

rem Disable LLMNR
Reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v EnableMulticast /t REG_DWORD /d 0 /f >nul
echo Disable LLMNR

rem Enable DNS over HTTPS
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableAutoDoh" /t REG_DWORD /d "2" /f >nul
echo Enable DNS over HTTPS

rem Disable Memory Pressure Protection (MPP)
Netsh int tcp set security mpp=disabled >nul
Netsh int tcp set security profiles=disabled >nul
call :TCPIP HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters EnableMPP 0
echo Disable Memory Pressure Protection (MPP)

rem Increase ARP Cache Size to 4096
netsh int ip set global neighborcachelimit=4096 >nul
echo Increase ARP Cache Size to 4096

rem Enable QoS Packet Scheduler (Psched)
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Psched" /v "Start" /t REG_DWORD /d "1" /f >nul
sc config Psched start=auto >nul
sc start Psched >nul
Reg add HKLM\System\CurrentControlSet\Services\Tcpip\QoS /v "Do not use NLA" /t REG_DWORD /d 1 /f >nul
echo Enable QoS Packet Scheduler (Psched)

rem Lower QoS TimerResolution
Reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\System\CurrentControlSet\Services\AFD\Parameters" /v "DoNotHoldNicBuffers" /t REG_DWORD /d "1" /f >nul
echo Lower QoS TimerResolution

rem Optimize DSCP For Certain Applications
for %%i in (csgo VALORANT-Win64-Shipping javaw FortniteClient-Win64-Shipping ModernWarfare r5apex) do (
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Application Name" /t REG_SZ /d "%%i.exe" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Local IP" /t REG_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "DSCP Value" /t REG_SZ /d "46" /f
) >nul
echo Optimize DSCP For Certain Applications

rem Disable Network Adapter Power Saving
mkdir "%SYSTEMDRIVE%\Backup" 2>nul
for /f "tokens=3*" %%a in ('Reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\NetworkCards" /k /v /f "Description" /s /e ^| findstr /ri "REG_SZ"') do ^
for /f %%g in ('Reg query "HKLM\System\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /s /f "%%b" /d ^| findstr /C:"HKEY"') do (
if not exist "%SYSTEMDRIVE%\Backup\(Default) %%b.reg" Reg export "%%g" "%SYSTEMDRIVE%\Backup\(Default) %%b.reg" /y
::Disable Wake Features
Reg add "%%g" /v "*WakeOnMagicPacket" /t REG_SZ /d "0" /f
Reg add "%%g" /v "*WakeOnPattern" /t REG_SZ /d "0" /f
Reg add "%%g" /v "WakeOnLink" /t REG_SZ /d "0" /f
Reg add "%%g" /v "WakeOnLinkChange" /t REG_SZ /d "0" /f
Reg add "%%g" /v "S5WakeOnLan" /t REG_SZ /d "0" /f
Reg add "%%g" /v "WolShutdownLinkSpeed" /t REG_SZ /d "2" /f
Reg add "%%g" /v "*ModernStandbyWoLMagicPacket	" /t REG_SZ /d "0" /f
Reg add "%%g" /v "*DeviceSleepOnDisconnect" /t REG_SZ /d "0" /f
::Energy Efficient Ethernet
Reg add "%%g" /v "*EEE" /t REG_SZ /d "0" /f
Reg add "%%g" /v "EEE" /t REG_SZ /d "0" /f
Reg add "%%g" /v "EeePhyEnable" /t REG_SZ /d "0" /f
Reg add "%%g" /v "EnableGreenEthernet" /t REG_SZ /d "0" /f
Reg add "%%g" /v "EEELinkAdvertisement" /t REG_SZ /d "0" /f
Reg add "%%g" /v "AdvancedEEE" /t REG_SZ /d "0" /f
::Ultra Low Power Mode
Reg add "%%g" /v "ULPMode" /t REG_SZ /d "0" /f
::Wi-Fi capability that saves power consumption
Reg add "%%g" /v "uAPSDSupport" /t REG_SZ /d "0" /f
::Disable Power Saving Features
Reg add "%%g" /v "*NicAutoPowerSaver" /t REG_SZ /d "0" /f
Reg add "%%g" /v "*SelectiveSuspend" /t REG_SZ /d "0" /f
Reg add "%%g" /v "SelectiveSuspend" /t REG_SZ /d "0" /f
Reg add "%%g" /v "EnablePME" /t REG_SZ /d "0" /f
Reg add "%%g" /v "ReduceSpeedOnPowerDown" /t REG_SZ /d "0" /f
Reg add "%%g" /v "PowerSavingMode" /t REG_SZ /d "0" /f
Reg add "%%g" /v "SavePowerNowEnabled" /t REG_SZ /d "0" /f
Reg add "%%g" /v "GigaLite" /t REG_SZ /d "0" /f
Reg add "%%g" /v "EnableSavePowerNow" /t REG_SZ /d "0" /f
Reg add "%%g" /v "bLowPowerEnable" /t REG_SZ /d "0" /f
Reg add "%%g" /v "EnablePowerManagement" /t REG_SZ /d "0" /f
Reg add "%%g" /v "*EnableDynamicPowerGating" /t REG_SZ /d "0" /f
Reg add "%%g" /v "DisableDelayedPowerUp" /t REG_SZ /d "1" /f
Reg add "%%g" /v "EnableConnectedPowerGating" /t REG_SZ /d "0" /f
Reg add "%%g" /v "AutoPowerSaveModeEnabled" /t REG_SZ /d "0" /f
Reg add "%%g" /v "PowerSaveMode" /t REG_SZ /d "0" /f
Reg add "%%g" /v "AutoDisableGigabit" /t REG_SZ /d "0" /f
Reg add "%%g" /v "PowerDownPll" /t REG_SZ /d "0" /f
Reg add "%%g" /v "S5NicKeepOverrideMacAddrV2" /t REG_SZ /d "0" /f
Reg add "%%g" /v "MIMOPowerSaveMode" /t REG_SZ /d "3" /f
Reg add "%%g" /v "AlternateSemaphoreDelay" /t REG_SZ /d "0" /f
Reg add "%%g" /v "SipsEnabled" /t REG_SZ /d "0" /f
::Enable Throughput Booster
Reg add "%%g" /v "ThroughputBoosterEnabled" /t REG_SZ /d "1" /f
::Access Point Compatibility Mode: 'High Performance'
Reg add "%%g" /v "ApCompatMode" /t REG_SZ /d "0" /f
::Disable network adapter power management
Reg add "%%g" /v "PnPCapabilities" /t REG_DWORD /d "24" /f
::Enable Offloads
Reg add "%%g" /v "*PMARPOffload" /t REG_SZ /d "1" /f
Reg add "%%g" /v "*PMNSOffload" /t REG_SZ /d "1" /f
Reg add "%%g" /v "*PMWiFiRekeyOffload" /t REG_SZ /d "1" /f
::Enable 802.1Q Tags
Reg add "%%g" /v "*PriorityVLANTag" /t REG_SZ /d "1" /f
) >nul
echo Disable Network Adapter Power Saving

rem Configure Network Adapter Device Parameters
for /f %%a in ('wmic path Win32_NetworkAdapter get PNPDeviceID ^| find "PCI\VEN_"') do (

rem Set Network Adapter Interrupt Priority to Undefined
Reg delete "HKLM\System\CurrentControlSet\Enum\%%a\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>&1
echo Set Network Adapter Interrupt Priority to Undefined

rem Set Network Adapter Policy to IrqPolicySpreadMessagesAcrossAllProcessors
Reg add "HKLM\System\CurrentControlSet\Enum\%%a\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "5" /f >nul
echo Set Network Adapter Policy to IrqPolicySpreadMessagesAcrossAllProcessors

rem Enable Network Adapter MSI Mode
Reg add "HKLM\System\CurrentControlSet\Enum\%%a\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f >nul
echo Enable Network Adapter MSI Mode
)

rem Optimize RSS
%Pwsh% Set-NetOffloadGlobalSetting -ReceiveSideScaling enabled
netsh int tcp set global rss=enabled >nul
set /a MaxRssProc=%NUMBER_OF_PROCESSORS%-2
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Ndis\Parameters" /v "RssBaseCpu" /t REG_DWORD /d "1" /f >nul
for /f "tokens=3*" %%a in ('Reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\NetworkCards" /k /v /f "Description" /s /e ^| findstr /ri "REG_SZ"') do ^
for /f %%g in ('Reg query "HKLM\System\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /s /f "%%b" /d ^| findstr /C:"HKEY"') do (
rem Add RSS Support
Reg add "%%g\Ndi\Params\*RSS" /v "ParamDesc" /t REG_SZ /d "Receive Side Scaling" /f
Reg add "%%g\Ndi\Params\*RSS" /v "default" /t REG_SZ /d "1" /f
Reg add "%%g\Ndi\Params\*RSS" /v "type" /t REG_SZ /d "enum" /f
Reg add "%%g\Ndi\Params\*RSS\Enum" /v "0" /t REG_SZ /d "Disabled" /f
Reg add "%%g\Ndi\Params\*RSS\Enum" /v "1" /t REG_SZ /d "Enabled" /f

rem Unlock RSS Queues
Reg add "%%g\Ndi\Params\*NumRssQueues" /v "ParamDesc" /t REG_SZ /d "Maximum Number of RSS Queues" /f
Reg add "%%g\Ndi\Params\*NumRssQueues" /v "default" /t REG_SZ /d "4" /f
Reg add "%%g\Ndi\Params\*NumRssQueues" /v "type" /t REG_SZ /d "enum" /f
Reg add "%%g\Ndi\Params\*NumRssQueues\Enum" /v "1" /t REG_SZ /d "1 Queue" /f
Reg add "%%g\Ndi\Params\*NumRssQueues\Enum" /v "2" /t REG_SZ /d "2 Queues" /f
Reg add "%%g\Ndi\Params\*NumRssQueues\Enum" /v "3" /t REG_SZ /d "3 Queues" /f
Reg add "%%g\Ndi\Params\*NumRssQueues\Enum" /v "4" /t REG_SZ /d "4 Queues" /f

rem Enable RSS
Reg add "%%g" /v "*RSS" /t REG_SZ /d "1" /f
Reg add "%%g" /v "*NumRssQueues" /t REG_SZ /d "4" /f
Reg add "%%g" /v "*RSSProfile" /t REG_SZ /d "4" /f
Reg add "%%g" /v "*NumaNodeId" /t REG_SZ /d "0" /f
Reg add "%%g" /v "*RssBaseProcGroup" /t REG_SZ /d "0" /f
Reg add "%%g" /v "*RssMaxProcGroup" /t REG_SZ /d "0" /f
Reg add "%%g" /v "*RssBaseProcNumber" /t REG_SZ /d "0" /f

rem Increase RSS Processors
Reg add "%%g" /v "*RssMaxProcNumber" /t REG_SZ /d "%MaxRssProc%" /f
Reg add "%%g" /v "*MaxRssProcessors" /t REG_SZ /d "%MaxRssProc%" /f

rem Use RssV2
Reg add "%%g" /v "RssV2" /t REG_SZ /d "1" /f
Reg add "%%g" /v "ValidateRssV2" /t REG_SZ /d "1" /f
) >nul
echo Enable RSS

rem Restart Explorer
rem taskkill /f /im explorer.exe >nul && start explorer.exe

rem Flush DNS Cache
ipconfig /flushdns >nul
echo Flush DNS Cache

rem Release/Renew IP address
ipconfig /release >nul
ipconfig /renew >nul
echo Renew IP address

rem Delete Address Resolution Protocol (ARP) Cache
netsh interface ip delete arpcache >nul
echo Delete Address Resolution Protocol (ARP) Cache

rem Wipe The Windows CryptNet SSL Certificate Cache
certutil -URLcache * delete >nul
echo Wipe The Windows CryptNet SSL Certificate Cache

rem Restart Network Adapter
choice /c yn /m "Operations complete, would you like to restart your network adapter?"
if %errorlevel% equ 1 %Pwsh% Restart-NetAdapter *
pause & exit

:NICSetting
for /f "tokens=3*" %%a in ('Reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\NetworkCards" /k /v /f "Description" /s /e ^| findstr /ri "REG_SZ"') do ^
for /f %%g in ('Reg query "HKLM\System\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /s /f "%%b" /d ^| findstr /C:"HKEY"') do (
	Reg add "%%g" /v "%1" /t REG_SZ /d "%2" /f
) >nul
goto:eof

:NICSettingPwsh
for /f "skip=3 tokens=4*" %%a in ('netsh interface show interface') do (
%Pwsh% Set-NetAdapterAdvancedProperty -Name "%%a" -RegistryKeyword "%1" -RegistryValue "%2"
) >nul
goto:eof

:TCPIP
set regpath=%~1
Reg add "%regpath%" /v "%~2" /t REG_DWORD /d "%~3" /f >nul
Reg add "%regpath:Tcpip=Tcpip6%" /v "%~2" /t REG_DWORD /d "%~3" /f >nul
goto:eof