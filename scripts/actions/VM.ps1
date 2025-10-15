if ((Get-WmiObject Win32_ComputerSystem).Model -match 'Virtual|VMware|VirtualBox|KVM|Hyper-V') {
    # things like CDROM and file sharing are disabled by default on windows, this script just saves the time of re-enabling them and rebooting upon install, if the user is running from a VM
    Write-Host "VM detected — adjusting accordingly"
}
# do nothing if the user isn't on a VM, cycle to next script 
