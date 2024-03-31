@echo off
dism /Online /Enable-Feature /FeatureName:"MediaPlayback" /NoRestart >nul 2>&1
dism /Online /Enable-Feature /FeatureName:"WindowsMediaPlayer" /NoRestart >nul 2>&1
echo Windows Media Player has been enabled. 
pause>nul