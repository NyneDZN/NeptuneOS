@echo off
setlocal enabledelayedexpansion

:: Path variables
set INITneptdir="C:\neptune-installer"
set neptdir="C:\Windows\NeptuneDir"
set currentuser=%INTneptdir%\tools\NSudoLG.exe -U:C -P:E -ShowWindowMode:Hide -Wait

:: Info scripts
call "%INITneptidir%\scripts\info\usersid.cmd"
