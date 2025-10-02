:: Registers the timer resolution task from AtlasOS
:: Set to 0.6ms
schtasks /create /tn "MyTaskName" /xml "%WinDir%\NeptuneDir\Tasks\Force Timer Resolution.xml"