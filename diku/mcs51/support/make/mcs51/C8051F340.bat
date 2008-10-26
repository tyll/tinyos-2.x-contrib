echo off
SET C51INC=C:\Keil\C51\INC\Cygnal\;C:\Keil\C51\INC\
SET C51LIB=C:\Keil\C51\LIB
SET CPU_TYPE=C8051F340
SET CPU_VENDOR=Silicon Laboratories, Inc.
SET UV2_TARGET=Target 1
SET CPU_XTAL=0x02DC6C00

echo on

rem Compile app.c to app.obj
C:\Keil\C51\BIN\C51.EXE "app.c" LARGE PRINT(.\app.lst) OBJECT(.\app.obj) SYMBOLS OPTIMIZE(10,SIZE)

rem Link startup.obj/app.obj and convert to hex
C:\Keil\C51\BIN\BL51.EXE "startup.obj", "app.obj" TO "app" PRINT (app.map) CODE(0-0xFBFF) XDATA(0X0000-0xFFF) RAMSIZE(256) REGFILE(app.reg)
C:\Keil\C51\BIN\OH51.EXE "app" 

rem Link using LX51 which should contain some optimisations...
rem LX51 is only available in the "professional edition"
rem C:\Keil\C51\BIN\LX51.EXE "startup.obj", "app.obj" TO "app" PRINT (app.map) CLASSES( XDATA(X:0x0000-X:0x0FFF), IDATA(I:0-I:0xFF)) REGFILE(app.reg)
rem C:\Keil\C51\BIN\OHX51.EXE "app" 

