#include "Octopus.h"
#include "Accelerometer.h"
#include "Msp430Adc12.h"
#include <UserButton.h>


module OctopusC {
	uses {
		interface Boot;
		interface SplitControl as RadioControl;
		interface SplitControl as SerialControl;

		interface Send as CollectSend;				// used by a node which want to send data to the root
		interface Receive as Snoop;					// used when we have to forward data
		interface Receive as CollectReceive;		// used for reception of data collected by the root of the network
		interface RootControl;						// used to specify which one of the mote is the root
		interface StdControl as CollectControl;		// used to start the service protocol
#if defined(COLLECTION_PROTOCOL)
		interface CtpInfo as CollectInfo;			// specific to the ctp protocol, used to get some data (parent and quality here)
#elif defined(DUMMY_COLLECT_PROTOCOL)
		interface DummyInfo as CollectInfo;			// specific to dummy protocol, used to get some data
#else
#error "A protocol needs to be selected to collect data"
#endif
		interface AMSend as SerialSend;
		interface Receive as SerialReceive;
		interface BlazePacket;

		interface Timer<TMilli> as LightTimer;
		interface Timer<TMilli> as AccelerometerTimer;
		interface Timer<TMilli> as AdcTimer;
		interface Timer<TMilli> as iCountTimer;
		interface Timer<TMilli> as EnergyReportTimer;

		interface Read<uint16_t> as LightRead;
		interface Read<uint16_t> as TemperatureRead;
		interface Read<uint16_t> as HumidityRead;
		interface Read<uint16_t> as WakeupADCRead;
		interface Read<uint16_t> as NormalADCRead;
		interface Read<uint16_t> as BatteryRead;
		interface Read<acc_t> as AccelerometerRead;
		interface Accelerometer;
		interface EnergyMeter;
		interface WakeupADC;
		interface WakeupADC as WakeupLight;
		interface NormalADC;
		interface McuSleep;
		interface Notify<button_state_t>;

		interface Queue<octopus_collected_msg_t> as OutgoingQueue;
		interface Timer<TMilli> as SendTimer;
		interface Queue<octopus_collected_msg_t> as UpstreamQueue;
		interface Timer<TMilli> as UpTimer;

		interface Leds;
		interface Random;

		interface RadioStatus;
		interface SpiByte;
		//interface GpioInterrupt as RxInterrupt[radio_id_t radioId];

		interface BlazeStrobe as SPWD;
		interface BlazeStrobe as SIDLE;
		interface BlazeStrobe as SXOFF;
		interface BlazeRegister as MDMCFG4;
		interface BlazeRegister as MDMCFG3;
	}
}
implementation {
	octopus_collected_msg_t localCollectedMsg;
	octopus_collected_msg_t qMsg;
	message_t fwdMsg;
	message_t sndMsg, serialMsg;
	bool fwdBusy, sendBusy, uartBusy, samplingBusy;
	bool energyCalculating = FALSE;
	
	//uint8_t rssi = 0;
	uint8_t lqi = 0;
	uint8_t sampleCounter = 0;
	uint16_t energyTime = 0;
	bool accIsOn = FALSE;
	bool lightInt = FALSE;

	nx_am_addr_t t;
	bool root=FALSE;

	void tryNextSend();
	void tryNextUpSend();
	void energyMeterRead();	
	task void readSensors();
	void processRequest(octopus_sent_msg_t *newRequest);
	task void collectSendTask();
	task void serialSendTask();
	task void energyMeterReadDone();
	void fillPacket();

// Use LEDs to report various status issues.
	static void fatalProblem() {	call Leds.led0On(); call Leds.led1On();	call Leds.led2On();	}
	static void reportProblem() {	call Leds.led0On(); call Leds.led1On();	call Leds.led2On();}
	static void reportSent() {call Leds.led2Toggle();}
	static void reportReceived() {}
	static void wakeupBySensors(){	call Leds.led2On();	}
	static void wakeupByLight(){call Leds.led0On();	} 
	static void wakeupByAdc(){	call Leds.led2On();	} 
	static void wakeupByReceive(){	call Leds.led1Toggle();	}
	static void sleepBySensors(){call Leds.led2Off();	} 
	static void sleepByLight(){call Leds.led0Off();	} 
	static void sleepByReceive(){call Leds.led1Off();	}

	event void Boot.booted() {
		dbg("function","booted\n");
		localCollectedMsg.moteId = TOS_NODE_ID;
		localCollectedMsg.reply = NO_REPLY;

		sendBusy = FALSE;
		uartBusy = FALSE;
		atomic samplingBusy = FALSE;
		while(call OutgoingQueue.empty() == FALSE)
			call OutgoingQueue.dequeue();
		while(call UpstreamQueue.empty() == FALSE)
			call UpstreamQueue.dequeue();

		if (call RadioControl.start() != SUCCESS){
		//  fatalProblem();
			call Leds.led0On();
		}
		else
			dbg("function","radio success\n");

		if (TOS_NODE_ID  == 0) {	// if we are the root, we have to use the serial port
			dbg("function","root\n");
			root = TRUE;
			if (call SerialControl.start() != SUCCESS){
				fatalProblem();
			}
		}

		call Accelerometer.init();
		call WakeupLight.init();
		call WakeupLight.setThreshold(LIGHT_WAKEUP_THRESHOLD, INST_BYTE_ADC1);
		call WakeupADC.init();
		call WakeupADC.setThreshold(ADC_THRESHOLD, INST_BYTE_ADC0);
		call NormalADC.init();

		call Notify.enable();
		energyMeterRead();
		call EnergyReportTimer.startPeriodic(ENERGY_REPORT_TIME);
		call SendTimer.startPeriodic(DEFAULT_SAMPLING_PERIOD );
		call UpTimer.startPeriodic(DEFAULT_SAMPLING_PERIOD );

		call McuSleep.sleep();
	}

	event void RadioControl.startDone(error_t error) {
		if (error == SUCCESS) {
			if (call CollectControl.start() != SUCCESS)
				fatalProblem();
			if (root)
				call RootControl.setRoot();
		} else
			fatalProblem();
	}
	event void RadioControl.stopDone(error_t error) {	}
	event void SerialControl.startDone(error_t error) { 
		if (error != SUCCESS)
			fatalProblem();
	}
	event void SerialControl.stopDone(error_t error) { }
	event message_t *SerialReceive.receive(message_t* msg, void* payload, uint8_t len) { return msg; }

	event void SendTimer.fired(){
		dbg("function","sendtimer\n");
		tryNextSend();
	}

	void tryNextSend(){
		if(sendBusy==FALSE&&call OutgoingQueue.empty() == FALSE){
			post collectSendTask();
		}
	}

	task void collectSendTask() {
		if (!sendBusy && !root) {
			octopus_collected_msg_t *o =
				(octopus_collected_msg_t *)call CollectSend.getPayload(&sndMsg,sizeof(octopus_collected_msg_t));
			qMsg=(call OutgoingQueue.dequeue());
			o->moteId=TOS_NODE_ID;
			memcpy(o, &qMsg, sizeof(octopus_collected_msg_t));
			if (call CollectSend.send(&sndMsg, sizeof(octopus_collected_msg_t)) == SUCCESS){
				sendBusy = TRUE;
			}
			else{
			//	reportProblem();
			}
		}
	}

	event void CollectSend.sendDone(message_t* msg, error_t error) {
		if (error != SUCCESS){
		//	reportProblem();
		}
		sendBusy = FALSE;
		localCollectedMsg.reply = NO_REPLY;
		reportSent();
		tryNextSend();
	}

	event void UpTimer.fired(){
		dbg("function","uarttimer\n");
		tryNextUpSend();
	}

	void tryNextUpSend(){
		if(uartBusy==FALSE&&call UpstreamQueue.empty() == FALSE){
			post serialSendTask();
		}
	}

	task void serialSendTask() {
		if (!uartBusy && root) {
			octopus_collected_msg_t * o =
				(octopus_collected_msg_t *)call SerialSend.getPayload(&sndMsg,sizeof(octopus_collected_msg_t));
			qMsg=(call UpstreamQueue.dequeue());
			//qMsg=	localCollectedMsg;
			memcpy(o,  &qMsg, sizeof(octopus_collected_msg_t));
			if (call SerialSend.send(0xffff, &sndMsg, sizeof(octopus_collected_msg_t)) == SUCCESS)
				uartBusy = TRUE;
			else{
			//	reportProblem();
			}
		}
	}

	event void SerialSend.sendDone(message_t *msg, error_t error) {
			if (error != SUCCESS){
		//		reportProblem();
			}
			uartBusy = FALSE;
			localCollectedMsg.reply = NO_REPLY;
			//reportSent();
			tryNextUpSend();
		}

	event message_t *CollectReceive.receive(message_t* msg, void* payload, uint8_t len) {
		octopus_collected_msg_t *collectedMsg = payload;
		int8_t rssi;
		wakeupByReceive();
		if(!root){
			return msg;
		}
		if (len == sizeof(octopus_collected_msg_t) && !fwdBusy) {
			octopus_collected_msg_t *fwdCollectedMsg = call SerialSend.getPayload(&fwdMsg,sizeof(octopus_collected_msg_t));
			*fwdCollectedMsg = *collectedMsg;
			fwdCollectedMsg->lqi = call BlazePacket.getLqi(msg);
			rssi = call BlazePacket.getRssi(msg);
			if(rssi < 128)
				fwdCollectedMsg->rssi = -(rssi/2 - 74); 
			else
				fwdCollectedMsg->rssi = -((rssi-128)/2 - 74); 
				
			call UpstreamQueue.enqueue(*fwdCollectedMsg);
			tryNextUpSend();
			reportReceived();
		}
		return msg;
	}

	event message_t* Snoop.receive(message_t* msg, void* payload, uint8_t len) {
		wakeupByReceive();
		return msg;
	}

	//	The quality of the link with the parent and the parent Id	are filled here.
	void fillPacket() {
		uint16_t tmp;
#if defined(COLLECTION_PROTOCOL)
		call CollectInfo.getEtx(&tmp);
#elif defined(DUMMY_COLLECT_PROTOCOL)
		call CollectInfo.getQuality(&tmp);
#endif
		localCollectedMsg.quality = tmp;
		call CollectInfo.getParent(&tmp);
		localCollectedMsg.parentId = tmp;
	}

	event void AccelerometerTimer.fired() {
		call AccelerometerRead.read();
	}
	event void LightTimer.fired() {
		call LightRead.read();
	}
	event void AdcTimer.fired() {
		call WakeupADCRead.read();
	}

	task void readSensors()
	{
		call LightRead.read();
//		call NormalADCRead.read();
//		call HumidityRead.read();
		call WakeupADCRead.read();
		call AccelerometerRead.read();
//		call TemperatureRead.read();
//		post energyMeterReadDone();

	}

	async event void Accelerometer.int1(){
		if(accIsOn == TRUE){
			accIsOn = FALSE;
			call AccelerometerTimer.stop();
			call Accelerometer.clearInt();
			sleepBySensors();
			post energyMeterReadDone();
		}
	}
	async event void Accelerometer.int2(){
		if(accIsOn == FALSE){
			accIsOn = TRUE;
			post energyMeterReadDone();
			wakeupBySensors();
			call AccelerometerTimer.startPeriodic(DEFAULT_SAMPLING_PERIOD);
		}
	}
	async event void WakeupADC.adc_int(){
		wakeupByAdc();
		call AdcTimer.startPeriodic(DEFAULT_SAMPLING_PERIOD);
	}
	async event void WakeupLight.adc_int(){
		if(lightInt == FALSE){
			lightInt = TRUE;
			post energyMeterReadDone();
			wakeupByLight();
			call LightTimer.startPeriodic(DEFAULT_SAMPLING_PERIOD);
		}
	}

	void packetEnQueue(uint16_t val0, uint16_t val1, uint16_t val2, uint8_t type)
	{
		localCollectedMsg.count++;
		localCollectedMsg.reply = type; 
		fillPacket();
		localCollectedMsg.reading[0] = val0;
		localCollectedMsg.reading[1] = val1;
		localCollectedMsg.reading[2] = val2;
		if(!root)			
			call OutgoingQueue.enqueue(localCollectedMsg);
		else
			call UpstreamQueue.enqueue(localCollectedMsg);
	}

	event void TemperatureRead.readDone(error_t err, uint16_t val) {
		if (err == SUCCESS ) 
			packetEnQueue(val, 0, 0, READING_TEMPERATURE);
	}
	event void HumidityRead.readDone(error_t err, uint16_t val) {
		if (err == SUCCESS ) 
			packetEnQueue(val,0,0, READING_HUMIDITY);
	}
	event void AccelerometerRead.readDone(error_t err, acc_t val){
		if (err == SUCCESS )  
			packetEnQueue(val.x, val.y, val.z, READING_ACC);
	}
	event void WakeupADCRead.readDone(error_t err, uint16_t val) {
		if (err == SUCCESS ) 
		{
			packetEnQueue(val,REF_VOLTAGE_25,0, READING_ADC);
		}
	}
	event void NormalADCRead.readDone(error_t err, uint16_t val) {
		if (err == SUCCESS ) 
			packetEnQueue(val,REF_VOLTAGE_25,0, READING_ADC);
	}	
	event void BatteryRead.readDone(error_t err, uint16_t val) {
		if (err == SUCCESS ) 
			packetEnQueue(val,REF_VOLTAGE_50,0, READING_BATTERY);
	}	
	event void LightRead.readDone(error_t err, uint16_t val){ 
		if (err == SUCCESS ) 
		{
			if(val > LIGHT_SLEEP_THRESHOLD ){
				lightInt = FALSE;
				call LightTimer.stop();
				sleepByLight();
				post energyMeterReadDone();
				return;
			}
			else{
				packetEnQueue(val, sampleCounter, 0, READING_LIGHT);
			}
		}
	}

	event void Notify.notify(button_state_t state){
		if(state == BUTTON_PRESSED)
			call Leds.led1On();
		else if(state == BUTTON_RELEASED)
			call Leds.led1Off();
	}

	void energyMeterRead() {
			call EnergyMeter.reset();
			call EnergyMeter.start();
			call iCountTimer.startPeriodic(ENERGYMETER_INTERVAL);
	}
	task void energyMeterReadDone(){ 
		uint32_t energy;
		uint8_t radioStatus;
		uint8_t cfg4;
		uint8_t cfg3;

	//	energyCalculating = TRUE;
		call BatteryRead.read();
		energy = call EnergyMeter.read();
		call EnergyMeter.reset();
		call EnergyMeter.start();

	//	radioStatus = call RadioStatus.getRadioStatus();
//		radioStatus = (call SpiByte.write(BLAZE_SNOP) >> 4) & 0x07;
		//packetEnQueue(radioStatus, 1, 1, READING_HUMIDITY);
	//	energyCalculating = FALSE;
		//	energy = energy * (1000/ENERGYMETER_INTERVAL);
		packetEnQueue(energy, energy>>16, energyTime, READING_ENERGY);
		energyTime = 0;

		/*
		call MDMCFG4.read(&cfg4);
		call MDMCFG3.read(&cfg3);
		packetEnQueue(cfg4, cfg3, 0, READING_HUMIDITY);
		*/

		tryNextSend();
		tryNextUpSend();
	}
	event void iCountTimer.fired(){
		energyTime++;
	}
	event void EnergyReportTimer.fired(){
		post energyMeterReadDone();
	}

	/*
	async event void RxInterrupt.fired[radio_id_t radioId](){
	//	call Leds.led1Toggle();
	}
	*/
}
