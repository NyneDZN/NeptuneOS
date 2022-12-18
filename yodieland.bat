:: UPDATED NEPTUNE OS POST INSTALL SCRIPT

:: Created by nyne.#1431
:: These tweaks are only compiled by the author.

@echo off
setlocal EnableDelayedExpansion
set version=0.2
title NeptuneOS Post-Install Version %version%
color f0

:: Fullscreen, Kill Explorer and Kill Mouse
wscript "%WinDir%\NEPTUNE\FullscreenCMD.vbs" >NUL 2>&1
taskkill /f /im explorer.exe >NUL 2>&1
devmanview /disable "HID-compliant mouse" >NUL 2>&1

echo.
echo.
echo  Disclaimer:
echo  Do NOT close out of this Post Install script.
echo  This script will continue to setup NeptuneOS
echo  This may take between 2-5 minutes depending on your HDD/SSD speed.
echo  Please report any errors you may encounter in the OS or with this script.
echo  If you close this, please re-run it in C:\Windows\NEPTUNE.
echo  Press any key to continue the script.
echo.
echo.
timeout /t 30 >NUL 2>&1
cls


:Prep
:: Importing NEPTUNE Registry
Regedit.exe /s "%windir%\NEPTUNE\yodieland.reg" >NUL 2>&1
PowerRun.exe /SW:0 regedit.exe /s "%windir%\NEPTUNE\yodieland.reg" >NUL 2>&1

:: Installing Prerequisites
start /b /wait "%windir%\NEPTUNE\VisualCppRedist_AIO_x86_x64.exe" /ai /gm2 >NUL 2>&1
"%windir%\NEPTUNE\DirectX\DXSETUP.exe" /silent >NUL 2>&1
"%windir%\NEPTUNE\MPC.exe" /VERYSILENT /NORESTART >NUL 2>&1
"%windir%\NEPTUNE\7z.exe" /S >NUL 2>&1
"%windir%\NEPTUNE\Open Shell.exe" /qn ADDLOCAL=StartMenu >NUL 2>&

