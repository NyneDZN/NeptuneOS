# services-drivers.ps1 - Action script to configure service/driver startup types

# ========================
# Helper function: set service/driver startup
# ========================
function Set-ServiceStartup {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ServiceName,

        [Parameter(Mandatory=$true)]
        [ValidateRange(0,4)]
        [int]$StartType
    )

    $regPath = "HKLM:\System\CurrentControlSet\Services\$ServiceName"

    # Check if service/driver exists
    if (-not (Test-Path $regPath)) {
        Write-Log "The specified service/driver '$ServiceName' was not found." "ERROR"
        return
    }

    try {
        Set-ItemProperty -Path $regPath -Name "Start" -Value $StartType -Type DWord -ErrorAction Stop
        Write-Log "Service/Driver '$ServiceName' configured to startup type $StartType"
    } 
    catch {
        Write-Log "Failed to configure '$ServiceName': $($_.Exception.Message)" "ERROR"
    }

}

# ========================
# Optional shortcut for batch-style calls
# ========================
$svc = { param($name,$type) Set-ServiceStartup -ServiceName $name -StartType $type }

# ========================
# Configure services/drivers here in order
# ========================
# Examples:
# & $svc "W32Time" 4     # Disable Windows Time
# & $svc "Spooler" 3     # Set Print Spooler to manual
# & $svc "bam" 2  # Automatic startup

