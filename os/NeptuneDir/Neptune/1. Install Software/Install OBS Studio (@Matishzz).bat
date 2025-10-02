@echo off
title OBS v1.5 Install + Config / By @Matishzz / https://discord.io/MatishzzTweaking
color F0
mode 120,50

:: Wow, it wasn't hard at all to see the code, was it? 
:: This file belongs to me and all shameless copies will be taken into account and will go through the famous rat channel. 
:: https://twitter.com/Matishzz Copyright (C) 2021

echo.
echo.
echo           __    __     ______     ______   __     ______     __  __     ______     ______    
echo          /\ "-./  \   /\  __ \   /\__  _\ /\ \   /\  ___\   /\ \_\ \   /\___  \   /\___  \   
echo          \ \ \-./\ \  \ \  __ \  \/_/\ \/ \ \ \  \ \___  \  \ \  __ \  \/_/  /__  \/_/  /__  
echo           \ \_\ \ \_\  \ \_\ \_\    \ \_\  \ \_\  \/\_____\  \ \_\ \_\   /\_____\   /\_____\ 
echo            \/_/  \/_/   \/_/\/_/     \/_/   \/_/   \/_____/   \/_/\/_/   \/_____/   \/_____/ 
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
timeout 3 /nobreak >nul

fltmc >nul 2>&1 && goto Check-OBS-Studio
PowerShell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs" >nul 2>&1 || (pause & exit 1)
exit 0

:Check-OBS-Studio
tasklist /FI "IMAGENAME eq obs64.exe" 2>nul | find /i "obs64.exe" >nul
if "%ERRORLEVEL%"=="0" (
	taskkill /F /IM obs64.exe >nul
	goto Obs-Is-Installed
)

cls
if exist "%programfiles%\obs-studio" (
    goto Obs-Is-Installed
) else (
		if exist "%programdata%\chocolatey\lib\obs-studio" (
        goto Obs-Is-Installed
    ) else (
			goto CheckChocolatey
    )
)
:Obs-Is-Installed
cls
echo.
echo.
echo                   OBS Studio is detected. What would you like to do?
echo.
echo       [1] Uninstall and reinstall OBS Studio    [2] Continue without uninstalling
echo.
echo.
echo                                                                @Matishzz
echo.
set /p Question1=

if "%Question1%"=="1" (
	goto Uninstall-OBS
) else if "%Question1%"=="2" (
		goto CheckGPU
)
echo x=msgbox("The selected option is invalid", DefaultMsgBox+vbExclamation+vbOKOnly, "OBS v1.5 Install + Config / By @Matishzz") > %tmp%\tmp.vbs & cscript //nologo %tmp%\tmp.vbs & del %tmp%\tmp.vbs & goto Obs-Is-Installed

:Uninstall-OBS
cls
echo Uninstalling OBS Studio...
choco --version >nul 2>&1
if %errorlevel% equ 0 (
	choco uninstall obs-studio.install -force -y -n >nul 2>&1
	choco uninstall obs-studio -force -y -n >nul 2>&1
)

rmdir /s /q "%APPDATA%\obs-studio" >nul 2>&1
rmdir /s /q "%programfiles%\obs-studio" >nul 2>&1	

if exist "%ProgramFiles%\obs-studio" (
    goto ERROR110
) else (
    goto CheckChocolatey
)

:ERROR110
echo x=msgbox("Apparently there is a program that is making use of an OBS DLL, close the respective program and reload the script.", DefaultMsgBox+vbExclamation+vbOKOnly, "ERROR 110") > %tmp%\tmp.vbs & cscript //nologo %tmp%\tmp.vbs & del %tmp%\tmp.vbs & start https://github.com/Matishzz/OBS-Studio/blob/main/Troubleshooting.md & exit

:CheckChocolatey
cls
echo Checking if Chocolatey is installed...
echo.
choco --version >nul 2>&1
if %errorlevel% equ 0 (
    goto InstallOBS
) else (
		goto InstallChocolatey
)

:InstallChocolatey
cls
echo Installing Chocolatey...
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

