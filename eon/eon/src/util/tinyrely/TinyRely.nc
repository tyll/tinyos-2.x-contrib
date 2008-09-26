
includes TinyRely;

configuration TinyRely {
	provides {
    interface StdControl;
    interface Connect;
    interface RelySend;
    interface RelyRecv;
  }
}
implementation {
	components TinyRelyM, GenericComm as Comm, TimerC;

	StdControl = TinyRelyM;
	RelySend = TinyRelyM.RelySend;
	RelyRecv = TinyRelyM.RelyRecv;
	Connect = TinyRelyM.Connect;

	TinyRelyM.LowerControl -> Comm;
	TinyRelyM.ConnectSend -> Comm.SendMsg[AM_TINYRELYCONNECT];
	TinyRelyM.LowerSend -> Comm.SendMsg[AM_TINYRELYMSG];
	TinyRelyM.AckSend -> Comm.SendMsg[AM_TINYRELYACK];

	TinyRelyM.ConnectRecv -> Comm.ReceiveMsg[AM_TINYRELYCONNECT];
	TinyRelyM.LowerReceive -> Comm.ReceiveMsg[AM_TINYRELYMSG];
	TinyRelyM.AckReceive -> Comm.ReceiveMsg[AM_TINYRELYACK];

	TinyRelyM.MainTimer -> TimerC.Timer[unique("Timer")];
	//TransPacketM.RecvTimer -> TimerC.Timer[unique("Timer")];
	//TransPacketM.FragTimer -> TimerC.Timer[unique("Timer")];
	//TransPacketM.Throttle  -> TimerC.Timer[unique("Timer")];
}
