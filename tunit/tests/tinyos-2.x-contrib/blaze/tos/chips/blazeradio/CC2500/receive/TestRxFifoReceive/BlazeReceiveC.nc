

/**
 * Let the normal connections be made, except route the RXFIFO, RxInterrupt,
 * AckSend, and RXREG into our test so we can control those.
 */
 
configuration BlazeReceiveC {

  provides {
    interface Receive[ radio_id_t id ];
    interface ReceiveController[ radio_id_t id ];
    interface AckReceive;    
  }
  
  uses {
    interface GeneralIO as Csn[ radio_id_t id ];
    interface GpioInterrupt as RxInterrupt[ radio_id_t id ];
    interface BlazeConfig[ radio_id_t id ];
  }
}

implementation {
  
  components TestRxFifoP;
  components BlazeReceiveP;
  BlazeReceiveP.RXFIFO -> TestRxFifoP;
  BlazeReceiveP.RxInterrupt -> TestRxFifoP.RxInterrupt;
  BlazeReceiveP.AckSend -> TestRxFifoP;
  BlazeReceiveP.RXREG -> TestRxFifoP;
  
  RxInterrupt = TestRxFifoP.TheRealRxInterruptThatWeIgnore;
  
  
  Receive = BlazeReceiveP;
  ReceiveController = BlazeReceiveP;
  AckReceive = BlazeReceiveP;
  Csn = BlazeReceiveP.Csn;
  BlazeConfig = BlazeReceiveP;
  
  components MainC;
  MainC.SoftwareInit -> BlazeReceiveP;
  
  
  components InterruptStateC;
  BlazeReceiveP.InterruptState -> InterruptStateC;
  
  components BlazePacketC,
      BlazeSpiC as Spi,
      new BlazeSpiResourceC();
      
  BlazeReceiveP.Resource -> BlazeSpiResourceC;
  BlazeReceiveP.SRX -> Spi.SRX;
  BlazeReceiveP.SFRX -> Spi.SFRX;
  BlazeReceiveP.SFTX -> Spi.SFTX;
  BlazeReceiveP.SIDLE -> Spi.SIDLE;
  
  BlazeReceiveP.RadioStatus -> Spi.RadioStatus;

  BlazeReceiveP.BlazePacket -> BlazePacketC;
  BlazeReceiveP.BlazePacketBody -> BlazePacketC;
  
  components ActiveMessageAddressC;
  BlazeReceiveP.ActiveMessageAddress -> ActiveMessageAddressC;
  
  components new StateC();
  BlazeReceiveP.State -> StateC;
  
  components LedsC;
  BlazeReceiveP.Leds -> LedsC;
  
}
