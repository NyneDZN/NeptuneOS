:: Features and Components
:: Enable DirectPlay
dism /Online /Enable-Feature /FeatureName:"LegacyComponents" /NoRestart 
dism /Online /Enable-Feature /FeatureName:"DirectPlay" /NoRestart 
:: Disable Hyper-V
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-All" /NoRestart 
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Management-Clients" /NoRestart 
:: Disable Hyper-V Management Tools
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Tools-All" /NoRestart 
:: Disable Hyper-V Module for Windows PowerShell
dism /Online /Disable-Feature /FeatureName:"Microsoft-Hyper-V-Management-PowerShell" /NoRestart 
:: Disable Telnet Client
dism /Online /Disable-Feature /FeatureName:"TelnetClient" /NoRestart 
:: Disable Net.TCP Port Sharing
dism /Online /Disable-Feature /FeatureName:"WCF-TCP-PortSharing45" /NoRestart 
:: Disable SMB Direct
dism /Online /Disable-Feature /FeatureName:"SmbDirect" /NoRestart 
:: Disable SMB1 Protocol
dism /online /Disable-Feature /FeatureName:"SMB1Protocol" /NoRestart 
dism /Online /Disable-Feature /FeatureName:"SMB1Protocol-Client" /NoRestart 
dism /Online /Disable-Feature /FeatureName:"SMB1Protocol-Server" /NoRestart 
:: Disable TFTP Client
dism /Online /Disable-Feature /FeatureName:"TFTP" /NoRestart 
:: Disable Internet Printing Client
dism /Online /Disable-Feature /FeatureName:"Printing-Foundation-InternetPrinting-Client" /NoRestart 
:: Disable LPD Print Service
dism /Online /Disable-Feature /FeatureName:"LPDPrintService" /NoRestart 
:: Disable Internet Explorer
dism /Online /Disable-Feature /FeatureName:"Internet-Explorer-Optional-x64" /NoRestart 
dism /Online /Disable-Feature /FeatureName:"Internet-Explorer-Optional-x84" /NoRestart 
dism /Online /Disable-Feature /FeatureName:"Internet-Explorer-Optional-amd64" /NoRestart 
:: Disable LPR Port Monitor
dism /Online /Disable-Feature /FeatureName:"Printing-Foundation-LPRPortMonitor" /NoRestart 
:: Disable Microsoft Print to PDF
dism /Online /Disable-Feature /FeatureName:"Printing-PrintToPDFServices-Features" /NoRestart 
:: Disable "PS Services
dism /Online /Disable-Feature /FeatureName:"Printing-XPSServices-Features" /NoRestart 
:: Disable XPS Viewer
dism /Online /Disable-Feature /FeatureName:"Xps-Foundation-Xps-Viewer" /NoRestart 
:: Disable Print and Document Services
dism /Online /Disable-Feature /FeatureName:"Printing-Foundation-Features" /NoRestart 
:: Disable Work Folders Client
dism /Online /Disable-Feature /FeatureName:"WorkFolders-Client" /NoRestart 
:: Disable Windows Media Player
dism /Online /Disable-Feature /FeatureName:"MediaPlayback" /NoRestart 
dism /Online /Disable-Feature /FeatureName:"WindowsMediaPlayer" /NoRestart 
:: Disable "Scan Management" feature
dism /Online /Disable-Feature /FeatureName:"ScanManagementConsole" /NoRestart 
:: Disable "Windows Fax and Scan" feature
dism /Online /Disable-Feature /FeatureName:"FaxServicesClientPackage" /NoRestart 
:: Disable PowerShell V2
dism /Online /Disable-Feature /FeatureName:"MicrosoftWindowsPowerShellV2Root" /NoRestart 
:: Disable Remote Differential Compression
dism /Online /Disable-Feature /FeatureName:"MSRDC-Infrastructure" /NoRestart 
:: Disable WCF Services
dism /Online /Disable-Feature /FeatureName:"WCF-Services45" /NoRestart 
:: Disable Remote Desktop Connection
dism /Online /Disable-Feature /FeatureName:"Microsoft-RemoteDesktopConnection" /NoRestart 


:: Capabilities
:: Remove "Internet Explorer 11
%PowerShell% "Get-WindowsCapability -Online -Name 'Browser.InternetExplorer*' | Remove-WindowsCapability -Online" 
:: Remove Math Recognizer
%PowerShell% "Get-WindowsCapability -Online -Name 'MathRecognizer~~~~0.0.1.0*' | Remove-WindowsCapability -Online" 
:: Remove "OneSync" (breaks Mail, People, and Calendar)
%PowerShell% "Get-WindowsCapability -Online -Name 'OneCoreUAP.OneSync*' | Remove-WindowsCapability -Online" 
:: Remove OpenSSH client
%PowerShell% "Get-WindowsCapability -Online -Name 'OpenSSH.Client*' | Remove-WindowsCapability -Online" 
:: Remove PowerShell ISE
%PowerShell% "Get-WindowsCapability -Online -Name 'Microsoft.Windows.PowerShell.ISE*' | Remove-WindowsCapability -Online" 
:: Remove Print Management Console
%PowerShell% "Get-WindowsCapability -Online -Name 'Print.Management.Console*' | Remove-WindowsCapability -Online" 
:: Remove Quick Assist
%PowerShell% "Get-WindowsCapability -Online -Name 'App.Support.QuickAssist*' | Remove-WindowsCapability -Online" 
:: Remove Steps Recorder
%PowerShell% "Get-WindowsCapability -Online -Name 'App.StepsRecorder*' | Remove-WindowsCapability -Online" 
:: Remove Windows Fax and Scan
%PowerShell% "Get-WindowsCapability -Online -Name 'Print.Fax.Scan*' | Remove-WindowsCapability -Online" 
:: Remove Hello Face
%PowerShell% "Get-WindowsCapability -Online -Name 'Hello.Face.20134~~~~0.0.1.0*' | Remove-WindowsCapability -Online" 
:: Remove WordPad
%PowerShell% "Get-WindowsCapability -Online -Name 'Microsoft.Windows.WordPad~~~~0.0.1.0*' | Remove-WindowsCapability -Online" 
:: Remove Extended Wallpapers
%PowerShell% "Get-WindowsCapability -Online -Name 'Microsoft.Wallpapers.Extended~~~~0.0.1.0*' | Remove-WindowsCapability -Online" 