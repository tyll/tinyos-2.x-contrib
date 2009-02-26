module ReporterC {
  uses {
    interface Boot;
    interface SplitControl as SerialControl;
    interface Receive as Detection;
    interface AMSend as Forward;
  }
}
implementation {
  message_t msg;
  bool inUse;
  
  event message_t* Detection.receive(message_t *m, void* payload, uint8_t len) {
    detection_msg_t *fmsg = call Forward.getPayload(&msg, sizeof *fmsg);

    if (fmsg && len == sizeof(detection_msg_t) && !inUse)
      {
	detection_msg_t *dmsg = payload;
	
	*fmsg = *dmsg;
	if (call Forward.send(AM_BROADCAST_ADDR, &msg, sizeof *fmsg) == SUCCESS)
	  inUse = TRUE;
      }
    
    return m;
  }

  event void Forward.sendDone(message_t* m, error_t error) { 
    if (m == &msg)
      inUse = FALSE;
  }

  event void Boot.booted() {
    call SerialControl.start();
  }

  event void SerialControl.startDone(error_t error) {
  }

  event void SerialControl.stopDone(error_t error) {
  }
}
