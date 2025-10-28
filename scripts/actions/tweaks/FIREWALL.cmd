:: Block hooked services
reg add "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Services" /t REG_SZ /d "v2.32|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=%SystemRoot%\System32\nepthost.exe|Name=Block Services|Desc=Block Certain Services Outbound UDP/TCP Traffic|" /f

:: Firewall rules to prevent the startmenu from talking
reg add "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block SearchApp" /t REG_SZ /d "v2.32|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=%SystemRoot%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\SearchApp.exe|Name=Block SearchApp|Desc=Block Cortana Outbound UDP/TCP Traffic|" /f

reg add "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block SearchHost" /t REG_SZ /d "v2.32|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=%SystemRoot%\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe|Name=Block SearchHost|Desc=Block Cortana Outbound UDP/TCP Traffic|" /f

reg add "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block StartMenuExperienceHost" /t REG_SZ /d "v2.32|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=%SystemRoot%\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\StartMenuExperienceHost.exe|Name=Block StartMenuExperienceHost|Desc=Block Cortana Outbound UDP/TCP Traffic|" /f

:: Block Windows Settings from making connections
reg add "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block SystemSettings" /t REG_SZ /d "v2.32|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=%SystemRoot%\ImmersiveControlPanel\SystemSettings.exe|Name=Block SystemSettings|Desc=Block Windows Settings Outbound UDP/TCP Traffic|" /f

:: Block explorer from making connections
reg add "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Explorer" /t REG_SZ /d "v2.32|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=%SystemRoot%\explorer.exe|Name=Block Explorer|Desc=Block Explorer Outbound UDP/TCP Traffic|" /f
