@echo off
color 0a
cd ..
echo BUILDING...
haxelib run lime build windows -debug
echo.
echo done!
pause