:: ---------------------------------
::       Tweaking existing files
:: ---------------------------------


:: Move NVIDIA Display Container LS folder from "Advanced Configuration" to "Driver Maintenance"
move "%WinDir%\NeptuneDir\Neptune\4. Advanced Configuration\NVIDIA Display Container LS" "%WinDir%\NeptuneDir\Neptune\2. Driver Maintenance\GPU\NVIDIA\Configuration"

:: Remove Open-Shell configuration scripts, these will be kept in the future once Windows 10 is re-supported
del "%WinDir%\NeptuneDir\Neptune\3. Configuration\Start Menu" /s /q



:: ----------------------------------
::          New additions
:: ----------------------------------


:: Move Updated QoS DSCP script to Network Configuration
move "%WinDir%\NeptuneDir\Updates\hotfixes\1.1\Set QoS.cmd" "%WinDir%\NeptuneDir\Neptune\2. Driver Maintenance\Network\Network Configuration"
del "%WinDir%\NeptuneDir\Neptune\4. Advanced Configuration\Add Game to DSCP Policy.cmd" /s /q
copy /y "%WinDir%\NeptuneDir\Updates\hotfixes\1.1\FullscreenCMD.vbs" "%WinDir%\NeptuneDir\Scripts\FullscreenCMD.vbs" 