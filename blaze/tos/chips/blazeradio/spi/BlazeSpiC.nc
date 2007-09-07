

#include "Blaze.h"

/**
 * CCxx00 SPI bus wiring
 * @author Jared Hill
 * @author David Moss
 */
 
configuration BlazeSpiC {

  provides interface Resource;
  provides interface RadioInit;
  
  // commands
  provides interface BlazeStrobe as SIDLE;
  provides interface BlazeStrobe as SNOP;
  provides interface BlazeStrobe as STX;
  provides interface BlazeStrobe as SFTX;
  provides interface BlazeStrobe as SRX;
  provides interface BlazeStrobe as SFRX;
  provides interface BlazeStrobe as SRES;
  provides interface BlazeStrobe as SFSTXON;
  provides interface BlazeStrobe as SXOFF;
  provides interface BlazeStrobe as SCAL;
  provides interface BlazeStrobe as SWOR;
  provides interface BlazeStrobe as SPWD;
  provides interface BlazeStrobe as SWORRST;
  
  // registers 
  provides interface BlazeRegister as IOCFG2;
  provides interface BlazeRegister as IOCFG1;
  provides interface BlazeRegister as IOCFG0;
  provides interface BlazeRegister as FIFOTHR;
  provides interface BlazeRegister as SYNC1;
  provides interface BlazeRegister as SYNC0;
  provides interface BlazeRegister as PKTLEN;
  provides interface BlazeRegister as PKTCTRL1;
  provides interface BlazeRegister as PKTCTRL0;
  provides interface BlazeRegister as ADDR;
  provides interface BlazeRegister as CHANNR;
  provides interface BlazeRegister as FSCTRL1;
  provides interface BlazeRegister as FSCTRL0;
  provides interface BlazeRegister as FREQ2;
  provides interface BlazeRegister as FREQ1;
  provides interface BlazeRegister as FREQ0;
  provides interface BlazeRegister as MDMCFG4;
  provides interface BlazeRegister as MDMCFG3;
  provides interface BlazeRegister as MDMCFG2;
  provides interface BlazeRegister as MDMCFG1;
  provides interface BlazeRegister as MDMCFG0;
  provides interface BlazeRegister as DEVIATN;
  provides interface BlazeRegister as MCSM2;
  provides interface BlazeRegister as MCSM1;
  provides interface BlazeRegister as MCSM0;
  provides interface BlazeRegister as FOCCFG;
  provides interface BlazeRegister as BSCFG;
  provides interface BlazeRegister as AGCTRL2;
  provides interface BlazeRegister as AGCTRL1;
  provides interface BlazeRegister as AGCTRL0;
  provides interface BlazeRegister as WOREVT1;
  provides interface BlazeRegister as WOREVT0;
  provides interface BlazeRegister as WORCTRL;
  provides interface BlazeRegister as FREND1;
  provides interface BlazeRegister as FREND0;
  provides interface BlazeRegister as FSCAL3;
  provides interface BlazeRegister as FSCAL2;
  provides interface BlazeRegister as FSCAL1;
  provides interface BlazeRegister as FSCAL0;
  provides interface BlazeRegister as RCCTRL1;
  provides interface BlazeRegister as RCCTRL0;
  provides interface BlazeRegister as FSTEST;
  provides interface BlazeRegister as PTEST;
  provides interface BlazeRegister as AGCTEST;
  provides interface BlazeRegister as TEST2;
  provides interface BlazeRegister as TEST1;
  provides interface BlazeRegister as TEST0;
  provides interface BlazeRegister as PARTNUM;
  provides interface BlazeRegister as VERSION;
  provides interface BlazeRegister as FREQEST;
  provides interface BlazeRegister as LQI;
  provides interface BlazeRegister as RSSI;
  provides interface BlazeRegister as MARCSTATE;
  provides interface BlazeRegister as WORTIME1;
  provides interface BlazeRegister as WORTIME0;
  provides interface BlazeRegister as PKTSTATUS;
  provides interface BlazeRegister as VCO_VC_DAC;
  provides interface BlazeRegister as TXBYTES;
  provides interface BlazeRegister as RXBYTES;
  provides interface BlazeRegister as RXREG;
  provides interface BlazeRegister as TXREG;
  provides interface BlazeRegister as PA;
  
  // fifos
  provides interface BlazeFifo as RXFIFO;
  provides interface BlazeFifo as TXFIFO;
  provides interface BlazeFifo as PATABLE;
  
  //radio control
  provides interface CheckRadio;
  provides interface RadioStatus;

}

