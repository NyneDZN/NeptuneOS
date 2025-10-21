call "%~dp0\modules\variables.cmd"

:: Network Shell
:: Reset the Network Configuration
:: ipconfig /release 
:: ipconfig /renew 
:: ipconfig /flushdns 
:: netsh int ip reset 
:: netsh int ipv4 reset 
:: netsh int ipv6 reset 
:: netsh int tcp reset 
:: netsh winsock reset 
netsh advfirewall reset 
:: netsh branchcache reset 
netsh http flush logbuffer 
:: - > Disable IPV6
:: IPV6 is disabled through regedit, so I'm commenting this out so it doesn't cause unforseen issues.
:: netsh int 6to4 set state disabled 
:: netsh int IPV6 set global randomizeidentifier=disabled 
:: netsh int IPV6 set privacy state=disable 
:: netsh int IPV6 6to4 set state state=disabled 
:: netsh int IPV6 isatap set state state=disabled 
:: netsh int IPV6 set teredo disable
:: - > Increase TTL (Time to Live)
:: https://packetpushers.net/ip-time-to-live-and-hop-limit-basics/
netsh int ip set global defaultcurhoplimit=255 
:: - > Disable Media Sense
netsh int ip set global dhcpmediasense=disabled 
netsh int ip set global neighborcachelimit=4096 
:: - > Enable Task Offloading
netsh int ip set global taskoffload=enabled 
:: netsh int ip set interface "Ethernet" metric=60 
:: - > Set MTU (maximum transmission unit)
netsh int ipv4 set subinterface "Ethernet" mtu=1500 store=persistent 
netsh int ipv4 set subinterface "Wi-Fi" mtu=1500 store=persistent 
:: - > Set AutoTuningLevel
:: https://www.majorgeeks.com/content/page/what_is_windows_auto_tuning.html
netsh int tcp set global autotuninglevel=normal 
netsh int tcp set global chimney=disabled 
:: - > Set Congestion Provider to CTCP (Client to Client Protocol)
:: - > CTCP Provides better throughput and latency for gaming
:: https://www.speedguide.net/articles/tcp-congestion-control-algorithms-comparison-7423
netsh int tcp set global congestionprovider=ctcp 
:: - > Set Congestion Provider to BBR2 on Windows 11
netsh int tcp set supplemental Template=Internet CongestionProvider=bbr2 
netsh int tcp set supplemental Template=Datacenter CongestionProvider=bbr2 
netsh int tcp set supplemental Template=Compat CongestionProvider=bbr2 
netsh int tcp set supplemental Template=DatacenterCustom CongestionProvider=bbr2 
netsh int tcp set supplemental Template=InternetCustom CongestionProvider=bbr2 
:: - > Enable Direct Cache Access
:: - > This will have a bigger impact on older CPU's
netsh int tcp set global dca=enabled 
:: - > Disable Explicit Congestion Notification
:: https://en.wikipedia.org/wiki/Explicit_Congestion_Notification
:: https://www.bufferbloat.net/projects/cerowrt/wiki/Enable_ECN/#:~:text=Enabling%20ECN%20does%20not%20much,already%2C%20but%20few%20clients%20do.
netsh int tcp set global ecncapability=disabled 
:: - > Enable TCP Fast Open
:: https://en.wikipedia.org/wiki/TCP_Fast_Open
netsh int tcp set global fastopen=enabled 
:: - > Set the TCP Retransmission Timer
:: https://www.speedguide.net/faq/how-does-tcpinitialrtt-or-initialrto-affect-tcp-498
netsh int tcp set global initialRto=3000 
:: - > Set Max SYN Retransmissions to the lowest value
:: https://medium.com/@avocadi/tcp-syn-retries-f30756ec7c55
netsh int tcp set global maxsynretransmissions=2 
netsh int tcp set global netdma=enabled 
:: - > Disable Non Sack RTT Resiliency
:: - > If you have fluctuating ping and packet loss, enabling this might benefit
:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
netsh int tcp set global nonsackrttresiliency=disabled 
:: - > Disable Receive Segment Coalescing State
:: - > Enabling this may provide higher throughput when lower CPU utilization is important
:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
netsh int tcp set global rsc=disabled 
:: - > Enable Receive Side Scaling
:: - > This allows multiple cores to process incoming packets, improving network performance
:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
netsh int tcp set global rss=enabled 
:: - > Disable TCP 1323 Timestamps
:: https://www.speedguide.net/articles/windows-10-tcpip-tweaks-5077
netsh int tcp set global timestamps=disabled 
:: - > Disable Scaling Heuristics
netsh int tcp set heuristics disabled 
:: - > Set Max Port Ranges
netsh int ipv4 set dynamicport udp start=1025 num=64511 
netsh int ipv4 set dynamicport tcp start=1025 num=64511 
:: - > Disable Memory Pressure Protection
:: - > This is a network security feature that will kill malicious TCP connections and SYN requests with no sort of performance or stability loss.
:: https://support.microsoft.com/en-us/topic/description-of-the-new-memory-pressure-protection-feature-for-tcp-stack-749c1746-ba10-ec18-d61a-bbdabbc403fc
:: netsh int tcp set security mpp=disabled 
:: netsh int tcp set security profiles=disabled 
netsh int tcp set supplemental Internet congestionprovider=ctcp 
netsh int tcp set supplemental template=custom icw=10 
:: - > Disable Teredo
netsh int teredo set state disabled 

