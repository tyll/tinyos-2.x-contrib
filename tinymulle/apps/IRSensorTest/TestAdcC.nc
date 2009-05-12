/**
* File: MotionSensorP.nc
* Version: 1.0
* Description:  Interface for motion sensor
* 
* Author: Laurynas Riliskis
* E-mail: Laurynas.Riliskis@ltu.se
* Date:   March 12, 2009
*
* Copyright notice
*
* Copyright (c) Communication Networks, Lulea University of Technology.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* 1. Redistributions of source code must retain the above copyright
*    notice, this list of conditions and the following disclaimer.
* 2. Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in the
*    documentation and/or other materials provided with the distribution.
* 3. All advertising materials mentioning features or use of this software
*    must display the following acknowledgement:
*   This product includes software developed by the Communication Networks
*   Group at Lulea University of Technology.
* 4. Neither the name of the University nor of the group may be used
*    to endorse or promote products derived from this software without
*    specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
* OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
* LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
* OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
* SUCH DAMAGE.
*/
 #include "Timer.h"
 #include "TestAdc.h"
//define rec to enable only reception of the data, ignoring reading
//the output is printed using _printf()

//#define rec 
module TestAdcC
{
  uses {
  	interface Read<uint16_t> as Read;
  
  	interface Boot;
  	interface Leds as MotionLeds;
  
  	interface Timer<TMilli> as MilliTimer;
  	interface SplitControl as SerialControl;
  	interface SplitControl as RadioControl;
    interface AMSend as RadioSend;
    interface Receive as RadioReceive;
    interface Packet;
    
    //interface GeneralIO as PortIRQ;
  }
  
}
implementation
{
  message_t packet;
  //test_serial_msg_t* rcm;
  uint8_t int4=0;
  
  event void Boot.booted()
  {
    //call PortIRQ.makeInput();
    //call PortIRQ.clr();
    call RadioControl.start();

    #ifdef rec
    call SerialControl.start();
    #endif
    
  }
  
  event void SerialControl.startDone(error_t err) 
  {
    if (err == SUCCESS) 
    {
      call MilliTimer.startPeriodic(100);
    }
  }
  event void SerialControl.stopDone(error_t err) {}

  event void RadioControl.startDone(error_t err) {
    if(err == SUCCESS){
      // start readind ADC only on sender side
      #ifndef rec
      call Read.read();
      #endif
  }
}

  event void RadioControl.stopDone(error_t err) {}
/*************************Timer.fired***************************************/  
  event void MilliTimer.fired() 
  {
    call Read.read();
    //int4 = P1.BIT.P1_6;
    //call MotionLeds.led0Toggle();
  }
/*************************** ADC received data*****************************/
  event void Read.readDone(error_t result, uint16_t data)
  {
    if (result == SUCCESS)
    {
          
        adc_msg_t* rcm = (adc_msg_t*)call Packet.getPayload(&packet, sizeof(adc_msg_t));
        rcm->data = data;
        if (call RadioSend.send(AM_BROADCAST_ADDR, &packet, sizeof(adc_msg_t)) == SUCCESS) 
        {
		    call MotionLeds.led2Toggle();
        }
        
    }
  }
  /*****************************************************************************/ 
  /* Radio receive, print message*/
    event message_t *RadioReceive.receive(message_t *msg,void *payload,uint8_t len) 
    {
      #ifdef rec
      adc_msg_t* rcm = (adc_msg_t*)payload;
      call MotionLeds.led2Toggle();

      _printf("%u\n", rcm->data);
      #endif
      
    	return msg;
    }
    // Make readings as fast as we can taking the transmission in to account
    event void RadioSend.sendDone(message_t* msg, error_t error) {
        if (error == SUCCESS){
          #ifndef rec
          call MotionLeds.led1Toggle();
          //call MilliTimer.startOneShot(1000);
          call Read.read();

          #endif
        }
    }
}
  
  
  