choco --version >nul 2>&1
if %errorlevel% equ 0 (
    goto InstallOBS
) else (
		goto RestartScript
)

:RestartScript
cls
"%temp%\OBS.Studio.v1.5.bat"
exit 

:InstallOBS
cls
echo Installing OBS Studio...
choco feature enable -n allowGlobalConfirmation >nul
choco install obs-studio --force --ignore-detected-reboot >nul
	if exist "%programfiles%\obs-studio" (
		start /min /d "%programfiles%\obs-studio\bin\64bit" "" obs64.exe
		timeout /t 3 >nul && powershell stop-process -ProcessName obs64 -Force
		goto CheckGPU
	) else (
			goto ERROR100
	)	

:ERROR100
echo x=msgbox("An error occurred during the verification of the OBS Studio installation", DefaultMsgBox+vbExclamation+vbOKOnly, "ERROR 100") > %tmp%\tmp.vbs & cscript //nologo %tmp%\tmp.vbs & del %tmp%\tmp.vbs & start https://github.com/Matishzz/OBS-Studio/blob/main/Troubleshooting.md & exit

:CheckGPU
cls
for /f "tokens=2 delims==" %%a in ('wmic path Win32_VideoController get VideoProcessor /value') do (
    for %%n in (GeForce NVIDIA RTX GTX) do echo %%a | find "%%n" >nul && (
        set "GPU=NVIDIA"
		goto Resolution
    )
    for %%n in (AMD Radeon Ryzen) do echo %%a | find "%%n" >nul && (
        set "GPU=AMD"
		goto Resolution
    )
)
    set "GPU=UHD"
	goto Resolution
)

:Resolution
cls
echo.
echo            Select the Recording/Streaming Resolution
echo.
echo          [1] 1080p    [2] 936p    [3] 900p    [4] 720p
echo.
echo.
echo                                                             @Matishzz

set /p Question3=
if "%Question3%"=="1" (
    set "X=1920"
	set "Y=1080"
	goto fps
) else if "%Question3%"=="2" (
    set "X=1664"
	set "Y=936"
	goto fps
) else if "%Question3%"=="3" (
    set "X=1600"
	set "Y=900"
	goto fps
) else if "%Question3%"=="4" (
    set "X=1280"
	set "Y=720"
	goto fps
)

echo x=msgbox("The selected option is invalid", DefaultMsgBox+vbExclamation+vbOKOnly, "OBS v1.5 Install + Config / By @Matishzz") > %tmp%\tmp.vbs & cscript //nologo %tmp%\tmp.vbs & del %tmp%\tmp.vbs & goto Resolution

:fps
cls
echo.
echo            At how many FPS do you want to record/clip and stream?
echo.
echo                  [1] 30 FPS    [2] 60 FPS    [3] 120 FPS
echo                        [4] Custom Fractional FPS
echo.
echo                                                          [0] Back
echo.
echo                                                             @Matishzz
set /p Question4=
if "%Question4%"=="1" (
    set "fps=30"
	goto CreateProfile
) else if "%Question4%"=="2" (
    set "fps=60"
	goto CreateProfile
) else if "%Question4%"=="3" (
    set "fps=120"
	goto CreateProfile
) else if "%Question4%"=="4" (
	goto CustomFractional
) else if "%Question4%"=="0" (
	goto Resolution
)

echo x=msgbox("The selected option is invalid", DefaultMsgBox+vbExclamation+vbOKOnly, "OBS v1.5 Install + Config / By @Matishzz") > %tmp%\tmp.vbs & cscript //nologo %tmp%\tmp.vbs & del %tmp%\tmp.vbs & goto fps

:CustomFractional
cls
echo Type in the value of the FPS you want to use (Uses only numbers)
echo.
echo                                                          [0] Back
echo.
set /p Question5=

if "%Question5%"=="0" (
goto fps
)
 
for /f "delims=0123456789" %%a in ("%Question5%") do (
	goto ERRORINPUT
)

if "%Question5%"=="%Question5%" (
    set "fps=%Question5%"
	goto CreateProfile
)

