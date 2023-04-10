@echo off
bcdedit /set nointegritychecks on
bcdedit /set loadoptions DISABLE_INTEGRITY_CHECKS
bcdedit /set TESTSIGNING ON
pause