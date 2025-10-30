call "C:\neptune-installer\modules\variables.cmd"
:: =========
reg add "HKU\%SID%\Control Panel\Mouse" /v "RawMouseThrottleDuration" /t REG_DWORD /d 0x14 /f
