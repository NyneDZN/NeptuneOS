:: This *may* improve single core performance on older CPU's if the Windows Timer is hammering on 1 core by spreading the timer across multiple cores, but the impact is pretty much undocumented, so try on your own.
:: Impact on modern CPU's is mostly unknown, so it's recommended to keep off and let windows handle it for you.

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DistributeTimers" /t REG_DWORD /d "1" /f