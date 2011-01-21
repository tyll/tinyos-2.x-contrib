/**
 * The Active Message layer on the IWING-MRF platform.
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */
configuration ActiveMessageC
{
  provides
  {
    interface Init;
    interface SplitControl;
    interface AMSend[am_id_t id];
    interface Receive[am_id_t id];
    interface Receive as Snoop[am_id_t id];
    interface AMPacket;
    interface Packet;
    interface PacketAcknowledgements;
    interface SendNotifier[am_id_t id];
  }
}
implementation
{
  enum {
    CLIENT_ID = unique("ActiveMessageC.Resource"),
  };

  components Atm328SpiC, 
             Mrf24SpiCtrlC,
             Mrf24ActiveMessageC,
             new Atm328GpioInterruptC() as Interrupt,
             HplAtm328InterruptC;

  Init         = Mrf24ActiveMessageC;
  SplitControl = Mrf24ActiveMessageC;
  AMSend       = Mrf24ActiveMessageC;
  Receive      = Mrf24ActiveMessageC.Receive;
  Snoop        = Mrf24ActiveMessageC.Snoop;
  AMPacket     = Mrf24ActiveMessageC;
  Packet       = Mrf24ActiveMessageC;
  SendNotifier = Mrf24ActiveMessageC;
  PacketAcknowledgements = Mrf24ActiveMessageC;

  Mrf24SpiCtrlC.Spi -> Atm328SpiC.Atm328Spi;
  Mrf24ActiveMessageC.SpiCtrl -> Mrf24SpiCtrlC;
  Mrf24ActiveMessageC.SpiByte -> Atm328SpiC.SpiByte;
  Mrf24ActiveMessageC.Interrupt -> Interrupt;
  Mrf24ActiveMessageC.Resource -> Atm328SpiC.Resource[CLIENT_ID];
  Interrupt.Atm328Interrupt -> HplAtm328InterruptC.PcInt0;
}
