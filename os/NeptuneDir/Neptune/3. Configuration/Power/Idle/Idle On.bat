powercfg -setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 0
powercfg -setactive scheme_current

:: Echo to Log
echo %date% %time% Enabled Idle >> %userlog%
:: Echo to User
echo !S_YELLOW!Idle has been enabled.
timeout /t 3 /nobreak >nul
exit