# Ordered list approach (run multiple services/drivers automatically)
$ServicesToConfigure = @(
    # Drivers
    @{ Name = "3ware"; Start = 4 },   # Disabled
    @{ Name = "ADP80XX"; Start = 4 }, # Disabled
    @{ Name = "AmdK8"; Start = 4 },   # Disabled
    @{ Name = "Beep"; Start = 4 },    # Disabled
    @{ Name = "BthA2dp"; Start = 4 }, # Disabled
    @{ Name = "BthAvctpSvc"; Start = 4 },   # Disabled
    @{ Name = "BthEnum"; Start = 4 },   # Disabled
    @{ Name = "BthHFEnum"; Start = 4 },   # Disabled
    @{ Name = "bthleenum"; Start = 4 },   # Disabled
    @{ Name = "BTHMODEM"; Start = 4 },   # Disabled
    @{ Name = "cdrom"; Start = 4 },   # Disabled
    @{ Name = "flpydisk"; Start = 4 },   # Disabled
    @{ Name = "GpuEnergyDrv"; Start = 4 },   # Disabled
    @{ Name = "mrxsmb"; Start = 4 },   # Disabled
    @{ Name = "mrxsmb20"; Start = 4 },   # Disabled
    @{ Name = "MsLldp"; Start = 4 },   # Disabled
    @{ Name = "NdisCap"; Start = 4 },   # Disabled
    @{ Name = "NdisTapi"; Start = 4 },   # Disabled
    @{ Name = "NdisWan"; Start = 4 },   # Disabled
    @{ Name = "ndiswanlegacy"; Start = 4 },   # Disabled
    @{ Name = "Ndu"; Start = 4 },   # Disabled
    @{ Name = "NetBIOS"; Start = 4 },   # Disabled
    @{ Name = "NetBT"; Start = 4 },   # Disabled
    @{ Name = "PptpMiniport"; Start = 4 },   # Disabled
    @{ Name = "RasAgileVpn"; Start = 4 },   # Disabled
    @{ Name = "Rasl2tp"; Start = 4 },   # Disabled
    @{ Name = "RasPppoe"; Start = 4 },   # Disabled
    @{ Name = "RasSstp"; Start = 4 },   # Disabled
    @{ Name = "rspndr"; Start = 4 },   # Disabled
    @{ Name = "srv2"; Start = 4 },   # Disabled
    @{ Name = "srvnet"; Start = 4 },   # Disabled
    @{ Name = "tcpipReg"; Start = 4 },   # Disabled
    @{ Name = "Telemetry"; Start = 4 },   # Disabled
    @{ Name = "uhssvc"; Start = 4 },   # Disabled
    @{ Name = "wanarp"; Start = 4 },   # Disabled
    @{ Name = "wanarpv6"; Start = 4 },   # Disabled
    @{ Name=  "KSecPkg"; Start = 4 },    # Disabled}

    # Services
    @{ Name = "Audiosrv"; Start = 2 },     # Automatic
    @{ Name = "AudioEndpointBuilder"; Start = 2 },     # Automatic
    @{ Name = "BTAGService"; Start = 4 },     # Disabled
    @{ Name = "BDESVC"; Start = 4 },     # Disabled
    @{ Name = "BluetoothUserService"; Start = 4 },     # Disabled
    @{ Name = "bthserv"; Start = 4 },     # Disabled
    @{ Name = "diagsvc"; Start = 4 },     # Disabled
    @{ Name = "DiagTrack"; Start = 4 },     # Disabled
    @{ Name = "DispBrokerDesktopSvc"; Start = 4 },     # Automatic
    @{ Name = "DisplayEnhancementService"; Start = 4 },     # Disabled
    @{ Name = "DPS"; Start = 4 },     # Disabled
    @{ Name = "DusmSvc"; Start = 4 },     # Disabled
    @{ Name = "edgeupdate"; Start = 4 },     # Disabled
    @{ Name = "edgeupdatem"; Start = 4 },     # Disabled
    @{ Name = "FontCache"; Start = 4 },     # Disabled
    @{ Name = "FontCache3.0.0.0"; Start = 4 },     # Disabled
    @{ Name = "HvHost"; Start = 4 },     # Disabled
    @{ Name = "IKEEXT"; Start = 4 },     # Disabled
    @{ Name = "iphlpsvc"; Start = 4 },     # Disabled
    @{ Name = "lfsvc"; Start = 4 },     # Disabled
    @{ Name = "LanManServer"; Start = 4 },     # Disabled
    @{ Name = "LanmanWorkstation"; Start = 4 },     # Disabled
    @{ Name = "lmhosts"; Start = 4 },     # Disabled
    @{ Name = "microsoft_bluetooth_avrcptransport"; Start = 4 },     # Disabled
    @{ Name = "MapsBroker"; Start = 4 },     # Disabled
    @{ Name = "MSDTC"; Start = 4 },     # Disabled
    @{ Name = "PrintNotify"; Start = 4 },     # Disabled
    @{ Name = "RasMan"; Start = 4 },     # Disabled
 #  @{ Name = "rdyboost"; Start = 4 },     # Disabled
    @{ Name = "RFCOMM"; Start = 4 },     # Disabled
    @{ Name = "RmSvc"; Start = 4 },     # Disabled
    @{ Name = "TrkWks"; Start = 4 },     # Disabled
    @{ Name = "ShellHWDetection"; Start = 4 },     # Disabled
    @{ Name = "Spooler"; Start = 4 },     # Disabled
    @{ Name = "SgrmBroker"; Start = 4 },     # Disabled
    @{ Name = "SysMain"; Start = 4 },     # Disabled
    @{ Name = "W32Time"; Start = 4 },     # Disabled
    @{ Name = "WaaSMedicSvc"; Start = 4 },     # Disabled
    @{ Name = "WarpJITSvc"; Start = 4 },     # Disabled
    @{ Name = "WdiServiceHost"; Start = 4 },     # Disabled
    @{ Name = "webthreatdefusersvc"; Start = 4 },     # Disabled
    @{ Name = "WinHttpAutoProxySvc"; Start = 4 },     # Disabled
    @{ Name = "WPDBusEnum"; Start = 4 },     # Disabled
    @{ Name = "webthreatdefsvc"; Start = 4 },     # Disabled
    @{ Name = "WerSvc"; Start = 4 },     # Disabled
    @{ Name = "WSearch"; Start = 4 }     # Disabled
)

foreach ($svcItem in $ServicesToConfigure) {
    Set-ServiceStartup -ServiceName $svcItem.Name -StartType $svcItem.Start
}
