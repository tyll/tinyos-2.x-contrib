//Laurynas
#include "Motion.h"

module MotionC @safe()
{
  uses {
    interface Boot;
    interface SplitControl as MotionControl;
    interface MotionSensor as Motion;
    interface Init;
    interface SplitControl as RadioControl;
    interface AMSend as RadioSend;
    interface Leds as MotionLeds;
    interface Packet;
  }
}
implementation
{

  message_t pkt;
  bool radio_busy;
  uint16_t data;

  event void Boot.booted()
  {
    atomic radio_busy = true;
    call Init.init(); 
    call MotionControl.start();
  }


  event void MotionControl.startDone(error_t error) {
      if( error == SUCCESS ) 
      {
        call RadioControl.start();
        call MotionLeds.led1On(); 
      } else {
        call MotionControl.start();
       }     
  }


  task void sendTask()
  {
    if(!radio_busy)
    {
      motion_msg_t* pl = (motion_msg_t*) call Packet.getPayload(&pkt, sizeof(motion_msg_t));
      atomic 
      {
        pl->data = data;
        radio_busy = true;
      }
      if (call RadioSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(motion_msg_t)) == SUCCESS) 
      {
		    call MotionLeds.led2Toggle();
      }
  
    }
  }

  event void RadioControl.startDone(error_t error)
  {
    if(error == SUCCESS) 
      atomic radio_busy = false;
    else 
      call RadioControl.start();

  }
  
  event void RadioControl.stopDone(error_t error) {}

  event void RadioSend.sendDone(message_t* msg, error_t error) 
  {
    if(error == SUCCESS)  atomic radio_busy = false; 
    
  }
  event void MotionControl.stopDone(error_t error) { call MotionLeds.led1Off(); }

  async event void Motion.isMotion()
  {
    if(!radio_busy)
    {
      atomic data=1;
      post sendTask();
    }
    call MotionLeds.led0Toggle();
  }
  
  async event void Motion.noMotion()
  {
    if(!radio_busy)
    {
      atomic data=0;
      post sendTask();
    }
    call MotionLeds.led0Toggle();
  }

  

  
}

