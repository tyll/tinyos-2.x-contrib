/*
 * Copyright (c) 2008 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * gps9546P is to control turning on/off the Leadtek GPS-9546 chip on
 * the MTS420CA sensorboard for the micaZ mote.  Calling start/stop will
 * turn on/off the power as well as connecting/disconnecting the UART pins
 * and start the UART.
 * 
 * Start/Stop Order:
 *   1. UART control
 *   2. GPS UART Pins
 * 
 * @author Danny Park
 */

module gps9546P {
  uses {
    interface Channel as GpsUartRxChannel;
    interface Channel as GpsUartTxChannel;
    interface StdControl as UartControl;
  }
  provides {
    interface SplitControl as GpsControl;
  }
}
implementation {
  command error_t GpsControl.start() {
    call UartControl.start();
    call GpsUartRxChannel.open();
    
    return SUCCESS;
  }
  
  /*
    Disconnect and stop the UART
  */
  command error_t GpsControl.stop() {
    call UartControl.stop();
    call GpsUartRxChannel.close();
    
    return SUCCESS;
  }
  
  event void GpsUartRxChannel.openDone(error_t error) {
    if(call GpsUartTxChannel.open() != SUCCESS) {
      //error
      
    }
  }
  
  event void GpsUartRxChannel.closeDone(error_t error) {
    if(call GpsUartTxChannel.close() != SUCCESS) {
      //error
      
    }
  }
  
  event void GpsUartTxChannel.openDone(error_t error) {
    signal GpsControl.startDone(SUCCESS);
  }
  
  event void GpsUartTxChannel.closeDone(error_t error) {
    signal GpsControl.stopDone(SUCCESS);
  }
}