:ERRORINPUT
echo x=msgbox("'%Question5%' is not a valid entry, use numbers only",DefaultMsgBox+vbCritical+vbOKOnly,"ERROR INPUT") > %tmp%\tmp.vbs && cscript //nologo %tmp%\tmp.vbs && del %tmp%\tmp.vbs
goto CustomFractional

:CreateProfile
cls
set "folder=%appdata%\obs-studio\basic\profiles\%Y%p %FPS%fps - (%GPU%) @Matishzz"

set "basic=%folder%\basic.ini"	
md "%folder%" 2>nul

	echo [General]>>"%basic%"
		echo Name=%Y%p %fps%fps - (%GPU%) @Matishzz>>"%basic%"
echo.>>"%basic%"
	echo [Output]>>"%basic%"
		echo Mode=Advanced>>"%basic%"
		echo DelayEnable=false>>"%basic%"
		echo DelayPreserve=true>>"%basic%"
		echo Reconnect=true>>"%basic%"
		echo RetryDelay=5>>"%basic%"
		echo MaxRetries=25>>"%basic%"
		echo BindIP=default>>"%basic%"
		echo NewSocketLoopEnable=false>>"%basic%"
		echo LowLatencyEnable=false>>"%basic%"

echo.>>"%basic%"

	echo [AdvOut]>>"%basic%"
		echo ApplyServiceSettings=true>>"%basic%"
		echo UseRescale=false>>"%basic%"
		echo VodTrackIndex=2>>"%basic%"

if /I "%GPU%"=="AMD" (
    echo Encoder=h264_texture_amf>>"%basic%"
) else if /I "%GPU%"=="NVIDIA" (
    echo Encoder=obs_nvenc_h264_tex>>"%basic%"
) else if /I "%GPU%"=="UHD" (
    echo Encoder=obs_qsv11_v2>>"%basic%"
)

		echo RecType=Standard>>"%basic%"
		echo RecFormat2=fragmented_mp4>>"%basic%"
		echo RecUseRescale=false>>"%basic%"

if /I "%GPU%"=="AMD" (
    echo RecEncoder=h264_texture_amf>>"%basic%"
) else if /I "%GPU%"=="NVIDIA" (
    echo RecEncoder=obs_nvenc_h264_tex>>"%basic%"
) else if /I "%GPU%"=="UHD" (
    echo RecEncoder=obs_qsv11_v2>>"%basic%"
)

		echo FFOutputToFile=true>>"%basic%"
		echo FFVGOPSize=250>>"%basic%"
		echo FFUseRescale=false>>"%basic%"
		echo FFIgnoreCompat=false>>"%basic%"
		echo FFABitrate=160>>"%basic%"
		echo Track1Bitrate=160>>"%basic%"
		echo Track2Bitrate=160>>"%basic%"
		echo Track3Bitrate=160>>"%basic%"
		echo Track4Bitrate=160>>"%basic%"
		echo Track5Bitrate=160>>"%basic%"
		echo Track6Bitrate=160>>"%basic%"
		echo RecSplitFileTime=15>>"%basic%"
		echo RecSplitFileSize=2048>>"%basic%"
		echo RecRB=true>>"%basic%"
		echo RecRBTime=120>>"%basic%"
		echo RecRBSize=1024>>"%basic%"
		echo AudioEncoder=ffmpeg_aac>>"%basic%"
		echo RecAudioEncoder=ffmpeg_aac>>"%basic%"
		echo RecSplitFileType=Time>>"%basic%"
		echo FFFormat=>>"%basic%"
		echo FFFormatMimeType=>>"%basic%"
		echo FFVEncoder=>>"%basic%"
		echo FFAEncoder=>>"%basic%"
		echo RecFileNameWithoutSpace=false>>"%basic%"
echo.>>"%basic%"
		echo [Video]>>"%basic%"
		echo BaseCX=%X%>>"%basic%"
		echo BaseCY=%Y%>>"%basic%"
		echo OutputCX=%X%>>"%basic%"
		echo OutputCY=%Y%>>"%basic%"

