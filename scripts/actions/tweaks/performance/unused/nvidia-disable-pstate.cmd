:: This forces your GPU into P-0, which will make your GPU run at it's boost clock regardless of what you're doing.
:: This is useful for overclockers, but can also boost performance at the cost of higher thermals and GPU lifespan (lifespan depends on your thermals overtime)
:: Laptop users should keep this *off* unless you got one of them fancy dancy laptop cooling setups, or you just don't give a shit about your dedicated GPU

 /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
	for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\ControlSet001\Enum\%%i" /v "Driver"') do (
		for /f %%i in ('echo %%a ^| findstr "{"') do (
		     reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "DisableDynamicPstate" /t REG_DWORD /d "1" /f >> APB_Log.txt
                   )
                )
             )