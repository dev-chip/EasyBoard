@echo off
cls
echo.
echo Building libd.h11 ...
cx6811 *.c *.s
clib -c libd.h11 *.o
echo.
echo Building libda.h11 ...
cx6811 +alu *.c
clib -c libda.h11 *.o
del *.o
echo.
echo Done.
