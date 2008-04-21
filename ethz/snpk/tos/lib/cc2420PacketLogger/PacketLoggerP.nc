#include "packetlogger.h"
module PacketLoggerP {
	uses {
		interface PacketLogger;
		interface LogRead;
		interface LogWrite;
		interface DsnSend;
		interface LocalTime<T32khz>;
		interface CC2420PacketBody;
		interface DsnCommand<uint16_t> as PacketLoggerCommand;
		interface Pool<packet_logger_event_t>;
		interface Queue<packet_logger_event_t*>;
		interface SplitControl as RadioControl;
		interface PowerCycle;
	}
}
implementation {
	packet_logger_event_t readbuffer;
	uint16_t logId=0;
	bool writebusy=FALSE;
	bool logging_enabled=FALSE;
	bool wakeup_is_logged=FALSE;
	uint8_t wakeupcount=0;
	uint16_t read_start, read_end;
	
	task void writequeue();
	
	event void PacketLogger.received(message_t* msg) {
		if (logging_enabled) {
			packet_logger_event_t* le;
			le = call Pool.get();
			if (le!=NULL) {
				cc2420_metadata_t * meta = call CC2420PacketBody.getMetadata(msg);
				cc2420_header_t * header = call CC2420PacketBody.getHeader(msg);
				uint32_t now = call LocalTime.get();
				le->logId=logId++;
				le->type=PL_TYPE_RX;
				le->time=now - ((uint16_t)now - meta->time);
				le->count=0;
				le->ack=0;
				le->source=header->src;
				le->dsn=header->dsn;
				call Queue.enqueue(le);
			}
		}
	}
	
	event void PacketLogger.sendDone(message_t* msg, error_t error) {
		if (logging_enabled) {
			packet_logger_event_t* le;
			le = call Pool.get();
			if (le!=NULL) {
				cc2420_metadata_t * meta = call CC2420PacketBody.getMetadata(msg);
				cc2420_header_t * header = call CC2420PacketBody.getHeader(msg);
				uint32_t now = call LocalTime.get();
				le->logId=logId++;
				le->type=PL_TYPE_TX;
				le->time=now - ((uint16_t)now - meta->time);
				le->count=meta->lplTransmissions;
				le->source=header->src;
				le->dsn=header->dsn;
				le->ack=meta->ack;
				call Queue.enqueue(le);
			}
		}
	}
	
	event void LogRead.readDone(void* buf, storage_len_t len, error_t error) {
		if (len>0) {
			if ((read_start==0 && read_end==0) || (readbuffer.logId>=read_start && readbuffer.logId<=read_end))
				call DsnSend.logHexStream((void*)&readbuffer, len);
			call LogRead.read(&readbuffer, sizeof(packet_logger_event_t));
		}
	}
	
	event void LogRead.seekDone(error_t error){
		call LogRead.read(&readbuffer, sizeof(packet_logger_event_t));
	}
	
	event void LogWrite.appendDone(void* buf, storage_len_t len, bool recordsLost, error_t error) {
		if (error==ESIZE) {
			writebusy=FALSE;
			logging_enabled=FALSE;
			call DsnSend.log("flash full");
			return;
		}
		writebusy=FALSE;
		call Pool.put(call Queue.dequeue());
		post writequeue();
	}
	
	event void LogWrite.eraseDone(error_t error){
		logId=0;
		wakeupcount=0;
		logging_enabled=TRUE;
		wakeup_is_logged=FALSE;
		call DsnSend.log("done");
	}
	
	event void LogWrite.syncDone(error_t error){
		call LogRead.seek(SEEK_BEGINNING);		
	}
	
	event void PacketLoggerCommand.detected(uint16_t * values, uint8_t n) {
		switch (values[0]) {
		case 0:
			// erase
			if (call LogWrite.erase()==SUCCESS)
				call DsnSend.log("erasing flash..");
			break;
		case 1:
			// print log
			if (n==1) {
				read_start=0;
				read_end=0;
			}
			else if (n==2) {
				read_start=values[1];
				read_end=values[1];
			}
			else {
				read_start=values[1];
				read_end=values[2];
			}
			call LogWrite.sync();
			break;
		case 2:
			// continue logging
			logging_enabled=TRUE;
			call DsnSend.log("start logging");
			break;
		case 3:
			// stop logging
			logging_enabled=FALSE;
			call DsnSend.log("stop logging");
			break;		
		case 4:
			// print logcount
			call DsnSend.logInt(logId);
			call DsnSend.log("logcount %i");
			break;
		}
	}
	
	/***************** SubControl Events ****************/
	event void RadioControl.startDone(error_t error) {
		if (logging_enabled && !wakeup_is_logged)
			if (wakeupcount<3)
				wakeupcount++;
			else {
				packet_logger_event_t* le;
				le = call Pool.get();
				if (le!=NULL) {
					le->logId=logId++;
					le->type=PL_TYPE_WAKEUP;
					le->time=call PowerCycle.getLastWakeUp();
					call Queue.enqueue(le);
				}
				wakeup_is_logged=TRUE;
			}
	}
	  
	event void RadioControl.stopDone(error_t error) {
		if (!call Queue.empty()) {
			post writequeue();
		}
	}
	
	task void writequeue() {
		packet_logger_event_t* le;
		if (!writebusy && !call Queue.empty()) {
			le = call Queue.head();
			if (call LogWrite.append(le, sizeof(packet_logger_event_t))==SUCCESS)
				writebusy=TRUE;
		}
	}
	
	event void PowerCycle.detected() {}
	
}
