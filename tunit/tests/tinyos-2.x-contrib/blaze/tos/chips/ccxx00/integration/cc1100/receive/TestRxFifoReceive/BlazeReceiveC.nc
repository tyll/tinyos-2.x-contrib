

/**
 * Let the normal connections be made, except route the RXFIFO, RxInterrupt,
 * AckSend, and RXREG into our test so we can control those.
 */
 
#warning "USING BLAZERECEIVEC DEFINED IN THE TEST SUITE"
configuration BlazeReceiveC {

  provides {
    interface Receive[ radio_id_t id ];
    interface AckReceive;
    interface SplitControl[ radio_id_t radioId ];
  }
  
  uses {
    interface GeneralIO as Csn[ radio_id_t id ];
    interface GpioInterrupt as RxInterrupt[ radio_id_t id ];
    interface GeneralIO as RxIo[ radio_id_t id ];
    interface BlazeConfig[ radio_id_t id ];
  }
}

implementation {
  
  components TestRxFifoP;
  components BlazeReceiveP;
  BlazeReceiveP.RXFIFO -> TestRxFifoP;
  BlazeReceiveP.RxInterrupt -> TestRxFifoP.RxInterrupt;
  BlazeReceiveP.RxIo -> TestRxFifoP.RxIo;
  BlazeReceiveP.AckSend -> TestRxFifoP;
  BlazeReceiveP.RXREG -> TestRxFifoP;
  
  SplitControl = BlazeReceiveP.SplitControl;
  
  RxInterrupt = TestRxFifoP.TheRealRxInterruptThatWeIgnore;
  RxIo = TestRxFifoP.TheRealRxIoThatWeIgnore;
  
  Receive = BlazeReceiveP;
  AckReceive = BlazeReceiveP;
  Csn = BlazeReceiveP.Csn;
  BlazeConfig = BlazeReceiveP;
  
  components MainC;
  MainC.SoftwareInit -> BlazeReceiveP;
  
  components BlazePacketC,
      BlazeSpiC as Spi,
      DummySpiResourceP,
      DummyRadioStatusP;
      
  BlazeReceiveP.Resource -> DummySpiResourceP;
  BlazeReceiveP.SRX -> Spi.SRX;
  BlazeReceiveP.SFRX -> Spi.SFRX;
  BlazeReceiveP.SFTX -> Spi.SFTX;
  BlazeReceiveP.SIDLE -> Spi.SIDLE;
  
  BlazeReceiveP.RadioStatus -> DummyRadioStatusP;

  BlazeReceiveP.BlazePacket -> BlazePacketC;
  BlazeReceiveP.BlazePacketBody -> BlazePacketC;
  
  components ActiveMessageAddressC;
  BlazeReceiveP.ActiveMessageAddress -> ActiveMessageAddressC;
  
  components new StateC();
  BlazeReceiveP.State -> StateC;
  
  components LedsC;
  BlazeReceiveP.Leds -> LedsC;
  
}
