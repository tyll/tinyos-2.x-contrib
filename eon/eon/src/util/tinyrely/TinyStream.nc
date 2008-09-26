
includes TinyStream;

configuration TinyStream {
	provides {
	  interface StdControl;
	  interface Connect;
	  interface StreamRead;
	  interface StreamWrite;
	}
}
implementation {
	components TinyStreamM, TinyRely;

	StdControl = TinyStreamM;
	StreamRead = TinyStreamM.StreamRead;
	StreamWrite = TinyStreamM.StreamWrite;
	Connect = TinyStreamM.Connect;

	TinyStreamM.SubControl -> TinyRely.StdControl;
	TinyStreamM.RelySend -> TinyRely.RelySend;
	TinyStreamM.RelyRecv -> TinyRely.RelyRecv;
	TinyStreamM.SubConnect -> TinyRely.Connect;

}
