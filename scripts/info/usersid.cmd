for /f "tokens=2 delims= " %%A in ('whoami /user /fo list ^| find "SID"') do set "SID=%%A"
echo SID=%SID%
pause