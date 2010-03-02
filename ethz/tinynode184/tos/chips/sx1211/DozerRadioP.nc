module DozerRadioP {
	provides {
		interface RadioControl;
		interface RSSI;
		interface ACKPacket;
	}
	uses {
		interface SX1211PhyRssi;
		interface SX1211PhyConf;
		interface AckSendReceive;
		interface SendBuff;
		interface SplitControl;
	}
}
implementation {
	
	/**************** RSSI ******************/
	uint8_t rssi;
	
	task void rssiDone() {
		signal RSSI.rssiDone(rssi);
	}
	
	async command error_t RSSI.getRSSI() {
		error_t res;
		res = call SX1211PhyRssi.getRssi(&rssi);
		if (res == SUCCESS)
			post rssiDone();
		return res;
	}
	
	/**************** ACKPacket ******************/
	 command error_t ACKPacket.enableAck() {
		 call AckSendReceive.enableAck();
		 return SUCCESS;
	 }
	 command error_t ACKPacket.disableAck() {
		 call AckSendReceive.disableAck();
		 return SUCCESS;
	 }
	 command void ACKPacket.setAckByte(uint16_t ackByte) {
		call AckSendReceive.setAckPayload(ackByte);
	 }
	 command uint16_t ACKPacket.getAckByte() {
		  return call AckSendReceive.getAckPayload();
	 }
	
	 /**************** RadioControl ******************/
	 bool stopping;
	 uint8_t channel;
	 uint8_t currentchannel;
	 
	 
	 task void stopTask() {
		 if (stopping && call SplitControl.stop()==EBUSY)
			 post stopTask();
	 }
	 
	 command error_t RadioControl.radioSleep() {
		 stopping=TRUE;
		 if (call SplitControl.stop()==EBUSY)
			 post stopTask();
		 return SUCCESS;
	 }
	 
	 command error_t RadioControl.radioListen() {
		 stopping=FALSE;
		 return call SplitControl.start();
	 }
	 
	 event void SplitControl.stopDone(error_t result) {}
	 event void SplitControl.startDone(error_t result) {}
	 
	 
	 command error_t RadioControl.radioSendBuf(uint8_t* buf,uint8_t size) {
		 return call SendBuff.send(buf, size);
	 }
	 
	 event void SendBuff.sendDone(uint8_t* buff,error_t err) {
		 signal RadioControl.radioSendBufDone(err);
	 }
	 
     async command bool RadioControl.isReceiving() {
    	 return FALSE;
     }
     
     task void setChannel() {
    	 if (call SX1211PhyConf.setFreq(channel,0)!=SUCCESS)
    		 post setChannel();
    	 else
    		 currentchannel = channel;
     }
     
     command error_t RadioControl.radioDefaultChannel() {
    	 channel = SX1211_CHANNEL_DEFAULT;
    	 if (call SX1211PhyConf.setFreq(channel,0)!=SUCCESS)
    		 post setChannel();
    	 else
    	     currentchannel = channel;
    	 return SUCCESS;
     }
     
     command error_t RadioControl.radioObjTransferChannel() {
    	 channel = (SX1211_CHANNEL_DEFAULT + 5) % 20;
    	 if (call SX1211PhyConf.setFreq(channel,0)!=SUCCESS)
    	 	 post setChannel();
    	 else
    	 	 currentchannel = channel;
    	 return SUCCESS;
     }
     
     command uint8_t RadioControl.getChannel() {
    	 return currentchannel;
     }
}
