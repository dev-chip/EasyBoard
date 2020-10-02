@echo off
cls
echo.
echo Building LIBM.H11 ...
ca6811 -v *.s
clib -c libm.h11 *.o
del *.o
echo.
echo Done.