if /I "%FPS%"=="120" (
    echo FPSCommon=30>>"%basic%"
    echo FPSType=2 >>"%basic%"
    echo FPSNum=120>>"%basic%"
	echo FPSInt=30>>"%basic%"
) else if /I "%FPS%"=="%Question5%" (
    echo FPSType=2 >>"%basic%"
    echo FPSNum=%Question5%>>"%basic%"
	echo FPSCommon=30>>"%basic%"
	echo FPSInt=30>>"%basic%"
)

		echo FPSCommon=%FPS%>>"%basic%"
		echo ScaleType=bilinear>>"%basic%"
		echo ColorFormat=NV12>>"%basic%"
		echo ColorSpace=sRGB>>"%basic%"
		echo ColorRange=Partial>>"%basic%"
		echo SdrWhiteLevel=300>>"%basic%"
		echo HdrNominalPeakLevel=1000>>"%basic%"
echo.>>"%basic%"
		echo [Audio]>>"%basic%"
		echo MonitoringDeviceId=default>>"%basic%"
		echo MonitoringDeviceName=default>>"%basic%"
		echo SampleRate=48000>>"%basic%"
		echo ChannelSetup=Stereo>>"%basic%"
		echo MeterDecayRate=23.53>>"%basic%"
echo.>>"%basic%"
	echo [Hotkeys]>>"%basic%"
		echo ReplayBuffer={"ReplayBuffer.Save":[{"key":"OBS_KEY_F9"}]}>>"%basic%"

if /I "%GPU%"=="AMD" (
    echo {"keyint_sec":2,"rate_control":"CQP","cqp":17,"bf":0} > "%folder%\recordEncoder.json"
) else if /I "%GPU%"=="NVIDIA" (
    echo {"rate_control":"CQP","cqp":17,"preset":"p4","multipass":"disabled","profile":"high","lookahead":false,"adaptive_quantization":false} > "%folder%\recordEncoder.json"
) else if /I "%GPU%"=="UHD" (
    echo {"target_usage":"TU7","profile":"high","keyint_sec":2,"rate_control":"CQP","cqp":17,"bframes":0}} > "%folder%\recordEncoder.json""
)

if /I "%Y%"=="1080" (
    if "%FPS%"=="30" (
        set "b=3732"
    ) else if "%FPS%"=="60" (
        set "b=7465"
    ) else if "%FPS%"=="120" (
        set "b=8000"
    ) else if "%FPS%"=="%Question5%" (
        set "b=7465"
    )
) else if /I "%Y%"=="936" (
    if "%FPS%"=="30" (
        set "b=2804"
    ) else if "%FPS%"=="60" (
        set "b=5607"
    ) else if "%FPS%"=="120" (
        set "b=8000"
    ) else if "%FPS%"=="%Question5%" (
        set "b=5607"
    )
) else if /I "%Y%"=="900" (
    if "%FPS%"=="30" (
        set "b=2592"
    ) else if "%FPS%"=="60" (
        set "b=5184"
    ) else if "%FPS%"=="120" (
        set "b=8000"
    ) else if "%FPS%"=="%Question5%" (
        set "b=5184"
    )
) else if /I "%Y%"=="864" (
    if "%FPS%"=="30" (
        set "b=4379"
    ) else if "%FPS%"=="60" (
        set "b=4778"
    ) else if "%FPS%"=="120" (
        set "b=4778"
    ) else if "%FPS%"=="%Question5%" (
        set "b=4778"
    )
) else if /I "%Y%"=="720" (
    if "%FPS%"=="30" (
        set "b=3041"
    ) else if "%FPS%"=="60" (
        set "b=3318"
    ) else if "%FPS%"=="120" (
        set "b=8000"
    ) else if "%FPS%"=="%Question5%" (
        set "b=3318"
    )
)

