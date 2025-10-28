@echo off
call "C:\neptune-installer\modules\variables.cmd"


start "C:\neptune-installer\prerequisites\ep-setup.exe"

reg add "HKU\%SID%\CLSID\{d93ed569-3b3e-4bff-8355-3c44f6a52bb5}" /f
reg add "HKU\%SID%\CLSID\{d93ed569-3b3e-4bff-8355-3c44f6a52bb5}\InprocServer32" /t REG_SZ /d "" /f
reg add "HKU\%SID%\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_ShowClassicMode" /t REG_DWORD /D 1 /f
reg add "HKU\%SID%\SOFTWARE\ExplorerPatcher" /f
reg add "HKU\%SID%\SOFTWARE\ExplorerPatcher" /v "OldTaskbar" /t REG_DWORD /D 0 /f
reg add "HKU\%SID%\SOFTWARE\ExplorerPatcher" /v "UpdatePolicy" /t REG_DWORD /D 2 /f
reg add "HKU\%SID%\SOFTWARE\ExplorerPatcher" /v "EnableSymbolDownload" /t REG_DWORD /D 0 /f
reg add "HKU\%SID%\SOFTWARE\ExplorerPatcher" /v "HideControlCenterButton" /t REG_DWORD /D 1 /f
reg add "HKU\%SID%\SOFTWARE\ExplorerPatcher" /v "StartDocked_DisableRecommendedSection" /t REG_DWORD /D 1 /f
reg add "HKU\%SID%\SOFTWARE\ExplorerPatcher" /v "TaskbarGlomLevel" /t REG_DWORD /D 2 /f
reg add "HKU\%SID%\SOFTWARE\ExplorerPatcher" /v "MMTaskbarGlomLevel" /t REG_DWORD /D 2 /f
reg add "HKU\%SID%\SOFTWARE\ExplorerPatcher" /v "OrbStyle" /t REG_DWORD /D 1 /f
reg add "HKU\%SID%\SOFTWARE\ExplorerPatcher" /v "FileExplorerCommandUI" /t REG_DWORD /D 2 /f
reg add "HKU\%SID%\SOFTWARE\ExplorerPatcher" /v "StartUI_EnableRoundedCorners" /t REG_DWORD /D 1 /f
reg add "HKU\%SID%\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ExplorerPatcher" /v "StartUI_EnableRoundedCorners" /t REG_DWORD /D 1 /f
reg add "HKU\%SID%\SOFTWARE\ExplorerPatcher" /v "ClockFlyoutOnWinC" /t REG_DWORD /D 1 /f
reg add "HKU\%SID%\SOFTWARE\ExplorerPatcher" /v "DisableOfficeHotkeys" /t REG_DWORD /D 1 /f
reg add "HKU\%SID%\SOFTWARE\ExplorerPatcher" /v "DisableWinFHotkey" /t REG_DWORD /D 1 /f
reg add "HKU\%SID%\SOFTWARE\ExplorerPatcher" /v "DoNotRedirectProgramsAndFeaturesToSettingsApp" /t REG_DWORD /D 1 /f
reg add "HKU\%SID%\SOFTWARE\ExplorerPatcher" /v "HideIconAndTitleInExplorer" /t REG_DWORD /D 3 /f
reg add "HKU\%SID%\SOFTWARE\ExplorerPatcher" /v "IMEStyle" /t REG_DWORD /D 4 /f
reg add "HKU\%SID%\SOFTWARE\ExplorerPatcher" /v "MicaEffectOnTitlebar" /t REG_DWORD /D 1 /f

taskkill /f /im "explorer.exe"