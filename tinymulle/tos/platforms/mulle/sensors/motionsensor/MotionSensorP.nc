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
*	This product includes software developed by the Communication Networks
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

module MotionSensorP {

    provides {
        interface MotionSensor;
        interface SplitControl as MotionControl;
        interface Init;
    }
    uses {
        interface Timer<TMilli> as MilliTimer;
        interface ReadNow<uint16_t> as MotionReadNow;
        interface Resource as ReadNowResource;

        interface GeneralIO as PortIRQ;
        interface GpioInterrupt as GIRQ;

    }
}
implementation {
  
    enum{
      STATE_STARTED,
      STATE_STARTING,
      STATE_IDLE,
      STATE_MOTION,
      STATE_SAMPLING,
      STATE_NO_MOTION,
      STATE_STOPING,
      STATE_STOPED
    };

    
      uint8_t cState;
      uint16_t rawData = 0;
      uint8_t msInterval = 10;
      uint16_t threshold = 50;
    

    task void stateChanged();

    command error_t Init.init()
    {
      atomic cState = STATE_STOPED;
      return SUCCESS;
    }

    async event void GIRQ.fired()
    {
        atomic cState = STATE_MOTION;
        post stateChanged();   
    }

    task void startDone()
    {
      call PortIRQ.makeInput();
      call PortIRQ.clr();
      call GIRQ.enableRisingEdge();
      signal MotionControl.startDone(SUCCESS);
      atomic cState = STATE_STARTED;
    }
      
    command error_t MotionControl.start(){
      error_t error = SUCCESS;
      atomic {
        if( cState == STATE_STOPED ) {
          cState = STATE_STARTING;         
        } else {
          error = EBUSY;
        } 
      }
      if(!error)
        post startDone();
      return error;
    }

    task void stopDone()
    {
      call PortIRQ.makeOutput();
      call PortIRQ.clr();
      call GIRQ.disable();
      atomic cState = STATE_STOPED;
      signal MotionControl.stopDone(SUCCESS);

    }

    command error_t MotionControl.stop()
    {
      error_t error = SUCCESS;
      atomic{
        if(cState == STATE_STARTED){
          cState=STATE_STOPING;
        } else {
            error = EBUSY;
        }
      }
      if(!error)
        post stopDone();
      return error;
    }

    task void samplingTask()
    {
      call MotionReadNow.read();
    }

    event void MilliTimer.fired() 
    {
      post samplingTask();
    }



    event void ReadNowResource.granted()
    {
       call MilliTimer.startPeriodic(msInterval);
    }
    
    /**
      *Algorithm for proccessing data from the ad read
      *
      */
    task void proccessDataTask()
    {
      uint16_t tmp;
      uint8_t nextState;
      uint8_t cst;
      atomic{
        tmp  = rawData;
        cst = cState;
      }
              //here can be some cleave calculations performed
      if(tmp < threshold){
          nextState = STATE_NO_MOTION;
          
       } else if (tmp >= threshold && cst == STATE_MOTION) {
          nextState = STATE_SAMPLING;
          
          
        } 
        if(nextState != cst){
            atomic cState= nextState;
            post stateChanged();
          }
        
          
        
      }
     

    async event void MotionReadNow.readDone(error_t result, uint16_t data)
    {
       if (result == SUCCESS)
       {
          atomic{
            rawData = data;
          }
          post proccessDataTask();
       } else {
          post samplingTask();
        }

    }
    

    /**
      * state masine for motion sensor
      */
    task void stateChanged() { 
      uint8_t state;
      atomic state =cState;
      switch(state){
        case STATE_MOTION:
          call GIRQ.disable();    // stop interupt
          call ReadNowResource.request();

        break;
        case STATE_SAMPLING:
              signal MotionSensor.isMotion();
          
        break;
        case STATE_NO_MOTION:
          call ReadNowResource.release();
          call GIRQ.enableRisingEdge();
          call MilliTimer.stop();
          signal MotionSensor.noMotion();
          atomic cState = STATE_STARTED;
        break;

        default:
        break;

      }


          
    }

    /*----------------- interface MotionSensor -----------------*/

    async command error_t MotionSensor.setSampleFrequency(uint8_t fr)
    {
        atomic msInterval = fr;
        return SUCCESS;
    }

    async command error_t MotionSensor.setThreshold(uint16_t thr)
    {
        atomic threshold = thr;
        return SUCCESS;
    }

}
