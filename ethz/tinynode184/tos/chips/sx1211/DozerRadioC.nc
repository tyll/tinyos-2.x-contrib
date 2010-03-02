configuration DozerRadioC {
	provides {
		interface Send;
		interface Receive;
		interface RadioControl;
		interface RSSI;
		interface ACKPacket;
		interface PacketAcknowledgements;
	}
}
implementation {
	
	components DozerRadioP, SX1211PhyC, SX1211PhyRssiConfC, SX1211SendReceiveC;
	
	DozerRadioP.SX1211PhyRssi -> SX1211PhyC;
	DozerRadioP.AckSendReceive -> SX1211SendReceiveC;
	DozerRadioP.SendBuff -> SX1211SendReceiveC;
	DozerRadioP.SplitControl -> SX1211SendReceiveC;
	DozerRadioP.SX1211PhyConf -> SX1211PhyRssiConfC;
	
	RSSI = DozerRadioP;
	ACKPacket = DozerRadioP;
	RadioControl = DozerRadioP;
	Send = SX1211SendReceiveC.Send;
	Receive = SX1211SendReceiveC.Receive;
	PacketAcknowledgements = SX1211SendReceiveC;
	
}
