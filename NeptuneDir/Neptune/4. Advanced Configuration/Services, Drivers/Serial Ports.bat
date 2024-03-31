@echo off

:: Check if script is escelated
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if %errorlevel% neq 0 (
    echo You are about to be prompted with the UAC. Please click yes when prompted.
) ELSE (
    goto admin
)

:prompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\prompt.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\prompt.vbs"
    "%temp%\prompt.vbs"
    exit /B

:admin
:: Delete prompt script
if exist "%temp%\prompt.vbs" ( del "%temp%\prompt.vbs" )


echo.  Disabling the Serial Ports will cause the mouse to break on laptops, and on VMs.


echo.	Press 1 to Enable
echo.	Press 2 to Disable
echo.
set /p c="Enter your answer: "
if /i %c% equ 1 goto :enable
if /i %c% equ 2 goto :disable

:disable
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Serenum" /v "Start" /t REG_DWORD /d "4" /f > nul 
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Serial" /v "Start" /t REG_DWORD /d "4" /f > nul 
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\sermouse" /v "Start" /t REG_DWORD /d "4" /f > nul 
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\i8042prt" /v "Start" /t REG_DWORD /d "4" /f > nul 

:enable
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Serenum" /v "Start" /t REG_DWORD /d "3" /f > nul 
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Serial" /v "Start" /t REG_DWORD /d "3" /f > nul 
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\sermouse" /v "Start" /t REG_DWORD /d "3" /f > nul 
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\i8042prt" /v "Start" /t REG_DWORD /d "3" /f > nul 