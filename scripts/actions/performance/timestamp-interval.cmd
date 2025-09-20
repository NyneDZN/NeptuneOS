:: This can potentially help smooth things out on a hard drive by setting timestamp logging to background priority, other wise on a sata SSD/NVME, won't do much besides negligably lower background overhead.

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" /v "TimeStampInterval" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" /v "IoPriority" /t REG_DWORD /d "3"