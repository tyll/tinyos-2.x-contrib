#define MC13192_DEF_CHANNEL 7
#define TOSH_DATA_LENGTH 125

configuration Mc13192SendReceiveTestAppC {}
implementation
{
  components MainC, Mc13192SendReceiveTestC, ConsoleC, mc13192SendReceiveC;
  components new TimerMilliC() as Timer0;
  
  MainC.Boot <- Mc13192SendReceiveTestC;
  ConsoleC <- Mc13192SendReceiveTestC.In;
  ConsoleC <- Mc13192SendReceiveTestC.Out;
  ConsoleC.StdControl <- Mc13192SendReceiveTestC.ConsoleControl;
  Timer0 <- Mc13192SendReceiveTestC.Timer;
  mc13192SendReceiveC.SplitControl <- Mc13192SendReceiveTestC.RadioControl;
  mc13192SendReceiveC.Send <- Mc13192SendReceiveTestC.Send;
  mc13192SendReceiveC.Receive <- Mc13192SendReceiveTestC.Receive;
  mc13192SendReceiveC.Packet <- Mc13192SendReceiveTestC.Packet;
}