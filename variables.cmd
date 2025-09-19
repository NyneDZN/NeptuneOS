:: @echo off
:: Call usersid
setlocal enabledelayedexpansion
set INITneptdir="C:\neptune-installer"
set neptdir="C\NeptuneDir"

call "%INITneptidir%\scripts\info\usersid.cmd"
echo Echo the SID for debug purposes
echo %SID%
echo !SID!


:: One-liner for sub-scripts
:: call "%~dp0variables.cmd"
