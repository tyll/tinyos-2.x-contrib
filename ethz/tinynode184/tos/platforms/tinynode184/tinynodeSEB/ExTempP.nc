
generic module ExTempP() {

    provides {
	interface Read<uint16_t>;
	interface ReadStream<uint16_t>;
	interface Init;
    }
    uses {
	interface Read<uint16_t> as ADCRead;
	interface ReadStream<uint16_t> as ADCReadStream;
	interface Timer<TMilli> as Timer;
    }
}

implementation {

#define ADC_EXBAT_DELAY 1

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
	
	TOSH_CLR_EX_TEMPE_PIN();
	TOSH_MAKE_EX_TEMPE_OUTPUT();
	
	TOSH_MAKE_EX_TEMP_INPUT();
	TOSH_SEL_EX_TEMP_MODFUNC();
	
	return SUCCESS;
    }
    
    command error_t Read.read() {
	sAdc = S_READ;
	TOSH_SET_EX_TEMPE_PIN();
	call Timer.startOneShot(ADC_EXBAT_DELAY);
	return SUCCESS;
    }

    event void ADCRead.readDone(error_t result, uint16_t data) {
	TOSH_CLR_EX_TEMPE_PIN();
	signal Read.readDone(result,data);

    }

    command error_t ReadStream.read(uint32_t _period) { 
	period = _period;
	sAdc = S_STREAM;
	TOSH_SET_EX_TEMPE_PIN();
	call Timer.startOneShot(ADC_EXBAT_DELAY);
	return SUCCESS;
    }

    event void ADCReadStream.readDone(error_t result, uint32_t actualPeriod) {
	TOSH_CLR_EX_TEMPE_PIN();
	signal ReadStream.readDone(result, actualPeriod);
    }

    command error_t ReadStream.postBuffer(uint16_t *buf, uint16_t count) {
	sAdc= S_BUFFER;
	tmpBuf = buf;
	tmpCnt = count;
	TOSH_CLR_EX_TEMPE_PIN();
	call Timer.startOneShot(ADC_EXBAT_DELAY);
	return SUCCESS;
    }

    event void ADCReadStream.bufferDone( error_t result, uint16_t* buf, uint16_t count ) {
	TOSH_CLR_EX_TEMPE_PIN();
	signal ReadStream.bufferDone(result, buf, count);
    }

    event void Timer.fired() {
	switch (sAdc) {
	case S_READ:
	    call ADCRead.read();
	    break;
	case S_BUFFER:
	    call ADCReadStream.postBuffer(tmpBuf, tmpCnt);
	    break;
	case S_STREAM:
	    call ADCReadStream.read(period);
	default:
	    break;
	}
    }


}
