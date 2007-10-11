echo off
SET C51INC=C:\Keil\C51\INC\Chipcon\;C:\Keil\C51\INC\
SET C51LIB=C:\Keil\C51\LIB
SET CPU_TYPE=CC2430-F128
SET CPU_VENDOR=Chipcon
SET UV2_TARGET=Target 1
SET CPU_XTAL=0x016E3600
echo on
rem C:\Keil\C51\BIN\C51.EXE "app.c" LARGE BROWSE DEBUG OBJECTEXTEND PRINT(.\app.lst) REGFILE(app.reg) OBJECT(.\app.obj)
rem C:\Keil\C51\BIN\C51.EXE "app.c" LARGE PRINT(.\app.lst) OPTIMIZE(0,SIZE) OBJECT(.\app.obj)

rem Compile app.c to app.obj
C:\Keil\C51\BIN\C51.EXE "app.c" LARGE PRINT(.\app.lst) OBJECT(.\app.obj) SYMBOLS

rem Link startup.obj/app.obj and convert to hex
rem C:\Keil\C51\BIN\BL51.EXE "startup.obj", "app.obj" TO "app" PRINT (app.map) XDATA( 0XE000-0XFF00 ) RAMSIZE(256) REGFILE(app.reg)
rem C:\Keil\C51\BIN\OH51.EXE "app" 

rem Link using LX51 which should contain some optimisations...
rem LX51 is only available in the "professional edition"
C:\Keil\C51\BIN\LX51.EXE "startup.obj", "app.obj" TO "app" PRINT (app.map) CLASSES( XDATA(X:0xE000-X:0xFF00), IDATA(I:0-I:0xFF)) REGFILE(app.reg)
C:\Keil\C51\BIN\OHX51.EXE "app" 

