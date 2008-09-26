
includes TinyStream;

configuration RadioTinyStream {
	provides {
	  interface StdControl;
	  interface Connect;
	  interface StreamRead;
	  interface StreamWrite;
	}
}
implementation {
	components RadioTinyStreamM as TSM, RadioTinyRely as TR;

	StdControl = TSM;
	StreamRead = TSM.StreamRead;
	StreamWrite = TSM.StreamWrite;
	Connect = TSM.Connect;

	TSM.SubControl -> TR.StdControl;
	TSM.RelySend -> TR.RelySend;
	TSM.RelyRecv -> TR.RelyRecv;
	TSM.SubConnect -> TR.Connect;

}
