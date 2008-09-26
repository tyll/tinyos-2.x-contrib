module sunlogM {
	provides interface StdControl;
	uses {
		interface AllocationReq;
		interface WriteData;
		interface Timer;
		interface DS2770;
	}
}
implementation {
	uint32_t alloc_req_size = 1024*1024;
	uint32_t offset = 0;
	int16_t voltage;
	int32_t current;
	int16_t acr;
	int16_t temp;

	command result_t StdControl.init () {
		result_t ok = SUCCESS;
		ok &= call AllocationReq.request(0, alloc_req_size);
		ok &= call DS2770.init();
		return ok;
	}
	command result_t StdControl.start () {
		Timer.start(TIMER_REPEAT, 1000*60*5); //repeat every 5 minutes
		return SUCCESS;
	}
	command result_t StdControl.stop () {
		Timer.stop();
		return SUCCESS;
	}

	event result_t Timer.fired() {
		result_t r_ok1, r_ok2;
		r_ok1 = call DS2770.getData(&voltage, &current, &acr, &temp);
		
		if (r_ok1 == FAIL)
			return FAIL;
		return call WriteData.write(offset, (uint8_t*)(&voltage), 2);
	}

	event result_t WriteData.writeDone(uint8_t* data, uint32_t num_bytes, result_t success) {
		if (success == FAIL) {
			return call WriteData.write(offset, (uint8_t*)(&voltage), 2);
		} else {
			offset += num_bytes;
			return SUCCESS;
		}
		return FAIL;
	}	

	event result_t AllocationReq.requestProcessed (result_t success) {
		if (success == SUCCESS)
			return SUCCESS;
		alloc_req_size -= 16;
		return call AllocationReq.request(0, alloc_req_size);
	}

}