if /I "%GPU%"=="AMD" (
    echo {"bitrate":%b%,"profile":"main","preset":"balanced","keyint_sec":2,"bf":0}>"%folder%\streamEncoder.json"
    ) else if "%GPU%"=="NVIDIA" (
    echo {"rate_control":"CBR","bitrate":%b%,"preset":"p4","tune":"hq","multipass":"disabled","profile":"main","adaptive_quantization":false,"lookahead":false} >"%folder%\streamEncoder.json"
    ) else if "%GPU%"=="UHD" (
    echo {"bitrate":%b%,"profile":"main","target_usage":"TU4","keyint_sec":2,"bframes":0} >"%folder%\streamEncoder.json"
)

:Scene
cls
if exist "%appdata%\obs-studio\basic\scenes\Matishzz.json" (
goto global
)
md "%appdata%\obs-studio\basic\scenes" 2>nul
set "Scene=%appdata%\obs-studio\basic\scenes\Matishzz.json"
echo { "DesktopAudioDevice1": { "prev_ver": 520093696, "name": "Desktop Audio", "uuid": "c0e58ca7-39fd-4b54-bff0-2b699edc7330", "id": "wasapi_output_capture", "versioned_id": "wasapi_output_capture", "settings": { "device_id": "default" }, "mixers": 255, "sync": 0, "flags": 0, "volume": 1.0, "balance": 0.5, "enabled": true, "muted": false, "push-to-mute": false, "push-to-mute-delay": 0, "push-to-talk": false, "push-to-talk-delay": 0, "hotkeys": { "libobs.mute": [], "libobs.unmute": [], "libobs.push-to-mute": [], "libobs.push-to-talk": [] }, "deinterlace_mode": 0, "deinterlace_field_order": 0, "monitoring_type": 0, "private_settings": {} }, "AuxAudioDevice1": { "prev_ver": 520093696, "name": "Mic/Aux", "uuid": "7c5e6b8f-de66-4cc9-8d60-fd4d2e7f97c3", "id": "wasapi_input_capture", "versioned_id": "wasapi_input_capture", "settings": { "device_id": "default" }, "mixers": 255, "sync": 0, "flags": 0, "volume": 1.0, "balance": 0.5, "enabled": true, "muted": false, "push-to-mute": false, "push-to-mute-delay": 0, "push-to-talk": false, "push-to-talk-delay": 0, "hotkeys": { "libobs.mute": [], "libobs.unmute": [], "libobs.push-to-mute": [], "libobs.push-to-talk": [] }, "deinterlace_mode": 0, "deinterlace_field_order": 0, "monitoring_type": 0, "private_settings": {}, "filters": [ { "prev_ver": 520093696, "name": "Noise Gate - Default", "uuid": "e43ef040-3361-42a5-b13f-46eaf90e4429", "id": "noise_gate_filter", "versioned_id": "noise_gate_filter", "settings": {}, "mixers": 255, "sync": 0, "flags": 0, "volume": 1.0, "balance": 0.5, "enabled": true, "muted": false, "push-to-mute": false, "push-to-mute-delay": 0, "push-to-talk": false, "push-to-talk-delay": 0, "hotkeys": {}, "deinterlace_mode": 0, "deinterlace_field_order": 0, "monitoring_type": 0, "private_settings": {} } ] }, "current_scene": "Scene", "current_program_scene": "Scene", "scene_order": [ { "name": "Scene" } ], "name": "Matishzz", "sources": [ { "prev_ver": 520093696, "name": "Scene", "uuid": "dace504e-59be-4faf-b468-efb3bc89c18a", "id": "scene", "versioned_id": "scene", "settings": { "id_counter": 1, "custom_size": false, "items": [] }, "mixers": 0, "sync": 0, "flags": 0, "volume": 1.0, "balance": 0.5, "enabled": true, "muted": false, "push-to-mute": false, "push-to-mute-delay": 0, "push-to-talk": false, "push-to-talk-delay": 0, "hotkeys": { "OBSBasic.SelectScene": [] }, "deinterlace_mode": 0, "deinterlace_field_order": 0, "monitoring_type": 0, "private_settings": {} } ], "groups": [], "quick_transitions": [ { "name": "Cut", "duration": 300, "hotkeys": [], "id": 1, "fade_to_black": false }, { "name": "Fade", "duration": 300, "hotkeys": [], "id": 2, "fade_to_black": false }, { "name": "Fade", "duration": 300, "hotkeys": [], "id": 3, "fade_to_black": true } ], "transitions": [], "saved_projectors": [], "current_transition": "Fade", "transition_duration": 300, "preview_locked": false, "scaling_enabled": false, "scaling_level": 0, "scaling_off_x": 0.0, "scaling_off_y": 0.0, "virtual-camera": { "type2": 3 }, "modules": { "scripts-tool": [], "output-timer": { "streamTimerHours": 0, "streamTimerMinutes": 0, "streamTimerSeconds": 30, "recordTimerHours": 0, "recordTimerMinutes": 0, "recordTimerSeconds": 30, "autoStartStreamTimer": false, "autoStartRecordTimer": false, "pauseRecordTimer": true }, "auto-scene-switcher": { "interval": 300, "non_matching_scene": "", "switch_if_not_matching": false, "active": false, "switches": [] }, "captions": { "source": "", "enabled": false, "lang_id": 1033, "provider": "mssapi" } }, "resolution": { "x": 1280, "y": 720 }, "version": 2 }>>"%Scene%"

