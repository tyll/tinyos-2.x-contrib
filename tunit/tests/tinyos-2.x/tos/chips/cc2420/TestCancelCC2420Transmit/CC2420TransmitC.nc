
/**
 * Just copied the CC2420TransmitC over, and wired the CCA pin to TestCancelP.
 */
 
#include "IEEE802154.h"

configuration CC2420TransmitC {

  provides {
    interface StdControl;
    interface CC2420Transmit;
    interface RadioBackoff;
    interface RadioTimeStamping;
    interface ReceiveIndicator as EnergyIndicator;
    interface ReceiveIndicator as ByteIndicator;
  }
}

implementation {

  components CC2420TransmitP;
  components TestCancelP;
  CC2420TransmitP.CCA -> TestCancelP.CcaProvider;
   
   
  StdControl = CC2420TransmitP;
  CC2420Transmit = CC2420TransmitP;
  RadioBackoff = CC2420TransmitP;
  RadioTimeStamping = CC2420TransmitP;
  EnergyIndicator = CC2420TransmitP.EnergyIndicator;
  ByteIndicator = CC2420TransmitP.ByteIndicator;

  components MainC;
  MainC.SoftwareInit -> CC2420TransmitP;
  MainC.SoftwareInit -> Alarm;
  
  components AlarmMultiplexC as Alarm;
  CC2420TransmitP.BackoffTimer -> Alarm;

  components HplCC2420PinsC as Pins;
  CC2420TransmitP.CSN -> Pins.CSN;
  CC2420TransmitP.SFD -> Pins.SFD;

  components HplCC2420InterruptsC as Interrupts;
  CC2420TransmitP.CaptureSFD -> Interrupts.CaptureSFD;

  components new CC2420SpiC() as Spi;
  CC2420TransmitP.SpiResource -> Spi;
  CC2420TransmitP.ChipSpiResource -> Spi;
  CC2420TransmitP.SNOP        -> Spi.SNOP;
  CC2420TransmitP.STXON       -> Spi.STXON;
  CC2420TransmitP.STXONCCA    -> Spi.STXONCCA;
  CC2420TransmitP.SFLUSHTX    -> Spi.SFLUSHTX;
  CC2420TransmitP.TXCTRL      -> Spi.TXCTRL;
  CC2420TransmitP.TXFIFO      -> Spi.TXFIFO;
  CC2420TransmitP.TXFIFO_RAM  -> Spi.TXFIFO_RAM;
  CC2420TransmitP.MDMCTRL1    -> Spi.MDMCTRL1;
  
  components CC2420ReceiveC;
  CC2420TransmitP.CC2420Receive -> CC2420ReceiveC;
  
  components CC2420PacketC;
  CC2420TransmitP.CC2420Packet -> CC2420PacketC;
  CC2420TransmitP.CC2420PacketBody -> CC2420PacketC;
  
  components LedsC;
  CC2420TransmitP.Leds -> LedsC;
}
