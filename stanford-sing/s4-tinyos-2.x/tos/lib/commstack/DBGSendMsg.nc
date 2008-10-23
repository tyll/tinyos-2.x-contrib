

module DBGSendMsg {
  provides interface BareSendMsg as Send;
  provides interface StdControl as Control;
}

implementation {
  
  char* _DBG_MODE = "BVR-mode";          /////////////////////// diff DBG_USR3

  bool busy = FALSE;
  message_t* msg_ptr;
 
  command error_t Control.init() {
    return SUCCESS;
  }

  command error_t Control.start() {
    return SUCCESS;
  } 

  command error_t Control.stop() {
    return SUCCESS;
  }

  command error_t Send.send(message_t* msg) {
    uint8_t i;
    uint8_t h = offsetof(message_t,data) + msg->length;
    dbg("BVR-debug","DBGSendMsg$send: %p\n",msg);
    //dbg_clear(_DBG_MODE,"UL: %d %d ",TOS_LOCAL_ADDRESS,tos_state.tos_time / 4000);
    dbg_clear(_DBG_MODE,"%d %d ",TOS_LOCAL_ADDRESS,tos_state.tos_time / 4000);
    for(i = 0; i < h; i++) 
    	dbg_clear(_DBG_MODE, "%02hhX ", ((uint8_t *)msg)[i]);
    dbg_clear(_DBG_MODE, "\n");
    return FAIL;
  }
}
