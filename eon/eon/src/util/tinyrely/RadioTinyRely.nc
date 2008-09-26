
includes TinyRely;

configuration RadioTinyRely {
  provides {
    interface StdControl;
    interface Connect;
    interface RelySend;
    interface RelyRecv;
  }
}
implementation {
	components RadioTinyRelyM as TRM, RadioComm as Comm, TimerC;

	StdControl = TimerC;
	StdControl = TRM;
	RelySend = TRM.RelySend;
	RelyRecv = TRM.RelyRecv;
	Connect = TRM.Connect;

	TRM.LowerControl -> Comm;
	TRM.ConnectSend -> Comm.SendMsg[AM_TINYRELYCONNECT];
	TRM.LowerSend -> Comm.SendMsg[AM_TINYRELYMSG];
	TRM.AckSend -> Comm.SendMsg[AM_TINYRELYACK];

	TRM.ConnectRecv -> Comm.ReceiveMsg[AM_TINYRELYCONNECT];
	TRM.LowerReceive -> Comm.ReceiveMsg[AM_TINYRELYMSG];
	TRM.AckReceive -> Comm.ReceiveMsg[AM_TINYRELYACK];

	TRM.MainTimer -> TimerC.Timer[unique("Timer")];

	//TransPacketM.RecvTimer -> TimerC.Timer[unique("Timer")];
	//TransPacketM.FragTimer -> TimerC.Timer[unique("Timer")];
	//TransPacketM.Throttle  -> TimerC.Timer[unique("Timer")];
}
