:: Path variables
set INITneptdir="C:\neptune-installer"
set neptdir="C:\Windows\NeptuneDir"
set currentuser=C:\neptune-installer\tools\NSudoLG.exe -U:C -P:E -ShowWindowMode:Hide -Wait

:: Winver Variables
for /f "tokens=6 delims=[.] " %%a in ('ver') do (set "win_version=%%a")
if %win_version% lss 22000 (set os=Windows 10) else (set os=Windows 11)
for /f "tokens=3" %%a in ('Reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "DisplayVersion"') do (set releaseid=%%a)
for /f "tokens=4-7 delims=[.] " %%a in ('ver') do (set "build=%%a.%%b.%%c.%%d")

:: SID 
for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "(Get-CimInstance Win32_UserAccount | Where-Object { $_.Name -eq $env:USERNAME -and $_.LocalAccount }) | Select-Object -ExpandProperty SID"`) do set "SID=%%A"

:: Info scripts
call "%INITneptidir%\scripts\info\usersid.cmd"
