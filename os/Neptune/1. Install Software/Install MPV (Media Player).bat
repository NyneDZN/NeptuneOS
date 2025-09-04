@echo off
cd %WINDIR%\NeptuneDir\Tools
curl -o mpv.7z -L https://cfhcable.dl.sourceforge.net/project/mpv-player-windows/64bit-v3/mpv-x86_64-v3-20240317-git-3afcaeb.7z
7za x mpv.7z
del mpv.7z
mkdir MPV2
move "doc" "MPV2"
move "installer" "MPV2"
move "mpv" "MPV2"
move "d3dcompiler_43.dll" "MPV2"
move "mpv.com" "MPV2"
move "mpv.exe" "MPV2"
move "updater.bat" MPV2
move "MPV2" "C:\Program Files (x86)" & cd "C:\Program Files (x86)"
rename "MPV2" "MPV"
call "C:\Program Files (x86)\MPV\installer\mpv-install.bat"

pause>nul
