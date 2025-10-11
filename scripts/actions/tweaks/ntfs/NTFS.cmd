:: Configuring the NTFS file system in Windows

:: Adjust MFT (master file table) and paged pool memory cache levels according to ram size
:: if !TOTAL_MEMORY! LSS 8000000 (
:: FSUTIL behavior set memoryusage 1 
:: FSUTIL behavior set mftzone 1 
:: ) else if !TOTAL_MEMORY! LSS 16000000 (
:: FSUTIL behavior set memoryusage 1 
:: FSUTIL behavior set mftzone 2 
:: ) else (
:: FSUTIL behavior set memoryusage 2 
:: FSUTIL behavior set mftzone 2 
:: )

:: Disallows characters from the extended character set to be used in 8.3 character-length short file names
FSUTIL behavior set allowextchar 0 
:: Disallow generation of a bug check
FSUTIL behavior set bugcheckoncorrupt 0 
:: Disable 8.3 File Creation
:: https://ttcshelbyville.wordpress.com/2018/12/02/should-you-disable-8dot3-for-performance-and-security
FSUTIL behavior set disable8dot3 1 
:: Disable NTFS File Compression
:: Causes DISM errors but also adds slight overhead when files are compressing in the background, user can re-enable if needed
FSUTIL behavior set disablecompression 1
:: Disable NTFS File Encryption
:: Commented out because this disables XBOX downloads
:: FSUTIL behavior set disableencryption 1 
:: Disable Last Accessed Timestamp
FSUTIL behavior set disablelastaccess 1 
FSUTIL behavior set disablespotcorruptionhandling 1 
:: Enable Trimming for SSD's
FSUTIL behavior set disabledeletenotify 0 
:: Disable paging file encryption
FSUTIL behavior set encryptpagingfile 0 
FSUTIL behavior set quotanotify 86400 
FSUTIL behavior set symlinkevaluation L2L:1 
:: Disable self repair on boot drive
FSUTIL repair set C: 0 

:: Disable Write Cache Buffer
for /f "tokens=*" %%i in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI" 2^>nul ^| findstr "HKEY"') do (
for /f "tokens=*" %%a in ('Reg query "%%i" 2^>nul ^| findstr "HKEY"') do reg add "%%a\Device Parameters\Disk" /v "CacheIsPowerProtected" /t Reg_DWORD /d "1" /f 
)
for /f "tokens=*" %%i in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI" 2^>nul ^| findstr "HKEY"') do (
for /f "tokens=*" %%a in ('Reg query "%%i" 2^>nul ^| findstr "HKEY"') do reg add "%%a\Device Parameters\Disk" /v "UserWriteCacheSetting" /t Reg_DWORD /d "1" /f 
)

:: Disable HIPM, DIPM, and HDD parking
FOR /F "eol=E" %%a in ('Reg QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "EnableHIPM"^| FINDSTR /V "EnableHIPM"') DO (
reg add "%%a" /F /V "EnableHIPM" /T Reg_DWORD /d 0 
reg add "%%a" /F /V "EnableDIPM" /T Reg_DWORD /d 0 
reg add "%%a" /F /V "EnableHDDParking" /T Reg_DWORD /d 0 
)

:: IOLATENCYCAP to 0
FOR /F "eol=E" %%a in ('Reg QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "IoLatencyCap"^| FINDSTR /V "IoLatencyCap"') DO (
reg add "%%a" /F /V "IoLatencyCap" /T Reg_DWORD /d 0 
)

:: Set Drive Label
label C: NeptuneOS 