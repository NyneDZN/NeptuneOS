reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dhcp" /v "DependOnService" /t Reg_MULTI_SZ /d "NSI\0Afd" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache" /v "DependOnService" /t Reg_MULTI_SZ /d "nsi" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc" /v "DependOnService" /t Reg_MULTI_SZ /d "NSI\0RpcSs\0TcpIp" /f 