@echo off
echo Doing some cleanup before final use, this won't take long.
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticecaption" /t REG_SZ /d "" /f >nul
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticetext" /t REG_SZ /d "" /f >nul
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f >nul
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f >nul

:: Explorer Patcher
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "ImportOK" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "OldTaskbar" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "SkinMenus" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "CenterMenus" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "FlyoutMenus" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\Software\Microsoft\TabletTip\1.7" /v "TipbandDesiredVisibility" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "HideControlCenterButton" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSD" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "LegacyFileTransferDialog" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "UseClassicDriveGrouping" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "DisableImmersiveContextMenu" /t REG_DWORD /d "1" /f
Reg.exe delete "HKCU\Software\Classes\CLSID\{056440FD-8568-48e7-A632-72157243B55B}\InprocServer32" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "ShrinkExplorerAddressBar" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "HideExplorerSearchBar" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "MicaEffectOnTitlebar" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_ShowClassicMode" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAl" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "MonitorOverride" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "MakeAllAppsDefault" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "AltTabSettings" /t REG_DWORD /d "3" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "LastSectionInProperties" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "ClockFlyoutOnWinC" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "ToolbarSeparators" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "PropertiesInWinX" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "NoMenuAccelerator" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "DisableOfficeHotkeys" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "DisableWinFHotkey" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "DisableAeroSnapQuadrants" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_PowerButtonAction" /t REG_DWORD /d "2" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "DoNotRedirectSystemToSettingsApp" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "DoNotRedirectProgramsAndFeaturesToSettingsApp" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "DoNotRedirectDateAndTimeToSettingsApp" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "DoNotRedirectNotificationIconsToSettingsApp" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "UpdatePolicy" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "UpdatePreferStaging" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "UpdateAllowDowngrades" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "UpdateURL" /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "UpdateURLStaging" /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "AllocConsole" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "Memcheck" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "TaskbarAutohideOnDoubleClick" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Control Panel\Desktop" /v "PaintDesktopVersion" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "ClassicThemeMitigations" /t REG_DWORD /d "0" /f
Reg.exe delete "HKCU\Software\Classes\CLSID\{1eeb5b5a-06fb-4732-96b3-975c0194eb39}\InprocServer32" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "NoPropertiesInContextMenu" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "EnableSymbolDownload" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "ExplorerReadyDelay" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ExplorerPatcher" /v "XamlSounds" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\ExplorerPatcher" /v "Language" /t REG_DWORD /d "0" /f

del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
del /s /f /q %USERPROFILE%\appdata\local\temp\*.* >nul 2>&1
cd %systemroot% & del *.log /s /f /q /a >nul 2>&1
cd %homepath% & del *.log /s /f /q /a >nul 2>&1
cls & echo Finished.
echo Enjoy NeptuneOS.
timeout /t 2 /nobreak >nul
del "%~f0"