:: Forked from Atlas
:: Modified by Nyne

@echo off
setlocal EnableDelayedExpansion

:: Determine the current user's profile path
set "userProfile=%USERPROFILE%"

echo Configuring Start Menu for current user...
echo ------------------------------------------------------------------------------------------------

if not exist "%userProfile%\AppData\Local" (
    echo Couldn't find AppData directory!
) else (
    echo Copying default layout XML
    copy /y "%WinDir%\Layout.xml" "%userProfile%\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml" > nul

    echo Clear Start Menu pinned items
    del /q /f "%userProfile%\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start.bin" > nul 2>&1
    del /q /f "%userProfile%\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start2.bin" > nul 2>&1
)

echo Clearing default 'tilegrid'
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount" /v "start.tilegrid" /f > nul 2>&1

echo Removing advertisements/stubs from Start Menu ^(23H2+^)
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Start" /v "Config" /f > nul 2>&1
