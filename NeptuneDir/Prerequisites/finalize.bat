@echo off
echo Finalizing the OS. This script will close and delete itself when it is finished.
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticecaption" /f
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticetext" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /f
Reg.exe add "HKCU\Software\7-Zip\FM\Columns" /v "RootFolder" /t REG_BINARY /d "0100000000000000010000000400000001000000A0000000" /f
Reg.exe add "HKCU\Software\7-Zip\Options" /v "ElimDupExtract" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\7-Zip\Options" /v "ContextMenu" /t REG_DWORD /d "4100" /f
Reg.exe add "HKCU\Software\Classes\.001" /ve /t REG_SZ /d "7-Zip.001" /f
Reg.exe add "HKCU\Software\Classes\.7z" /ve /t REG_SZ /d "7-Zip.7z" /f
Reg.exe add "HKCU\Software\Classes\.arj" /ve /t REG_SZ /d "7-Zip.arj" /f
Reg.exe add "HKCU\Software\Classes\.bz2" /ve /t REG_SZ /d "7-Zip.bz2" /f
Reg.exe add "HKCU\Software\Classes\.bzip2" /ve /t REG_SZ /d "7-Zip.bzip2" /f
Reg.exe add "HKCU\Software\Classes\.cab" /ve /t REG_SZ /d "7-Zip.cab" /f
Reg.exe add "HKCU\Software\Classes\.cpio" /ve /t REG_SZ /d "7-Zip.cpio" /f
Reg.exe add "HKCU\Software\Classes\.deb" /ve /t REG_SZ /d "7-Zip.deb" /f
Reg.exe add "HKCU\Software\Classes\.dmg" /ve /t REG_SZ /d "7-Zip.dmg" /f
Reg.exe add "HKCU\Software\Classes\.fat" /ve /t REG_SZ /d "7-Zip.fat" /f
Reg.exe add "HKCU\Software\Classes\.gz" /ve /t REG_SZ /d "7-Zip.gz" /f
Reg.exe add "HKCU\Software\Classes\.gzip" /ve /t REG_SZ /d "7-Zip.gzip" /f
Reg.exe add "HKCU\Software\Classes\.hfs" /ve /t REG_SZ /d "7-Zip.hfs" /f
Reg.exe add "HKCU\Software\Classes\.iso" /ve /t REG_SZ /d "7-Zip.iso" /f
Reg.exe add "HKCU\Software\Classes\.lha" /ve /t REG_SZ /d "7-Zip.lha" /f
Reg.exe add "HKCU\Software\Classes\.lzh" /ve /t REG_SZ /d "7-Zip.lzh" /f
Reg.exe add "HKCU\Software\Classes\.lzma" /ve /t REG_SZ /d "7-Zip.lzma" /f
Reg.exe add "HKCU\Software\Classes\.ntfs" /ve /t REG_SZ /d "7-Zip.ntfs" /f
Reg.exe add "HKCU\Software\Classes\.rar" /ve /t REG_SZ /d "7-Zip.rar" /f
Reg.exe add "HKCU\Software\Classes\.rpm" /ve /t REG_SZ /d "7-Zip.rpm" /f
Reg.exe add "HKCU\Software\Classes\.squashfs" /ve /t REG_SZ /d "7-Zip.squashfs" /f
Reg.exe add "HKCU\Software\Classes\.swm" /ve /t REG_SZ /d "7-Zip.swm" /f
Reg.exe add "HKCU\Software\Classes\.tar" /ve /t REG_SZ /d "7-Zip.tar" /f
Reg.exe add "HKCU\Software\Classes\.taz" /ve /t REG_SZ /d "7-Zip.taz" /f
Reg.exe add "HKCU\Software\Classes\.tbz" /ve /t REG_SZ /d "7-Zip.tbz" /f
Reg.exe add "HKCU\Software\Classes\.tbz2" /ve /t REG_SZ /d "7-Zip.tbz2" /f
Reg.exe add "HKCU\Software\Classes\.tgz" /ve /t REG_SZ /d "7-Zip.tgz" /f
Reg.exe add "HKCU\Software\Classes\.tpz" /ve /t REG_SZ /d "7-Zip.tpz" /f
Reg.exe add "HKCU\Software\Classes\.txz" /ve /t REG_SZ /d "7-Zip.txz" /f
Reg.exe add "HKCU\Software\Classes\.vhd" /ve /t REG_SZ /d "7-Zip.vhd" /f
Reg.exe add "HKCU\Software\Classes\.wim" /ve /t REG_SZ /d "7-Zip.wim" /f
Reg.exe add "HKCU\Software\Classes\.xar" /ve /t REG_SZ /d "7-Zip.xar" /f
Reg.exe add "HKCU\Software\Classes\.xz" /ve /t REG_SZ /d "7-Zip.xz" /f
Reg.exe add "HKCU\Software\Classes\.z" /ve /t REG_SZ /d "7-Zip.z" /f
Reg.exe add "HKCU\Software\Classes\.zip" /ve /t REG_SZ /d "7-Zip.zip" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.001" /ve /t REG_SZ /d "001 Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.001\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,9" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.001\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.001\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.001\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.7z" /ve /t REG_SZ /d "7z Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.7z\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,0" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.7z\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.7z\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.7z\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.arj" /ve /t REG_SZ /d "arj Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.arj\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,4" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.arj\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.arj\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.arj\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.bz2" /ve /t REG_SZ /d "bz2 Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.bz2\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.bz2\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.bz2\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.bz2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.bzip2" /ve /t REG_SZ /d "bzip2 Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.bzip2\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.bzip2\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.bzip2\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.bzip2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.cab" /ve /t REG_SZ /d "cab Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.cab\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,7" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.cab\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.cab\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.cab\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.cpio" /ve /t REG_SZ /d "cpio Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.cpio\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,12" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.cpio\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.cpio\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.cpio\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.deb" /ve /t REG_SZ /d "deb Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.deb\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,11" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.deb\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.deb\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.deb\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.dmg" /ve /t REG_SZ /d "dmg Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.dmg\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,17" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.dmg\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.dmg\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.dmg\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.fat" /ve /t REG_SZ /d "fat Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.fat\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,21" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.fat\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.fat\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.fat\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.gz" /ve /t REG_SZ /d "gz Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.gz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.gz\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.gz\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.gz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.gzip" /ve /t REG_SZ /d "gzip Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.gzip\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.gzip\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.gzip\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.gzip\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.hfs" /ve /t REG_SZ /d "hfs Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.hfs\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,18" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.hfs\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.hfs\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.hfs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.iso" /ve /t REG_SZ /d "iso Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.iso\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,8" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.iso\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.iso\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.iso\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.lha" /ve /t REG_SZ /d "lha Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.lha\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,6" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.lha\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.lha\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.lha\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.lzh" /ve /t REG_SZ /d "lzh Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.lzh\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,6" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.lzh\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.lzh\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.lzh\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.lzma" /ve /t REG_SZ /d "lzma Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.lzma\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,16" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.lzma\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.lzma\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.lzma\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.ntfs" /ve /t REG_SZ /d "ntfs Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.ntfs\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,22" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.ntfs\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.ntfs\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.ntfs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.rar" /ve /t REG_SZ /d "rar Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.rar\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,3" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.rar\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.rar\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.rar\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.rpm" /ve /t REG_SZ /d "rpm Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.rpm\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,10" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.rpm\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.rpm\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.rpm\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.squashfs" /ve /t REG_SZ /d "squashfs Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.squashfs\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,24" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.squashfs\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.squashfs\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.squashfs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.swm" /ve /t REG_SZ /d "swm Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.swm\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,15" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.swm\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.swm\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.swm\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tar" /ve /t REG_SZ /d "tar Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tar\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,13" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tar\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tar\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tar\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.taz" /ve /t REG_SZ /d "taz Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.taz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,5" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.taz\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.taz\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.taz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz" /ve /t REG_SZ /d "tbz Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz2" /ve /t REG_SZ /d "tbz2 Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz2\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz2\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz2\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tgz" /ve /t REG_SZ /d "tgz Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tgz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tgz\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tgz\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tgz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tpz" /ve /t REG_SZ /d "tpz Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tpz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tpz\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tpz\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.tpz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.txz" /ve /t REG_SZ /d "txz Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.txz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,23" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.txz\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.txz\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.txz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.vhd" /ve /t REG_SZ /d "vhd Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.vhd\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,20" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.vhd\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.vhd\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.vhd\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.wim" /ve /t REG_SZ /d "wim Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.wim\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,15" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.wim\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.wim\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.wim\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.xar" /ve /t REG_SZ /d "xar Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.xar\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,19" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.xar\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.xar\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.xar\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.xz" /ve /t REG_SZ /d "xz Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.xz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,23" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.xz\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.xz\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.xz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.z" /ve /t REG_SZ /d "z Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.z\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,5" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.z\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.z\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.z\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.zip" /ve /t REG_SZ /d "zip Archive" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.zip\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,1" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.zip\shell" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.zip\shell\open" /ve /t REG_SZ /d "" /f
Reg.exe add "HKCU\Software\Classes\7-Zip.zip\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f
del "%~f0"