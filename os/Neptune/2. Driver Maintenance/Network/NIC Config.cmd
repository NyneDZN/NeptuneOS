:: Set network adapter driver registry key
for /f %%a in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
	for /f "tokens=3" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%a" /v "Driver" 2^>nul') do (
        set "netKey=HKLM\SYSTEM\CurrentControlSet\Control\Class\%%b"
    )
)

:: Configure internet adapter settings
:: Dump of all possible settings found
:: TO DO: revise and document each setting
for %%a in (
    "AdvancedEEE"
    "AlternateSemaphoreDelay"
    "ApCompatMode"
    "ARPOffloadEnable"
    "AutoDisableGigabit"
    "AutoPowerSaveModeEnabled"
    "bAdvancedLPs"
    "bLeisurePs"
    "bLowPowerEnable"
    "DeviceSleepOnDisconnect"
    "DMACoalescing"
    "EEE"
    "EEELinkAdvertisement"
    "EeePhyEnable"
    "Enable9KJFTpt"
    "EnableConnectedPowerGating"
    "EnableDynamicPowerGating"
    "EnableEDT"
    "EnableGreenEthernet"
    "EnableModernStandby"
    "EnablePME"
    "EnablePowerManagement"
    "EnableSavePowerNow"
    "EnableWakeOnLan"
    "FlowControl"
    "FlowControlCap"
    "GigaLite"
    "GPPSW"
    "GTKOffloadEnable"
    "InactivePs"
    "LargeSendOffload"
    "LargeSendOffloadJumboCombo"
    "LogLevelWarn"
    "LsoV1IPv4"
    "LsoV2IPv4"
    "LsoV2IPv6"
    "MasterSlave"
    "ModernStandbyWoLMagicPacket"
    "MPC"
    "NicAutoPowerSaver"
    "Node"
    "NSOffloadEnable"
    "PacketCoalescing"
    "PMWiFiRekeyOffload"
    "PowerDownPll"
    "PowerSaveMode"
    "PowerSavingMode"
    "PriorityVLANTag"
    "ReduceSpeedOnPowerDown"
    "S5WakeOnLan"
    "SavePowerNowEnabled"
    "SelectiveSuspend"
    "SipsEnabled"
    "uAPSDSupport"
    "ULPMode"
    "WaitAutoNegComplete"
    "WakeOnDisconnect"
    "WakeOnLink"
    "WakeOnMagicPacket"
    "WakeOnPattern"
    "WakeOnSlot"
    "WakeUpModeCap"
    "WoWLANLPSLevel"
    "WoWLANS5Support"
) do (
    rem Check without '*'
    for /f %%b in ('reg query "%netKey%" /v "%%~a" 2^>nul ^| findstr "HKEY" 2^>nul') do (
        reg add "%netKey%" /v "%%~a" /t REG_SZ /d "0" /f > nul
    )
    rem Check with '*'
    for /f %%b in ('reg query "%netKey%" /v "*%%~a" 2^>nul ^| findstr "HKEY" 2^>nul') do (
        reg add "%netKey%" /v "*%%~a" /t REG_SZ /d "0" /f > nul
    )
)
