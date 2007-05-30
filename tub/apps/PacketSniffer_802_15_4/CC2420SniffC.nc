configuration CC2420SniffC {

  provides interface SplitControl;  
  provides command error_t setChannel(uint8_t channel);
  
  uses async command void* rawReceive(void*);
}

implementation {

  components MainC, CC2420ControlC, CC2420SniffP;

  SplitControl = CC2420SniffP;
  rawReceive = CC2420SniffP.rawReceive;
  setChannel  = CC2420SniffP.setChannel;

  CC2420SniffP.Resource -> CC2420ControlC;
  CC2420SniffP.CC2420Power -> CC2420ControlC; 
  
  components CC2420ActiveMessageP as AM;
  AM.amAddress -> CC2420SniffP;
  
  
  // HPL components (be carefull: shared with CC2420ControlP)
  components HplCC2420InterruptsC as Interrupts;
  CC2420SniffP.InterruptCCA -> Interrupts.InterruptCCA;
  CC2420SniffP.CaptureSFD -> Interrupts.CaptureSFD;
  CC2420SniffP.InterruptFIFOP -> Interrupts.InterruptFIFOP;

  components HplCC2420PinsC as Pins;
  CC2420SniffP.CSN -> Pins.CSN;
  CC2420SniffP.FIFO -> Pins.FIFO;
  CC2420SniffP.FIFOP -> Pins.FIFOP;
  
  components new CC2420SpiC() as Spi;  
  CC2420SniffP.SRXON -> Spi.SRXON;
  CC2420SniffP.SRFOFF -> Spi.SRFOFF;
  CC2420SniffP.SXOSCON -> Spi.SXOSCON;
  CC2420SniffP.FSCTRL -> Spi.FSCTRL;
  CC2420SniffP.IOCFG0 -> Spi.IOCFG0;
  CC2420SniffP.IOCFG1 -> Spi.IOCFG1;
  CC2420SniffP.MDMCTRL0 -> Spi.MDMCTRL0;
  CC2420SniffP.RXCTRL1 -> Spi.RXCTRL1;
  CC2420SniffP.PANID -> Spi.PANID;
  CC2420SniffP.RXFIFO -> Spi.RXFIFO;
  CC2420SniffP.SFLUSHRX -> Spi.SFLUSHRX;
  
  MainC.SoftwareInit -> CC2420SniffP;
}