:: Application Settings and Defaults
Reg.exe add "HKCU\SOFTWARE\7-Zip\Options" /v "ContextMenu" /t REG_DWORD /d "2147487748" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\7-Zip\Options" /v "ElimDupExtract" /t REG_DWORD /d "0" /f >nul 2>&1 
Reg.exe add "HKLM\SOFTWARE\Classes\.esd" /ve /t REG_SZ /d "7-Zip.esd" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.esd" /ve /t REG_SZ /d "esd Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.esd\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,15" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.esd\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.esd\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.esd\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.001" /ve /t REG_SZ /d "7-Zip.001" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.7z" /ve /t REG_SZ /d "7-Zip.7z" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.arj" /ve /t REG_SZ /d "7-Zip.arj" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.bz2" /ve /t REG_SZ /d "7-Zip.bz2" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.bzip2" /ve /t REG_SZ /d "7-Zip.bzip2" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.cab" /ve /t REG_SZ /d "7-Zip.cab" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.cpio" /ve /t REG_SZ /d "7-Zip.cpio" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.deb" /ve /t REG_SZ /d "7-Zip.deb" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.dmg" /ve /t REG_SZ /d "7-Zip.dmg" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.fat" /ve /t REG_SZ /d "7-Zip.fat" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.gz" /ve /t REG_SZ /d "7-Zip.gz" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.gzip" /ve /t REG_SZ /d "7-Zip.gzip" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.hfs" /ve /t REG_SZ /d "7-Zip.hfs" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.iso" /ve /t REG_SZ /d "7-Zip.iso" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.lha" /ve /t REG_SZ /d "7-Zip.lha" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.lzh" /ve /t REG_SZ /d "7-Zip.lzh" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.lzma" /ve /t REG_SZ /d "7-Zip.lzma" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.ntfs" /ve /t REG_SZ /d "7-Zip.ntfs" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.rar" /ve /t REG_SZ /d "7-Zip.rar" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.rpm" /ve /t REG_SZ /d "7-Zip.rpm" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.squashfs" /ve /t REG_SZ /d "7-Zip.squashfs" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.swm" /ve /t REG_SZ /d "7-Zip.swm" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.tar" /ve /t REG_SZ /d "7-Zip.tar" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.taz" /ve /t REG_SZ /d "7-Zip.taz" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.tbz" /ve /t REG_SZ /d "7-Zip.tbz" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.tbz2" /ve /t REG_SZ /d "7-Zip.tbz2" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.tgz" /ve /t REG_SZ /d "7-Zip.tgz" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.tpz" /ve /t REG_SZ /d "7-Zip.tpz" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.txz" /ve /t REG_SZ /d "7-Zip.txz" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.vhd" /ve /t REG_SZ /d "7-Zip.vhd" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.wim" /ve /t REG_SZ /d "7-Zip.wim" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.xar" /ve /t REG_SZ /d "7-Zip.xar" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.xz" /ve /t REG_SZ /d "7-Zip.xz" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.z" /ve /t REG_SZ /d "7-Zip.z" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.zip" /ve /t REG_SZ /d "7-Zip.zip" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.001" /ve /t REG_SZ /d "001 Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.001\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,9" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.001\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.001\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.001\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.7z" /ve /t REG_SZ /d "7z Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.7z\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.7z\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.7z\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.7z\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.arj" /ve /t REG_SZ /d "arj Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.arj\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,4" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.arj\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.arj\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.arj\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.bz2" /ve /t REG_SZ /d "bz2 Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.bz2\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.bz2\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.bz2\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.bz2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.bzip2" /ve /t REG_SZ /d "bzip2 Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.bzip2\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.bzip2\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.bzip2\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.bzip2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.cab" /ve /t REG_SZ /d "cab Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.cab\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,7" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.cab\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.cab\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.cab\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.cpio" /ve /t REG_SZ /d "cpio Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.cpio\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,12" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.cpio\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.cpio\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.cpio\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.deb" /ve /t REG_SZ /d "deb Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.deb\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,11" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.deb\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.deb\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.deb\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.dmg" /ve /t REG_SZ /d "dmg Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.dmg\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,17" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.dmg\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.dmg\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.dmg\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.fat" /ve /t REG_SZ /d "fat Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.fat\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,21" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.fat\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.fat\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.fat\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.gz" /ve /t REG_SZ /d "gz Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.gz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.gz\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.gz\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.gz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.gzip" /ve /t REG_SZ /d "gzip Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.gzip\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.gzip\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.gzip\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.gzip\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.hfs" /ve /t REG_SZ /d "hfs Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.hfs\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,18" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.hfs\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.hfs\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.hfs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.iso" /ve /t REG_SZ /d "iso Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.iso\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,8" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.iso\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.iso\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.iso\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.lha" /ve /t REG_SZ /d "lha Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.lha\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,6" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.lha\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.lha\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.lha\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.lzh" /ve /t REG_SZ /d "lzh Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.lzh\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,6" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.lzh\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.lzh\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.lzh\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.lzma" /ve /t REG_SZ /d "lzma Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.lzma\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,16" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.lzma\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.lzma\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.lzma\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.ntfs" /ve /t REG_SZ /d "ntfs Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.ntfs\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,22" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.ntfs\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.ntfs\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.ntfs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.rar" /ve /t REG_SZ /d "rar Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.rar\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,3" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.rar\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.rar\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.rar\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.rpm" /ve /t REG_SZ /d "rpm Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.rpm\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,10" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.rpm\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.rpm\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.rpm\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.squashfs" /ve /t REG_SZ /d "squashfs Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.squashfs\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,24" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.squashfs\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.squashfs\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.squashfs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.swm" /ve /t REG_SZ /d "swm Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.swm\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,15" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.swm\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.swm\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.swm\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tar" /ve /t REG_SZ /d "tar Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tar\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,13" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tar\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tar\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tar\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.taz" /ve /t REG_SZ /d "taz Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.taz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,5" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.taz\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.taz\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.taz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tbz" /ve /t REG_SZ /d "tbz Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tbz2" /ve /t REG_SZ /d "tbz2 Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tbz2\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tbz2\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tbz2\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tbz2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tbz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tbz\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tbz\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tbz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tgz" /ve /t REG_SZ /d "tgz Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tgz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tgz\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tgz\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tgz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tpz" /ve /t REG_SZ /d "tpz Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tpz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tpz\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tpz\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.tpz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.txz" /ve /t REG_SZ /d "txz Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.txz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,23" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.txz\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.txz\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.txz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.vhd" /ve /t REG_SZ /d "vhd Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.vhd\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,20" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.vhd\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.vhd\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.vhd\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.wim" /ve /t REG_SZ /d "wim Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.wim\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,15" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.wim\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.wim\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.wim\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.xar" /ve /t REG_SZ /d "xar Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.xar\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,19" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.xar\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.xar\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.xar\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.xz" /ve /t REG_SZ /d "xz Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.xz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,23" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.xz\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.xz\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.xz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.z" /ve /t REG_SZ /d "z Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.z\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,5" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.z\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.z\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.z\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.zip" /ve /t REG_SZ /d "zip Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.zip\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.zip\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.zip\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.zip\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.vhdx" /ve /t REG_SZ /d "7-Zip.vhdx" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.vhdx" /ve /t REG_SZ /d "vhdx Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.vhdx\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,20" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.vhdx\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.vhdx\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.vhdx\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\.apfs" /ve /t REG_SZ /d "7-Zip.apfs" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.apfs" /ve /t REG_SZ /d "apfs Archive" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.apfs\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,25" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.apfs\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.apfs\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Classes\7-Zip.apfs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\OpenShell\StartMenu" /v "ShowedStyle2" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "Version" /t REG_DWORD /d "67371150" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "MenuStyle" /t REG_SZ /d "Win7" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "ShiftClick" /t REG_SZ /d "Nothing" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "ShiftWin" /t REG_SZ /d "Nothing" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "ControlPanelCategories" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "AllProgramsMetro" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "HideProgramsMetro" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "RecentPrograms" /t REG_SZ /d "None" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "ShutdownCommand" /t REG_SZ /d "CommandShutdown" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "HybridShutdown" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "StartScreenShortcut" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "AutoStart" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "HighlightNew" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "HighlightNewApps" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "CheckWinUpdates" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "PreCacheIcons" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchBox" /t REG_SZ /d "Normal" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchTrack" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchPath" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchMetroApps" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchMetroSettings" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchKeywords" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchSubWord" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchFiles" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchContents" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchCategories" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SearchInternet" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "InvertMetroIcons" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "MainMenuAnimation" /t REG_SZ /d "None" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SubMenuAnimation" /t REG_SZ /d "None" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "MenuFadeSpeed" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkinW7" /t REG_SZ /d "Midnight" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkinVariationW7" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkinOptionsW7" /t REG_MULTI_SZ /d "USER_IMAGE=0\0SMALL_ICONS=0\0LARGE_FONT=0\0DISABLE_MASK=0\0OPAQUE=1\0TRANSPARENT_LESS=0\0TRANSPARENT_MORE=0\0WHITE_SUBMENUS2=0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "EnableStartButton" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkipMetro" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "MenuItems7" /t REG_MULTI_SZ /d "Item1.Command=user_files\0Item1.Settings=ITEM_DISABLED\0Item2.Command=user_documents\0Item2.Settings=ITEM_DISABLED\0Item3.Command=user_pictures\0Item3.Settings=ITEM_DISABLED\0Item4.Command=user_music\0Item4.Settings=ITEM_DISABLED\0Item5.Command=user_videos\0Item5.Settings=ITEM_DISABLED\0Item6.Command=downloads\0Item6.Settings=ITEM_DISABLED\0Item7.Command=homegroup\0Item7.Settings=ITEM_DISABLED\0Item8.Command=separator\0Item9.Command=games\0Item9.Settings=TRACK_RECENT|ITEM_DISABLED\0Item10.Command=favorites\0Item10.Settings=ITEM_DISABLED\0Item11.Command=recent_documents\0Item11.Settings=ITEM_DISABLED\0Item12.Command=computer\0Item12.Settings=NOEXPAND\0Item13.Command=network\0Item13.Settings=ITEM_DISABLED\0Item14.Command=network_connections\0Item14.Settings=ITEM_DISABLED\0Item15.Command=separator\0Item16.Command=control_panel\0Item16.Label=$Menu.ControlPanel\0Item16.Tip=$Menu.ControlPanelTip\0Item16.Settings=TRACK_RECENT|NOEXPAND\0Item17.Command=pc_settings\0Item17.Settings=TRACK_RECENT|ITEM_DISABLED\0Item18.Command=admin\0Item18.Settings=TRACK_RECENT|ITEM_DISABLED\0Item19.Command=devices\0Item19.Settings=ITEM_DISABLED\0Item20.Command=defaults\0Item20.Settings=ITEM_DISABLED\0Item21.Command=help\0Item21.Settings=ITEM_DISABLED\0Item22.Command=run\0Item22.Settings=ITEM_DISABLED\0Item23.Command=apps\0Item23.Settings=ITEM_DISABLED\0Item24.Command=windows_security\0Item24.Settings=ITEM_DISABLED" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "EnableContextMenu" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "ShowNewFolder" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "EnableExit" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "EnableExplorer" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SoundMain" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SoundPopup" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SoundCommand" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SoundDrop" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "ProgramsStyle" /t REG_SZ /d "Inline" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "PinnedPrograms" /t REG_SZ /d "PinnedItems" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "MainMenuAnimate" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "MenuShadow" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "EnableGlass" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "CustomTaskbar" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "TaskbarColor" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "OpenPrograms" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "EnableJumplists" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "EnableAccessibility" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "NumericSort" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\OpenShell\StartMenu\Settings" /v "FontSmoothing" /t REG_SZ /d "None" /f > NUL 2>&1
reg.exe add "HKCU\SOFTWARE\Memory Cleaner\Settings" /v "EnableCustomTimerResolution" /t REG_SZ /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner" /v "LicenseAccepted" /t REG_SZ /d "True" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner" /v "EnableClearingOfTheStandbyList" /t REG_SZ /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner" /v "EnableFlushingOfTheModifiedList" /t REG_SZ /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner" /v "EnableCustomTimerResolution" /t REG_SZ /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner" /v "EnableClearingOfTheLowPriorityStandbyList" /t REG_SZ /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner" /v "EnableEmptyingOfTheWorkingSet" /t REG_SZ /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner" /v "StartMemoryCleanerOnSystemStartup" /t REG_SZ /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner" /v "StartMinimized" /t REG_SZ /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner" /v "StartTimerResolutionAutomatically" /t REG_SZ /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner" /v "TimerEnabled" /t REG_SZ /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner" /v "CheckedForUpdates" /t REG_SZ /d "True" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner" /v "DesiredTimerResolution" /t REG_SZ /d "10000" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner" /v "HotkeyToCleanMemory" /t REG_SZ /d "F10" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner" /v "TimerPollingInterval" /t REG_SZ /d "1 sec" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner\Settings" /v "LicenseAccepted" /t REG_SZ /d "True" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner\Settings" /v "DesiredTimerResolution" /t REG_SZ /d "10000" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner\Settings" /v "EnableClearingOfTheStandbyList" /t REG_SZ /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner\Settings" /v "EnableCustomTimerResolution" /t REG_SZ /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner\Settings" /v "EnableEmptyingOfTheWorkingSet" /t REG_SZ /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner\Settings" /v "HotkeyModifierKey" /t REG_SZ /d "None" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner\Settings" /v "HotkeyToCleanMemory" /t REG_SZ /d "F10" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner\Settings" /v "StartMemoryCleanerOnSystemStartup" /t REG_SZ /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner\Settings" /v "StartMinimized" /t REG_SZ /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner\Settings" /v "StartTimerResolutionAutomatically" /t REG_SZ /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner\Settings" /v "TimerEnabled" /t REG_SZ /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Memory Cleaner\Settings" /v "TimerPollingInterval" /t REG_SZ /d "1 sec" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Sysinternals\AutoRuns" /v "EulaAccepted" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKCU\Software\Sysinternals\Regjump" /v "EulaAccepted" /t REG_DWORD /d "1" /f > NUL 2>&1


