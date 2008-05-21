module mc13192SendReceiveP 
{
  provides 
  {
    interface SplitControl;
    interface Send;
    interface Receive;
    interface Packet;
    interface PacketAcknowledgements;
  }
  uses
  {
    interface StdControl as HardwareControl;
    interface SplitControl as RadioSplitControl;
    interface StdControl as TimerControl;
    interface mc13192Control as RadioControl;
    interface mc13192State as State;
    interface mc13192DataInterrupt as Interrupt;
    interface mc13192Regs as Regs;
  }
}
implementation
{
  // Operation in progress.
  uint16_t operation = IDLE_MODE;
  
  // TX packet variables
  norace message_t *txMsg;
  norace uint8_t txLength;
  
  // RX packet variables
  message_t rxBuf;
  message_t *rxBufPtr = &rxBuf;
  
  bool sending = FALSE;
  
  // Forward function declarations
  error_t send();
  error_t receive();
  uint8_t getCCAFinal();
  void writeTXPacketLength();
  bool readRXPacketLength();
  void writeTXPacket();
  void readRXPacket();
  error_t disableReceive();

  /* Packet structure accessor functions. Note that everything is
   * relative to the data field. */
  mc13192_header_t *getHeader(message_t *amsg) 
  {
    return (mc13192_header_t *)(amsg->data - sizeof(mc13192_header_t));
  }

  mc13192_footer_t *getFooter(message_t *amsg) 
  {
    return (mc13192_footer_t *)(amsg->footer);
  }
  
  mc13192_metadata_t *getMetadata(message_t *amsg) 
  {
    return (mc13192_metadata_t *)((uint8_t *)amsg->footer + sizeof(mc13192_footer_t));
  }
  
  /***********************/
  /*   Start/stop code   */
  /***********************/
	
  command error_t SplitControl.start()
  {
    call HardwareControl.start();
    call RadioSplitControl.start();
  }
  
  command error_t SplitControl.stop()
  {
    call TimerControl.stop();
    call RadioSplitControl.stop();
  }
  
  event void RadioSplitControl.startDone(error_t res)
  {
    
    call TimerControl.start();
    call RadioControl.setChannel(MC13192_DEF_CHANNEL);
    signal SplitControl.startDone(SUCCESS);
    receive();
  }
  
  event void RadioSplitControl.stopDone(error_t res)
  {
  	call HardwareControl.stop();
    signal SplitControl.stopDone(SUCCESS);
  }
  
	/***********************/
	/*   Send interface    */
	/***********************/  

  command error_t Send.send(message_t *msg, uint8_t len)
  {
    bool wasSending;
    atomic {
      wasSending = sending;
      sending = TRUE;
    }
    if (!wasSending) {
      error_t retVal;
      txMsg = msg;
      (getHeader(msg))->length = len;
      // calculate payload size. We don't send the crc field.
      txLength = len + sizeof(message_header_t);
      // We can only send 125 byte in a packet
      if(len > (125 - sizeof(message_header_t)))
        {
          atomic sending = FALSE;
          return FAIL;
        }
      // Disable receiver.
      disableReceive();
      // We pad even length packets to avoid all-zero packets caused by
      // an MC13192 hardware bug.
      // We can only do this, because payload length is explicit in the frame structure.
      txLength = txLength + (txLength%2?0:1);
      retVal = send();
      if (retVal == FAIL) {
        // We need to re-enable the receiver.
        receive();
        atomic sending = FALSE;
      }
      return retVal;
    }
    return FAIL;
  }
  
  command error_t Send.cancel(message_t* msg)
  {
  	// We don't do that
  	return FAIL;
  }
  
  task void signalSendDone()
  {
    message_t *tmp;
    
    atomic
    {
      tmp = txMsg;
      sending = FALSE;
    }
    receive();
    signal Send.sendDone(tmp, SUCCESS);
  }

  command uint8_t Send.maxPayloadLength() 
  {
    return call Packet.maxPayloadLength();
  }

  command void* Send.getPayload(message_t *m) 
  {
    return call Packet.getPayload(m, NULL);
  }
  
  /*************************/
  /*   Receive interface   */
  /*************************/
  
  command void* Receive.getPayload(message_t *m, uint8_t *len) 
  {
    return call Packet.getPayload(m, len);
  }

  command uint8_t Receive.payloadLength(message_t *m) 
  {
    return call Packet.payloadLength(m);
  }
  
  task void signalReceive()
  {
  	mc13192_header_t *header = getHeader(rxBufPtr);
  	
  	rxBufPtr = signal Receive.receive(rxBufPtr, call Packet.getPayload(rxBufPtr, NULL),
  	                                  header->length);
  	receive();
  }
  
  /************************/
  /*   Packet interface   */
  /************************/
  
  command void Packet.clear(message_t *msg) 
  {
    memset(msg, 0, sizeof(message_t));
  }

  command uint8_t Packet.payloadLength(message_t *msg) 
  {
    mc13192_header_t *header = getHeader(msg);
    return header->length;
  }
 
  command void Packet.setPayloadLength(message_t *msg, uint8_t len) 
  {
    getHeader(msg)->length  = len;
  }
  
  command uint8_t Packet.maxPayloadLength() 
  {
    return TOSH_DATA_LENGTH;
  }

  command void* Packet.getPayload(message_t *msg, uint8_t *len) 
  {
    if (len != NULL) {
      mc13192_header_t *header = getHeader(msg);

      *len = header->length;
    }
    return (void*)msg->data;
  }
  
  /****************************************/
  /*   PacketAcknowledgements interface   */
  /****************************************/
  
  async command error_t PacketAcknowledgements.requestAck( message_t* msg )
  {
    return FAIL;
  }
  
  async command error_t PacketAcknowledgements.noAck( message_t* msg )
  {
    return SUCCESS;
  }
  
  async command bool PacketAcknowledgements.wasAcked(message_t* msg)
  {
    return FALSE;
  }
  
  	/******************************/
	/*     Interrupt handlers     */
	/******************************/
	
	// Interrupt indicating packet mode tx done.
	async event void Interrupt.txDone()
	{
		// We're done!
		post signalSendDone();
	}

	// Interrupt indicating that data has been received in
	// packet mode.
	async event void Interrupt.dataIndication(bool crc)
	{
		if (readRXPacketLength() && crc) {
			readRXPacket(); // Read data from MC13192.
			// We can recieve a packet that is one byte larger
			// than TOSH_DATA_LENGTH. We should ignore it.
			if( getHeader(rxBufPtr)->length > TOSH_DATA_LENGTH) 
			{
			  receive();
			  return;
			}
 			post signalReceive();
 		} else {
 			// Restart receive operation.
			receive();
 		}
	}

	async event void Interrupt.lockLost()
	{
		// Frequency lock was lost. Restart operation.
		if (operation == RX_MODE) {
			receive();
		} else if (operation == TX_MODE) {
			send();
		}
	}

	async event void Interrupt.ccaDone(bool isClear)
	{

	}
	
	event error_t RadioControl.resetIndication()
	{
		return SUCCESS;
	}

	/******************************/
	/*   RX/TX helper functions   */
	/******************************/

	inline error_t send()
	{
		writeTXPacketLength();
		writeTXPacket();
		operation = TX_MODE;
		return call State.setTXMode();
	}
	
	inline error_t receive()
	{
		operation = RX_MODE;
		return call State.setRXMode();
	}
	
	inline error_t disableReceive()
	{
		return call State.setIdleMode();
	}
	
	inline uint8_t getCCAFinal()
	{
		uint16_t power;
		power = call Regs.read(RX_STATUS);
		power = ((power & 0xFF00) >> 8);
		return (uint8_t)power;
	}
	
	inline void writeTXPacketLength()
	{
		uint16_t reg;
		reg = call Regs.read(TX_PKT_CTL);
		reg = (0xFF80 & reg) | (txLength+2); // Mask out old length setting and update. Include 2 CRC bytes.
		call Regs.write(TX_PKT_CTL, reg); // Update the TX packet length field	
	}

	inline bool readRXPacketLength()
	{
		uint8_t length, lqi, status[2];
		mc13192_metadata_t *metadata = getMetadata(rxBufPtr);
		
		*((uint16_t*)status) = call Regs.read(RX_STATUS);
		
		// Read out link quality and packet length.
		lqi = status[0];
		length = status[1] & 0x007F;
		
		//Drop invalid packages and packages larger than our buffer
		if (length < 3 || (length - 2) > (TOSH_DATA_LENGTH + sizeof(message_header_t) + 1)) {
			// This is not valid.
			return FALSE;
		}
		
		// MC13192 reports length with 2 CRC bytes. We don't need them.
		metadata->receivedBytes = length - 2;
		metadata->lqi = lqi;
		return TRUE;
	}
	
	
	/******************************/
	/*   Packet mode functions    */
	/******************************/
	
	inline void writeTXPacket()
	{
		uint8_t *buffer;
		uint8_t i = 0;
		
		buffer = (uint8_t*) getHeader(txMsg);
		call Regs.seqWriteStart(TX_PKT_RAM);
		while (i<txLength) {
			call Regs.seqWriteWord(buffer+i);
			i += 2;
		}
		call Regs.seqEnd();
	}
	
	inline void readRXPacket()
	{
		uint8_t *buffer;
		uint8_t i = 0;
		mc13192_metadata_t *metadata = getMetadata(rxBufPtr);
		
		buffer = (uint8_t*)getHeader(rxBufPtr);
		call Regs.seqReadStart(RX_PKT_RAM);
		call Regs.seqReadWord(buffer); // Receive register will contain garbage for first read.

		while (i < metadata->receivedBytes) {
			call Regs.seqReadWord(buffer+i);			
			i += 2;
		}
		call Regs.seqEnd();
	}
}