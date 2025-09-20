@echo off
setlocal EnableDelayedExpansion
cd %WinDir%\NeptuneDir\Scripts >nul && where ansi.cmd >nul && call ansi.cmd >nul
mode 70,20

:: Call Administrator


fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select 'Run as administrator'.
        pause & exit 1
    )
    exit 0
)



echo !S_YELLOW!Process Explorer will replace the default task manager.
choice /C YN /M "Are you sure you want to continue?"
if errorlevel 2 (
    goto Nope
) else (
    goto Install
)





:Install
cls & echo Installing Process Explorer
echo]
echo]
echo !S_RED!WARNING: !S_YELLOW!Chocolatey will display a checksum warning.
echo This is due to the ignore checksums argument.
echo If you want to verify the checksum, please do this manually.
echo]
echo]
echo The script will continue in a moment, or you can press a key.
timeout /t 10 >nul
choco install procexp --ignore-checksums
%windir%\NeptuneDir\Tools\PowerRun.exe /SW:0 "Reg.exe" add "HKLM\System\CurrentControlSet\services\pcw" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe" /v "Debugger" /t REG_SZ /d "C:\ProgramData\chocolatey\lib\procexp\tools\procexp64.exe" /f >nul 2>&1
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "EulaAccepted" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "Windowplacement" /t REG_BINARY /d "2c00000000000000010000000083ffff0083ffffffffffffffffffff390200002f000000e50600008f030000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "FindWindowplacement" /t REG_BINARY /d "2c00000000000000000000000000000000000000000000000000000096000000960000000000000000000000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "SysinfoWindowplacement" /t REG_BINARY /d "2c00000000000000010000000000000000000000ffffffffffffffff28000000280000002b0300002b020000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "PropWindowplacement" /t REG_BINARY /d "2c00000000000000010000000000000000000000ffffffffffffffff2800000028000000e70100009f020000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "DllPropWindowplacement" /t REG_BINARY /d "2c00000000000000000000000000000000000000000000000000000028000000280000000000000000000000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "UnicodeFont" /t REG_BINARY /d "080000000000000000000000000000009001000000000000000000004d00530020005300680065006c006c00200044006c00670000000000000000000000000000000000000000000000000000000000000000000000000000000000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "Divider" /t REG_BINARY /d "000000000000f03f" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "SavedDivider" /t REG_BINARY /d "000000000000e03f" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ProcessImageColumnWidth" /t REG_DWORD /d "200" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowUnnamedHandles" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowDllView" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HandleSortColumn" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HandleSortDirection" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "DllSortColumn" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "DllSortDirection" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ProcessSortColumn" /t REG_DWORD /d "4294967295" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ProcessSortDirection" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightServices" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightOwnProcesses" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightRelocatedDlls" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightJobs" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightNewProc" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightDelProc" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightImmersive" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightProtected" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightPacked" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightNetProcess" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightSuspend" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightDuration" /t REG_DWORD /d "1000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowCpuFractions" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowLowerpane" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowAllUsers" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowProcessTree" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "SymbolWarningShown" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HideWhenMinimized" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "AlwaysOntop" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "OneInstance" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "NumColumnSets" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ConfirmKill" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "RefreshRate" /t REG_DWORD /d "1000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "PrcessColumnCount" /t REG_DWORD /d "11" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "DllColumnCount" /t REG_DWORD /d "4" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HandleColumnCount" /t REG_DWORD /d "2" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "DefaultProcPropPage" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "DefaultSysInfoPage" /t REG_DWORD /d "4" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "DefaultDllPropPage" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "DbgHelpPath" /t REG_SZ /d "C:\Windows\SYSTEM32\dbghelp.dll" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "SymbolPath" /t REG_SZ /d "" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorPacked" /t REG_DWORD /d "16711808" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorImmersive" /t REG_DWORD /d "15395328" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorOwn" /t REG_DWORD /d "16765136" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorServices" /t REG_DWORD /d "13684991" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorRelocatedDlls" /t REG_DWORD /d "10551295" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorGraphBk" /t REG_DWORD /d "15790320" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorJobs" /t REG_DWORD /d "27856" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorDelProc" /t REG_DWORD /d "4605695" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorNewProc" /t REG_DWORD /d "4652870" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorNet" /t REG_DWORD /d "10551295" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorProtected" /t REG_DWORD /d "8388863" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowHeatmaps" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorSuspend" /t REG_DWORD /d "8421504" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "StatusBarColumns" /t REG_DWORD /d "8213" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowAllCpus" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowAllGpus" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "Opacity" /t REG_DWORD /d "100" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "GpuNodeUsageMask" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "GpuNodeUsageMask1" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "VerifySignatures" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "VirusTotalCheck" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "VirusTotalSubmitUnknown" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ToolbarBands" /t REG_BINARY /d "0601000000000000000000004b00000001000000000000004b00000002000000000000004b00000003000000000000004b00000004000000000000004b00000005000000000000004b00000006000000000000004b0000000700000000000000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "UseGoogle" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowNewProcesses" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "TrayCPUHistory" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowIoTray" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowNetTray" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowDiskTray" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowPhysTray" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowCommitTray" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowGpuTray" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "FormatIoBytes" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "StackWindowPlacement" /t REG_BINARY /d "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ETWstandardUserWarning" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\DllColumnMap" /v "0" /t REG_DWORD /d "26" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\DllColumnMap" /v "1" /t REG_DWORD /d "42" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\DllColumnMap" /v "2" /t REG_DWORD /d "1033" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\DllColumnMap" /v "3" /t REG_DWORD /d "1111" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\DllColumns" /v "0" /t REG_DWORD /d "110" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\DllColumns" /v "1" /t REG_DWORD /d "180" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\DllColumns" /v "2" /t REG_DWORD /d "140" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\DllColumns" /v "3" /t REG_DWORD /d "300" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\HandleColumnMap" /v "0" /t REG_DWORD /d "21" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\HandleColumnMap" /v "1" /t REG_DWORD /d "22" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\HandleColumns" /v "0" /t REG_DWORD /d "100" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\HandleColumns" /v "1" /t REG_DWORD /d "450" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "0" /t REG_DWORD /d "3" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "1" /t REG_DWORD /d "1055" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "2" /t REG_DWORD /d "1060" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "3" /t REG_DWORD /d "1063" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "4" /t REG_DWORD /d "4" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "5" /t REG_DWORD /d "1200" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "6" /t REG_DWORD /d "1092" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "7" /t REG_DWORD /d "1333" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "8" /t REG_DWORD /d "5" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "9" /t REG_DWORD /d "1340" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "10" /t REG_DWORD /d "1191" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "0" /t REG_DWORD /d "200" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "1" /t REG_DWORD /d "40" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "2" /t REG_DWORD /d "80" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "3" /t REG_DWORD /d "80" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "4" /t REG_DWORD /d "40" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "5" /t REG_DWORD /d "100" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "6" /t REG_DWORD /d "78" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "7" /t REG_DWORD /d "81" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "8" /t REG_DWORD /d "49" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "9" /t REG_DWORD /d "53" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "10" /t REG_DWORD /d "100" /f


:: Echo to Logger
cls & echo %date% %time% Replaced Task Manager with Process Explorer. >> %userlog%
:: Echo to User
cls & echo Replaced Task Manager with Process Explorer.
timeout /t 2 >nul
exit /b





:Nope
exit /b