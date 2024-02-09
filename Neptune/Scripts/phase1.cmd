:: UAC Permissions
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "0" /f > nul
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "0" /f > nul
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d "0" /f > nul

::: Finalize
echo Restarting...
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "Neptune" /t REG_SZ /d "C:\Neptune\nsudo.exe -U:T -P:E -ShowWindowMode:Show -Wait \"C:\Neptune\Scripts\phase2.cmd\"" /f
timeout /t 3 > nul
shutdown /f /r /t 0