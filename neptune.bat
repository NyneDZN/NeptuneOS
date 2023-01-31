:: Script created for NeptuneOS by nyne.#1431

:: - Credit given to
:: - amitxv (EVA) 
:: - AdamX
:: - AtlasOS
:: - DuckOS (AnhNguyen#7472, fikinoob#6487)
:: - ShDW
:: - EchoX

::  This script will only run on non-NeptuneOS builds if all prerequisites are in their respective directories.
::  If you're having trouble, please dm nyne.#1431 on discord.


@echo off

:: Delayed Expansion
setlocal EnableDelayedExpansion

:: Enviornment Variables
set version=v0.2
set build=public
set neptune=%windir%\NEPTUNE\
set onneptune=1
set network=0
set github=0

:: Setup Colors
color f0
set c_black=[30m
set c_red=[31m
set c_green=[32m
set c_gold=[33m
set c_blue=[34m
set c_purple=[35m
set c_cyan=[36m
set c_white=[37m

:: Elevation Check
 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (  
	echo An error has occured. Please restart to re-run the script or reinstall NeptuneOS.
)

:: Prevent the script from being closed
if %onneptune%==1 (
	wscript "%windir%\NEPTUNE\FullscreenCMD.vbs"
	%windir%\NEPTUNE\devmanview /disable "HID-compliant mouse"
)

:: Set Title
title Neptune %version%

:: Label Drive 
if %onneptune%==1 (
	label C: NeptuneOS %version% 
)

:: Begin Log for debugging purposes
echo NeptuneOS Logs %date% %time% >%temp%\NeptuneDebugger.txt
echo NeptuneOS Error Logs %date% %time% >%temp%\NeptuneErrors.txt

:: Can we connect to the internet?
ping -n 1 1.1.1.1 | findstr Reply >NUL && set network=1

:: What about GitHub?
ping -n 1 raw.githubusercontent.com | findstr Reply >NUL && set github=1

cls
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
timeout /t 300 > nul
cls
goto Prep


:Prep
:: neptune prerequisites
if %onneptune%==1 (
	echo %c_blue%Installing Prerequisites.. This may take some time.
	start /b /wait "%windir%\NEPTUNE\VisualCppRedist_AIO_x86_x64.exe" /ai /gm2
	"%windir%\NEPTUNE\DirectX\DXSETUP.exe" /silent 
	"%windir%\NEPTUNE\MPC.exe" /VERYSILENT /NORESTART 
	"%windir%\NEPTUNE\7z.exe" /S 
	"%windir%\NEPTUNE\Open Shell.exe" /qn ADDLOCAL=StartMenu 
	nircmd shortcut "%windir%\Memory Cleaner.exe" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" "mc" 
	nircmd shortcut "C:\POST INSTALL" "%userprofile%\Desktop" "Post-Install"  
	Regedit.exe /s "%windir%\NEPTUNE\neptune.reg" 
	PowerRun.exe /SW:0 regedit.exe /s "%windir%\NEPTUNE\neptune.reg" 
)
goto yodieland



:yodieland
:: credit atlasos
set currentuser=%windir%\NSudoLG.exe -U:C -P:E -ShowWindowMode:Hide -Wait

:: default media player
Reg.exe add "HKLM\Software\Classes\MediaPlayerClassic.Autorun\Shell\PlayCDAudio\Command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" %%1 /cd" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\MediaPlayerClassic.Autorun\Shell\PlayDVDMovie\Command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" %%1 /dvd" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\MediaPlayerClassic.Autorun\Shell\PlayMusicFiles\Command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" %%1" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\MediaPlayerClassic.Autorun\Shell\PlayVideoFiles\Command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" %%1" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3g2" /ve /t REG_SZ /d "3G2" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3g2\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3g2\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3g2\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3g2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3ga" /ve /t REG_SZ /d "3GP" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3ga\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3ga\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3ga\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3ga\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3gp" /ve /t REG_SZ /d "3GP" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3gp2" /ve /t REG_SZ /d "3G2" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3gp2\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3gp2\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3gp2\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3gp2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3gp\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3gp\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3gp\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3gp\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3gpp" /ve /t REG_SZ /d "3GP" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3gpp\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3gpp\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3gpp\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.3gpp\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aac" /ve /t REG_SZ /d "MPEG-4 Audio" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aac\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aac\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aac\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aac\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ac3" /ve /t REG_SZ /d "AC-3" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ac3\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ac3\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ac3\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ac3\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aif" /ve /t REG_SZ /d "AIFF" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aif\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aif\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aif\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aif\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aifc" /ve /t REG_SZ /d "AIFF" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aifc\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aifc\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aifc\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aifc\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aiff" /ve /t REG_SZ /d "AIFF" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aiff\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aiff\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aiff\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aiff\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.alac" /ve /t REG_SZ /d "Apple Lossless" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.alac\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.alac\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.alac\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.alac\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.amr" /ve /t REG_SZ /d "AMR" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.amr\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.amr\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.amr\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.amr\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.amv" /ve /t REG_SZ /d "Other" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.amv\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.amv\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.amv\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.amv\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aob" /ve /t REG_SZ /d "Other Audio" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aob\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aob\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aob\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.aob\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ape" /ve /t REG_SZ /d "Monkey's Audio" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ape\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ape\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ape\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ape\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.apl" /ve /t REG_SZ /d "Monkey's Audio" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.apl\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.apl\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.apl\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.apl\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.asf" /ve /t REG_SZ /d "Windows Media Video" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.asf\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.asf\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.asf\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.asf\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.asx" /ve /t REG_SZ /d "Playlist" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.asx\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.asx\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.asx\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.asx\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.au" /ve /t REG_SZ /d "AU/SND" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.au\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.au\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.au\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.au\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.avi" /ve /t REG_SZ /d "AVI" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.avi\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.avi\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.avi\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.avi\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.bdmv" /ve /t REG_SZ /d "Blu-ray playlist" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.bdmv\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.bdmv\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.bdmv\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.bdmv\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.bik" /ve /t REG_SZ /d "Smacker/Bink Video" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.bik\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.bik\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.bik\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.bik\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.cda" /ve /t REG_SZ /d "Audio CD track" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.cda\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.cda\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.cda\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.cda\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.divx" /ve /t REG_SZ /d "Other" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.divx\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.divx\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.divx\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.divx\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dsa" /ve /t REG_SZ /d "DirectShow Media" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dsa\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dsa\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dsa\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dsa\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dsm" /ve /t REG_SZ /d "DirectShow Media" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dsm\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dsm\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dsm\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dsm\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dss" /ve /t REG_SZ /d "DirectShow Media" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dss\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dss\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dss\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dss\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dsv" /ve /t REG_SZ /d "DirectShow Media" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dsv\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dsv\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dsv\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dsv\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dts" /ve /t REG_SZ /d "DTS/DTS-HD" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dts\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dts\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dts\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dts\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dtshd" /ve /t REG_SZ /d "DTS/DTS-HD" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dtshd\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dtshd\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dtshd\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dtshd\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dtsma" /ve /t REG_SZ /d "DTS/DTS-HD" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dtsma\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dtsma\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dtsma\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.dtsma\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.evo" /ve /t REG_SZ /d "MPEG" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.evo\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.evo\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.evo\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.evo\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.f4v" /ve /t REG_SZ /d "Flash Video" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.f4v\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.f4v\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.f4v\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.f4v\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flac" /ve /t REG_SZ /d "FLAC" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flac\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flac\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flac\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flac\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flc" /ve /t REG_SZ /d "FLIC Animation" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flc\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flc\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flc\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flc\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.fli" /ve /t REG_SZ /d "FLIC Animation" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.fli\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.fli\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.fli\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.fli\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flic" /ve /t REG_SZ /d "FLIC Animation" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flic\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flic\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flic\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flic\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flv" /ve /t REG_SZ /d "Flash Video" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flv\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flv\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flv\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.flv\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.hdmov" /ve /t REG_SZ /d "MP4" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.hdmov\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.hdmov\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.hdmov\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.hdmov\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ifo" /ve /t REG_SZ /d "DVD-Video" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ifo\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ifo\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ifo\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ifo\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ivf" /ve /t REG_SZ /d "Indeo Video Format" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ivf\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ivf\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ivf\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ivf\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m1a" /ve /t REG_SZ /d "MPEG audio" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m1a\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m1a\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m1a\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m1a\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m1v" /ve /t REG_SZ /d "MPEG" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m1v\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m1v\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m1v\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m1v\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2a" /ve /t REG_SZ /d "MPEG audio" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2a\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2a\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2a\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2a\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2p" /ve /t REG_SZ /d "MPEG" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2p\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2p\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2p\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2p\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2t" /ve /t REG_SZ /d "MPEG-TS" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2t\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2t\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2t\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2t\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2ts" /ve /t REG_SZ /d "MPEG-TS" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2ts\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2ts\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2ts\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2ts\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2v" /ve /t REG_SZ /d "MPEG" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2v\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2v\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2v\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m2v\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m3u" /ve /t REG_SZ /d "Playlist" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m3u8" /ve /t REG_SZ /d "Playlist" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m3u8\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m3u8\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m3u8\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m3u8\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m3u\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m3u\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m3u\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m3u\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4a" /ve /t REG_SZ /d "MPEG-4 Audio" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4a\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4a\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4a\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4a\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4b" /ve /t REG_SZ /d "MPEG-4 Audio" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4b\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4b\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4b\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4b\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4r" /ve /t REG_SZ /d "MPEG-4 Audio" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4r\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4r\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4r\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4r\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4v" /ve /t REG_SZ /d "MP4" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4v\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4v\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4v\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.m4v\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mid" /ve /t REG_SZ /d "MIDI" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mid\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mid\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mid\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mid\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.midi" /ve /t REG_SZ /d "MIDI" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.midi\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.midi\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.midi\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.midi\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mk3d" /ve /t REG_SZ /d "Matroska" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mk3d\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mk3d\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mk3d\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mk3d\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mka" /ve /t REG_SZ /d "Matroska audio" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mka\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mka\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mka\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mka\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mkv" /ve /t REG_SZ /d "Matroska" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mkv\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mkv\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mkv\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mkv\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mlp" /ve /t REG_SZ /d "Other Audio" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mlp\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mlp\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mlp\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mlp\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mov" /ve /t REG_SZ /d "QuickTime Movie" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mov\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mov\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mov\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mov\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp2" /ve /t REG_SZ /d "MPEG audio" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp2\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp2\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp2\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp2v" /ve /t REG_SZ /d "MPEG" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp2v\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp2v\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp2v\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp2v\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp3" /ve /t REG_SZ /d "MP3" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp3\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp3\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp3\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp3\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp4" /ve /t REG_SZ /d "MP4" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp4\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp4\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp4\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp4\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp4v" /ve /t REG_SZ /d "MP4" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp4v\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp4v\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp4v\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mp4v\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpa" /ve /t REG_SZ /d "MPEG audio" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpa\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpa\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpa\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpa\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpc" /ve /t REG_SZ /d "Musepack" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpc\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpc\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpc\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpc\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpcpl" /ve /t REG_SZ /d "Playlist" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpcpl\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpcpl\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpcpl\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpcpl\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpe" /ve /t REG_SZ /d "MPEG" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpe\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpe\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpe\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpe\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpeg" /ve /t REG_SZ /d "MPEG" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpeg\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpeg\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpeg\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpeg\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpg" /ve /t REG_SZ /d "MPEG" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpg\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpg\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpg\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpg\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpls" /ve /t REG_SZ /d "Blu-ray playlist" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpls\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpls\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpls\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpls\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpv2" /ve /t REG_SZ /d "MPEG" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpv2\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpv2\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpv2\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpv2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpv4" /ve /t REG_SZ /d "MP4" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpv4\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpv4\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpv4\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mpv4\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mts" /ve /t REG_SZ /d "MPEG-TS" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mts\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mts\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mts\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.mts\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ofr" /ve /t REG_SZ /d "OptimFROG" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ofr\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ofr\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ofr\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ofr\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ofs" /ve /t REG_SZ /d "OptimFROG" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ofs\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ofs\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ofs\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ofs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.oga" /ve /t REG_SZ /d "Ogg Vorbis" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.oga\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.oga\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.oga\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.oga\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ogg" /ve /t REG_SZ /d "Ogg Vorbis" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ogg\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ogg\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ogg\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ogg\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ogm" /ve /t REG_SZ /d "Ogg Media" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ogm\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ogm\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ogm\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ogm\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ogv" /ve /t REG_SZ /d "Ogg Media" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ogv\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ogv\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ogv\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ogv\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.opus" /ve /t REG_SZ /d "Opus Audio Codec" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.opus\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.opus\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.opus\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.opus\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.pls" /ve /t REG_SZ /d "Playlist" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.pls\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.pls\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.pls\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.pls\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.pva" /ve /t REG_SZ /d "MPEG" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.pva\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.pva\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.pva\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.pva\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ra" /ve /t REG_SZ /d "Real Audio" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ra\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ra\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ra\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ra\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ram" /ve /t REG_SZ /d "Real Script" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ram\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ram\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ram\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ram\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rec" /ve /t REG_SZ /d "MPEG-TS" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rec\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rec\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rec\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rec\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rm" /ve /t REG_SZ /d "Real Media" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rm\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rm\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rm\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rm\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rmi" /ve /t REG_SZ /d "MIDI" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rmi\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rmi\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rmi\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rmi\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rmm" /ve /t REG_SZ /d "Real Script" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rmm\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rmm\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rmm\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rmm\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rmvb" /ve /t REG_SZ /d "Real Media" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rmvb\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rmvb\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rmvb\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rmvb\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rp" /ve /t REG_SZ /d "Real Script" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rp\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rp\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rp\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rp\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rpm" /ve /t REG_SZ /d "Real Script" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rpm\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rpm\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rpm\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rpm\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rt" /ve /t REG_SZ /d "Real Script" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rt\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rt\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rt\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.rt\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.smi" /ve /t REG_SZ /d "Real Script" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.smi\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.smi\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.smi\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.smi\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.smil" /ve /t REG_SZ /d "Real Script" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.smil\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.smil\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.smil\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.smil\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.smk" /ve /t REG_SZ /d "Smacker/Bink Video" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.smk\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.smk\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.smk\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.smk\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.snd" /ve /t REG_SZ /d "AU/SND" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.snd\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.snd\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.snd\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.snd\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ssif" /ve /t REG_SZ /d "MPEG-TS" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ssif\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ssif\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ssif\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ssif\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.swf" /ve /t REG_SZ /d "Shockwave Flash" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.swf\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.swf\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.swf\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.swf\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.tak" /ve /t REG_SZ /d "TAK" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.tak\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.tak\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.tak\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.tak\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.thd" /ve /t REG_SZ /d "Other Audio" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.thd\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.thd\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.thd\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.thd\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.tp" /ve /t REG_SZ /d "MPEG-TS" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.tp\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.tp\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.tp\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.tp\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.trp" /ve /t REG_SZ /d "MPEG-TS" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.trp\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.trp\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.trp\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.trp\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ts" /ve /t REG_SZ /d "MPEG-TS" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ts\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ts\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ts\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.ts\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.tta" /ve /t REG_SZ /d "True Audio" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.tta\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.tta\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.tta\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.tta\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.vob" /ve /t REG_SZ /d "DVD-Video" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.vob\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.vob\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.vob\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.vob\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wav" /ve /t REG_SZ /d "WAV" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wav\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wav\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wav\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wav\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wax" /ve /t REG_SZ /d "Playlist" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wax\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wax\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wax\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wax\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.webm" /ve /t REG_SZ /d "WebM" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.webm\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.webm\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.webm\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.webm\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wm" /ve /t REG_SZ /d "Windows Media Video" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wm\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wm\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wm\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wm\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wma" /ve /t REG_SZ /d "Windows Media Audio" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wma\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wma\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wma\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wma\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wmp" /ve /t REG_SZ /d "Windows Media Video" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wmp\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wmp\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wmp\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wmp\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wmv" /ve /t REG_SZ /d "Windows Media Video" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wmv\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wmv\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wmv\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wmv\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wmx" /ve /t REG_SZ /d "Playlist" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wmx\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wmx\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wmx\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wmx\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wv" /ve /t REG_SZ /d "WavPack" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wv\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wv\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wv\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wv\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wvx" /ve /t REG_SZ /d "Playlist" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wvx\DefaultIcon" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\",0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wvx\shell\open" /v "Icon" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wvx\shell\open" /ve /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Classes\mplayerc64.wvx\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\MPC-HC\mpc-hc64.exe\" \"%%1\"" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mpe" /t REG_SZ /d "mplayerc64.mpe" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".m1v" /t REG_SZ /d "mplayerc64.m1v" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".m2v" /t REG_SZ /d "mplayerc64.m2v" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mpv2" /t REG_SZ /d "mplayerc64.mpv2" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mp2v" /t REG_SZ /d "mplayerc64.mp2v" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".pva" /t REG_SZ /d "mplayerc64.pva" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".evo" /t REG_SZ /d "mplayerc64.evo" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".m2p" /t REG_SZ /d "mplayerc64.m2p" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".ts" /t REG_SZ /d "mplayerc64.ts" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".tp" /t REG_SZ /d "mplayerc64.tp" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".trp" /t REG_SZ /d "mplayerc64.trp" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".m2t" /t REG_SZ /d "mplayerc64.m2t" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".m2ts" /t REG_SZ /d "mplayerc64.m2ts" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mts" /t REG_SZ /d "mplayerc64.mts" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".rec" /t REG_SZ /d "mplayerc64.rec" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".ssif" /t REG_SZ /d "mplayerc64.ssif" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".vob" /t REG_SZ /d "mplayerc64.vob" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".ifo" /t REG_SZ /d "mplayerc64.ifo" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mkv" /t REG_SZ /d "mplayerc64.mkv" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mk3d" /t REG_SZ /d "mplayerc64.mk3d" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".webm" /t REG_SZ /d "mplayerc64.webm" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mp4" /t REG_SZ /d "mplayerc64.mp4" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".m4v" /t REG_SZ /d "mplayerc64.m4v" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mp4v" /t REG_SZ /d "mplayerc64.mp4v" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mpv4" /t REG_SZ /d "mplayerc64.mpv4" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".hdmov" /t REG_SZ /d "mplayerc64.hdmov" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mov" /t REG_SZ /d "mplayerc64.mov" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".3gp" /t REG_SZ /d "mplayerc64.3gp" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".3gpp" /t REG_SZ /d "mplayerc64.3gpp" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".3ga" /t REG_SZ /d "mplayerc64.3ga" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".3g2" /t REG_SZ /d "mplayerc64.3g2" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".3gp2" /t REG_SZ /d "mplayerc64.3gp2" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".flv" /t REG_SZ /d "mplayerc64.flv" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".f4v" /t REG_SZ /d "mplayerc64.f4v" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".ogm" /t REG_SZ /d "mplayerc64.ogm" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".ogv" /t REG_SZ /d "mplayerc64.ogv" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".rm" /t REG_SZ /d "mplayerc64.rm" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".rmvb" /t REG_SZ /d "mplayerc64.rmvb" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".rt" /t REG_SZ /d "mplayerc64.rt" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".ram" /t REG_SZ /d "mplayerc64.ram" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".rpm" /t REG_SZ /d "mplayerc64.rpm" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".rmm" /t REG_SZ /d "mplayerc64.rmm" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".rp" /t REG_SZ /d "mplayerc64.rp" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".smi" /t REG_SZ /d "mplayerc64.smi" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".smil" /t REG_SZ /d "mplayerc64.smil" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".wmv" /t REG_SZ /d "mplayerc64.wmv" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".wmp" /t REG_SZ /d "mplayerc64.wmp" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".wm" /t REG_SZ /d "mplayerc64.wm" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".asf" /t REG_SZ /d "mplayerc64.asf" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".smk" /t REG_SZ /d "mplayerc64.smk" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".bik" /t REG_SZ /d "mplayerc64.bik" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".fli" /t REG_SZ /d "mplayerc64.fli" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".flc" /t REG_SZ /d "mplayerc64.flc" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".flic" /t REG_SZ /d "mplayerc64.flic" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".dsm" /t REG_SZ /d "mplayerc64.dsm" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".dsv" /t REG_SZ /d "mplayerc64.dsv" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mpeg" /t REG_SZ /d "mplayerc64.mpeg" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".dss" /t REG_SZ /d "mplayerc64.dss" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".ivf" /t REG_SZ /d "mplayerc64.ivf" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".swf" /t REG_SZ /d "mplayerc64.swf" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".divx" /t REG_SZ /d "mplayerc64.divx" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".amv" /t REG_SZ /d "mplayerc64.amv" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".ac3" /t REG_SZ /d "mplayerc64.ac3" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".dts" /t REG_SZ /d "mplayerc64.dts" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".dtshd" /t REG_SZ /d "mplayerc64.dtshd" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".dtsma" /t REG_SZ /d "mplayerc64.dtsma" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".aif" /t REG_SZ /d "mplayerc64.aif" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".aifc" /t REG_SZ /d "mplayerc64.aifc" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".aiff" /t REG_SZ /d "mplayerc64.aiff" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mpg" /t REG_SZ /d "mplayerc64.mpg" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".amr" /t REG_SZ /d "mplayerc64.amr" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".ape" /t REG_SZ /d "mplayerc64.ape" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".apl" /t REG_SZ /d "mplayerc64.apl" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".au" /t REG_SZ /d "mplayerc64.au" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".snd" /t REG_SZ /d "mplayerc64.snd" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".cda" /t REG_SZ /d "mplayerc64.cda" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".flac" /t REG_SZ /d "mplayerc64.flac" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".m4a" /t REG_SZ /d "mplayerc64.m4a" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".m4b" /t REG_SZ /d "mplayerc64.m4b" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".m4r" /t REG_SZ /d "mplayerc64.m4r" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".aac" /t REG_SZ /d "mplayerc64.aac" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mid" /t REG_SZ /d "mplayerc64.mid" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".midi" /t REG_SZ /d "mplayerc64.midi" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".rmi" /t REG_SZ /d "mplayerc64.rmi" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mka" /t REG_SZ /d "mplayerc64.mka" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mp3" /t REG_SZ /d "mplayerc64.mp3" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mpa" /t REG_SZ /d "mplayerc64.mpa" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mp2" /t REG_SZ /d "mplayerc64.mp2" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".m1a" /t REG_SZ /d "mplayerc64.m1a" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".m2a" /t REG_SZ /d "mplayerc64.m2a" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mpc" /t REG_SZ /d "mplayerc64.mpc" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".ofr" /t REG_SZ /d "mplayerc64.ofr" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".ofs" /t REG_SZ /d "mplayerc64.ofs" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".ogg" /t REG_SZ /d "mplayerc64.ogg" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".oga" /t REG_SZ /d "mplayerc64.oga" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".opus" /t REG_SZ /d "mplayerc64.opus" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".ra" /t REG_SZ /d "mplayerc64.ra" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".tak" /t REG_SZ /d "mplayerc64.tak" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".tta" /t REG_SZ /d "mplayerc64.tta" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".wav" /t REG_SZ /d "mplayerc64.wav" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".wma" /t REG_SZ /d "mplayerc64.wma" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".wv" /t REG_SZ /d "mplayerc64.wv" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".aob" /t REG_SZ /d "mplayerc64.aob" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mlp" /t REG_SZ /d "mplayerc64.mlp" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".thd" /t REG_SZ /d "mplayerc64.thd" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".asx" /t REG_SZ /d "mplayerc64.asx" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".m3u" /t REG_SZ /d "mplayerc64.m3u" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".m3u8" /t REG_SZ /d "mplayerc64.m3u8" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".pls" /t REG_SZ /d "mplayerc64.pls" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".wvx" /t REG_SZ /d "mplayerc64.wvx" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".wax" /t REG_SZ /d "mplayerc64.wax" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".wmx" /t REG_SZ /d "mplayerc64.wmx" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mpcpl" /t REG_SZ /d "mplayerc64.mpcpl" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".mpls" /t REG_SZ /d "mplayerc64.mpls" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".bdmv" /t REG_SZ /d "mplayerc64.bdmv" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".avi" /t REG_SZ /d "mplayerc64.avi" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".dsa" /t REG_SZ /d "mplayerc64.dsa" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Clients\Media\Media Player Classic\Capabilities\FileAssociations" /v ".alac" /t REG_SZ /d "mplayerc64.alac" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlers\PlayCDAudioOnArrival" /v "MPCPlayCDAudioOnArrival" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlers\PlayDVDMovieOnArrival" /v "MPCPlayDVDMovieOnArrival" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlers\PlayMusicFilesOnArrival" /v "MPCPlayMusicFilesOnArrival" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlers\PlayVideoFilesOnArrival" /v "MPCPlayVideoFilesOnArrival" /t REG_SZ /d "" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayCDAudioOnArrival" /v "DefaultIcon" /t REG_SZ /d "C:\Program Files\MPC-HC\mpc-hc64.exe,0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayCDAudioOnArrival" /v "InvokeVerb" /t REG_SZ /d "PlayCDAudio" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayCDAudioOnArrival" /v "InvokeProgID" /t REG_SZ /d "MediaPlayerClassic.Autorun" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayCDAudioOnArrival" /v "Provider" /t REG_SZ /d "Media Player Classic" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayCDAudioOnArrival" /v "Action" /t REG_SZ /d "Play Audio CD" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayDVDMovieOnArrival" /v "InvokeVerb" /t REG_SZ /d "PlayDVDMovie" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayDVDMovieOnArrival" /v "DefaultIcon" /t REG_SZ /d "C:\Program Files\MPC-HC\mpc-hc64.exe,0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayDVDMovieOnArrival" /v "InvokeProgID" /t REG_SZ /d "MediaPlayerClassic.Autorun" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayDVDMovieOnArrival" /v "Provider" /t REG_SZ /d "Media Player Classic" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayDVDMovieOnArrival" /v "Action" /t REG_SZ /d "Play DVD Movie" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayMusicFilesOnArrival" /v "Provider" /t REG_SZ /d "Media Player Classic" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayMusicFilesOnArrival" /v "InvokeProgID" /t REG_SZ /d "MediaPlayerClassic.Autorun" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayMusicFilesOnArrival" /v "InvokeVerb" /t REG_SZ /d "PlayMusicFiles" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayMusicFilesOnArrival" /v "Action" /t REG_SZ /d "Play Music" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayMusicFilesOnArrival" /v "DefaultIcon" /t REG_SZ /d "C:\Program Files\MPC-HC\mpc-hc64.exe,0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayVideoFilesOnArrival" /v "DefaultIcon" /t REG_SZ /d "C:\Program Files\MPC-HC\mpc-hc64.exe,0" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayVideoFilesOnArrival" /v "Provider" /t REG_SZ /d "Media Player Classic" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayVideoFilesOnArrival" /v "Action" /t REG_SZ /d "Play Video" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayVideoFilesOnArrival" /v "InvokeVerb" /t REG_SZ /d "PlayVideoFiles" /f > NUL 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\MPCPlayVideoFilesOnArrival" /v "InvokeProgID" /t REG_SZ /d "MediaPlayerClassic.Autorun" /f > NUL 2>&1

:: Delete obsolete registry keys
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\HotStart" /f 
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Sidebar" /f 
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Telephony" /f 
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Screensavers" /f 
reg delete "HKCU\Printers" /f 
reg delete "HKLM\SYSTEM\ControlSet001\Control\Print" /f 
reg delete "HKCU\System\GameConfigStore\Children" /f 
reg delete "HKCU\System\GameConfigStore\Parents" /f 
reg delete "HKEY_USERS\.DEFAULT\System\GameConfigStore\Children" /f 
reg delete "HKEY_USERS\.DEFAULT\System\GameConfigStore\Parents" /f 

:: disable microsoft account syncing
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t Reg_DWORD /d 5 /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t Reg_DWORD /d 0 /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\AppSync" /v "Enabled" /t Reg_DWORD /d 0 /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t Reg_DWORD /d 0 /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t Reg_DWORD /d 0 /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\DesktopTheme" /v "Enabled" /t Reg_DWORD /d 0 /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t Reg_DWORD /d 0 /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\PackageState" /v "Enabled" /t Reg_DWORD /d 0 /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t Reg_DWORD /d 0 /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\StartLayout" /v "Enabled" /t Reg_DWORD /d 0 /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t Reg_DWORD /d 0 /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t Reg_DWORD /d 2 /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t Reg_DWORD /d 1 /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableAppSyncSettingSync" /t Reg_DWORD /d 2 /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableAppSyncSettingSyncUserOverride" /t Reg_DWORD /d 1 /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableApplicationSettingSync" /t Reg_DWORD /d 2 /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableApplicationSettingSyncUserOverride" /t Reg_DWORD /d 1 /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableCredentialsSettingSync" /t Reg_DWORD /d 2 /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableCredentialsSettingSyncUserOverride" /t Reg_DWORD /d 1 /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableDesktopThemeSettingSync" /t Reg_DWORD /d 2 /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableDesktopThemeSettingSyncUserOverride" /t Reg_DWORD /d 1 /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisablePersonalizationSettingSync" /t Reg_DWORD /d 2 /f 
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisablePersonalizationSettingSyncUserOverride" /t Reg_DWORD /d 1 /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableStartLayoutSettingSync" /t Reg_DWORD /d 2 /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableStartLayoutSettingSyncUserOverride" /t Reg_DWORD /d 1 /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSyncOnPaidNetwork" /t Reg_DWORD /d 1 /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWebBrowserSettingSync" /t Reg_DWORD /d 2 /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWebBrowserSettingSyncUserOverride" /t Reg_DWORD /d 1 /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWindowsSettingSync" /t Reg_DWORD /d 2 /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWindowsSettingSyncUserOverride" /t Reg_DWORD /d 1 /f

:: disable customer experience improvement program (ceip)
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Messenger\Client" /v "CEIP" /t REG_DWORD /d "2" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient" /v "CorporateSQMURL" /t REG_SZ /d "0.0.0.0" /f

:: enable dark mode
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d "0" /f
:: disable transparency
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f
:: disable wide context menu
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\FlightedFeatures" /v "ImmersiveContextMenu" /t REG_DWORD /d "0" /f
:: hide meet now button on taskbar
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f
:: hide people on taskbar
%currentuser% reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HidePeopleBar" /t REG_DWORD /d "1" /f
:: hide task view button on taskbar
%currentuser% reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MultiTaskingView\AllUpView" /v "Enabled" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /D "0" /f
:: always unload dll
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "AlwaysUnloadDLL" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AlwaysUnloadDLL" /v "Default" /t REG_DWORD /d "1" /f
:: disable toast notifications
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /t REG_DWORD /d "1" /f
:: enable balloon notifications
%currentuser% reg add HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer /v EnableLegacyBalloonNotifications /t REG_DWORD /d 1 /f
:: Unhide icons, don't put them in the sys tray
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d "0" /f 
:: configure file explorer
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d "1" /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowInfoTip" /t REG_DWORD /d "0" /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowStatusBar" /t REG_DWORD /d "0" /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "0" /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowPreviewHandlers" /t REG_DWORD /d "0" /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SharingWizardOn" /t REG_DWORD /d "0" /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarGlomLevel" /t REG_DWORD /d "2" /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d "1" /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d "0" /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCompColor" /t REG_DWORD /d "0" /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapFill" /t REG_DWORD /d "0" /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "JointResize" /t REG_DWORD /d "0" /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapAssist" /t REG_DWORD /d "0" /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StoreAppsOnTaskbar" /t REG_DWORD /d "0" /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "IconsOnly" /t REG_DWORD /d "0" /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SeparateProcess" /t REG_DWORD /d "0" /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DontPrettyPath" /t REG_DWORD /d "1" /f
%currentuser% Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HideRecentlyAddedApps" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "ShowOrHideMostUsedApps" /t REG_DWORD /d "2" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoDataExecutionPrevention" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoHeapTerminationOnCorruption" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoNewAppAlert" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableContextMenusInStart" /t REG_DWORD /d "0" /f

:: fix dualboot timezone issues
reg add "HKLM\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f

:: disable ease of access 
%currentuser% reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_DWORD /d "0" /f

:: configure application permissions
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t REG_SZ /d "Deny" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /v "Value" /t REG_SZ /d "Deny" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t REG_SZ /d "Deny" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /v "Value" /t REG_SZ /d "Deny" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /v "Value" /t REG_SZ /d "Deny" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t REG_SZ /d "Deny" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /v "Value" /t REG_SZ /d "Deny" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /v "Value" /t REG_SZ /d "Deny" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" /v "Value" /t REG_SZ /d "Deny" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /v "Value" /t REG_SZ /d "Deny" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /v "Value" /t REG_SZ /d "Deny" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /v "Value" /t REG_SZ /d "Deny" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t REG_SZ /d "Deny" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /v "Value" /t REG_SZ /d "Deny" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /v "Value" /t REG_SZ /d "Deny" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /v "Value" /t REG_SZ /d "Deny" /f

:: disable settings sync
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSyncOnPaidNetwork" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t REG_DWORD /d "5" /f

:: enable legacy photo viewer
for %%i in (tif tiff bmp dib gif jfif jpe jpeg jpg jxr png) do (
    reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".%%~i" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f
)

:: set legacy photo viewer as default
for %%i in (tif tiff bmp dib gif jfif jpe jpeg jpg jxr png) do (
    %currentuser% reg add "HKCU\SOFTWARE\Classes\.%%~i" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f
    %currentuser% reg add "HKCU\SOFTWARE\Classes\.wdp" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f
)

:: disable background apps
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d "2" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f

:: apply the default account picture to all users
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "UseDefaultTile" /t REG_DWORD /d "1" /f

:: do not reduce sounds while in a call
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d "3" /f

:: do not show hidden/disconnected devices in sound settings
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowDisconnectedDevices" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowHiddenDevices" /t REG_DWORD /d "0" /f

:: set sound scheme to no sounds
PowerShell -NoProfile -Command "New-ItemProperty -Path HKCU:\AppEvents\Schemes -Name '(Default)' -Value '.None' -Force | Out-Null"
PowerShell -NoProfile -Command "Get-ChildItem -Path 'HKCU:\AppEvents\Schemes\Apps' | Get-ChildItem | Get-ChildItem | Where-Object {$_.PSChildName -eq '.Current'} | Set-ItemProperty -Name '(Default)' -Value ''"

:: remove '- Shortcut' text added onto shortcuts
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d "00000000" /f

:: disable exclusive mode for audio devices
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d 0 /f
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d 0 /f
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d 0 /f
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do PowerRun.exe /SW:0 Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d 0 /f

:: audio panel
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" /v "EnableMtcUvc" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Multimedia\Audio\DeviceCpl" /v "VolumeUnits" /t REG_DWORD /d "0" /f
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore" /f 

:: bsod settings 
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f 
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d "0" /f 

:: old alt tab
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "AltTabSettings" /t REG_DWORD /d "1" /f

:: disable windows spotlight features
%currentuser% reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightFeatures" /t REG_DWORD /d "1" /f

:: disable tips for settings app (immersive control panel)
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowOnlineTips" /v "value" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllowOnlineTips" /t REG_DWORD /d "0" /f

:: disable suggest ways I can finish setting up my device
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d "0" /f

:: disable automatically restart apps after sign in
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "RestartApps" /t REG_DWORD /d "0" /f

:: disable disk quota
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DiskQuota" /v "Enable" /t REG_DWORD /d "0" /f

:: do not allow pinning microsoft store app to taskbar
%currentuser% reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoPinningStoreToTaskbar" /t REG_DWORD /d "1" /f

:: disable program compatibility assistant
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableEngine" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d "1" /f


:: disable enhance pointer precison
%currentuser% reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f
%currentuser% reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f
%currentuser% reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f
%currentuser% reg add "HKCU\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "0" /f

:: configure ease of access settings
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Ease of Access" /v "selfvoice" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Ease of Access" /v "selfscan" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Control Panel\Accessibility" /v "Sound on Activation" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Control Panel\Accessibility" /v "Warning Sounds" /t REG_DWORD /d "0" /f

:: disable annoying keyboard features
%currentuser% reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Control Panel\Accessibility\MouseKeys" /v "Flags" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_DWORD /d "0" /f

:: disable windows error reporting
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultConsent" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultOverrideBehavior" /t REG_DWORD /d "1" /f

:: disable data collection
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowDeviceNameInTelemetry" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f

:: disable windows feedback
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f 
%currentuser% reg delete "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f

:: show all tasks on control panel, credits to tenforums
reg add "HKLM\SOFTWARE\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /ve /t REG_SZ /d "All Tasks" /f
reg add "HKLM\SOFTWARE\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /v "InfoTip" /t REG_SZ /d "View list of all Control Panel tasks" /f
reg add "HKLM\SOFTWARE\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /v "System.ControlPanel.Category" /t REG_SZ /d "5" /f
reg add "HKLM\SOFTWARE\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}\DefaultIcon" /ve /t REG_SZ /d "%%WinDir%%\System32\imageres.dll,-27" /f
reg add "HKLM\SOFTWARE\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}\Shell\Open\Command" /ve /t REG_SZ /d "explorer.exe shell:::{ED7BA470-8E54-465E-825C-99712043E01C}" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\NameSpace\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /ve /t REG_SZ /d "All Tasks" /f

:: disable hyper-v and vbs
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "EnableVirtualizationBasedSecurity" /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "RequirePlatformSecurityFeatures" /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HypervisorEnforcedCodeIntegrity" /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HVCIMATRequired" /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "LsaCfgFlags" /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "ConfigureSystemGuardLaunch" /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequireMicrosoftSignedBootChain" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f

:: disable fault tolerant heap
reg add "HKLM\SOFTWARE\Microsoft\FTH" /v "Enabled" /t REG_DWORD /d "0" /f

:: disable autoplay and autorun
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v "DisableAutoplay" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d "255" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoAutoplayfornonVolume" /t REG_DWORD /d "1" /f

:: disable delay for run and runonce keys
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DelayedDesktopSwitchTimeout" /t reg_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t reg_DWORD /d "0" /f 


:: desktop timeouts
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f 
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "8" /f 
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "1000" /f 
%currentuser% Reg.exe add "HKCU\Control Panel\Desktop" /v "LowLevelHooksTimeout" /t REG_SZ /d "1000" /f 
Reg.exe add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "100" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "1000" /f 

:: disable updates
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "UseWUServer" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "IncludeRecommendedUpdates" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DoNotConnectToWindowsUpdateInternetLocations" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "UpdateServiceUrlAlternate" /t REG_SZ /d "http://disableupdateserver.com/" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUServer" /t REG_SZ /d "http://disableupdateserver.com/" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUStatusServer" /t REG_SZ /d "http://disableupdateserver.com/" /f 
Reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgrade" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate" /v "value" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate" /v "value" /t REG_DWORD /d "1" /f

:: disable telemetry
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /d "0" /t REG_DWORD /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowClipboardHistory" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowCrossDeviceClipboard" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v "value" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v "value" /t REG_DWORD /d "0" /f

:: configure dwm
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableWindowColorization" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f 
reg add "HKLM\Software\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f 
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "Composition" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowComposition" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DWMWA_TRANSITIONS_FORCEDISABLED" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "DisableDrawListCaching" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "DisallowNonDrawListRendering" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "EnableCpuClipping" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "EnableDrawToBackbuffer" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "EnableImageProcessing" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "EnableMPCPerfCounter" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "TelemetryFramesSequenceMaximumPeriodMilliseconds" /t REG_DWORD /d "500" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "UseHWDrawListEntriesOnWARP" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d "5" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "DwmInputUsesIoCompletionPort" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "EnableDwmInputProcessing" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm\ExtendedComposition" /v "ExclusiveModeFramerateAveragingPeriodMs" /t REG_DWORD /d "1000" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Dwm\ExtendedComposition" /v "ExclusiveModeFramerateThresholdPercent" /t REG_DWORD /d "250" /f 

:: disable printer management
%currentuser% Reg.exe add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v "LegacyDefaultPrinterMode" /t REG_DWORD /d "1" /f

:: tweak login times
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DelayedDesktopSwitchTimeout" /t REG_DWORD /d "0" /f

:: disable network navigation pane
reg add "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2962489444" /f

:: disable scheduled tasks
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
      schtasks.exe /change /disable /tn %%i 
      powerrun.exe /sw:0 schtasks.exe /change /disable /tn %%i 
)

:: disable system uac
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableVirtualization" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableInstallerDetection" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableSecureUIAPaths" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "ValidateAdminCodeSignatures" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableUIADesktopToggle" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorUser" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "FilterAdministratorToken" /t REG_DWORD /d "0" /f

:: configure language bar
%currentuser% Reg.exe add "HKCU\Software\Microsoft\CTF\LangBar" /v "ShowStatus" /t REG_DWORD /d "3" /f 
%currentuser% Reg.exe add "HKCU\Software\Microsoft\CTF\LangBar" /v "ExtraIconsOnMinimized" /t REG_DWORD /d "0" /f 
%currentuser% Reg.exe add "HKCU\Software\Microsoft\CTF\LangBar" /v "Transparency" /t REG_DWORD /d "255" /f 
%currentuser% Reg.exe add "HKCU\Software\Microsoft\CTF\LangBar" /v "Label" /t REG_DWORD /d "0" /f 
goto PowerPlan



:PowerPlan
echo & cls %c_blue%Importing and configuring power plan...
:: configure powerplan
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
powercfg -setactive 11111111-1111-1111-1111-111111111111
powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a > NUL 2>&1
powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e > NUL 2>&1
powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c > NUL 2>&1
powercfg -delete e9a42b02-d5df-448d-aa00-03f14749eb61 > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMin" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PerfCalculateActualUtilization" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "SleepReliabilityDetailedDiagnostics" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "QosManagesIdleProcessors" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableVsyncLatencyUpdate" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableSensorWatchdog" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "MfBufferingThreshold" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "InterruptSteeringDisabled" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "TimerRebaseThresholdOnDripsExit" /t REG_DWORD /d "30" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoreParkingDisabled" /t REG_DWORD /d 0"" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f 
goto BCD


:BCD
BCDEDIT /set disabledynamictick yes 
BCDEDIT /set useplatformtick Yes 
BCDEDIT /set nx AlwaysOff 
BCDEDIT /set ems No 
BCDEDIT /set bootems No 
BCDEDIT /set tpmbootentropy ForceDisable 
BCDEDIT /set bootmenupolicy Legacy 
BCDEDIT /set debug No 
BCDEDIT /set hypervisorlaunchtype Off 
BCDEDIT /set vm No 
BCDEDIT /set vsmlaunchtype Off 
BCDEDIT /set quietboot Yes 
BCDEDIT /set bootux Disabled 
BCDEDIT /set allowedinmemorysettings 0x0
BCDEDIT /set {current} description "NeptuneOS v%version%"
BCDEDIT /set firstmegabytepolicy UseAll 
BCDEDIT /set avoidlowmemory 0x8000000 
BCDEDIT /set nolowmem Yes 
bcdedit /set {current} recoveryenabled no 
BCDEDIT /timeout 5 
BCDEDIT /deletevalue useplatformclock 
goto FSU


:FSU
:: File System
FSUTIL behavior set allowextchar 0 
FSUTIL behavior set Bugcheckoncorrupt 0 
FSUTIL behavior set disable8dot3 1 
FSUTIL behavior set disablecompression 1 
FSUTIL behavior set disableencryption 1 
FSUTIL behavior set disablelastaccess 1 
FSUTIL behavior set disablespotcorruptionhandling 1 
FSUTIL behavior set encryptpagingfile 0 
FSUTIL behavior set quotanotify 86400 
FSUTIL behavior set symlinkevaluation L2L:1 
FSUTIL behavior set disabledeletenotify 0 
FSUTIL repair set C: 0 
label C: NeptuneOS %version% 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsMftZoneReservation" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NTFSDisable8dot3NameCreation" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "DontVerifyRandomDrivers" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NTFSDisableLastAccessUpdate" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "ContigFileAllocSize" /t REG_DWORD /d "64" /f 


:GPU
echo & cls %c_blue%Configuring GPU...
:: configure mmcss
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "AlwaysOn" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "a" /f 
Reg.exe add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "a" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Affinity" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Background Only" /t REG_SZ /d "True" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "BackgroundPriority" /t REG_DWORD /d "8" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Clock Rate" /t REG_DWORD /d "10000" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "GPU Priority" /t REG_DWORD /d "8" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Priority" /t REG_DWORD /d "8" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Scheduling Category" /t REG_SZ /d "High" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "SFIO Priority" /t REG_SZ /d "High" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Latency Sensitive" /t REG_SZ /d "True" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Affinity" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d "False" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t REG_DWORD /d "10000" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d "18" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d "6" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Affinity" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Background Only" /t REG_SZ /d "True" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Clock Rate" /t REG_DWORD /d "10000" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "GPU Priority" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Priority" /t REG_DWORD /d "2" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Scheduling Category" /t REG_SZ /d "Medium" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "SFIO Priority" /t REG_SZ /d "Normal" /f

:: directx
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "DisableAGPSupport" /t reg_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "UseNonLocalVidMem" /t reg_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "UseNonLocalVidMem" /t reg_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "DisableDDSCAPSInDDSD" /t reg_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "EmulationOnly" /t reg_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectMusic" /v "DisableHWAcceleration" /t reg_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "EmulatePointSprites" /t reg_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "ForceRgbRasterizer" /t reg_DWORD /d "0" /f/f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "EmulateStateBlocks" /t reg_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "EnableDebugging" /t reg_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "FullDebug" /t reg_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "DisableDM" /t reg_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "EnableMultimonDebugging" /t reg_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "LoadDebugRuntime" /t reg_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumReference" /t reg_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumSeparateMMX" /t reg_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumRamp" /t reg_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumNullDevice" /t reg_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "FewVertices" /t reg_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "DisableMMX" /t reg_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "DisableMMX" /t reg_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "MMX Fast Path" /t reg_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "MMXFastPath" /t reg_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "UseMMXForRGB" /t reg_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "UseMMXForRGB" /t reg_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumSeparateMMX" /t reg_DWORD /d "1" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "ForceNoSysLock" /t reg_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorLatencyTolerance" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "0" /f 
%currentuser% Reg.exe add "HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "VRROptimizeEnable=0;" /f 

:: disable v-sync control
:: enable gpu preemption
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "VsyncIdleTimeout" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d "0" /f

:: enable fse
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f 
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f 
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f 
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "1" /f 
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f 
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f 
%currentuser% Reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_DSEBehavior" /t REG_DWORD /d "2" /f 
%currentuser% Reg.exe delete "HKCU\System\GameConfigStore\Children" /f 
%currentuser% Reg.exe delete "HKCU\System\GameConfigStore\Parents" /f

:: Reliable Timestamp
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Reliability" /v "TimeStampInterval" /t Reg_DWORD /d "1" /f 
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Reliability" /v "IoPriority" /t Reg_DWORD /d "3" /f 


:: Win32PrioritySeperation
Reg add "HKLM\System\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f 

:: Microsoft Multimedia Tweaks (pretty sure this is completely bullshit and placebo)
::reg add "HKCU\SOFTWARE\Microsoft\Games" /v "FpsAll" /t REG_DWORD /d "1" /f 
::reg add "HKCU\SOFTWARE\Microsoft\Games" /v "FpsStatusGames" /t REG_DWORD /d "10" /f 
::reg add "HKCU\SOFTWARE\Microsoft\Games" /v "FpsStatusGamesAll" /t REG_DWORD /d "4" /f 
::reg add "HKCU\SOFTWARE\Microsoft\Games" /v "GameFluidity" /t REG_DWORD /d "1" /f 
goto devman

:devman
echo & cls %c_blue%Disabling device manager devices...
:: disable devices
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (IKEv2)" 
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (IP)" 
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (IPv6)" 
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (L2TP)" 
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (Network Monitor)" 
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (PPPOE)" 
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (PPTP)" 
"%windir%\NEPTUNE\devmanview.exe" /disable "WAN Miniport (SSTP)" 
"%windir%\NEPTUNE\devmanview.exe" /disable "Motherboard resources" 
"%windir%\NEPTUNE\devmanview.exe" /disable "System board" 
"%windir%\NEPTUNE\devmanview.exe" /disable "System Speaker" 
"%windir%\NEPTUNE\devmanview.exe" /disable "System Timer" 
"%windir%\NEPTUNE\devmanview.exe" /disable "Microsoft Virtual Drive Enumerator" 
"%windir%\NEPTUNE\devmanview.exe" /disable "Microsoft Hyper-V Virtualization Infrastructure Driver" 
"%windir%\NEPTUNE\devmanview.exe" /disable "Microsoft GS Wavetable Synth" 
"%windir%\NEPTUNE\devmanview.exe" /disable "Microsoft Device Association Root Enumerator" 
"%windir%\NEPTUNE\devmanview.exe" /disable "Microsoft Kernel Debug Network Adapter" 
"%windir%\NEPTUNE\devmanview.exe" /disable "Microsoft RRAS Root Enumerator" 
"%windir%\NEPTUNE\devmanview.exe" /disable "PCI Data Acquisition and Signal Processing Controller" 
"%windir%\NEPTUNE\devmanview.exe" /disable "PCI Simple Communications Controller" 
"%windir%\NEPTUNE\devmanview.exe" /disable "PCI Device" 
"%windir%\NEPTUNE\devmanview.exe" /disable "PCI Simple Communications Controller" 
"%windir%\NEPTUNE\devmanview.exe" /disable "PCI Memory Controller" 
"%windir%\NEPTUNE\devmanview.exe" /disable "PCI standard RAM Controller" 
"%windir%\NEPTUNE\devmanview.exe" /disable "ACPI Processor Aggregator" 
"%windir%\NEPTUNE\devmanview.exe" /disable "ACPI Wake Alarm" 
"%windir%\NEPTUNE\devmanview.exe" /disable "UMBus Root Bus Enumerator" 
"%windir%\NEPTUNE\devmanview.exe" /disable "Root Print Queue" 
"%windir%\NEPTUNE\devmanview.exe" /disable "NDIS Virtual Network Adapter Enumerator" 
"%windir%\NEPTUNE\devmanview.exe" /disable "Direct memory access controller" 
"%windir%\NEPTUNE\devmanview.exe" /disable "Unknown Device" 
"%windir%\NEPTUNE\devmanview.exe" /disable "SM Bus Controller" 
"%windir%\NEPTUNE\devmanview.exe" /disable "Programmable interrupt controller" 
"%windir%\NEPTUNE\devmanview.exe" /disable "Numeric data processor" 
"%windir%\NEPTUNE\devmanview.exe" /disable "High precision event timer" 
goto servcon

:servcon
echo & cls %c_blue%Configuring services and drivers...
:: disable performance counters
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\PerfOS\Performance" /v "Collect Supports Metadata" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\PerfOS\Performance" /v "Collect Timeout" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\PerfDisk\Performance" /v "Collect Supports Metadata" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\PerfDisk\Performance" /v "Collect Timeout" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\PerfProc\Performance" /v "Collect Supports Metadata" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\PerfProc\Performance" /v "Collect Timeout" /t REG_DWORD /d "0" /f 

:: disable dma remapping
:: https://docs.microsoft.com/en-us/windows-hardware/drivers/pci/enabling-dma-remapping-for-device-drivers
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\DmaGuard\DeviceEnumerationPolicy" /v "value" /t REG_DWORD /d "2" /f 
reg add "HKLM\System\ControlSet001\Services\pci\Parameters" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f 
reg add "HKLM\System\ControlSet001\Services\storahci\Parameters" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f 
reg add "HKLM\System\ControlSet001\Services\stornvme\Parameters" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f 
reg add "HKLM\System\ControlSet001\Services\USBXHCI\Parameters" /v "DmaRemappingCompatibleSelfhost" /t REG_DWORD /d "0" /f 
reg add "HKLM\System\ControlSet001\Services\USBXHCI\Parameters" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f 

:: split audio services
copy /y "%windir%\System32\svchost.exe" "%windir%\System32\audiosvchost.exe"
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv" /v "ImagePath" /t REG_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalServiceNetworkRestricted -p" /f
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\AudioEndpointBuilder" /v "ImagePath" /t REG_EXPAND_SZ /d "%SystemRoot%\System32\audiosvchost.exe -k LocalSystemNetworkRestricted -p" /f 

:: disable drivers and services
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\services\Beep" /v "Start" /t REG_DWORD /d "4" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d "4" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\luafv" /v "Start" /t REG_DWORD /d "4" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\FileCrypt" /v "Start" /t REG_DWORD /d "4" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\vwififlt" /v "Start" /t REG_DWORD /d "4" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\cdrom" /v "Start" /t REG_DWORD /d "4" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\UsoSvc" /v "Start" /t REG_DWORD /d "4" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\TrkWks" /v "Start" /t REG_DWORD /d "4" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\lmhosts" /v "Start" /t REG_DWORD /d "4" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Themes" /v "Start" /t REG_DWORD /d "4" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\CDPSvc" /v "Start" /t REG_DWORD /d "4" /f 
goto memcon

:memcon
echo & cls %c_blue%Configuring memory...
:: disable superfetch features
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 0 /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d 0 /f 
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableBootTrace" /t REG_DWORD /d "0" /f 
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "SfTracingState" /t REG_DWORD /d "0" /f

:: disable memory compression
PowerShell "Disable-MMAgent -MemoryCompression"

:: page file to 2gb
Reg.exe add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Memory Management" /v "PagingFiles" /t REG_MULTI_SZ /d "?:\pagefile.sys 2048 2048" /f 

:: svchost split treshold 64gb
Reg.exe add "HKLM\SYSTEM\ControlSet001\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "4294967295" /f 

:: enable large system cache
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "1" /f 

:: disallow drivers to get paged into virtual memory
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f 

:: disable page combining
Reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePageCombining" /t REG_DWORD /d "1" /f 
Reg add "HKLM\SYSTEM\currentcontrolset\control\session manager\Memory Management" /v "DisablePagingCombining" /t REG_DWORD /d "1" /f 

:: disable swapfile
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SwapfileControl" /t REG_DWORD /d "0" /f 

:: free unused ram
Reg add "HKLM\System\CurrentControlSet\Control\Session Manager" /v "HeapDeCommitFreeBlockThreshold" /t REG_DWORD /d "262144" /f 

:: Set background apps priority below normal
for %%i in (OriginWebHelperService.exe ShareX.exe EpicWebHelper.exe SocialClubHelper.exe steamwebhelper.exe StartMenu.exe ) do (
  reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "5" /f
)

:: Process Priorities
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\audiodg.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "3" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f 
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f 
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f 
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\fontdrvhost.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f 
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\fontdrvhost.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f 
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f 
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f 
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f 
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f 
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WmiPrvSE.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f 
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WmiPrvSE.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f 
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\winlogon.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "2" /f 
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\winlogon.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "2" /f

goto pwrsave

:pwrsave
echo & cls %c_blue%Disabling power-saving features...
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
		Reg.exe add "%%b" /v "%%a" /t REG_DWORD /d "0" /f 
	)
) 
for %%a in (WakeEnabled WdkSelectiveSuspendEnable) do (
	for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class" /s /f "%%a" ^| findstr "HKEY"') do (
		Reg.exe add "%%b" /v "%%a" /t REG_DWORD /d "0" /f 
	)
) 
powershell "%WinDir%\NEPTUNE\pnp-powersaving.ps1" 

:: coalescing timer interval
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager\Executive" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\System\CurrentControlSet\Control\Session Manager" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power\ModernSleep" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\System\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\System\CurrentControlSet\Control" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 

:: disable storport idle
for /f "tokens=*" %%s in ('reg query "HKLM\System\CurrentControlSet\Enum" /S /F "StorPort" ^| findstr /e "StorPort"') do Reg add "%%s" /v "EnableIdlePowerManagement" /t REG_DWORD /d "0" /f 

:: energy estimation
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WcmSvc\GroupPolicy" /v "fDisablePowerManagement" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PDC\Activators\Default\VetoPolicy" /v "EA:EnergySaverEngaged" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PDC\Activators\28\VetoPolicy" /v "EA:PowerStateDischarging" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\Policy\Settings\Misc" /v "DeviceIdlePolicy" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\Policy\Settings\Processor" /v "PerfEnergyPreference" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "DisableTaggedEnergyLogging" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxApplication" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxTagPerApplication" /t REG_DWORD /d "0" /f

:: Disable Write Cache buffer
	for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI"^| findstr "HKEY"') do (
		for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do Reg.exe add "%%a\Device Parameters\Disk" /v "CacheIsPowerProtected" /t REG_DWORD /d "1" /f 
	)
	for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI"^| findstr "HKEY"') do (
		for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do Reg.exe add "%%a\Device Parameters\Disk" /v "UserWriteCacheSetting" /t REG_DWORD /d "1" /f 
	)
)

:: IOLATENCYCAP 0
FOR /F "eol=E" %%a in ('REG QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "IoLatencyCap"^| FINDSTR /V "IoLatencyCap"') DO (
	REG ADD "%%a" /F /V "IoLatencyCap" /T REG_DWORD /d 0 

	FOR /F "tokens=*" %%z IN ("%%a") DO (
		SET STR=%%z
		SET STR=!STR:HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\=!
		SET STR=!STR:\Parameters=!
		ECHO Setting IoLatencyCap to 0 in !STR!
	)
)

:: Disable HIPM DIPM and HDD parking
FOR /F "eol=E" %%a in ('REG QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "EnableHIPM"^| FINDSTR /V "EnableHIPM"') DO (
	REG ADD "%%a" /F /V "EnableHIPM" /T REG_DWORD /d 0 
	REG ADD "%%a" /F /V "EnableDIPM" /T REG_DWORD /d 0 
	REG ADD "%%a" /F /V "EnableHDDParking" /T REG_DWORD /d 0 

	FOR /F "tokens=*" %%z IN ("%%a") DO (
		SET STR=%%z
		SET STR=!STR:HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\=!
		ECHO Disabling HIPM and DIPM in !STR!
	)
)
goto mitigations

:mitigations
echo & cls %c_blue%Configuring system mitigations...

:: disable spectre, meltdown, cfg and aslr
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "MoveImages" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DontVerifyRandomDrivers" /t REG_DWORD /d "1" /f 

:: NTFS Mitigations
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f

:: Disable SEHOP Mitigation
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f 

::Turn Core Isolation Memory Integrity OFF
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f 

:: Disable TSX to mitigate zombieload
reg add "HKLM\SYSTEM\currentcontrolset\control\session manager\Kernel" /v "DisableTsx" /t REG_DWORD /d "1" /f 

:: System Mitigations
Powershell -Command "Set-ProcessMitigation -System -Disable DEP, EmulateAtlThunks, SEHOP, ForceRelocateImages, RequireInfo, BottomUp, HighEntropy, StrictHandle, DisableWin32kSystemCalls, AuditSystemCall, DisableExtensionPoints, BlockDynamicCode, AllowThreadsToOptOut, AuditDynamicCode, CFG, SuppressExports, StrictCFG, MicrosoftSignedOnly, AllowStoreSignedBinaries, AuditMicrosoftSigned, AuditStoreSigned, EnforceModuleDependencySigning, DisableNonSystemFonts, AuditFont, BlockRemoteImageLoads, BlockLowLabelImageLoads, PreferSystem32, AuditRemoteImageLoads, AuditLowLabelImageLoads, AuditPreferSystem32, EnableExportAddressFilter, AuditEnableExportAddressFilter, EnableExportAddressFilterPlus, AuditEnableExportAddressFilterPlus, EnableImportAddressFilter, AuditEnableImportAddressFilter, EnableRopStackPivot, AuditEnableRopStackPivot, EnableRopCallerCheck, AuditEnableRopCallerCheck, EnableRopSimExec, AuditEnableRopSimExec, SEHOP, AuditSEHOP, SEHOPTelemetry, TerminateOnError, DisallowChildProcessCreation, AuditChildProcess"

:: VALORANT Mitigation Patch
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vgc.exe" /v "MitigationOptions" /t REG_BINARY /d "00000000000100000000000000000000" /f

:: mitigate against hivenightmare/serious sam
icacls %WinDir%\system32\config\*.* /inheritance:e

:: block anonymous enumeration of sam accounts
:: https://www.stigviewer.com/stig/windows_10/2021-03-10/finding/V-220929
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RestrictAnonymousSAM" /t REG_DWORD /d "1" /f

:: hardening
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe" /v "AuditLevel" /t REG_DWORD /d "8" /f 
Reg add "HKLM\Software\Policies\Microsoft\Windows\CredentialsDelegation" /v "AllowProtectedCreds" /t REG_DWORD /d "1" /f 
Reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdminOutboundCreds" /t REG_DWORD /d "1" /f 
Reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdmin" /t REG_DWORD /d "0" /f 
Reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "RunAsPPL" /t REG_DWORD /d "1" /f 
Reg add "HKLM\System\CurrentControlSet\Control\SecurityProviders\WDigest" /v "Negotiate" /t REG_DWORD /d "0" /f 
Reg add "HKLM\System\CurrentControlSet\Control\SecurityProviders\WDigest" /v "UseLogonCredential" /t REG_DWORD /d "0" /f 

:: netbios hardening
:: netbios is disabled. if it manages to become enabled, protect against NBT-NS poisoning attacks
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" /v "NodeType" /t REG_DWORD /d "2" /f

:: disable and delete adobe font type manager
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Font Drivers" /v "Adobe Type Manager" /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "DisableATMFD" /t REG_DWORD /d "1" /f
goto Network

:Network
echo & cls %c_blue%Configuring network settings...

:: netsh
netsh int tcp set global autotuninglevel=normal 
netsh int tcp set global chimney=disabled 
netsh int tcp set global dca=enabled 
netsh int tcp set global netdma=disabled 
netsh int tcp set global timestamps=enabled 
netsh int tcp set global congestionprovider=ctcp 
netsh int tcp set global ecncapability=disabled 
netsh int tcp set global ecncapability=disabled 
netsh int tcp set heuristics enabled 
netsh int tcp set global rss=enabled 
netsh int tcp set global fastopen=enabled 
netsh int tcp set global nonsackrttresiliency=disabled 
netsh int tcp set global rsc=disabled 
netsh int tcp set global maxsynretransmissions=2 
netsh int tcp set global initialRto=2000 
netsh int tcp set supplemental Internet congestionprovider=ctcp 
netsh int tcp set supplemental template=custom icw=10 
netsh int ip set glob defaultcurhoplimit=255 
netsh int ip set interface "Ethernet" metric=60 
netsh int ipv4 set subinterface "Ethernet" mtu=1500 store=persistent 

:: disable bandwith reservation
reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t reg_DWORD /d "1" /f 
reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t reg_DWORD /d "00000000" /f 
reg add "HKLM\Software\WOW6432Node\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t reg_DWORD /d "0" /f 

:: disable network level authentication
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_SZ /d "1" /f 

:: set max port to 65535
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "65534" /f 

:: Reduce TIME_WAIT
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d "30" /f 

:: reduce time to live
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d "64" /f 

:: duplicate acks
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t REG_DWORD /d "2" /f 

:: disable sacks
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t REG_DWORD /d "0" /f 

:: disable multicast
reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t reg_DWORD /d "0" /f 

:: enable tcp extensions for high performance
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t reg_DWORD /d "00000001" /f 

:: enable dns over https
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableAutoDoh" /t REG_DWORD /d "2" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeSOACacheTime" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NetFailureCacheTime" /t REG_DWORD /d "0" /f 

:: disable llmnr
Reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d "0" /f 

:: disable administrative shares
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "AutoShareWks" /t REG_DWORD /d "0" /f 

:: enable the network adapter onboard processor
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableTaskOffload" /t reg_DWORD /d "0" /f 

:: disable the tcp autotuning diagnostic tool
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableWsd" /t reg_DWORD /d "00000000" /f 

:: disable network features
PowerShell -NoLogo -NoProfile -NonInteractive -Command "Enable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip,ms_pacer ; Disable-NetAdapterBinding -Name "*" -ComponentID ms_lldp,ms_lltdio,ms_implat,ms_rspndr,ms_tcpip6,ms_server,ms_msclient" 

:: host resolution priority
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t REG_DWORD /d "6" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t REG_DWORD /d "5" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t REG_DWORD /d "4" /f 
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t REG_DWORD /d "7" /f 

:: TCP Congestion Control/Avoidance Algorithm
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "0200" /t reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "1700" /t reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f

:: detect congestion fail to receive acknowledgement for a packet within the estimated timeout
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPCongestionControl" /t reg_DWORD /d "00000001" /f

:: disable nagle's algorithm
Reg add "HKLM\Software\Microsoft\MSMQ\Parameters" /v "TCPNoDelay" /t REG_DWORD /d "1" /f
for /f %%s in ('Reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\NetworkCards" /f "ServiceName" /s') do set "str=%%i" & if "!str:ServiceName_=!" neq "!str!" (
		Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TCPNoDelay" /t REG_DWORD /d "1" /f
		Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f
		Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpDelAckTicks" /t REG_DWORD /d "0" /f
		Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpInitialRTT" /d "300" /t REG_DWORD /f
        Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "UseZeroBroadcast" /d "0" /t REG_DWORD /f
        Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "DeadGWDetectDefault" /d "1" /t REG_DWORD /f
)   


:: qos priority 
for %%i in (csgo VALORANT-Win64-Shipping javaw FortniteClient-Win64-Shipping ModernWarfare r5apex Overwatch RocketLeague) do (
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
)
goto Finish


:Finish
echo %c_blue%Finishing up installation and restarting. Enjoy NeptuneOS.
echo %c_blue%Please report any bugs you may find to the discord, or to the github. Thank you for your support.
Reg.exe delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "POST INSTALL" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "POST INSTALL" /t REG_SZ /d "explorer \"C:\POST INSTALL\"" /f > NUL 2>&1
devmanview /enable "HID-compliant mouse" 
del /f /q "%windir%\NEPTUNE\DevManView.exe" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\neptune.reg" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\Open-Shell.exe" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\FullscreenCMD.vbs" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\7z.exe" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\power.pow" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\Open Shell.exe" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\pnp-powersaving.ps1" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\MPC.exe" > NUL 2>&1
del /f /q "%windir%\NEPTUNE\VisualCppRedist_AIO_x86_x64.exe" > NUL 2>&1
rmdir /s /q "%windir%\NEPTUNE\DirectX" > NUL 2>&1

shutdown /r /f -t 5 /c "Setup Complete: Enjoy NeptuneOS"
del "%~f0"