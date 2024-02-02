@echo off
echo Finalizing the OS. This script will close and delete itself when it is finished.
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticecaption" /f >nul
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "legalnoticetext" /f >nul
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /f >nul
Reg.exe add "HKCU\Software\7-Zip\FM\Columns" /v "RootFolder" /t REG_BINARY /d "0100000000000000010000000400000001000000A0000000" /f >nul
Reg.exe add "HKCU\Software\7-Zip\Options" /v "ElimDupExtract" /t REG_DWORD /d "0" /f >nul
Reg.exe add "HKCU\Software\7-Zip\Options" /v "ContextMenu" /t REG_DWORD /d "4100" /f >nul
Reg.exe add "HKCU\Software\Classes\.001" /ve /t REG_SZ /d "7-Zip.001" /f >nul
Reg.exe add "HKCU\Software\Classes\.7z" /ve /t REG_SZ /d "7-Zip.7z" /f >nul
Reg.exe add "HKCU\Software\Classes\.arj" /ve /t REG_SZ /d "7-Zip.arj" /f >nul
Reg.exe add "HKCU\Software\Classes\.bz2" /ve /t REG_SZ /d "7-Zip.bz2" /f >nul
Reg.exe add "HKCU\Software\Classes\.bzip2" /ve /t REG_SZ /d "7-Zip.bzip2" /f >nul
Reg.exe add "HKCU\Software\Classes\.cab" /ve /t REG_SZ /d "7-Zip.cab" /f >nul
Reg.exe add "HKCU\Software\Classes\.cpio" /ve /t REG_SZ /d "7-Zip.cpio" /f >nul
Reg.exe add "HKCU\Software\Classes\.deb" /ve /t REG_SZ /d "7-Zip.deb" /f >nul
Reg.exe add "HKCU\Software\Classes\.dmg" /ve /t REG_SZ /d "7-Zip.dmg" /f >nul
Reg.exe add "HKCU\Software\Classes\.fat" /ve /t REG_SZ /d "7-Zip.fat" /f >nul
Reg.exe add "HKCU\Software\Classes\.gz" /ve /t REG_SZ /d "7-Zip.gz" /f >nul
Reg.exe add "HKCU\Software\Classes\.gzip" /ve /t REG_SZ /d "7-Zip.gzip" /f >nul
Reg.exe add "HKCU\Software\Classes\.hfs" /ve /t REG_SZ /d "7-Zip.hfs" /f >nul
Reg.exe add "HKCU\Software\Classes\.iso" /ve /t REG_SZ /d "7-Zip.iso" /f >nul
Reg.exe add "HKCU\Software\Classes\.lha" /ve /t REG_SZ /d "7-Zip.lha" /f >nul
Reg.exe add "HKCU\Software\Classes\.lzh" /ve /t REG_SZ /d "7-Zip.lzh" /f >nul
Reg.exe add "HKCU\Software\Classes\.lzma" /ve /t REG_SZ /d "7-Zip.lzma" /f >nul
Reg.exe add "HKCU\Software\Classes\.ntfs" /ve /t REG_SZ /d "7-Zip.ntfs" /f >nul
Reg.exe add "HKCU\Software\Classes\.rar" /ve /t REG_SZ /d "7-Zip.rar" /f >nul
Reg.exe add "HKCU\Software\Classes\.rpm" /ve /t REG_SZ /d "7-Zip.rpm" /f >nul
Reg.exe add "HKCU\Software\Classes\.squashfs" /ve /t REG_SZ /d "7-Zip.squashfs" /f >nul
Reg.exe add "HKCU\Software\Classes\.swm" /ve /t REG_SZ /d "7-Zip.swm" /f >nul
Reg.exe add "HKCU\Software\Classes\.tar" /ve /t REG_SZ /d "7-Zip.tar" /f >nul
Reg.exe add "HKCU\Software\Classes\.taz" /ve /t REG_SZ /d "7-Zip.taz" /f >nul
Reg.exe add "HKCU\Software\Classes\.tbz" /ve /t REG_SZ /d "7-Zip.tbz" /f >nul
Reg.exe add "HKCU\Software\Classes\.tbz2" /ve /t REG_SZ /d "7-Zip.tbz2" /f >nul
Reg.exe add "HKCU\Software\Classes\.tgz" /ve /t REG_SZ /d "7-Zip.tgz" /f >nul
Reg.exe add "HKCU\Software\Classes\.tpz" /ve /t REG_SZ /d "7-Zip.tpz" /f >nul
Reg.exe add "HKCU\Software\Classes\.txz" /ve /t REG_SZ /d "7-Zip.txz" /f >nul
Reg.exe add "HKCU\Software\Classes\.vhd" /ve /t REG_SZ /d "7-Zip.vhd" /f >nul
Reg.exe add "HKCU\Software\Classes\.wim" /ve /t REG_SZ /d "7-Zip.wim" /f >nul
Reg.exe add "HKCU\Software\Classes\.xar" /ve /t REG_SZ /d "7-Zip.xar" /f >nul
Reg.exe add "HKCU\Software\Classes\.xz" /ve /t REG_SZ /d "7-Zip.xz" /f >nul
Reg.exe add "HKCU\Software\Classes\.z" /ve /t REG_SZ /d "7-Zip.z" /f >nul
Reg.exe add "HKCU\Software\Classes\.zip" /ve /t REG_SZ /d "7-Zip.zip" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.001" /ve /t REG_SZ /d "001 Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.001\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,9" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.001\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.001\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.001\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.7z" /ve /t REG_SZ /d "7z Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.7z\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,0" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.7z\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.7z\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.7z\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.arj" /ve /t REG_SZ /d "arj Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.arj\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,4" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.arj\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.arj\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.arj\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.bz2" /ve /t REG_SZ /d "bz2 Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.bz2\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.bz2\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.bz2\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.bz2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.bzip2" /ve /t REG_SZ /d "bzip2 Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.bzip2\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.bzip2\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.bzip2\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.bzip2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.cab" /ve /t REG_SZ /d "cab Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.cab\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,7" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.cab\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.cab\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.cab\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.cpio" /ve /t REG_SZ /d "cpio Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.cpio\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,12" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.cpio\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.cpio\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.cpio\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.deb" /ve /t REG_SZ /d "deb Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.deb\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,11" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.deb\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.deb\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.deb\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.dmg" /ve /t REG_SZ /d "dmg Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.dmg\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,17" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.dmg\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.dmg\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.dmg\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.fat" /ve /t REG_SZ /d "fat Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.fat\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,21" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.fat\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.fat\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.fat\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.gz" /ve /t REG_SZ /d "gz Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.gz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.gz\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.gz\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.gz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.gzip" /ve /t REG_SZ /d "gzip Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.gzip\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.gzip\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.gzip\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.gzip\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.hfs" /ve /t REG_SZ /d "hfs Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.hfs\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,18" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.hfs\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.hfs\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.hfs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.iso" /ve /t REG_SZ /d "iso Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.iso\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,8" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.iso\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.iso\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.iso\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.lha" /ve /t REG_SZ /d "lha Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.lha\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,6" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.lha\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.lha\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.lha\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.lzh" /ve /t REG_SZ /d "lzh Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.lzh\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,6" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.lzh\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.lzh\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.lzh\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.lzma" /ve /t REG_SZ /d "lzma Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.lzma\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,16" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.lzma\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.lzma\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.lzma\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.ntfs" /ve /t REG_SZ /d "ntfs Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.ntfs\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,22" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.ntfs\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.ntfs\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.ntfs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.rar" /ve /t REG_SZ /d "rar Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.rar\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,3" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.rar\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.rar\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.rar\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.rpm" /ve /t REG_SZ /d "rpm Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.rpm\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,10" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.rpm\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.rpm\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.rpm\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.squashfs" /ve /t REG_SZ /d "squashfs Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.squashfs\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,24" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.squashfs\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.squashfs\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.squashfs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.swm" /ve /t REG_SZ /d "swm Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.swm\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,15" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.swm\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.swm\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.swm\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tar" /ve /t REG_SZ /d "tar Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tar\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,13" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tar\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tar\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tar\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.taz" /ve /t REG_SZ /d "taz Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.taz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,5" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.taz\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.taz\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.taz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz" /ve /t REG_SZ /d "tbz Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz2" /ve /t REG_SZ /d "tbz2 Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz2\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz2\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz2\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tbz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tgz" /ve /t REG_SZ /d "tgz Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tgz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tgz\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tgz\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tgz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tpz" /ve /t REG_SZ /d "tpz Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tpz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tpz\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tpz\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.tpz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.txz" /ve /t REG_SZ /d "txz Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.txz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,23" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.txz\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.txz\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.txz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.vhd" /ve /t REG_SZ /d "vhd Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.vhd\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,20" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.vhd\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.vhd\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.vhd\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.wim" /ve /t REG_SZ /d "wim Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.wim\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,15" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.wim\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.wim\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.wim\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.xar" /ve /t REG_SZ /d "xar Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.xar\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,19" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.xar\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.xar\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.xar\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.xz" /ve /t REG_SZ /d "xz Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.xz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,23" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.xz\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.xz\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.xz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.z" /ve /t REG_SZ /d "z Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.z\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,5" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.z\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.z\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.z\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.zip" /ve /t REG_SZ /d "zip Archive" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.zip\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,1" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.zip\shell" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.zip\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg.exe add "HKCU\Software\Classes\7-Zip.zip\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f >nul
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /f >nul

