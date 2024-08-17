@echo off
color 0a
cd ..
echo BUILDING...
haxelib run lime build windows -release
echo.
echo done!
pause