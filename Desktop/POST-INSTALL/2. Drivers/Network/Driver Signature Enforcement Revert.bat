@echo off
bcdedit /deletevalue nointegritychecks
bcdedit /set loadoptions ENABLE_INTEGRITY_CHECKS
bcdedit /deletevalue TESTSIGNING
pause