:: NeptuneOS Shortcuts
nircmd shortcut "%windir%\Memory Cleaner.exe" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" "mc" > NUL 2>&1
nircmd shortcut "C:\POST INSTALL" "%userprofile%\Desktop" "Post-Install" > NUL 2>&1
nircmd shortcut "C:\Program Files\Open-Shell\StartMenu.exe" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" "StartMenu" > NUL 2>&1


:: Deleting Microcode Updates
takeown /f C:\Windows\System32\mcupdate_GenuineIntel.dll >NUL 2>&1
takeown /f C:\Windows\System32\mcupdate_AuthenticAMD.dll >NUL 2>&1
del C:\Windows\System32\mcupdate_GenuineIntel.dll /s /f /q >NUL 2>&1
del C:\Windows\System32\mcupdate_AuthenticAMD.dll /s /f /q >NUL 2>&1


:: Limit System Logging
wevtutil sl Security /ms:48048576 > NUL 2>&1
wevtutil sl Application /ms:48048576 > NUL 2>&1
wevtutil sl Setup /ms:48048576 > NUL 2>&1
wevtutil sl System /ms:48048576 > NUL 2>&1
wevtutil sl "Windows Powershell" /ms:24048576 > NUL 2>&1
wevtutil sl "Microsoft-Windows-PowerShell/Operational" /ms:24048576 > NUL 2>&1
wevtutil sl "Microsoft-Windows-Sysmon/Operational" /ms:24048576 > NUL 2>&1
wevtutil sl "Microsoft-Windows-TaskScheduler/Operational" /e:true > NUL 2>&1
wevtutil sl "Microsoft-Windows-DNS-Client/Operational" /e:true > NUL 2>&1


:: Disable Reserved Storage
DISM /Online /Set-ReservedStorageState /State:Disabled > NUL 2>&1


:: Changing Time Server to NTP
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org" > NUL 2>&1
w32tm /config /update > NUL 2>&1
w32tm /resync > NUL 2>&1

timeout /t 3 /nobreak >NUL 2>&1
goto Main




:Main
:: Boot Configuration
BCDEDIT /set disabledynamictick yes >NUL 2>&1
BCDEDIT /set useplatformtick Yes >NUL 2>&1
BCDEDIT /set nx AlwaysOff >NUL 2>&1
BCDEDIT /set ems No >NUL 2>&1
BCDEDIT /set bootems No >NUL 2>&1
BCDEDIT /set tpmbootentropy ForceDisable >NUL 2>&1
BCDEDIT /set bootmenupolicy Legacy >NUL 2>&1
BCDEDIT /set debug No >NUL 2>&1
BCDEDIT /set hypervisorlaunchtype Off >NUL 2>&1
BCDEDIT /set vm No >NUL 2>&1
BCDEDIT /set vsmlaunchtype Off >NUL 2>&1
BCDEDIT /set quietboot Yes >NUL 2>&1
BCDEDIT /set bootux Disabled >NUL 2>&1
BCDEDIT /set allowedinmemorysettings 0x0
BCDEDIT /set {current} description "NeptuneOS v0.2"
BCDEDIT /set firstmegabytepolicy UseAll >NUL 2>&1
BCDEDIT /set avoidlowmemory 0x8000000 >NUL 2>&1
BCDEDIT /set nolowmem Yes >NUL 2>&1
bcdedit /set {current} recoveryenabled no >NUL 2>&1
BCDEDIT /timeout 5 >NUL 2>&1
BCDEDIT /deletevalue useplatformclock >NUL 2>&1


:: File System
FSUTIL behavior set allowextchar 0 >NUL 2>&1
FSUTIL behavior set Bugcheckoncorrupt 0 >NUL 2>&1
FSUTIL behavior set disable8dot3 1 >NUL 2>&1
FSUTIL behavior set disablecompression 1 >NUL 2>&1
FSUTIL behavior set disableencryption 1 >NUL 2>&1
FSUTIL behavior set disablelastaccess 1 >NUL 2>&1
FSUTIL behavior set disablespotcorruptionhandling 1 >NUL 2>&1
FSUTIL behavior set encryptpagingfile 0 >NUL 2>&1
FSUTIL behavior set quotanotify 86400 >NUL 2>&1
FSUTIL behavior set symlinkevaluation L2L:1 >NUL 2>&1
FSUTIL behavior set disabledeletenotify 0 >NUL 2>&1
FSUTIL repair set C: 0 >NUL 2>&1
label C: NeptuneOS v0.2 >NUL 2>&1


