

/**
 * Lowest level implementation on the receive branch.
 *
 * @author Jared Hill
 * @author David Moss
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
    interface GeneralIO as RxAvailable[ radio_id_t id ];
    interface BlazeConfig[ radio_id_t id ];
  }
}

implementation {

  components BlazeReceiveP;
  Receive = BlazeReceiveP;
  ReceiveController = BlazeReceiveP;
  AckReceive = BlazeReceiveP;
  Csn = BlazeReceiveP.Csn;
  BlazeConfig = BlazeReceiveP;
  RxInterrupt = BlazeReceiveP.RxInterrupt;
  RxAvailable = BlazeReceiveP.RxAvailable;
  
  components MainC;
  MainC.SoftwareInit -> BlazeReceiveP;
  
  
  components InterruptStateC;
  BlazeReceiveP.InterruptState -> InterruptStateC;
  
  components BlazePacketC,
      BlazeSpiC as Spi,
      new BlazeSpiResourceC();
      
  BlazeReceiveP.Resource -> BlazeSpiResourceC;
  BlazeReceiveP.SNOP -> Spi.SNOP;
  BlazeReceiveP.SRX -> Spi.SRX;
  BlazeReceiveP.SFRX -> Spi.SFRX;
  BlazeReceiveP.SFTX -> Spi.SFTX;
  BlazeReceiveP.STX -> Spi.STX;
  BlazeReceiveP.RXFIFO -> Spi.RXFIFO;
  BlazeReceiveP.SIDLE -> Spi.SIDLE;
  BlazeReceiveP.RxReg -> Spi.RXREG;
  BlazeReceiveP.PktStatus -> Spi.PKTSTATUS;
  
  BlazeReceiveP.RadioStatus -> Spi.RadioStatus;

  BlazeReceiveP.BlazePacket -> BlazePacketC;
  BlazeReceiveP.BlazePacketBody -> BlazePacketC;
  
  components BlazeTransmitC;
  BlazeReceiveP.AckSend -> BlazeTransmitC.AckSend;
  
  components ActiveMessageAddressC;
  BlazeReceiveP.ActiveMessageAddress -> ActiveMessageAddressC;
  
  components PacketCrcC;
  BlazeReceiveP.PacketCrc -> PacketCrcC;
  
  components new StateC();
  BlazeReceiveP.State -> StateC;
  
  components LedsC;
  BlazeReceiveP.Leds -> LedsC;
  
}
