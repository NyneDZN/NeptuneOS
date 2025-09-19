@echo off
:: Call usersid
call "scripts\info\usersid.cmd"
echo Echo the SID for debug purposes
echo %SID%


:: One-liner for sub-scripts
:: call "%~dp0variables.cmd"
