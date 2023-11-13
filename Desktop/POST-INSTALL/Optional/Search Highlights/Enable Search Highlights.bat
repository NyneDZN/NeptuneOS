@echo off
Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
taskkill /f /im explorer.exe & start explorer.exe