/** based upon BaseStationP */

#include "AM.h"
#include "Serial.h"
#include "sniff802154.h"

module Sniff802154P {
  uses {
    interface Boot;
    
    // serial stuff
    interface SplitControl as SerialControl;
    interface AMSend as UartSend[am_id_t id];
    interface Receive as UartReceive[am_id_t id];
    interface Packet as UartPacket;
    interface AMPacket as UartAMPacket;
    
    // radio stuff
    interface SplitControl as RadioSniffControl;
    command error_t setChannel(uint8_t channel);

    interface Leds;
  }
  provides {
 		async command void* rawReceive(void*);
  }
}

implementation
{
  enum {
    UART_QUEUE_LEN = 50,
  };

  message_t uartAckControl;
  message_t* uartAckControlPtr = &uartAckControl;
  
  norace message_t  uartQueueBufs[UART_QUEUE_LEN];
  norace message_t  *uartQueue[UART_QUEUE_LEN];
  norace uint8_t    uartIn, uartOut;
  norace bool       uartBusy, uartFull;
  
  task void uartRawSendTask();
 

  void dropBlink() {
    call Leds.led2Toggle();
  }

  event void Boot.booted() {
    uint8_t i;

    for (i = 0; i < UART_QUEUE_LEN; i++)
      uartQueue[i] = &uartQueueBufs[i];
    uartIn = uartOut = 0;
    uartBusy = FALSE;
    uartFull = TRUE;

    call RadioSniffControl.start();
    call SerialControl.start();
  }

  event void RadioSniffControl.startDone(error_t error) {
    if (error == SUCCESS) {
    }
  }

  event void SerialControl.startDone(error_t error) {
    if (error == SUCCESS) {
      uartFull = FALSE;
    }
  }

  event void SerialControl.stopDone(error_t error) {}
  event void RadioSniffControl.stopDone(error_t error) {}

  async command void* rawReceive(void* buffer) {
    message_t *ret = buffer;
    atomic {
      if (!uartFull)
      {
        // not so fast...
        // memcpy((void*)&uartQueue[uartIn]->data, buffer, (*((uint8_t*)buffer)+1));
	      
        ret = uartQueue[uartIn];
	  		uartQueue[uartIn] = (message_t*)buffer;
                
        uartIn = (uartIn + 1) % UART_QUEUE_LEN;
        
        if (uartIn == uartOut)
          uartFull = TRUE;

        if (!uartBusy)
        {
          post uartRawSendTask();
          uartBusy = TRUE;
        }
      } else {
       dropBlink();
    	}
    }
  	return ret;
  }

  // sends the raw captured packet via serial
  task void uartRawSendTask() {
    uint8_t len;
    am_id_t id;
    am_addr_t addr;
    message_t* msg;
    
    atomic if (uartIn == uartOut && !uartFull)
    {
      uartBusy = FALSE;
      return;
    }

    msg = uartQueue[uartOut];
        
    len = *((uint8_t*)msg->data)+1;
    id = AM_RAW_PKT_T;
    addr = AM_BROADCAST_ADDR;

    if (call UartSend.send[id](addr, uartQueue[uartOut], len) == SUCCESS)
      call Leds.led1Toggle();
    else
    {
      post uartRawSendTask();
    }
  }
  
  
  event void UartSend.sendDone[am_id_t id](message_t* msg, error_t error) {
    if (error != SUCCESS)
      dropBlink();
    else {
      atomic if (msg == uartQueue[uartOut])
      {
        if (++uartOut >= UART_QUEUE_LEN)
          uartOut = 0;
        if (uartFull)
          uartFull = FALSE;
      }
      else {
        uartAckControlPtr = msg;
      }
    }
    post uartRawSendTask();
  }

  event message_t *UartReceive.receive[am_id_t id](message_t *msg,
      void *payload,
      uint8_t len) 
  {
    message_t *ret = msg;

    // control packet
    if (id == AM_CONTROL_PKT_T) {
      if ((call setChannel(((control_pkt_t*)payload)->channel) == SUCCESS) 
           && (uartAckControlPtr != ret))
      {
        // send ack in form of the same control packet
        ret = uartAckControlPtr;
        call UartSend.send[AM_CONTROL_PKT_T](AM_BROADCAST_ADDR, msg, len);
      }
    } 
    // packet injection not supported yet!
    else if (id == AM_RAW_PKT_T) {  
			;
    }
     
    return ret;
  }

}  

