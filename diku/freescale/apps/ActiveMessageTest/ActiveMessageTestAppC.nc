enum {
  TESTER_MSG1 = 6,
  TESTER_MSG2 = 7,
};

configuration ActiveMessageTestAppC {}
implementation
{
  components MainC, ConsoleC, ActiveMessageTestC;
  components new AMSenderC(TESTER_MSG1) as Sender1;
  components new AMReceiverC(TESTER_MSG1) as Receiver1;
  components new AMSnooperC(TESTER_MSG1) as Snooper1;
  components new AMSenderC(TESTER_MSG2) as Sender2;
  components new AMReceiverC(TESTER_MSG2) as Receiver2;
  components new AMSnooperC(TESTER_MSG2) as Snooper2;
  components ActiveMessageC;
  
  ActiveMessageTestC.Boot -> MainC.Boot;
  ConsoleC <- ActiveMessageTestC.In;
  ConsoleC <- ActiveMessageTestC.Out;
  ConsoleC.StdControl <- ActiveMessageTestC.ConsoleControl;
  
  ActiveMessageTestC.Receive1 -> Receiver1;
  ActiveMessageTestC.Snoop1 -> Snooper1;
  ActiveMessageTestC.Send1 -> Sender1;
  ActiveMessageTestC.Receive2 -> Receiver2;
  ActiveMessageTestC.Snoop2 -> Snooper2;
  ActiveMessageTestC.Send2 -> Sender2;
  ActiveMessageTestC.AMControl -> ActiveMessageC;
  ActiveMessageTestC.Packet -> ActiveMessageC;
  ActiveMessageTestC.AMPacket -> ActiveMessageC;
}