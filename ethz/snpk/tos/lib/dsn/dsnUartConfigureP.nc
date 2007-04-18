/**
 * DSN Component for TinyOS.
 *
 * This component gives the facility to easily log messages to the Deployment Support Network
 * and receive commands.
 *
 * @author Roman Lim <rlim@ee.ethz.ch>
 * @modified 10/3/2006 Added documentation.
 *
 **/

#include "DSN.h"

module dsnUartConfigureP {
  provides interface Msp430UartConfigure;
}
implementation {
  
  msp430_uart_union_config_t dsn_config = {
  	{ubr: UBR_1MHZ_115200, //UBR_32KHZ_9600,			//UBR_1MHZ_9600
  	umctl: UMCTL_1MHZ_115200, //UMCTL_32KHZ_9600, 			//UMCTL_1MHZ_9600
  	ssel: 0x02, //0x01,		//Clock source (00=UCLKI; 01=ACLK; 10=SMCLK; 11=SMCLK)
	pena: 0,
	pev: 0,
	spb: 0,
	clen: 1,
	listen: 0,
	mm: 0,
	ckpl:0,
	urxse: 0,
	urxeie: 1,
	urxwie: 0,
	utxe:1,		// 1:enable tx module
  	urxe:1,		// 1:enable rx module
  	}};

  async command msp430_uart_union_config_t* Msp430UartConfigure.getConfig() {
    return &dsn_config;
  }
}
/*
possible properties:
	UBR_1MHZ_1200=0x0369,   UMCTL_1MHZ_1200=0x7B,
	UBR_1MHZ_1800=0x0246,   UMCTL_1MHZ_1800=0x55,
	UBR_1MHZ_2400=0x01B4,   UMCTL_1MHZ_2400=0xDF,
	UBR_1MHZ_4800=0x00DA,   UMCTL_1MHZ_4800=0xAA,
	UBR_1MHZ_9600=0x006D,   UMCTL_1MHZ_9600=0x44,
	UBR_1MHZ_19200=0x0036,  UMCTL_1MHZ_19200=0xB5,
	UBR_1MHZ_38400=0x001B,  UMCTL_1MHZ_38400=0x94,
	UBR_1MHZ_57600=0x0012,  UMCTL_1MHZ_57600=0x84,
	UBR_1MHZ_76800=0x000D,  UMCTL_1MHZ_76800=0x6D,
	UBR_1MHZ_115200=0x0009, UMCTL_1MHZ_115200=0x10,
	UBR_1MHZ_230400=0x0004, UMCTL_1MHZ_230400=0x55,      
*/
