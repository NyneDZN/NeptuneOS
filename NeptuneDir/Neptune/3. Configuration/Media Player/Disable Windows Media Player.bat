@echo off
dism /Online /Disable-Feature /FeatureName:"MediaPlayback" /NoRestart >nul 2>&1
dism /Online /Disable-Feature /FeatureName:"WindowsMediaPlayer" /NoRestart >nul 2>&1
echo Windows Media Player has been disabled. 
pause>nul