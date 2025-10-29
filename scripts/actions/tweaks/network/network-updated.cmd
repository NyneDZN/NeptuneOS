@echo OFF




rem Configure MTU
for /f "tokens=4*" %%a in ('netsh interface show interface ^| findstr /I "connected"') do netsh interface ipv4 set subinterface "%%a" mtu=1500 store=persistent >nul
set /a MTU = 1501
:MTU
set /a MTU -= 1
for /f "tokens=10" %%a in ('ping google.com -f -n 1 -4 -l %MTU% ^| findstr /I "Lost"') do if %%a neq 0 goto :MTU
for /f "tokens=10" %%a in ('ping google.com -f -4 -l %MTU% ^| findstr /I "Lost"') do if %%a neq 0 goto :MTU
set /a MTU += 28
for /f "tokens=4*" %%a in ('netsh interface show interface ^| findstr /I "connected"') do netsh interface ipv4 set subinterface "%%a" mtu=%MTU% store=persistent >nul



















rem Variables
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