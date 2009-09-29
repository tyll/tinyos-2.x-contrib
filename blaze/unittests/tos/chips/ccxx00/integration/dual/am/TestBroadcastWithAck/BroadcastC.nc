
/**
 * Test the ability to send and receive broadcast packets from the top
 * of the stack, without acknowledgements
 * @author David Moss
 */
 
#warning "This test requires Dynamic Acks. Adding that through the Makefile..."
 
configuration BroadcastC {
}

implementation {
  components new TestCaseC() as TestBroadcastC;
  
  components BroadcastP,
      new AMSenderC(0),
      new AMReceiverC(0),
      ActiveMessageC,
      BlazePacketC,
      LedsC;
      
  BroadcastP.SetUpOneTime -> TestBroadcastC.SetUpOneTime;
  BroadcastP.TearDownOneTime -> TestBroadcastC.TearDownOneTime;
  
  BroadcastP.TestBroadcast -> TestBroadcastC;
  BroadcastP.AMSend -> AMSenderC;
  BroadcastP.Receive -> AMReceiverC.Receive;
  BroadcastP.PacketAcknowledgements -> ActiveMessageC;
  BroadcastP.SplitControl -> ActiveMessageC;
  BroadcastP.AMPacket -> ActiveMessageC;
  BroadcastP.BlazePacketBody -> BlazePacketC;
  BroadcastP.Leds -> LedsC;
  
      
}

