echo off
SET C51INC=C:\Keil\C51\INC\Chipcon\;C:\Keil\C51\INC\
SET C51LIB=C:\Keil\C51\LIB
echo on
C:\Keil\C51\BIN\A51.EXE "startup.a51" SET (SMALL) DEBUG EP
