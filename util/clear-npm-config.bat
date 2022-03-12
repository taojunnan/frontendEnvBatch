@echo off
echo delete prefix
call npm config delete prefix
echo delete cache
call npm config delete cache
echo delete registry
call npm config delete registry
echo list config
call npm config list
pause