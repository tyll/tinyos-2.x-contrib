

configuration EonNetworkC
{
	provides
	{
		interface INetwork;
	}
}
implementation
{
 	components EonDTNM;
	components ActiveMessageC;
	components new AMSenderC(5);
	components new AMReceiverC(5);
	
	INetwork = EonDTNM.INetwork;
	EonDTNM.Packet -> AMSenderC;
	EonDTNM.AMPacket -> AMSenderC;
	EonDTNM.AMSend -> AMSenderC;
	EonDTNM.AMControl -> ActiveMessageC;
	EonDTNM.Receive -> AMReceiverC;
}
