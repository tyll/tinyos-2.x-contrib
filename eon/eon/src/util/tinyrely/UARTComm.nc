//A modified version of Generic Comm.  See original file for original license

configuration UARTComm
{
  provides {
    interface StdControl as Control;

    // The interface are as parameterised by the active message id
    interface SendMsg[uint8_t id];
    interface ReceiveMsg[uint8_t id];

    // How many packets were received in the past second
    command uint16_t activity();
  }
  uses {
    // signaled after every send completion for components which wish to
    // retry failed sends
    event result_t sendDone();
  }
}
implementation
{
  // CRCPacket should be multiply instantiable. As it is, I have to use
  // RadioCRCPacket for the radio, and UARTNoCRCPacket for the UART to
  // avoid conflicting components of CRCPacket.
  components UARTAMStandard as AMS, 
    UARTFramedPacket as UARTPacket,
    LedsC as Leds, 
    TimerC, HPLPowerManagementM;

  Control = AMS.Control;
  SendMsg = AMS.SendMsg;
  ReceiveMsg = AMS.ReceiveMsg;
  sendDone = AMS.sendDone;

  activity = AMS.activity;
  AMS.TimerControl -> TimerC.StdControl;  
  AMS.ActivityTimer -> TimerC.Timer[unique("Timer")];
  
  AMS.UARTControl -> UARTPacket.Control;
  AMS.UARTSend -> UARTPacket.Send;
  AMS.UARTReceive -> UARTPacket.Receive;
  AMS.Leds -> Leds;
  
  AMS.PowerManagement -> HPLPowerManagementM.PowerManagement;
  
}
