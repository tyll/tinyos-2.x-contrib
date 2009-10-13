
generic module ExBattP() {

    provides {
	interface Read<uint16_t>;
//	interface ReadStream<uint16_t>;
	interface Init;
    }
    uses {
	interface Read<uint16_t> as ADCRead;
//	interface ReadStream<uint16_t> as ADCReadStream;
	interface Timer<TMilli> as Timer;
    }
}

implementation {

#define ADC_EXBAT_DELAY 2

    uint8_t sAdc;
    enum {
	S_READ=0,
	S_STREAM=1,
	S_BUFFER=2,
    };
    uint16_t *tmpBuf;
    uint16_t tmpCnt;
    uint32_t period;

    command error_t Init.init() {
	/*
	  TOSH_SET_NVSUPE_PIN();
	  TOSH_MAKE_NVSUPE_OUTPUT();
	*/
	TOSH_CLR_VREF_EN_PIN();
	TOSH_MAKE_VREF_EN_OUTPUT();
	return SUCCESS;
    }

    command error_t Read.read() {
	//	TOSH_CLR_NVSUPE_PIN();
	sAdc = S_READ;
	TOSH_SET_VREF_EN_PIN();
	call Timer.startOneShot(ADC_EXBAT_DELAY);
	return SUCCESS;
    }

    event void ADCRead.readDone(error_t result, uint16_t data) {
	//	TOSH_SET_NVSUPE_PIN();
	TOSH_CLR_VREF_EN_PIN();
	signal Read.readDone(result,  data);
    }

/*
    command error_t ReadStream.read(uint32_t _period) {
	period = _period;
	sAdc = S_STREAM;
	TOSH_CLR_NVSUPE_PIN();
	call Timer.startOneShot(ADC_EXBAT_DELAY);
	return SUCCESS;
    }
    
    event void ADCReadStream.readDone(error_t result, uint32_t actualPeriod) {
	TOSH_SET_NVSUPE_PIN();
	signal ReadStream.readDone(result, actualPeriod);
    }


    command error_t ReadStream.postBuffer(uint16_t *buf, uint16_t count) {
	sAdc= S_BUFFER;
	tmpBuf = buf;
	tmpCnt = count;
	TOSH_CLR_NVSUPE_PIN();
	call Timer.startOneShot(ADC_EXBAT_DELAY);
	return SUCCESS;
    }

    event void ADCReadStream.bufferDone( error_t result, uint16_t* buf, uint16_t count ) {
	TOSH_CLR_NVSUPE_PIN();
	signal ReadStream.bufferDone(result, buf, count);
    }
*/
    event void Timer.fired() {
	switch (sAdc) {
	case S_READ:
	    call ADCRead.read();
	    break;
	case S_BUFFER:
//	    call ADCReadStream.postBuffer(tmpBuf, tmpCnt);
	    break;
	case S_STREAM:
//	    call ADCReadStream.read(period);
	default:
	    break;
	}
    }

}