:User
cls
set "Globalini=%appdata%\obs-studio\Global.ini"

	echo [General]>>"%GlobalInI%"
		echo Pre31Migrated=false>>"%GlobalInI%"
		echo MaxLogs=10>>"%GlobalInI%"
		echo InfoIncrement=-1>>"%GlobalInI%"
		echo ProcessPriority=Normal>>"%GlobalInI%"
		echo EnableAutoUpdates=false>>"%GlobalInI%"
		echo BrowserHWAccel=true>>"%GlobalInI%"
		echo InstallGUID=3ea4eae22cac81a58ea345f51a96d71b602ec233>>"%GlobalInI%"
		echo LastVersion=520093696>>"%GlobalInI%"
echo.>>"%GlobalInI%"
	echo [Video]> "%GlobalInI%">>"%GlobalInI%"
		echo Renderer=Direct3D 11>>"%GlobalInI%"
echo.>>"%GlobalInI%"
	echo [Audio]>>"%GlobalInI%"
		echo DisableAudioDucking=true>>"%GlobalInI%"

set "UserIni=%appdata%\obs-studio\user.ini"

	echo [General]> "%UserIni%"
		echo Pre19Defaults=false>>"%UserIni%"
		echo Pre21Defaults=false>>"%UserIni%"
		echo Pre23Defaults=false>>"%UserIni%"
		echo Pre24.1Defaults=false>>"%UserIni%"
		echo FirstRun=true>>"%UserIni%"
		echo SkipUpdateVersion=452984833>>"%UserIni%"
		echo ProcessPriority=Normal>>"%UserIni%"

:Theme
if exist "%systemdrive%\Program Files\7-Zip\7z.exe" (
	set "7z=S"
) else (
		choco install 7zip
		set "7z=N"
if not exist "%systemdrive%\Program Files\7-Zip\7z.exe" (
			goto Error 200
)
)

powershell -Command "Invoke-WebRequest -Uri 'https://obsproject.com/forum/resources/fluent-dark-grey.1961/download' -OutFile '%temp%\theme.zip'"
"%systemdrive%\Program Files\7-Zip\7z.exe" x "%TEMP%\theme.zip" -o"%ProgramFiles%\obs-studio\data\obs-studio\themes" -y

if "%7z%"=="N" (
"%systemdrive%\Program Files\7-Zip\Uninstall.exe" /S
)

del /q "%temp%\theme.zip" > nul 2>&1
        if exist "%ProgramFiles%\obs-studio\data\obs-studio\themes\fluentdarkgrey" (
        echo "%UserIni%"
        echo [Appearance]>>"%UserIni%"
			echo Theme=fluentdarkgrey>>"%UserIni%"
        goto Continue
) else (
        goto ERROR200
)

