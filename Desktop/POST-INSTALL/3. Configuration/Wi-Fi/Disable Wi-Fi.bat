@echo off
echo Script credit given to Atlas.
timeout /t 1>nul
sc config WlanSvc start=disabled
sc config vwififlt start=disabled
set /P c="Would you like to disable the Network Icon? (disables 2 extra services) [Y/N]: "
if /I "%c%" EQU "N" goto wifiDskip
sc config netprofm start=disabled
sc config NlaSvc start=disabled
echo Wi-Fi and extra services have been disabled.
pause>nul

:wifiDskip
echo Wi-Fi is now disabled.
pause>nul