:: Device Manager
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (IKEv2)" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (IP)" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (IPv6)" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (L2TP)" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (Network Monitor)" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (PPPOE)" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (PPTP)" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (SSTP)" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Motherboard resources" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "System board" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "System Speaker" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "System Timer" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Microsoft Virtual Drive Enumerator" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Microsoft Hyper-V Virtualization Infrastructure Driver" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Microsoft GS Wavetable Synth" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Microsoft Device Association Root Enumerator" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Microsoft Kernel Debug Network Adapter" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Microsoft RRAS Root Enumerator" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "PCI Data Acquisition and Signal Processing Controller" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "PCI Simple Communications Controller" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "PCI Device" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "PCI Simple Communications Controller" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "PCI Memory Controller" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "PCI standard RAM Controller" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "ACPI Processor Aggregator" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "ACPI Wake Alarm" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "UMBus Root Bus Enumerator" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Root Print Queue" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "NDIS Virtual Network Adapter Enumerator" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Direct memory access controller" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Unknown Device" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "SM Bus Controller" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Programmable interrupt controller" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "Numeric data processor" >NUL 2>&1
"%windir%\NEPTUNE\devmanview.exe" /disable "High precision event timer" >NUL 2>&1


:: Autoruns
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Active Setup\Installed Components\{8A69D345-D564-463c-AFF1-A69D9E530F96}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Active Setup\Installed Components\{AFE6A462-C574-4B8A-AF43-4CC60DF4563B}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{29D03007-F8B1-4E12-ACAF-5C16C640D894}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{834F4B4B-2375-46D7-AB12-546EF47FC46F}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{8B76D8B3-FDFD-4A7D-B89A-C0787A05BE76}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{CFDB528C-406A-4C14-9533-64C65AA183BB}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain\{06C2AEAE-A87D-43BA-B84E-AE7E4A11C897}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{06C2AEAE-A87D-43BA-B84E-AE7E4A11C897}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{29D03007-F8B1-4E12-ACAF-5C16C640D894}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{834F4B4B-2375-46D7-AB12-546EF47FC46F}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{8B76D8B3-FDFD-4A7D-B89A-C0787A05BE76}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{CFDB528C-406A-4C14-9533-64C65AA183BB}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\AMDInstallUEP" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\GoogleUpdateTaskMachineCore" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\GoogleUpdateTaskMachineUA" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\StartCN" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\StartDVR" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\System\CurrentControlSet\Control\Terminal Server\Wds\rdpwd" /v "StartupPrograms" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Services\AMD External Events Utility" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Services\AMD External Events Utility" /v "DeleteFlag" /t REG_DWORD /d "1" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Active Setup\Installed Components\{89B4C1CD-B018-4511-B0A1-5476DBF70820}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "Open-Shell Start Menu" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\WOW6432Node\Microsoft\Active Setup\Installed Components\{89B4C1CD-B018-4511-B0A1-5476DBF70820}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain\{0E76D7E3-DA81-46BD-A750-C06B6B660CB4}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{0E76D7E3-DA81-46BD-A750-C06B6B660CB4}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Mozilla\Firefox Background Update 308046B0AF4A39CB" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\System\CurrentControlSet\Control\Session Manager\KnownDLLs" /v "_wow64win" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\System\CurrentControlSet\Control\Session Manager\KnownDLLs" /v "_wowarmhw" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\System\CurrentControlSet\Control\Session Manager\KnownDLLs" /v "_wow64" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\System\CurrentControlSet\Control\Session Manager\KnownDLLs" /v "_wow64cpu" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\FontCache3.0.0.0" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Font Drivers" /v "Adobe Type Manager" /f > NUL 2>&1


:: Disable Scheduled Tasks
for %%i in (
      "\Microsoft\Windows\WaaSMedic\PerformRemediation"
      "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance"
      "\Microsoft\Windows\Device Setup\Metadata Refresh"
      "\Microsoft\Windows\PushToInstall\LoginCheck"
      "\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask"
      "\Microsoft\Windows\Printing\EduPrintProv"
      "\Microsoft\Windows\Multimedia\Microsoft\Windows\Multimedia"
      "\Microsoft\Windows\InstallService\ScanForUpdates"
      "\Microsoft\Windows\InstallService\ScanForUpdatesAsUser"
      "\Microsoft\Windows\InstallService\SmartRetry"
      "\Microsoft\Windows\International\Synchronize Language Settings"
      "\Microsoft\Windows\Shell\FamilySafetyMonitor"
      "\Microsoft\Windows\RetailDemo\CleanupOfflineContent"
      "\Microsoft\Windows\StateRepository\MaintenanceTasks"
      "\Microsoft\Windows\SOFTWAREProtectionPlatform\SvcRestartTaskLogon"
      "\Microsoft\Windows\SOFTWAREProtectionPlatform\SvcRestartTaskNetwork"
      "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
      "\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask"
      "\MicrosoftEdgeUpdateTaskMachineCore"
      "\MicrosoftEdgeUpdateTaskMachineUA"
      "\MicrosoftEdgeUpdateBrowserReplacementTask"
      "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
      "\Microsoft\Windows\Diagnosis\Scheduled"
      "\Microsoft\Windows\Ras\MobilityManager"
      "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSYSTEM"
      "\Microsoft\Windows\NetTrace\GatherNetworkInfo"
      "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
      "\Microsoft\Windows\Application Experience\AitAgent"
      "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
      "\Microsoft\Windows\Application Experience\StartupAppTask"
      "\Microsoft\Windows\Application Experience\PcaPatchDbTask"
      "\Microsoft\Windows\Autochk\Proxy"
      "\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask"
      "\Microsoft\Windows\Chkdsk\ProactiveScan"
      "\Microsoft\Windows\Chkdsk\SyspartRepair"
      "\Microsoft\Windows\Data Integrity Scan\Data Integrity Scan"
      "\Microsoft\Windows\Data Integrity Scan\Data Integrity Scan for Crash Recovery"
      "\Microsoft\Windows\Defrag\ScheduledDefrag"
      "\Microsoft\Windows\Diagnosis\Scheduled"
      "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
      "\Microsoft\Windows\DiskCleanup\SilentCleanup"
      "\Microsoft\Windows\DiskFootPrint\Diagnostics"
      "\Microsoft\Windows\DiskFootPrint\StorageSense"
      "\Microsoft\Windows\LanguageComponentsInstaller\Uninstallation"
      "\Microsoft\Windows\MemoryDiagnostic\DecompressionFailureDetector"
      "\Microsoft\Windows\MemoryDiagnostic\CorruptionDetector"
      "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents"
      "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic"
      "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"
      "\Microsoft\Windows\Registry\RegIdleBackup"
      "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime"
      "\Microsoft\Windows\Time Synchronization\SynchronizeTime"
      "\Microsoft\Windows\Time Zone\SynchronizeTimeZone"
      "\Microsoft\Windows\UpdateOrchestrator\Reboot"
      "\Microsoft\Windows\WindowsUpdate\Scheduled Start"
      "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan"
      "\Microsoft\Windows\UpdateOrchestrator\Schedule Work"
      "\Microsoft\Windows\UpdateOrchestrator\UpdateModelTask"
      "\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker"
      "\Microsoft\Windows\UpdateOrchestrator\Report policies"
      "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task"
      "\Microsoft\Windows\UpdateOrchestrator\USO_Broker_Display"
      "\Microsoft\Windows\UPnP\UPnPHostConfig"
      "\Microsoft\Windows\User Profile Service\HiveUploadTask"
      "\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange"
      "\Microsoft\Windows\WindowsUpdate\Scheduled Start"
      "\Microsoft\Windows\WindowsUpdate\sih"
      "\Microsoft\Windows\Wininet\CacheTask"
      "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
      "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
      "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver"
      "\Microsoft\Windows\Location\Notifications"
      "\Microsoft\Windows\USB\Usb-Notifications"
      "\Microsoft\Windows\Location\WindowsActionDialog"
      "\Microsoft\Windows\Offline Files\Background Synchronization"
      "\Microsoft\Windows\Offline Files\Logon Synchronization"
      "\Microsoft\Windows\WDI\ResolutionHost"
      "\Microsoft\Windows\Workplace Join\Automatic-Device-Join"
      "Microsoft\Windows\Workplace Join\Recovery-Check"
) do (
      schtasks.exe /change /disable /tn %%i >nul 2>&1
      powerrun.exe /sw:0 schtasks.exe /change /disable /tn %%i >nul 2>&1
)


