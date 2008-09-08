#ifndef _RESOURCE_CONTEXTS_H
#define _RESOURCE_CONTEXTS_H
/* These are globally known resource ids */
/* Resources represent energy sinks, peripherals that can independently spend energy.
 * These are NOT activities, or contexts, but get attributed activities over time */
enum {
    CPU_RESOURCE_ID = 0,

    LED0_RESOURCE_ID = 0x50,
    LED1_RESOURCE_ID = 0x51,
    LED2_RESOURCE_ID = 0x52,

    SHT11_RESOURCE_ID = 0x60,

    CC2420_RESOURCE_ID = 0x40,
    CC2420_SPI_RESOURCE_ID = 0x42,

    MSP430_USART0_ID = 0x30,
    MSP430_USART1_ID = 0x31,
};
#endif


