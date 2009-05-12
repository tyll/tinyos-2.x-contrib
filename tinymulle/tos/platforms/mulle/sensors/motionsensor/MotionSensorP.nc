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
//IRA-E700 needs some time to start up
#define START_UP_TIME 5500
//Stabaliser counters
//How many reading to do before determing no motion state
#define STABLE_COUNTER_TH 30
//how many reading to do before going in motion state 
#define MOTION_COUNTER_TH 30

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
  
    /**
      * States that component can be enter
      * State transsitions
      * STATE_STOPED -> STATE_STARTING -> STATE_IDLE ->
      * ->  STATE_INTERRUPT -> STATE_MOTION -> STATE_NO_MOTION -> STATE_IDLE
      * ->  STATE_INTERRUPT -> STATE_IDLE
      * STATE_IDLE -> STATE_STOPING -> STATE_STOPED
      */
    enum{
      STATE_STARTING,
      STATE_IDLE,
      STATE_INTERRUPT,
      STATE_MOTION,
      STATE_NO_MOTION,
      STATE_STOPING,
      STATE_STOPED
    };

    
      uint8_t cState;
      uint16_t rawData = 0;
      uint8_t stable_counter = 0;
      uint8_t motion_counter = 0;

      /**
        * Threshold and sampling values are determined experimentaly
        * more cleva proccesing can be done
        */
      uint8_t msInterval = 10;
      uint16_t threshold_top = 560;
      uint16_t threshold_bottom = 510; 
    

    task void stateChanged();

    command error_t Init.init()
    {
      atomic cState = STATE_STOPED;
      return SUCCESS;
    }
    
    /**
      * Event occurs when the interrupt is captured
      */
    async event void GIRQ.fired()
    {
        atomic cState = STATE_INTERRUPT;
        call GIRQ.disable();
        post stateChanged();   
    }

    /**
      * Task for performing start up
      */
    task void startDone()
    {
      call PortIRQ.makeInput();
      call PortIRQ.clr();
      call GIRQ.enableRisingEdge();
      atomic cState = STATE_IDLE;
      signal MotionControl.startDone(SUCCESS);
     }
    
    /**
      * Command for initiating start of the IR sensor
      * Only possible if sensor is stoped
      */  
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
        call MilliTimer.startOneShot(START_UP_TIME);        
      return error;
    }

    /**
      * Task for stopping sensor
      * Error returned from stops can be ignored
      */
    task void stopDone()
    {
      call PortIRQ.makeOutput();
      call PortIRQ.clr();
      call GIRQ.disable();
      call MilliTimer.stop(); //just in case
      atomic cState = STATE_STOPED;
      signal MotionControl.stopDone(SUCCESS);

    }

    /**
      * Command for initiating stop of the sensor
      * Only possible if IR-sensor is in 
      * STATE_STARTED or STATE_IDLE state
      */
    command error_t MotionControl.stop()
    {
      error_t error = SUCCESS;
      atomic{
        if(cState == STATE_IDLE){
          cState=STATE_STOPING;
        } else {
            error = EBUSY;
        }
      }
      if(!error)
        post stopDone();
      return error;
    }

    /**
      * Samplings task
      */
    task void samplingTask()
    {
    
      call MotionReadNow.read();
    }

    /**
      * Event then timer fires
      */
    event void MilliTimer.fired() 
    {
      uint8_t s;
      atomic s = cState;
      if(s == STATE_STARTING) //wait for sensor to start, can be done nicer
        post startDone();
      else
        post samplingTask();
      
    }


    /**
      * Event when resource is granted
      */
    event void ReadNowResource.granted()
    {
       //call MilliTimer.startPeriodic(msInterval);
       call MilliTimer.startOneShot(msInterval); 
    }
    
    /**
      *Algorithm for proccessing data from the ad read
      *
      */
    task void proccessDataTask()
    {
      uint16_t tmp;
      uint8_t cst;
      atomic{
        tmp  = rawData;
        cst = cState;
      }
      //data incomming from AD converter is fluctuating
      //therefore we use some stabalising measurments
      if (cst == STATE_INTERRUPT) {
          if(tmp > threshold_top || tmp < threshold_bottom )
            atomic motion_counter++;

          if( motion_counter > MOTION_COUNTER_TH) 
          {
            atomic {
              motion_counter = 0;
              cState = STATE_MOTION;
            }
            post stateChanged();
          }
          call MilliTimer.startOneShot(msInterval); 
       } else  if(cst == STATE_MOTION){
          if(tmp < threshold_top || tmp > threshold_bottom)
            atomic stable_counter++;
          if(stable_counter > STABLE_COUNTER_TH)
          {
            atomic {
              cState = STATE_NO_MOTION;
              stable_counter = 0;
              motion_counter = 0;
            }
            post stateChanged();
          } else {
              call MilliTimer.startOneShot(msInterval); 
          }

       }  
            
          
        
      }
     
    /**
      * Reading is done from AD converter
      * lets post proccesing task
      */
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
      * State masine for motion sensor
      */
    task void stateChanged() { 
      uint8_t state;
      atomic state =cState;
      switch(state){
        case STATE_INTERRUPT: //Start reading
          call ReadNowResource.request();

        break;
        case STATE_MOTION: //signal motion
            signal MotionSensor.isMotion();
        break;
        case STATE_IDLE:
          call ReadNowResource.release();
          call GIRQ.enableRisingEdge();
          call MilliTimer.stop();
        break;
        case STATE_NO_MOTION:
          signal MotionSensor.noMotion();
          atomic cState = STATE_IDLE;
          post stateChanged();
        break;

        default:
        break;

      }


          
    }

    /**
      * Command for setting samplings frequencey
      */
    async command error_t MotionSensor.setSampleFrequency(uint8_t fr)
    {
        atomic msInterval = fr;
        return SUCCESS;
    }
  
    /**
      * Command for setting top value of the threshold
      */
    async command error_t MotionSensor.setThreshold(uint16_t thr)
    {
        atomic threshold_top = thr;
        return SUCCESS;
    }

}
