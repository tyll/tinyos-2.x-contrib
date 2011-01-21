/**
 * Active message implementation on top of the MRF24J40 radio.
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */
configuration Mrf24ActiveMessageC
{
  provides
  {
    interface Init;
    interface SplitControl;
    interface AMSend[am_id_t id];
    interface Receive[am_id_t id];
    interface Receive as Snoop[am_id_t id];
    interface Packet;
    interface AMPacket;
    interface PacketAcknowledgements as Acks;
    interface SendNotifier[am_id_t id];
  }

  uses
  {
    interface SpiByte;
    interface Mrf24SpiCtrl as SpiCtrl;
    interface Resource;
    interface GpioInterrupt as Interrupt;
  }
}
implementation
{
  components Mrf24ActiveMessageP, Mrf24RegisterC;
  components ActiveMessageAddressC, Mrf24PacketC;
  components MainC, RandomC;
  //components LedsC;
  //Mrf24ActiveMessageP.Leds -> LedsC;

  Init         = Mrf24ActiveMessageP;
  SplitControl = Mrf24ActiveMessageP;
  AMSend       = Mrf24ActiveMessageP;
  Receive      = Mrf24ActiveMessageP.Receive;
  Snoop        = Mrf24ActiveMessageP.Snoop;
  AMPacket     = Mrf24ActiveMessageP;
  Packet       = Mrf24ActiveMessageP;
  Acks         = Mrf24ActiveMessageP;
  SendNotifier = Mrf24ActiveMessageP;
  Resource     = Mrf24ActiveMessageP;
  Interrupt    = Mrf24ActiveMessageP;

  SpiByte = Mrf24RegisterC;
  SpiCtrl = Mrf24RegisterC;

  Mrf24ActiveMessageP.Reg -> Mrf24RegisterC;
  Mrf24ActiveMessageP.ActiveMessageAddress -> ActiveMessageAddressC;
  Mrf24ActiveMessageP.PacketBody -> Mrf24PacketC;
  Mrf24ActiveMessageP.Random -> RandomC;
  MainC.SoftwareInit -> Mrf24ActiveMessageP;
}

