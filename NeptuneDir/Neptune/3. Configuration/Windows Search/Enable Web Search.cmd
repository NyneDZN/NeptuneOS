@echo off

set "___args="%~f0" %*"
fltmc > nul 2>&1 || (
	echo Administrator privileges are required.
	powershell -c "Start-Process -Verb RunAs -FilePath 'cmd' -ArgumentList """/c $env:___args"""" 2> nul || (
		echo You must run this script as admin.
		if "%*"=="" pause
		exit /b 1
	)
	exit /b
)

echo]
echo Enabling Web Search ^& Search Highlights...

call "%windir%\NeptuneDir\Scripts\settingsPages.cmd" /unhide search-permissions /silent

(
	reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /f
	reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsAADCloudSearchEnabled" /f
	reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsDeviceSearchHistoryEnabled" /f
	reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsMSACloudSearchEnabled" /f
	reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "SafeSearchMode" /f
	reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /f
	reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /f
	reg delete "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /f
	reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "EnableDynamicContentInWSB" /f
	reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsDynamicSearchBoxEnabled" /t REG_DWORD /d "1" /f
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "2" /f
    taskkill /f /im explorer.exe
    taskkill /f /im SearchHost.exe
	taskkill /f /im SystemSettings.exe
    start explorer.exe
) > nul 2>&1


echo]
echo]
:: Echo to Log
echo %date% %time% Enabled Web Search >> %userlog%
:: Echo to User
echo !S_YELLOW!Web Search has been enabled.
timeout /t 3 /nobreak >nul
exit
