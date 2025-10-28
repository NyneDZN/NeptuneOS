
:: Install Open-Shell
"C:\neptune-installer\prerequisites\openshell.exe" /qn ADDLOCAL=StartMenu

:: Configuration
reg add "HKU\%SID%\Software\OpenShell\StartMenu" /v "ShowedStyle2" /t REG_DWORD /d "2" /f 
reg add "HKU\%SID%\Software\OpenShell\StartMenu\Settings" /v "Version" /t REG_DWORD /d "67371150" /f 
reg add "HKU\%SID%\Software\OpenShell\StartMenu\Settings" /v "SkipMetro" /t REG_DWORD /d "1" /f 
reg add "HKU\%SID%\Software\OpenShell\StartMenu\Settings" /v "MenuStyle" /t REG_SZ /d "Win7" /f 
reg add "HKU\%SID%\Software\OpenShell\StartMenu\Settings" /v "ProgramsMenuDelay" /t REG_DWORD /d "99999999" /f 
reg add "HKU\%SID%\Software\OpenShell\StartMenu\Settings" /v "StartScreenShortcut" /t REG_DWORD /d "0" /f 
reg add "HKU\%SID%\Software\OpenShell\StartMenu\Settings" /v "SkinW7" /t REG_SZ /d "" /f 
reg add "HKU\%SID%\Software\OpenShell\StartMenu\Settings" /v "SkinVariationW7" /t REG_SZ /d "" /f 
reg add "HKU\%SID%\Software\OpenShell\StartMenu\Settings" /v "SkinOptionsW7" /t REG_MULTI_SZ /d "USER_IMAGE=1\0SMALL_ICONS=1\0THICK_BORDER=0\0SOLID_SELECTION=0" /f 
reg add "HKU\%SID%\Software\OpenShell\StartMenu\Settings" /v "MenuItems7" /t REG_MULTI_SZ /d "Item1.Command=user_files\0Item1.Settings=NOEXPAND\0Item2.Command=user_documents\0Item2.Settings=NOEXPAND\0Item3.Command=user_pictures\0Item3.Settings=NOEXPAND\0Item4.Command=user_music\0Item4.Settings=NOEXPAND\0Item5.Command=user_videos\0Item5.Settings=ITEM_DISABLED\0Item6.Command=downloads\0Item6.Settings=ITEM_DISABLED\0Item7.Command=homegroup\0Item7.Settings=ITEM_DISABLED\0Item8.Command=separator\0Item9.Command=games\0Item9.Settings=TRACK_RECENT|NOEXPAND|ITEM_DISABLED\0Item10.Command=favorites\0Item10.Settings=ITEM_DISABLED\0Item11.Command=computer\0Item11.Settings=NOEXPAND\0Item12.Command=downloads\0Item12.Settings=NOEXPAND\0Item13.Command=network\0Item13.Settings=ITEM_DISABLED\0Item14.Command=network_connections\0Item14.Settings=ITEM_DISABLED\0Item15.Command=separator\0Item16.Command=control_panel\0Item16.Settings=TRACK_RECENT|NOEXPAND\0Item17.Command=pc_settings\0Item17.Settings=TRACK_RECENT\0Item18.Command=admin\0Item18.Settings=TRACK_RECENT|ITEM_DISABLED\0Item19.Command=devmgmt.msc\0Item19.Label=Device Manager\0Item19.Icon=C:\Windows\system32\devmgr.dll, 201\0Item19.Settings=NOEXPAND\0Item20.Command=defaults\0Item20.Settings=ITEM_DISABLED\0Item21.Command=help\0Item21.Settings=ITEM_DISABLED\0Item22.Command=run\0Item23.Command=apps\0Item23.Settings=ITEM_DISABLED\0Item24.Command=windows_security\0Item24.Settings=ITEM_DISABLED" /f 
reg add "HKU\%SID%\Software\OpenShell\StartMenu\Settings" /v "ShiftRight" /t REG_DWORD /d "1" /f 
reg add "HKU\%SID%\Software\OpenShell\StartMenu\Settings" /v "RecentPrograms" /t REG_SZ /d "None" /f 
reg add "HKU\%SID%\Software\OpenShell\StartMenu\Settings" /v "SearchTrack" /t REG_DWORD /d "0" /f 
reg add "HKU\%SID%\Software\OpenShell\StartMenu\Settings" /v "SearchAutoComplete" /t REG_DWORD /d "0" /f 
reg add "HKU\%SID%\Software\OpenShell\StartMenu\Settings" /v "SearchInternet" /t REG_DWORD /d "0" /f 
reg add "HKU\%SID%\Software\OpenShell\StartMenu\Settings" /v "MainMenuAnimate" /t REG_DWORD /d "0" /f 
reg add "HKU\%SID%\Software\OpenShell\StartMenu\Settings" /v "FontSmoothing" /t REG_SZ /d "Default" /f


:: move "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Open-Shell\Open-Shell Menu Settings.lnk" "%WinDir%\NeptuneDir\Neptune\3. Configuration\Start Menu" 
:: rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Open-Shell"