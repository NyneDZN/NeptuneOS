@echo off
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul

:: Call Administrator
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select 'Run as administrator'.
        pause & exit 1
    )
    exit 0
)

echo Resetting network settings to Neptune defaults...

(
	:: https://packetpushers.net/ip-time-to-live-and-hop-limit-basics/
	netsh int ip set global defaultcurhoplimit=255 >nul
	:: - > Disable Media Sense
	netsh int ip set global dhcpmediasense=disabled >nul
	netsh int ip set global neighborcachelimit=4096 >nul
	:: - > Enable Task Offloading
	netsh int ip set global taskoffload=enabled >nul
	:: netsh int ip set interface "Ethernet" metric=60 >nul
	:: - > Set MTU (maximum transmission unit)
	netsh int ipv4 set subinterface "Ethernet" mtu=1500 store=persistent >nul
	netsh int ipv4 set subinterface "Wi-Fi" mtu=1500 store=persistent >nul
	:: - > Set AutoTuningLevel
	:: https://www.majorgeeks.com/content/page/what_is_windows_auto_tuning.html
	netsh int tcp set global autotuninglevel=normal >nul
	netsh int tcp set global chimney=disabled >nul
	:: - > Set Congestion Provider to CTCP (Client to Client Protocol)
	:: - > CTCP Provides better throughput and latency for gaming
	:: https://www.speedguide.net/articles/tcp-congestion-control-algorithms-comparison-7423
	netsh int tcp set global congestionprovider=ctcp >nul
	:: - > Set Congestion Provider to BBR2 on Windows 11
	if "%os%"=="Windows 11" (
	netsh int tcp set supplemental Template=Internet CongestionProvider=bbr2 >nul
	netsh int tcp set supplemental Template=Datacenter CongestionProvider=bbr2 >nul
	netsh int tcp set supplemental Template=Compat CongestionProvider=bbr2 >nul
	netsh int tcp set supplemental Template=DatacenterCustom CongestionProvider=bbr2 >nul
	netsh int tcp set supplemental Template=InternetCustom CongestionProvider=bbr2 >nul
	)
	:: - > Enable Direct Cache Access
	:: - > This will have a bigger impact on older CPU's
	netsh int tcp set global dca=enabled >nul
	:: - > Disable Explicit Congestion Notification
	:: https://en.wikipedia.org/wiki/Explicit_Congestion_Notification
	:: https://www.bufferbloat.net/projects/cerowrt/wiki/Enable_ECN/#:~:text=Enabling%20ECN%20does%20not%20much,already%2C%20but%20few%20clients%20do.
	netsh int tcp set global ecncapability=disabled >nul
	:: - > Enable TCP Fast Open
	:: https://en.wikipedia.org/wiki/TCP_Fast_Open
	netsh int tcp set global fastopen=enabled >nul
	:: - > Set the TCP Retransmission Timer
	:: https://www.speedguide.net/faq/how-does-tcpinitialrtt-or-initialrto-affect-tcp-498
	netsh int tcp set global initialRto=3000 >nul
	:: - > Set Max SYN Retransmissions to the lowest value
	:: https://medium.com/@avocadi/tcp-syn-retries-f30756ec7c55
	netsh int tcp set global maxsynretransmissions=2 >nul
	netsh int tcp set global netdma=enabled >nul
	:: - > Disable Non Sack RTT Resiliency
	:: - > If you have fluctuating ping and packet loss, enabling this might benefit
	:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
	netsh int tcp set global nonsackrttresiliency=disabled >nul
	:: - > Disable Receive Segment Coalescing State
	:: - > Enabling this may provide higher throughput when lower CPU utilization is important
	:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
	netsh int tcp set global rsc=disabled >nul
	:: - > Enable Receive Side Scaling
	:: - > This allows multiple cores to process incoming packets, improving network performance
	:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
	netsh int tcp set global rss=enabled >nul
	:: - > Disable TCP 1323 Timestamps
	:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
	netsh int tcp set global timestamps=disabled >nul
	:: - > Disable Scaling Heuristics
	netsh int tcp set heuristics disabled >nul
	:: - > Set Max Port Ranges
	netsh int ipv4 set dynamicport udp start=1025 num=64511 >nul
	netsh int ipv4 set dynamicport tcp start=1025 num=64511 >nul
	:: - > Disable Memory Pressure Protection
	:: - > This is a network security feature that will kill malicious TCP connections and SYN requests with no sort of performance or stability loss.
	:: https://support.microsoft.com/en-us/topic/description-of-the-new-memory-pressure-protection-feature-for-tcp-stack-749c1746-ba10-ec18-d61a-bbdabbc403fc
	:: netsh int tcp set security mpp=disabled >nul
	:: netsh int tcp set security profiles=disabled >nul
	netsh int tcp set supplemental Internet congestionprovider=ctcp >nul
	netsh int tcp set supplemental template=custom icw=10 >nul
	:: - > Disable Teredo
	netsh int teredo set state disabled >nul
) > nul

echo Finished, please reboot your device for changes to apply.
echo %date% %time% Reset Network to Neptune Default >> %userlog%
timeout /t 3 /nobreak >nul
exit