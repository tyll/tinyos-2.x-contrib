
includes hardware;
includes StatusMsg;

configuration Stargate
{

  provides
  {
    interface StdControl;
    interface SGWakeup;

  }

}
implementation
{
  components StargateM, TimerC, UARTComm as Comm, UARTTinyStream,
    LedsC as Leds;

  StdControl = StargateM;
  SGWakeup = StargateM;

  StargateM.CommControl -> UARTTinyStream.StdControl;
  StargateM.Timer->TimerC.Timer[unique ("Timer")];
  StargateM.WakeTimer->TimerC.Timer[unique ("Timer")];
  StargateM.SleepSend->Comm.SendMsg[AM_SLEEP_MSG];
  StargateM.StatusRecv->Comm.ReceiveMsg[AM_STATUS_MSG];
  StargateM.PathDoneRecv->Comm.ReceiveMsg[AM_PATHDONE_MSG];
  StargateM.Connect->UARTTinyStream.Connect;
  StargateM.Leds->Leds;
}
