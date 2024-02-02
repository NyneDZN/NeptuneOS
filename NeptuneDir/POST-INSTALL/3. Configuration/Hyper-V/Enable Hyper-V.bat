@echo off
sc config vmickvpexchange start=demand
sc config vmicguestinterface start=demand
sc config vmicshutdown start=demand
sc config vmicheartbeat start=demand
sc config vmicvmsession start=demand
sc config vmicrdv start=demand
sc config vmictimesync start=demand
sc config vmicvss start=demand
sc config hyperkbd start=demand
sc config hypervideo start=demand
sc config gencounter start=demand
sc config vmgid start=demand
sc config storflt start=boot
sc config bttflt start=boot
sc config vpci start=boot
sc config hvservice start=demand
sc config hvcrash start=disabled
sc config HvHost start=demand
sc config rdbss start=system
C:\Windows\NeptuneDir\Tools\dmv.exe /enable "Remote Desktop Device Redirector Bus"
C:\Windows\NeptuneDir\Tools\dmv.exe /enable "Microsoft Hyper-V Virtualization Infrastructure Driver"
cls
echo Hyper-V enabled. Please reboot.
pause