implementation {

  components BlazeSpiWireC as Spi;
  
  Resource = Spi.Resource;
  RadioInit = Spi;
  
  // commands
  SIDLE = Spi.Strobe[ BLAZE_SIDLE ];
  SNOP = Spi.Strobe[ BLAZE_SNOP ];
  SFRX = Spi.Strobe[ BLAZE_SFRX ];
  SFTX = Spi.Strobe[ BLAZE_SFTX ];
  SRX = Spi.Strobe[ BLAZE_SRX ];
  STX = Spi.Strobe[ BLAZE_STX ];
  SRES = Spi.Strobe[ BLAZE_SRES ];
  SFSTXON = Spi.Strobe[ BLAZE_SFSTXON ];
  SXOFF = Spi.Strobe[ BLAZE_SXOFF ];
  SCAL = Spi.Strobe[ BLAZE_SCAL ];
  SWOR = Spi.Strobe[ BLAZE_SWOR ];
  SPWD = Spi.Strobe[ BLAZE_SPWD ];
  SWORRST = Spi.Strobe[ BLAZE_SWORRST ];
  
  // registers
  IOCFG2 = Spi.Reg[ BLAZE_IOCFG2];
  IOCFG1 = Spi.Reg[ BLAZE_IOCFG1 ];
  IOCFG0 = Spi.Reg[ BLAZE_IOCFG0 ];
  FIFOTHR = Spi.Reg[ BLAZE_FIFOTHR ];
  SYNC1 = Spi.Reg[ BLAZE_SYNC1 ];
  SYNC0 = Spi.Reg[ BLAZE_SYNC0 ];
  PKTLEN = Spi.Reg[ BLAZE_PKTLEN ];
  PKTCTRL1 = Spi.Reg[ BLAZE_PKTCTRL1 ];
  PKTCTRL0 = Spi.Reg[ BLAZE_PKTCTRL0 ];
  ADDR = Spi.Reg[ BLAZE_ADDR ]; 
  CHANNR = Spi.Reg[ BLAZE_CHANNR ];
  FSCTRL1 = Spi.Reg[ BLAZE_FSCTRL1 ];
  FSCTRL0 = Spi.Reg[ BLAZE_FSCTRL0 ];
  FREQ2 = Spi.Reg[ BLAZE_FREQ2 ]; 
  FREQ1 = Spi.Reg[ BLAZE_FREQ1 ]; 
  FREQ0 = Spi.Reg[ BLAZE_FREQ0 ];
  MDMCFG4 = Spi.Reg[ BLAZE_MDMCFG4 ]; 
  MDMCFG3 = Spi.Reg[ BLAZE_MDMCFG3 ]; 
  MDMCFG2 = Spi.Reg[ BLAZE_MDMCFG2 ]; 
  MDMCFG1 = Spi.Reg[ BLAZE_MDMCFG1 ]; 
  MDMCFG0 = Spi.Reg[ BLAZE_MDMCFG0 ]; 
  DEVIATN = Spi.Reg[ BLAZE_DEVIATN ]; 
  MCSM2 = Spi.Reg[ BLAZE_MCSM2 ]; 
  MCSM1 = Spi.Reg[ BLAZE_MCSM1 ]; 
  MCSM0 = Spi.Reg[ BLAZE_MCSM0 ]; 
  FOCCFG = Spi.Reg[ BLAZE_FOCCFG ];
  BSCFG = Spi.Reg[ BLAZE_BSCFG ]; 
  AGCTRL2 = Spi.Reg[ BLAZE_AGCTRL2 ]; 
  AGCTRL1 = Spi.Reg[ BLAZE_AGCTRL1 ]; 
  AGCTRL0 = Spi.Reg[ BLAZE_AGCTRL0 ]; 
  WOREVT1 = Spi.Reg[ BLAZE_WOREVT1 ]; 
  WOREVT0 = Spi.Reg[ BLAZE_WOREVT0 ]; 
  WORCTRL = Spi.Reg[ BLAZE_WORCTRL ]; 
  FREND1 = Spi.Reg[ BLAZE_FREND1 ]; 
  FREND0 = Spi.Reg[ BLAZE_FREND0 ]; 
  FSCAL3 = Spi.Reg[ BLAZE_FSCAL3 ]; 
  FSCAL2 = Spi.Reg[ BLAZE_FSCAL2 ]; 
  FSCAL1 = Spi.Reg[ BLAZE_FSCAL1 ]; 
  FSCAL0 = Spi.Reg[ BLAZE_FSCAL0 ]; 
  RCCTRL1 = Spi.Reg[ BLAZE_RCCTRL1 ]; 
  RCCTRL0 = Spi.Reg[ BLAZE_RCCTRL0 ]; 
  FSTEST = Spi.Reg[ BLAZE_FSTEST ];
  PTEST = Spi.Reg[ BLAZE_PTEST ]; 
  AGCTEST = Spi.Reg[ BLAZE_AGCTEST ];
  TEST2 = Spi.Reg[ BLAZE_TEST2 ]; 
  TEST1 = Spi.Reg[ BLAZE_TEST1 ]; 
  TEST0 = Spi.Reg[ BLAZE_TEST0 ]; 
  PARTNUM = Spi.Reg[ BLAZE_PARTNUM ];
  VERSION = Spi.Reg[ BLAZE_VERSION ];
  FREQEST = Spi.Reg[ BLAZE_FREQEST ];
  LQI = Spi.Reg[ BLAZE_LQI ]; 
  RSSI = Spi.Reg[ BLAZE_RSSI ];
  MARCSTATE = Spi.Reg[ BLAZE_MARCSTATE ]; 
  WORTIME1 = Spi.Reg[ BLAZE_WORTIME1 ]; 
  WORTIME0 = Spi.Reg[ BLAZE_WORTIME0 ]; 
  PKTSTATUS = Spi.Reg[ BLAZE_PKSTATUS ]; 
  VCO_VC_DAC = Spi.Reg[ BLAZE_VCO_VC_DAC ];
  TXBYTES = Spi.Reg[ BLAZE_TXBYTES ]; 
  RXBYTES = Spi.Reg[ BLAZE_RXBYTES ]; 
  RXREG = Spi.Reg[ BLAZE_RXFIFO ];
  TXREG = Spi.Reg[ BLAZE_TXFIFO ];
  PA = Spi.Reg[ BLAZE_PATABLE ];
  
  // fifos
  RXFIFO = Spi.Fifo[ BLAZE_RXFIFO ];
  TXFIFO = Spi.Fifo[ BLAZE_TXFIFO ];
  PATABLE = Spi.Fifo[ BLAZE_PATABLE ];

  //radio control
  CheckRadio = Spi.CheckRadio;
  RadioStatus = Spi.RadioStatus;

}

