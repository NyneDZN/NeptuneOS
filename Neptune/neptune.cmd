@echo off

:: Call Administrator
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select 'Run as administrator'.
        pause & exit 1
    )
    exit 0
)

:: Window Configuration
mode con: cols=80 lines=30
title "NeptuneOS Installer | Created by @NyneDZN"

:: PowerShell Variables
set sudo="C:\NeptuneOS-installer\Neptune\PowerRun_x64.exe" /SW:0 /SYS
set currentuser="C:\NeptuneOS-installer\Neptune\PowerRun_x64.exe" /SW:0
:: Dev Branch
set sudoDev="C:\NeptuneOS-installer-dev\Neptune\PowerRun_x64.exe" /SW:0 /SYS
set currentuserDev="C:\NeptuneOS-installer-dev\Neptune\PowerRun_x64.exe" /SW:0
:: NSUDO Variables
:: set sudo="C:\NeptuneOS-installer-dev\Neptune\nsudo.exe" -U:T -P:E -ShowWindowMode:Hide -Wait
:: set currentuser="C:\NeptuneOS-installer-dev\Neptune\nsudo.exe" -U:C -ShowWindowMode:Hide -Wait

:: Path Variables
set neptunemain=C:\NeptuneOS-installer\Neptune\
set neptunedev=C:\NeptuneOS-installer-dev\Neptune\

:: Set ANSI escape characters (AtlasOS)
cd /d "%~dp0"
for /f %%a in ('forfiles /m "%~nx0" /c "cmd /c echo 0x1B"') do set "ESC=%%a"
set "right=%ESC%[<x>C"
set "bullet= %ESC%[34m-%ESC%[0m"
set "CMDLINE=RED=[31m,S_GRAY=[90m,S_RED=[91m,S_GREEN=[92m,S_YELLOW=[93m,S_MAGENTA=[95m,S_WHITE=[97m,B_BLACK=[40m,B_YELLOW=[43m,UNDERLINE=[4m,_UNDERLINE=[24m"
set "%CMDLINE:,=" & set "%"


echo %ESC%[4mBy running the NeptuneOS installer, you allow it to make changes to your PC.%ESC%[0m

set /p userInput=Please type 'yes' to continue.: 
if /i "%userInput%"=="yes" (goto Menu) else (goto NotAccepted)
    
:NotAccepted
echo You did not type 'yes'
echo Closing...
exit /b

:menu
cls & mode con: cols=60 lines=20
echo]
echo    %ESC%[7mNeptuneOS Installer.%ESC%[0m
echo]
echo %bullet% 1. Install NeptuneOS
echo %bullet% 2. Exit
echo]
echo]
echo %bullet% https://discord.gg/4YTSkcK8b8
echo]
echo]
choice /c 12 /n /m "Select a choice:"

if errorlevel 2 (
    goto Nope
) else (
    if errorlevel 1 (
        goto NeptuneInstall
    )
)



:NeptuneInstall
mode con: cols=40 lines=20
title "Please wait..."
setlocal EnableDelayedExpansion
cls & echo !S_YELLOW!This will take a moment.
echo !S_YELLOW!We are disabling defender and UAC.
echo]
echo]
echo !S_YELLOW!We will restart when this is done.
del "%temp%\installer.zip"

:: UAC Permissionss
%WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "0" /f > nul
%WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "0" /f > nul
%WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d "0" /f > nul

:: Install Chocolatey
PowerShell Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) >nul

:: Refresh Enviornment
call "%neptmain%RefreshEnv.cmd" >nul 2>&1

:: Disable Global Confirmation in Chocolatey
choco feature enable -n allowGlobalConfirmation > nul

:: Disable Hash Checking in Chocolatey
:: This is due to it causing errors, if you need to check the hashes, please do this manually
choco feature disable -n checksumFiles > nul

:: Remove Server Manager from Startup on Servers
if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Server Manager.lnk" (%WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Server\ServerManager" /v "DoNotOpenAtLogon" /t REG_DWORD /d "1" /f >nul 2>&1)

:: Remove OneDrive
if exist "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" (taskkill /f /im OneDrive.exe >nul 2>&1)
if exist "C:\" ("%WINDIR%\System32\OneDriveSetup.exe" /uninstall >nul 2>&1) else ("%WINDIR%\SysWOW64\OneDriveSetup.exe" /uninstall >nul 2>&1) 
%WinDir%\System32\Reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1

:: Remove Azure Arc Setup from Startup on Servers
if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Server Manager.lnk" (%WinDir%\System32\Reg.exe delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "AzureArcSetup" /f >nul 2>&1)

:: Disable Defender via Cab
cd %neptunemain%
call "online-sxs.cmd" NoDefender.cab -Silent

:: RunOnce Neptune2
%WinDir%\System32\Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "Neptune" /t REG_SZ /d "%neptmain%neptune2.cmd" /f > nul

:: Finalize
echo Restarting...
pause
timeout /t 1 > nul
shutdown /f /r /t 0
exit /b




:Nope
cls
echo]
echo Exiting...
rmdir /s /q "C:\NeptuneOS-installer-dev"
timeout /t 2 >nul
exit /b
