:: @echo off
:: Call usersid
setlocal enabledelayedexpansion
set INITneptdir="C:\neptune-installer"
set neptdir="C:\Windows\NeptuneDir"
set currentuser=%INTneptdir%\tools\NSudoLG.exe -U:C -P:E -ShowWindowMode:Hide -Wait

call "%INITneptidir%\scripts\info\usersid.cmd"
echo Echo the SID for debug purposes
echo %SID%


:: One-liner for sub-scripts
:: call "%~dp0variables.cmd"