:: Powerplan 
powercfg -import "C:\Windows\NEPTUNE\power.pow" 11111111-1111-1111-1111-111111111111 > NUL 2>&1
powercfg -h off > NUL 2>&1
powercfg -changename 11111111-1111-1111-1111-111111111111 "NeptuneOS Powerplan" "A powerplan created to achieve low latency and high 0.01% lows." > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\0012ee47-9041-4b5d-9b77-535fba8b1442\d3d55efd-c1ff-424e-9dc3-441be7833010" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\0012ee47-9041-4b5d-9b77-535fba8b1442\d639518a-e56d-4345-8af2-b9f32fb26109" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\0853a681-27c8-4100-a2fd-82013e970683" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\06cadf0e-64ed-448a-8927-ce7bf90eb35d" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\12a0ab44-fe28-4fa9-b3bd-4b64f44960a6" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\4b92d758-5a24-4851-a470-815d78aee119" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\5d76a2ca-e8c0-402f-a133-2158492d58ad" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\7b224883-b3cc-4d79-819f-8374152cbe7c" /v "Attributes" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\0012ee47-9041-4b5d-9b77-535fba8b1442\6738e2c4-e8a5-4a42-b16a-e040e769756e" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\0012ee47-9041-4b5d-9b77-535fba8b1442\6738e2c4-e8a5-4a42-b16a-e040e769756e" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\0012ee47-9041-4b5d-9b77-535fba8b1442\d3d55efd-c1ff-424e-9dc3-441be7833010" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\0012ee47-9041-4b5d-9b77-535fba8b1442\d3d55efd-c1ff-424e-9dc3-441be7833010" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\0012ee47-9041-4b5d-9b77-535fba8b1442\d639518a-e56d-4345-8af2-b9f32fb26109" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\0012ee47-9041-4b5d-9b77-535fba8b1442\d639518a-e56d-4345-8af2-b9f32fb26109" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\0d7dbae2-4294-402a-ba8e-26777e8488cd\309dce9b-bef4-4119-9921-a851fb12f0f4" /v "ACSettingIndex" /t REG_DWORD /d "1" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\0d7dbae2-4294-402a-ba8e-26777e8488cd\309dce9b-bef4-4119-9921-a851fb12f0f4" /v "DCSettingIndex" /t REG_DWORD /d "1" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\19cbb8fa-5279-450e-9fac-8a3d5fedd0c1\12bbebe6-58d6-4636-95bb-3217ef867c1a" /v "ACSettingIndex" /t REG_BINARY /d "00000000" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\19cbb8fa-5279-450e-9fac-8a3d5fedd0c1\12bbebe6-58d6-4636-95bb-3217ef867c1a" /v "DCSettingIndex" /t REG_BINARY /d "00000000" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\238c9fa8-0aad-41ed-83f4-97be242c8f20\bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\238c9fa8-0aad-41ed-83f4-97be242c8f20\bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\2a737441-1930-4402-8d77-b2bebba308a3\0853a681-27c8-4100-a2fd-82013e970683" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\2a737441-1930-4402-8d77-b2bebba308a3\0853a681-27c8-4100-a2fd-82013e970683" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\2a737441-1930-4402-8d77-b2bebba308a3\48e6b7a6-50f5-4782-a5d4-53bb8f07e226" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\2a737441-1930-4402-8d77-b2bebba308a3\48e6b7a6-50f5-4782-a5d4-53bb8f07e226" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\4f971e89-eebd-4455-a8de-9e59040e7347\7648efa3-dd9c-4e3e-b566-50f929386280" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\4f971e89-eebd-4455-a8de-9e59040e7347\7648efa3-dd9c-4e3e-b566-50f929386280" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1	
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\4f971e89-eebd-4455-a8de-9e59040e7347\96996bc0-ad50-47ec-923b-6f41874dd9eb" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\4f971e89-eebd-4455-a8de-9e59040e7347\96996bc0-ad50-47ec-923b-6f41874dd9eb" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\501a4d13-42af-4429-9fd1-a8218c268e20\ee12f906-d277-404b-b6da-e5fa1a576df5" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\501a4d13-42af-4429-9fd1-a8218c268e20\ee12f906-d277-404b-b6da-e5fa1a576df5" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\06cadf0e-64ed-448a-8927-ce7bf90eb35d" /v "ACSettingIndex" /t REG_DWORD /d "2" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\06cadf0e-64ed-448a-8927-ce7bf90eb35d" /v "DCSettingIndex" /t REG_DWORD /d "2" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\12a0ab44-fe28-4fa9-b3bd-4b64f44960a6" /v "ACSettingIndex" /t REG_DWORD /d "1" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\12a0ab44-fe28-4fa9-b3bd-4b64f44960a6" /v "DCSettingIndex" /t REG_DWORD /d "1" /f > NUL 2>&1 
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\4b92d758-5a24-4851-a470-815d78aee119" /v "ACSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\4b92d758-5a24-4851-a470-815d78aee119" /v "DCSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\5d76a2ca-e8c0-402f-a133-2158492d58ad" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\5d76a2ca-e8c0-402f-a133-2158492d58ad" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\7b224883-b3cc-4d79-819f-8374152cbe7c" /v "ACSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\7b224883-b3cc-4d79-819f-8374152cbe7c" /v "DCSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c" /v "ACSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c" /v "DCSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\94d3a615-a899-4ac5-ae2b-e4d8f634367f" /v "ACSettingIndex" /t REG_DWORD /d "1" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\94d3a615-a899-4ac5-ae2b-e4d8f634367f" /v "DCSettingIndex" /t REG_DWORD /d "1" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\bc5038f7-23e0-4960-96da-33abaf5935ec" /v "ACSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\54533251-82be-4824-96c1-47b60b740d00\bc5038f7-23e0-4960-96da-33abaf5935ec" /v "DCSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\7516b95f-f776-4464-8c53-06167f40cc99\3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\7516b95f-f776-4464-8c53-06167f40cc99\3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1	
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\7516b95f-f776-4464-8c53-06167f40cc99\aded5e82-b909-4619-9949-f5d71dac0bcb" /v "ACSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\7516b95f-f776-4464-8c53-06167f40cc99\aded5e82-b909-4619-9949-f5d71dac0bcb" /v "DCSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\7516b95f-f776-4464-8c53-06167f40cc99\f1fbfde2-a960-4165-9f88-50667911ce96" /v "ACSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\7516b95f-f776-4464-8c53-06167f40cc99\f1fbfde2-a960-4165-9f88-50667911ce96" /v "DCSettingIndex" /t REG_DWORD /d "100" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\7516b95f-f776-4464-8c53-06167f40cc99\fbd9aa66-9553-4097-ba44-ed6e9d65eab8" /v "ACSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\User\PowerSchemes\11111111-1111-1111-1111-111111111111\7516b95f-f776-4464-8c53-06167f40cc99\fbd9aa66-9553-4097-ba44-ed6e9d65eab8" /v "DCSettingIndex" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMin" /t REG_DWORD /d "0" /f >NUL 2>&1
powercfg -setactive 11111111-1111-1111-1111-111111111111
powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a > NUL 2>&1
powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e > NUL 2>&1
powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c > NUL 2>&1
powercfg -delete e9a42b02-d5df-448d-aa00-03f14749eb61 > NUL 2>&1


