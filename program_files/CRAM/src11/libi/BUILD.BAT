@echo off
cls
echo.
echo Building libi.h11 ...
cx6811 *.c
ca6811 -v -dalu=0 *.s
clib -c libi.h11 *.o
echo.
echo Building libia.h11 ...
cx6811 +alu *.c
ca6811 -v -dalu=1 *.s
clib -c libia.h11 *.o
del *.o
echo.
echo Done.
