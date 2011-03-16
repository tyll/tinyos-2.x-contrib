module SWUartTxP {
	uses {
		interface BusyWait<TMicro,uint16_t>;
		interface GeneralIO as TxPin;  
	}
	provides {
		interface UartStream;
	}
}
implementation {
	
	enum {
		BYTETIME = 49, // 19200
	};
	
	uint8_t* m_buf = NULL;
	uint16_t m_len, pos;
	bool busy = FALSE;
	
	void sendByte(uint8_t data) {
		uint8_t i;
		atomic {
			// startbit
			call TxPin.clr();
			call BusyWait.wait(BYTETIME);
			for (i=0;i<8;i++) {
				if (((data>>i) & 0x1) >0)
					call TxPin.set();
				else
					call TxPin.clr();
				call BusyWait.wait(BYTETIME);
			}
			// stopbit
			call TxPin.set();
			call BusyWait.wait(BYTETIME);
		}
	}
	
	task void nextchar() {
		atomic
		if (pos < m_len) {
			sendByte(m_buf[pos++]);
			post nextchar();
		}
		else {
			busy=FALSE;
			signal UartStream.sendDone( m_buf, pos, SUCCESS ); 
		}
	}
	
	// UartStream
	
	async command error_t UartStream.send( uint8_t* buf, uint16_t len ) {
		atomic 
		if (!busy) {
			m_buf = buf;
			m_len = len;
			pos = 0;
			busy=TRUE;
			post nextchar();
			return SUCCESS;
		}
		else
			return EBUSY;		 
	}

	async command error_t UartStream.enableReceiveInterrupt() { return FAIL; }

	async command error_t UartStream.disableReceiveInterrupt() { return FAIL; } 
	 
	async command error_t UartStream.receive( uint8_t* buf, uint16_t len ) { return FAIL; }
		
}
