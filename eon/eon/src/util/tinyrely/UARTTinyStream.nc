
includes TinyStream;

configuration UARTTinyStream {
	provides {
	  interface StdControl;
	  interface Connect;
	  interface StreamRead;
	  interface StreamWrite;
	}
}
implementation {
	components UARTTinyStreamM as TSM, UARTTinyRely as TR;

	StdControl = TSM;
	StreamRead = TSM.StreamRead;
	StreamWrite = TSM.StreamWrite;
	Connect = TSM.Connect;

	TSM.SubControl -> TR.StdControl;
	TSM.RelySend -> TR.RelySend;
	TSM.RelyRecv -> TR.RelyRecv;
	TSM.SubConnect -> TR.Connect;

}
