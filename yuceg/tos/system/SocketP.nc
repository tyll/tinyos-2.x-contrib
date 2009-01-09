#include "RadioCountToLeds.h"

module SocketP {
	provides interface Socket;
	uses interface AMSend;
	uses interface SplitControl as AMControl;
	uses interface JobControl;
}

implementation {
	bool locked = FALSE;
	uint8_t job_id;
	message_t * packet;
	error_t res;
	
	command void Socket.init()
	{
		call AMControl.start();
	}
	
	event void AMControl.startDone(error_t err) {
		if (err != SUCCESS) {
			call AMControl.start();
		}
	}
	
	event void AMControl.stopDone(error_t err) {
	}
	
	inline command error_t Socket.sendB(uint8_t id,am_addr_t addr, message_t* msg, uint8_t len)
	{
		if (locked) {
			return EBUSY;
		}
		job_id = id;
		packet = msg;
		if (call AMSend.send(addr, msg, len) == SUCCESS) {
			locked = TRUE;
			call JobControl.suspend(job_id);
		}
		return res;
	}
	
	event void AMSend.sendDone(message_t* bufPtr, error_t error) {
		if (packet == bufPtr) {
			locked = FALSE;
			call JobControl.resume(job_id);
		}
		res = error;
	}
	
}