:: Disable Power Features (Core Parking, Throttling, CoalescingTimerInterval, Energy Saving, Sleep Study)
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PerfCalculateActualUtilization" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "SleepReliabilityDetailedDiagnostics" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "QosManagesIdleProcessors" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableVsyncLatencyUpdate" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableSensorWatchdog" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "MfBufferingThreshold" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "InterruptSteeringDisabled" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "TimerRebaseThresholdOnDripsExit" /t REG_DWORD /d "30" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoreParkingDisabled" /t REG_DWORD /d 0"" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager\Executive" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\ModernSleep" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >NUL 2>&1


:: Multimedia Class Scheduler
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "AlwaysOn" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "a" /f >NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "a" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Affinity" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Background Only" /t REG_SZ /d "True" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "BackgroundPriority" /t REG_DWORD /d "8" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Clock Rate" /t REG_DWORD /d "10000" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "GPU Priority" /t REG_DWORD /d "8" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Priority" /t REG_DWORD /d "8" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Scheduling Category" /t REG_SZ /d "High" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "SFIO Priority" /t REG_SZ /d "High" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Latency Sensitive" /t REG_SZ /d "True" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Affinity" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d "False" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t REG_DWORD /d "10000" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d "18" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d "6" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Affinity" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Background Only" /t REG_SZ /d "True" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Clock Rate" /t REG_DWORD /d "10000" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "GPU Priority" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Priority" /t REG_DWORD /d "2" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Scheduling Category" /t REG_SZ /d "Medium" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "SFIO Priority" /t REG_SZ /d "Normal" /f >NUL 2>&1

:: DirectX 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "DisableAGPSupport" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "UseNonLocalVidMem" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "UseNonLocalVidMem" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "DisableDDSCAPSInDDSD" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "EmulationOnly" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectMusic" /v "DisableHWAcceleration" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "EmulatePointSprites" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "ForceRgbRasterizer" /t reg_DWORD /d "0" /f/f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "EmulateStateBlocks" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "EnableDebugging" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "FullDebug" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "DisableDM" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "EnableMultimonDebugging" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "LoadDebugRuntime" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumReference" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumSeparateMMX" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumRamp" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumNullDevice" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "FewVertices" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "DisableMMX" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "DisableMMX" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "MMX Fast Path" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "MMXFastPath" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "UseMMXForRGB" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "UseMMXForRGB" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumSeparateMMX" /t reg_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "ForceNoSysLock" /t reg_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorLatencyTolerance" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "VRROptimizeEnable=0;" /f >NUL 2>&1


:: Disable V-Sync Control & GPU Preemption
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "VsyncIdleTimeout" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d "0" /f > NUL 2>&1


:: Disable Superfetch
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableBootTrace" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "SfTracingState" /t REG_DWORD /d "0" /f >nul 2>&1


:: Paging File 
Reg.exe add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Memory Management" /v "PagingFiles" /t REG_MULTI_SZ /d "?:\pagefile.sys 2048 2048" /f >nul 2>&1


:: Split Threshold
Reg.exe add "HKLM\SYSTEM\ControlSet001\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "4294967295" /f >nul 2>&1


:: Large System Cache to improve microstuttering
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "1" /f >nul 2>&1


:: Disallow drivers to get paged into virtual memory
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f >nul 2>&1


:: Disable Page Combining
Reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePageCombining" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\currentcontrolset\control\session manager\Memory Management" /v "DisablePagingCombining" /t REG_DWORD /d "1" /f >nul 2>&1


:: Disable Swapfile
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SwapfileControl" /t REG_DWORD /d "0" /f >nul 2>&1


:: Free unused ram
Reg add "HKLM\System\CurrentControlSet\Control\Session Manager" /v "HeapDeCommitFreeBlockThreshold" /t REG_DWORD /d "262144" /f >nul 2>&1


:: Process Priorities
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WmiPrvSE.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WmiPrvSE.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\winlogon.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "2" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\winlogon.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "2" /f >NUL 2>&1


:: Global Exclusive Fullscreen 
Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f >NUL 2>&1
Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f >NUL 2>&1
Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f >NUL 2>&1
Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_DSEBehavior" /t REG_DWORD /d "2" /f >NUL 2>&1
Reg.exe delete "HKCU\System\GameConfigStore\Children" /f >NUL 2>&1
Reg.exe delete "HKCU\System\GameConfigStore\Parents" /f >NUL 2>&1

:: Reliable Timestamp
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Reliability" /v "TimeStampInterval" /t Reg_DWORD /d "1" /f >NUL 2>&1
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Reliability" /v "IoPriority" /t Reg_DWORD /d "3" /f >NUL 2>&1


:: Win32PrioritySeperation
Reg add "HKLM\System\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f >NUL 2>&1


:: Splitting Audio Services
copy /y "%windir%\System32\svchost.exe" "%windir%\System32\audiosvchost.exe" > NUL 2>&1
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv" /v "ImagePath" /t REG_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalServiceNetworkRestricted -p" /f >NUL 2>&1
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\AudioEndpointBuilder" /v "ImagePath" /t REG_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalSystemNetworkRestricted -p" /f >NUL 2>&1


:: Disable Exclusive Audio Mode 
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d 0 /f >NUL 2>&1
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d 0 /f >NUL 2>&1
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d 0 /f >NUL 2>&1
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d 0 /f >NUL 2>&1


:: Disable Memory Compression
PowerShell "Disable-MMAgent -MemoryCompression" >NUL 2>&1


:: Set background apps priority below normal
for %%i in (OriginWebHelperService.exe ShareX.exe EpicWebHelper.exe SocialClubHelper.exe steamwebhelper.exe) do (
  reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "5" /f
)


