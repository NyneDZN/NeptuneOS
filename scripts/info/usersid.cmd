@echo off
REM Get the current user's SID using whoami and store in %SID%
for /f "tokens=2 delims= " %%A in ('whoami /user /fo list ^| find "SID"') do set "SID=%%A"

REM Test output
echo SID=%SID%
pause