:ERROR200
echo x=msgbox("Apparently, an error occurred when importing the Fluent Dark (Grey) Theme.",DefaultMsgBox+vbCritical+vbOKOnly,"ERROR 200") > %tmp%\tmp.vbs && cscript //nologo %tmp%\tmp.vbs && del %tmp%\tmp.vbs
        echo [Appearance]>>"%UserIni%"
		echo Theme=com.obsproject.Yami.Original >>"%UserIni%"

:Continue
echo.>> "%UserIni%"
	echo [Basic]>>"%UserIni%"
		echo Profile=%Y%p %fps%fps - (%GPU%) @Matishzz>>"%UserIni%"
		echo ProfileDir=%Y%p %fps%fps - (%GPU%) @Matishzz>>"%UserIni%"
		echo SceneCollection=Matishzz>>"%UserIni%"
		echo SceneCollectionFile=Matishzz>>"%UserIni%"
echo.>> "%UserIni%"
		echo [BasicWindow]>>"%UserIni%"
		echo gridMode=false>>"%UserIni%"
		echo geometry=AdnQywADAAAAAAGkAAAAqgAABqIAAAO+AAABpAAAAMkAAAaiAAADvgAAAAAAAAAAB4AAAAGkAAAAyQAABqIAAAO+>>"%UserIni%"
		echo DockState=AAAA/wAAAAD9AAAAAgAAAAAAAADIAAABg/wCAAAAAfsAAAAUAHMAYwBlAG4AZQBzAEQAbwBjAGsBAAAAFwAAAYMAAAChAP///wAAAAMAAAT/AAABNvwBAAAABfsAAAAWAHMAbwB1AHIAYwBlAHMARABvAGMAawEAAAAAAAAAxQAAAJgA////+wAAAB4AdAByAGEAbgBzAGkAdABpAG8AbgBzAEQAbwBjAGsAAAACogAAATAAAAEwAP////sAAAASAHMAdABhAHQAcwBEAG8AYwBrAQAAAMkAAAJfAAACXwD////7AAAAEgBtAGkAeABlAHIARABvAGMAawEAAAMsAAABHwAAALYA////+wAAABgAYwBvAG4AdAByAG8AbABzAEQAbwBjAGsBAAAETwAAALAAAACwAP///wAABDMAAAGDAAAABAAAAAQAAAAIAAAACPwAAAAA>>"%UserIni%"
		echo ExtraBrowserDocks=[]>>"%UserIni%"
		echo PreviewEnabled=true>>"%UserIni%"
		echo AlwaysOnTop=false>>"%UserIni%"
		echo SceneDuplicationMode=true>>"%UserIni%"
		echo SwapScenesMode=true>>"%UserIni%"
		echo ShowContextToolbars=false>>"%UserIni%"
		echo EditPropertiesMode=false>>"%UserIni%"
		echo VerticalVolControl=true>>"%UserIni%"
		echo PreviewProgramMode=false>>"%UserIni%"
		echo DocksLocked=false>>"%UserIni%"
		echo WarnBeforeStartingStream=false>>"%UserIni%"
		echo WarnBeforeStoppingStream=false>>"%UserIni%"
		echo WarnBeforeStoppingRecord=false>>"%UserIni%"
		echo HideProjectorCursor=false>>"%UserIni%"
		echo ProjectorAlwaysOnTop=false>>"%UserIni%"
echo.>> "%UserIni%"

	echo [ScriptLogWindow]>> "%UserIni%"
		echo geometry=AdnQywADAAAAAAABAAAAIAAAAlgAAAGvAAAAAQAAACAAAAJYAAABrwAAAAAAAAAAB4AAAAABAAAAIAAAAlgAAAGv>>"%UserIni%"
goto Final

:Final
cls
echo Profile "%Y%p %fps%fps - (%GPU%) @Matishzz" has been created successfully
echo The default key assigned for clip out is F8 and the time is 120, you can adjust it whenever you want.
echo.
start /d "%programfiles%\obs-studio\bin\64bit" "" obs64.exe
timeout /t 4 >nul
start https://twitter.com/Matishzz && Exit

