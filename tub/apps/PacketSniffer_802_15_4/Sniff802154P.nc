/** based upon BaseStationP */

#include "AM.h"
#include "Serial.h"
#include "sniff802154.h"
#include "IEEE802154.h"

module Sniff802154P {
  uses {
    interface Boot;
    
    // serial stuff
    interface SplitControl as SerialControl;
    interface AMSend as UartSend[am_id_t id];
    interface Receive as UartReceive[am_id_t id];
    interface Packet as UartPacket;
    interface Send as TransparentUartSend;
    //    interface Receive as TransparentReceive;
    
    // radio stuff
    interface StdControl as RadioReceiveControl;
    interface CC2420Receive as RadioReceive;
    interface Receive as RadioDataReceive;
    interface CC2420Config as RadioConfig;
    interface CC2420Power as RadioPower;
    interface CC2420PacketBody as RadioPacketBody;
    interface Resource as RadioControlResource;

    interface GpioCapture as CaptureSFD;
    interface Leds;
  }

}

implementation
{

  typedef enum {
    S_PRE_INIT,
    S_SET_CHANNEL,
    S_SNIFF_RECEIVE,
  } sniff_state_t;

  enum {
    UART_QUEUE_LEN = 50,
  };

  sniff_state_t m_sniff_state;
  
  message_t uartAckControl;
  message_t* uartAckControlPtr = &uartAckControl;
  
  norace message_t  uartQueueBufs[UART_QUEUE_LEN];
  norace message_t  *uartQueue[UART_QUEUE_LEN];
  norace uint8_t    uartIn, uartOut;
  norace bool       uartBusy, uartFull;
  
  task void start_done_task();
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

    atomic m_sniff_state = S_PRE_INIT;

    call RadioPower.startVReg();
  }

  
  async event void RadioPower.startVRegDone() {
    call RadioControlResource.request();
  }
  
  event void RadioControlResource.granted() {
    if (m_sniff_state == S_PRE_INIT)
      call RadioPower.startOscillator();
  }

  async event void RadioPower.startOscillatorDone() {
    post start_done_task();
  }

  task void start_done_task() {
    call RadioReceiveControl.start();
    call RadioPower.rxOn();
    call RadioControlResource.release();
    call SerialControl.start(); 
  }

  event void SerialControl.startDone(error_t error) {
    if (error == SUCCESS) {
      uartFull = FALSE;
      atomic m_sniff_state = S_SNIFF_RECEIVE;
    }
  }

  event void SerialControl.stopDone(error_t error) {}


  message_t* sniffReceive(message_t* msg) {

    message_t *ret = msg;
    atomic {
      if (!uartFull)
      {
	      
        ret = uartQueue[uartIn];
	uartQueue[uartIn] = msg;
        
	if (++uartIn >= UART_QUEUE_LEN)
	  uartIn = 0;
        
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


  async event void RadioReceive.receive( uint8_t type, message_t* msg ) {
    uint8_t state;
    atomic state=m_sniff_state;
    if (state == S_SNIFF_RECEIVE)
      sniffReceive(msg);
  }


  // sends the raw captured packet via serial
  task void uartRawSendTask() {
    uint8_t len;
    message_t* msg;
    cc2420_header_t* header;

    atomic if (uartIn == uartOut && !uartFull)
    {
      uartBusy = FALSE;
      return;
    }

    msg = uartQueue[uartOut];
    
    header = call RadioPacketBody.getHeader(msg);
    len = header->length+1-sizeof(cc2420_header_t);
    if (uartAckControlPtr != msg) { 
      if (call TransparentUartSend.send(msg, len) == SUCCESS)
	call Leds.led1Toggle();
      else
	{
	  call Leds.led0Toggle();
	  post uartRawSendTask();
	}
    }
  }
   
 event void TransparentUartSend.sendDone(message_t* msg, error_t error) {
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

  event message_t *UartReceive.receive[am_id_t id](message_t *msg, void *payload, uint8_t len) {
    message_t *ret = msg;

    // control packet
    if (id == AM_CONTROL_PKT_T) {
      if (uartAckControlPtr != ret) {
        atomic m_sniff_state=S_SET_CHANNEL;
        call RadioConfig.setChannel((((control_pkt_t*)payload)->channel));
        call RadioConfig.sync(); 
	call UartSend.send[AM_CONTROL_PKT_T](AM_BROADCAST_ADDR, msg, len);
        ret = uartAckControlPtr;
      }
    }
    return ret;
  }

  event void RadioConfig.syncDone( error_t error ) {
    atomic {
      if (m_sniff_state == S_SET_CHANNEL)
	m_sniff_state = S_SNIFF_RECEIVE;
    }
  }

  event message_t* RadioDataReceive.receive(message_t* msg, void* payload, uint8_t len) { return msg; }
  async event void CaptureSFD.captured( uint16_t time ) {}

}  

