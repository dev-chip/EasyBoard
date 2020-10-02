@echo off
echo  Cosmic Relocatable 68hc11 Assembler 
if NOT EXIST %1 echo Cannot find filename %1
if NOT EXIST %1 goto :byebye
@echo off
ca6811 -l -orelobj.o %1 
echo Your object is called relobj.o
echo list file is called relobj.lst
:byebye

