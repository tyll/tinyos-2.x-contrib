echo off
SET C51INC=C:\Keil\C51\INC\Nordic\;C:\Keil\C51\INC\
SET C51LIB=C:\Keil\C51\LIB
SET CPU_TYPE=nRF24E1
SET CPU_VENDOR=Nordic Semiconductor
SET UV2_TARGET=Simulator
SET CPU_XTAL=0x00F42400
echo on
cd build\cc2430em\
C:\Keil\C51\BIN\C51.EXE app.c PRINT(.\app.lst) OBJECT(.\app.obj)
C:\Keil\C51\BIN\BL51.EXE app.obj TO "APP" PRINT(".\APP.m51") RAMSIZE(256)
C:\Keil\C51\BIN\OH51.EXE APP
cd ..\..