:: Debloating UWP again to prevent leftovers
PowerShell -ExecutionPolicy Unrestricted -Command "$shortcuts = @(; @{ Revert = $True;  Path = "^""$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk"^""; }; @{ Revert = $True;  Path = "^""$env:AppData\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge.lnk"^""; }; @{ Revert = $True;  Path = "^""$env:AppData\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Microsoft Edge.lnk"^""; }; @{ Revert = $True;  Path = "^""$env:Public\Desktop\Microsoft Edge.lnk"^""; }; @{ Revert = $True;  Path = "^""$env:SystemRoot\System32\config\systemprofile\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge.lnk"^""; }; @{ Revert = $False; Path = "^""$env:UserProfile\Desktop\Microsoft Edge.lnk"^""; }; ); foreach ($shortcut in $shortcuts) {; if (-Not (Test-Path $shortcut.Path)) {; Write-Host "^""Skipping, shortcut does not exist: `"^""$($shortcut.Path)`"^""."^""; continue; }; try {; Remove-Item -Path $shortcut.Path -Force -ErrorAction Stop; Write-Output "^""Successfully removed shortcut: `"^""$($shortcut.Path)`"^""."^""; } catch {; Write-Error "^""Encountered an issue while attempting to remove shortcut at: `"^""$($shortcut.Path)`"^""."^""; }; }"
PowerShell -Command "Get-AppxPackage -allusers *3DBuilder* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *bing* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *bingfinance* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *bingsports* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *BingWeather* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Clipchamp.Clipchamp* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *CommsPhone* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Drawboard PDF* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Facebook* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Getstarted* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Microsoft.549981C3F5F10* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Microsoft.Cortana* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Microsoft.GamingApp* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Microsoft.GetHelp* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Microsoft.Messaging* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Microsoft.MicrosoftEdge.Stable* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Microsoft.MicrosoftStickyNotes* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Microsoft.OutlookForWindows* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Microsoft.PowerAutomateDesktop* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Microsoft.Todos* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Microsoft.Windows.Photos* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Microsoft.Xbox* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Microsoft.YourPhone* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *MicrosoftCorporationII.QuickAssist* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *MicrosoftOfficeHub* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Office.OneNote* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *OneNote* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *people* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *SkypeApp* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *solit* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Sway* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Twitter* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *Windows.DevHome* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *WindowsAlarms* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *WindowsCalculator* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *WindowsCamera* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *windowscommunicationsapps* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *WindowsFeedbackHub* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *WindowsMaps* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *WindowsPhone* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *WindowsSoundRecorder* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *WindowsTerminal* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -allusers *zune* | Remove-AppxPackage"
start /wait "" "%SYSTEMROOT%\System32\ONEDRIVESETUP.EXE" /UNINSTALL
move "C:\Neptune\NeptuneOS-main\Desktop\Neptune.lnk" "%USERPROFILE%\Desktop"
:: Cleanup
rmdir /s /q "C:\Neptune" >nul 2>&1
dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
cls & echo Finished.
echo Enjoy NeptuneOS.
timeout /t 2 /nobreak >nul
del "%~f0"