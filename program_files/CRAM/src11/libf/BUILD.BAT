@echo off
cls
echo.
echo Building libf.h11 ...
cx6811 +sprec *.c *.s
clib -c libf.h11 *.o
echo.
echo Building libfa.h11 ...
cx6811 +sprec +alu *.c
clib -c libfa.h11 *.o
del *.o
echo.
echo Done.