:: IOLATENCYCAP 0
FOR /F "eol=E" %%a in ('REG QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "IoLatencyCap"^| FINDSTR /V "IoLatencyCap"') DO (
	REG ADD "%%a" /F /V "IoLatencyCap" /T REG_DWORD /d 0 >NUL 2>&1

	FOR /F "tokens=*" %%z IN ("%%a") DO (
		SET STR=%%z
		SET STR=!STR:HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\=!
		SET STR=!STR:\Parameters=!
		ECHO Setting IoLatencyCap to 0 in !STR!
	)
)


:: Disable HIPM DIPM and HDD parking
FOR /F "eol=E" %%a in ('REG QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "EnableHIPM"^| FINDSTR /V "EnableHIPM"') DO (
	REG ADD "%%a" /F /V "EnableHIPM" /T REG_DWORD /d 0 >NUL 2>&1
	REG ADD "%%a" /F /V "EnableDIPM" /T REG_DWORD /d 0 >NUL 2>&1
	REG ADD "%%a" /F /V "EnableHDDParking" /T REG_DWORD /d 0 >NUL 2>&1

	FOR /F "tokens=*" %%z IN ("%%a") DO (
		SET STR=%%z
		SET STR=!STR:HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\=!
		ECHO Disabling HIPM and DIPM in !STR!
	)
)


:: Disable Powersaving on devices
for %%a in (
	EnhancedPowerManagementEnabled
	AllowIdleIrpInD3
	EnableSelectiveSuspend
	DeviceSelectiveSuspended
	SelectiveSuspendEnabled
	SelectiveSuspendOn
	WaitWakeEnabled
	D3ColdSupported
	WdfDirectedPowerTransitionEnable
	EnableIdlePowerManagement
	IdleInWorkingState
) do (
	for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "%%a" ^| findstr "HKEY"') do (
		Reg.exe add "%%b" /v "%%a" /t REG_DWORD /d "0" /f >nul 2>&1
	)
) >nul 2>&1
for %%a in (WakeEnabled WdkSelectiveSuspendEnable) do (
	for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class" /s /f "%%a" ^| findstr "HKEY"') do (
		Reg.exe add "%%b" /v "%%a" /t REG_DWORD /d "0" /f >nul 2>&1
	)
) >nul 2>&1
powershell "%WinDir%\NEPTUNE\pnp-powersaving.ps1" >nul 2>&1


:: Disable Write Cache buffer
	for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI"^| findstr "HKEY"') do (
		for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do Reg.exe add "%%a\Device Parameters\Disk" /v "CacheIsPowerProtected" /t REG_DWORD /d "1" /f >nul 2>&1
	)
	for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI"^| findstr "HKEY"') do (
		for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do Reg.exe add "%%a\Device Parameters\Disk" /v "UserWriteCacheSetting" /t REG_DWORD /d "1" /f >nul 2>&1
	)
)


:: Disable Storport Idle
for /f "tokens=*" %%s in ('reg query "HKLM\System\CurrentControlSet\Enum" /S /F "StorPort" ^| findstr /e "StorPort"') do Reg add "%%s" /v "EnableIdlePowerManagement" /t REG_DWORD /d "0" /f >nul 2>&1


:: Disable DMA Remapping
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\DmaGuard\DeviceEnumerationPolicy" /v "value" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\System\ControlSet001\Services\pci\Parameters" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\System\ControlSet001\Services\storahci\Parameters" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\System\ControlSet001\Services\stornvme\Parameters" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\System\ControlSet001\Services\USBXHCI\Parameters" /v "DmaRemappingCompatibleSelfhost" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\System\ControlSet001\Services\USBXHCI\Parameters" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f >nul 2>&1


:: Process Mitigations
for %%i in (dwm.exe lsass.exe svchost.exe WmiPrvSE.exe winlogon.exe csrss.exe) do (
	reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i" /v "MitigationOptions" /t REG_BINARY /d "22222222222222222222222222222222" /f > NUL 2>&1
	reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i" /v "MitigationAuditOptions" /t REG_BINARY /d "22222222222222222222222222222222" /f > NUL 2>&1
)


:: Spectre, Meltdown, CFG, ASLR Mitigations
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "MoveImages" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DontVerifyRandomDrivers" /t REG_DWORD /d "1" /f >nul 2>&1


:: Harden LSASS
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe" /v "AuditLevel" /t REG_DWORD /d "8" /f >nul 2>&1
Reg add "HKLM\Software\Policies\Microsoft\Windows\CredentialsDelegation" /v "AllowProtectedCreds" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdminOutboundCreds" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdmin" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "RunAsPPL" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\SecurityProviders\WDigest" /v "Negotiate" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\SecurityProviders\WDigest" /v "UseLogonCredential" /t REG_DWORD /d "0" /f >nul 2>&1


:: NTFS Mitigations
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f >nul 2>&1


:: Disable SEHOP Mitigation
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f >nul 2>&1


::Turn Core Isolation Memory Integrity OFF
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1


:: Disable TSX to mitigate zombieload
reg add "HKLM\SYSTEM\currentcontrolset\control\session manager\Kernel" /v "DisableTsx" /t REG_DWORD /d "1" /f > NUL 2>&1


:: System Mitigations
Powershell -Command "Set-ProcessMitigation -System -Disable DEP, EmulateAtlThunks, SEHOP, ForceRelocateImages, RequireInfo, BottomUp, HighEntropy, StrictHandle, DisableWin32kSystemCalls, AuditSystemCall, DisableExtensionPoints, BlockDynamicCode, AllowThreadsToOptOut, AuditDynamicCode, CFG, SuppressExports, StrictCFG, MicrosoftSignedOnly, AllowStoreSignedBinaries, AuditMicrosoftSigned, AuditStoreSigned, EnforceModuleDependencySigning, DisableNonSystemFonts, AuditFont, BlockRemoteImageLoads, BlockLowLabelImageLoads, PreferSystem32, AuditRemoteImageLoads, AuditLowLabelImageLoads, AuditPreferSystem32, EnableExportAddressFilter, AuditEnableExportAddressFilter, EnableExportAddressFilterPlus, AuditEnableExportAddressFilterPlus, EnableImportAddressFilter, AuditEnableImportAddressFilter, EnableRopStackPivot, AuditEnableRopStackPivot, EnableRopCallerCheck, AuditEnableRopCallerCheck, EnableRopSimExec, AuditEnableRopSimExec, SEHOP, AuditSEHOP, SEHOPTelemetry, TerminateOnError, DisallowChildProcessCreation, AuditChildProcess" > NUL 2>&1


:: VALORANT Mitigation Patch
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vgc.exe" /v "MitigationOptions" /t REG_BINARY /d "00000000000100000000000000000000" /f > NUL 2>&1


:: More File System
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsMftZoneReservation" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NTFSDisable8dot3NameCreation" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "DontVerifyRandomDrivers" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NTFSDisableLastAccessUpdate" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "ContigFileAllocSize" /t REG_DWORD /d "64" /f > NUL 2>&1

