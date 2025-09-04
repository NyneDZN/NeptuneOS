Set WshShell = WScript.CreateObject("WScript.Shell")
Dim ObjShell :Set ObjShell = CreateObject("Wscript.Shell")
ObjShell.AppActivate("Administrator:")
WshShell.AppActivate("Administrator:")
WshShell.SendKeys "{F11}"