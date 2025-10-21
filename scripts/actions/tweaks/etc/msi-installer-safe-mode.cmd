:: ============================================
:: Enable Windows Installer (MSIServer) in Safe Mode
:: ============================================

:: Minimal Safe Mode
reg add "HKLM\SYSTEM\ControlSet001\Control\SafeBoot\Minimal\MSIServer" /ve /t REG_SZ /d "Service" /f

:: Safe Mode with Networking
reg add "HKLM\SYSTEM\ControlSet001\Control\SafeBoot\Network\MSIServer" /ve /t REG_SZ /d "Service" /f
