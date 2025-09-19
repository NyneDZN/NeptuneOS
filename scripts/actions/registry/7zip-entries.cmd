call "C:\neptune-installer\variables.cmd"

:: Context Menu Options
%currentuser% reg add "HKCU\Software\7-Zip\FM\Columns" /v "RootFolder" /t REG_BINARY /d "0100000000000000010000000400000001000000A0000000" /f 
%currentuser% reg add "HKCU\Software\7-Zip\Options" /v "ElimDupExtract" /t REG_DWORD /d "0" /f 
%currentuser% reg add "HKCU\Software\7-Zip\Options" /v "ContextMenu" /t REG_DWORD /d "4100" /f 
%currentuser% reg add "HKCU\SOFTWARE\7-Zip\Options" /v "ContextMenu" /t REG_DWORD /d "1073746726" /f
:: File Assoc
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.001\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.001\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.7z\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.7z\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.apfs\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.apfs\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.arj\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.arj\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.bz2\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.bz2\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.bzip2\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.bzip2\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.cab\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.cab\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.cpio\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.cpio\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.deb\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.deb\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.dmg\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.dmg\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.esd\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.esd\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.fat\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.fat\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.gz\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.gz\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.gzip\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.gzip\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.hfs\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.hfs\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.iso\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.iso\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.lha\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.lha\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.lzh\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.lzh\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.lzma\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.lzma\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.ntfs\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.ntfs\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.rar\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.rar\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.rpm\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.rpm\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.squashfs\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.squashfs\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.swm\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.swm\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.tar\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.tar\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.taz\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.taz\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.tbz2\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.tbz2\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.tbz\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.tbz\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.tgz\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.tgz\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.tpz\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.tpz\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.txz\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.txz\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.vhd\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.vhd\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.vhdx\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.vhdx\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.wim\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.wim\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.xz\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.xz\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.z\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.z\shell\open" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.zip\shell" /ve /t REG_SZ /d ^"" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\7-Zip.zip\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.001\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.001\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.7z\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.7z\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.apfs\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.apfs\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.arj\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.arj\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.bz2\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.bz2\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.bzip2\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.bzip2\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.cab\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.cab\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.cpio\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.cpio\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.deb\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.deb\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.dmg\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.dmg\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.esd\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.esd\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.fat\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.fat\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.gz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.gz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.gzip\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.gzip\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.hfs\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.hfs\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.iso\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.iso\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lha\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lha\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lzh\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lzh\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lzma\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lzma\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.ntfs\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.ntfs\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.rar\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.rar\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.rpm\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.rpm\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.squashfs\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.squashfs\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.swm\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.swm\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tar\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tar\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.taz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.taz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz2\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz2\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tgz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tgz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tpz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tpz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.txz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.txz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.vhd\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.vhd\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.vhdx\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.vhdx\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.wim\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.wim\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.xz\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.xz\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.z\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.z\shell\open" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.zip\shell" /ve /t REG_SZ /d ^"" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.zip\shell\open" /ve /t REG_SZ /d ^"" /f