:: Disable Drivers and Services
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\services\Beep" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\luafv" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\FileCrypt" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\vwififlt" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\cdrom" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\UsoSvc" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\TrkWks" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\lmhosts" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Themes" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\CDPSvc" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1

:: Disable Performance Counters
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\PerfOS\Performance" /v "Collect Supports Metadata" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\PerfOS\Performance" /v "Collect Timeout" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\PerfDisk\Performance" /v "Collect Supports Metadata" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\PerfDisk\Performance" /v "Collect Timeout" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\PerfProc\Performance" /v "Collect Supports Metadata" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\PerfProc\Performance" /v "Collect Timeout" /t REG_DWORD /d "0" /f > NUL 2>&1


:: 	NETWORK TWEAKS
:: 	Some of these may default when the network driver is updated/reinstalled.
:: 	This network script is provided in the Post-Install folder along with a few other tweaks to test.

:: NIC
netsh int tcp set global autotuninglevel=normal > NUL 2>&1
netsh int tcp set global chimney=disabled > NUL 2>&1
netsh int tcp set global dca=enabled > NUL 2>&1
netsh int tcp set global netdma=disabled > NUL 2>&1
netsh int tcp set global timestamps=enabled > NUL 2>&1
netsh int tcp set global congestionprovider=ctcp > NUL 2>&1
netsh int tcp set global ecncapability=disabled > NUL 2>&1
netsh int tcp set global ecncapability=disabled > NUL 2>&1
netsh int tcp set heuristics enabled > NUL 2>&1
netsh int tcp set global rss=enabled > NUL 2>&1
netsh int tcp set global fastopen=enabled > NUL 2>&1
netsh int tcp set global nonsackrttresiliency=disabled > NUL 2>&1
netsh int tcp set global rsc=disabled > NUL 2>&1
netsh int tcp set global maxsynretransmissions=2 > NUL 2>&1
netsh int tcp set global initialRto=2000 > NUL 2>&1
netsh int tcp set supplemental Internet congestionprovider=ctcp > NUL 2>&1
netsh int tcp set supplemental template=custom icw=10 > NUL 2>&1
netsh int ip set glob defaultcurhoplimit=255 > NUL 2>&1
netsh int ip set interface "Ethernet" metric=60 > NUL 2>&1
netsh int ipv4 set subinterface "Ethernet" mtu=1500 store=persistent > NUL 2>&1

:: Disable Bandwith Reservation
reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t reg_DWORD /d "1" /f > NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t reg_DWORD /d "00000000" /f > NUL 2>&1
reg add "HKLM\Software\WOW6432Node\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t reg_DWORD /d "0" /f > NUL 2>&1

:: Disable Network Level Authentication
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_SZ /d "1" /f > NUL 2>&1

:: Set max port to 65535
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "65534" /f > NUL 2>&1

:: Reduce TIME_WAIT
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d "30" /f > NUL 2>&1

:: Reduce Time To Live
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d "64" /f > NUL 2>&1

:: Duplicate ACKs
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t REG_DWORD /d "2" /f >nul 2>&1

:: Disable SACKS
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t REG_DWORD /d "0" /f >nul 2>&1

:: Disable Multicast
reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t reg_DWORD /d "0" /f > NUL 2>&1

:: Enable TCP Extensions for High Performance
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t reg_DWORD /d "00000001" /f > NUL 2>&1

:: Enable DNS over HTTPS
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableAutoDoh" /t REG_DWORD /d "2" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t REG_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeSOACacheTime" /t REG_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NetFailureCacheTime" /t REG_DWORD /d "0" /f >NUL 2>&1

:: Disable LLMNR
Reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d "0" /f > NUL 2>&1

:: Enable The Network Adapter Onboard Processor
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableTaskOffload" /t reg_DWORD /d "0" /f >NUL 2>&1

:: Disable the TCP autotuning diagnostic tool
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableWsd" /t reg_DWORD /d "00000000" /f >NUL 2>&1

:: Disable Network Features
PowerShell -NoLogo -NoProfile -NonInteractive -Command "Enable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip,ms_pacer ; Disable-NetAdapterBinding -Name "*" -ComponentID ms_lldp,ms_lltdio,ms_implat,ms_rspndr,ms_tcpip6,ms_server,ms_msclient" > NUL 2>&1

:: Host Resolution Priority
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t REG_DWORD /d "6" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t REG_DWORD /d "5" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t REG_DWORD /d "7" /f > NUL 2>&1

:: TCP Congestion Control/Avoidance Algorithm
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "0200" /t reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f > NUL 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "1700" /t reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f > NUL 2>&1

:: Detect congestion fail to receive acknowledgement for a packet within the estimated timeout
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPCongestionControl" /t reg_DWORD /d "00000001" /f > NUL 2>&1

:: Disable Nagle's Algorithm
Reg add "HKLM\Software\Microsoft\MSMQ\Parameters" /v "TCPNoDelay" /t REG_DWORD /d "1" /f >nul 2>&1  
for /f %%s in ('Reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\NetworkCards" /f "ServiceName" /s') do set "str=%%i" & if "!str:ServiceName_=!" neq "!str!" (
		Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TCPNoDelay" /t REG_DWORD /d "1" /f
		Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f
		Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpDelAckTicks" /t REG_DWORD /d "0" /f
		Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpInitialRTT" /d "300" /t REG_DWORD /f
        Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "UseZeroBroadcast" /d "0" /t REG_DWORD /f
        Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "DeadGWDetectDefault" /d "1" /t REG_DWORD /f
) >nul 2>&1  


:: QoS Priority 
for %%i in (csgo VALORANT-Win64-Shipping javaw FortniteClient-Win64-Shipping ModernWarfare r5apex Overwatch) do (
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Application Name" /t REG_SZ /d "%%i.exe" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Version" /t REG_SZ /d "1.0" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Protocol" /t REG_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Local Port" /t REG_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Local IP" /t REG_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Local IP Prefix Length" /t REG_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Remote Port" /t REG_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Remote IP" /t REG_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Remote IP Prefix Length" /t REG_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "DSCP Value" /t REG_SZ /d "46" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Throttle Rate" /t REG_SZ /d "-1" /f
) >nul 2>&1

timeout /t 3 /nobreak >nul 2>&1
cls
goto Finish


:Finish
echo Finishing up installation and restarting. Enjoy NeptuneOS.
Reg.exe delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "POST INSTALL" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "POST INSTALL" /t REG_SZ /d "explorer \"C:\POST INSTALL\"" /f > NUL 2>&1
devmanview /enable "HID-compliant mouse" >nul 2>&1
del /f /q "%windir%\NEPTUNE\DevManView.exe" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\Open-Shell.exe" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\FullscreenCMD.vbs" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\7z.exe" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\power.pow" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\Open Shell.exe" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\yodieland.reg" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\pnp-powersaving.ps1" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\MPC.exe" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\VisualCppRedist_AIO_x86_x64.exe" > NUL 2>&1
rmdir /s /q "%windir%\NEPTUNE\DirectX" > NUL 2>&1
timeout /t 3 /nobreak >nul 2>&1

shutdown /r /f -t 5 /c "Setup Complete. Restarting."
del "%~f0"