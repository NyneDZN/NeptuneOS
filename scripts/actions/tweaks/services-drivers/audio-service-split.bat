:: Split Audio Services
:: This will prevent audio dropouts when setting svchost.exe to low priority
copy /y "%windir%\System32\svchost.exe" "%windir%\System32\audiosvchost.exe" 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv" /v "ImagePath" /t Reg_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalServiceNetworkRestricted -p" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AudioEndpointBuilder" /v "ImagePath" /t Reg_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalSystemNetworkRestricted -p" /f 