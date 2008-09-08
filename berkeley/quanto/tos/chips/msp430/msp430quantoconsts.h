#ifndef _MSP430QUANTOCONSTS_H
#define _MSP430QUANTOCONSTS_H
//Quanto: these are the primary proxy activities for each
//         interrupt that TinyOS uses from the MSP430.
enum {
    ACT_PXY_ADC     = 0x40,
    ACT_PXY_DACDMA  = 0x41,    
    ACT_PXY_NMI     = 0x42,
    ACT_PXY_PORT1   = 0x43,
    ACT_PXY_PORT2   = 0x44,
    ACT_PXY_TIMERA0 = 0x45,
    ACT_PXY_TIMERA1 = 0x46,
    ACT_PXY_TIMERB0 = 0x47,
    ACT_PXY_TIMERB1 = 0x48,
    ACT_PXY_UART0RX = 0x49,
    ACT_PXY_UART0TX = 0x4A,
    ACT_PXY_UART1RX = 0x4B,
    ACT_PXY_UART1TX = 0x4C,
};
#endif

