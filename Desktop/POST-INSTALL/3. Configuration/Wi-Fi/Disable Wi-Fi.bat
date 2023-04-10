@echo off
sc config WlanSvc start=disabled
sc config vwififlt start=disabled
set /P c="Would you like to disable the Network Icon? (disables 2 extra services) [Y/N]: "
if /I "%c%" EQU "N" goto wifiDskip
sc config netprofm start=disabled
sc config NlaSvc start=disabled