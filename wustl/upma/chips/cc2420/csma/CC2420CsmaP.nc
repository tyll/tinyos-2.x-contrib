/*
 * "Copyright (c) 2007-2008 Washington University in St. Louis.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL WASHINGTON UNIVERSITY IN ST. LOUIS BE LIABLE TO ANY PARTY
 * FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING
 * OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF WASHINGTON
 * UNIVERSITY IN ST. LOUIS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * WASHINGTON UNIVERSITY IN ST. LOUIS SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND WASHINGTON UNIVERSITY IN ST. LOUIS HAS NO
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS."
 */
 
/*
 * Copyright (c) 2005-2006 Arch Rock Corporation
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
 * - Neither the name of the Arch Rock Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * @author Jonathan Hui <jhui@archrock.com>
 * @author Greg Hackmann
 * @author Kevin Klues
 * @author Octav Chipara
 * @version $Revision$ $Date$
 */

module CC2420CsmaP {

  provides interface RadioPowerControl;
  provides interface AsyncSend as Send;

  uses interface Resource;
  uses interface CC2420Power;
  uses interface AsyncStdControl as SubControl;
  uses interface CC2420Transmit;
  uses interface Random;
  uses interface AMPacket;
  uses interface Leds;
  uses interface CC2420Packet;
  uses interface CC2420PacketBody;
  uses interface State as SplitControlState;
  
#ifdef DUTY_CYCLE_BENCHMARK
  uses interface Counter<T32khz, uint32_t>;
#endif

}

implementation {

  enum {
    S_STOPPED,
    S_STARTING,
    S_STARTED,
    S_STOPPING,
    S_TRANSMITTING,
  };

  message_t* m_msg;
  
  error_t sendErr = SUCCESS;
  
#ifdef DUTY_CYCLE_BENCHMARK
   norace uint32_t vStartedAt, oscStartedAt, radioStartedAt, radioStoppedAt;
#endif
  
  /** TRUE if we are to use CCA when sending the current packet */
  norace bool ccaOn;
  
  /****************** Prototypes ****************/
  task void startDone_task();
  task void stopDone_task();
  void sendDone();
  
  void shutdown();

  /***************** SplitControl Commands ****************/
  task void signalStartDone() {
    signal RadioPowerControl.startDone( SUCCESS );
  }
  
  async command error_t RadioPowerControl.start() {
    if(call SplitControlState.requestState(S_STARTING) == SUCCESS) {
#ifdef DUTY_CYCLE_BENCHMARK
      radioStartCount++;
	  vStartedAt = call Counter.get();
#endif
      call CC2420Power.startVReg();
      return SUCCESS;
    
    } else if(call SplitControlState.isState(S_STARTED)) {
      post signalStartDone();
      return EALREADY;
    } else if(call SplitControlState.isState(S_STARTING)) {
      return SUCCESS;
    }
    
    return EBUSY;
  }
  
  task void signalStopDone() {
    signal RadioPowerControl.stopDone( SUCCESS );
  }

  async command error_t RadioPowerControl.stop() {
    if (call SplitControlState.isState(S_STARTED)) {
      call SplitControlState.forceState(S_STOPPING);
      shutdown();
      return SUCCESS;
      
    } else if(call SplitControlState.isState(S_STOPPED)) {
      post signalStopDone();
      return EALREADY;
    
    } else if(call SplitControlState.isState(S_TRANSMITTING)) {
      call SplitControlState.forceState(S_STOPPING);
      // At sendDone, the radio will shut down
      return SUCCESS;
    
    } else if(call SplitControlState.isState(S_STOPPING)) {
      return SUCCESS;
    }
    
    return EBUSY;
  }

  /***************** Send Commands ****************/
  async command error_t Send.cancel( message_t* p_msg ) {
    return call CC2420Transmit.cancel();
  }

  async command error_t Send.send( message_t* p_msg, uint8_t len ) {
    
    cc2420_header_t* header = call CC2420PacketBody.getHeader( p_msg );
    cc2420_metadata_t* metadata = call CC2420PacketBody.getMetadata( p_msg );

    atomic {
      if (!call SplitControlState.isState(S_STARTED)) {
        return FAIL;
      }
      
      call SplitControlState.forceState(S_TRANSMITTING);
      m_msg = p_msg;
    }

    header->length = len;
    header->fcf &= 1 << IEEE154_FCF_ACK_REQ;
    header->fcf |= ( ( IEEE154_TYPE_DATA << IEEE154_FCF_FRAME_TYPE ) |
		     ( 1 << IEEE154_FCF_INTRAPAN ) |
		     ( IEEE154_ADDR_SHORT << IEEE154_FCF_DEST_ADDR_MODE ) |
		     ( IEEE154_ADDR_SHORT << IEEE154_FCF_SRC_ADDR_MODE ) );
    header->src = call AMPacket.address();
    metadata->ack = FALSE;
    metadata->rssi = 0;
    metadata->lqi = 0;
    metadata->time = 0;
    
    call CC2420Transmit.send( p_msg );
    return SUCCESS;

  }

  async command void* Send.getPayload(message_t* m) {
    return m->data;
  }

  async command uint8_t Send.maxPayloadLength() {
    return TOSH_DATA_LENGTH;
  }

  /**************** Events ****************/
  async event void CC2420Transmit.sendDone( message_t* p_msg, error_t err ) {
    atomic sendErr = err;
    sendDone();
  }

  async event void CC2420Power.startVRegDone() {
    call Resource.request();
  }
  
  event void Resource.granted() {
#ifdef DUTY_CYCLE_BENCHMARK
    oscStartedAt = call Counter.get();
#endif
    call CC2420Power.startOscillator();
  }

  async event void CC2420Power.startOscillatorDone() {
    post startDone_task();
  }
    
#ifdef DUTY_CYCLE_BENCHMARK
  async event void Counter.overflow() { }
#endif
  
  /***************** Tasks ****************/
  void sendDone() {
    error_t packetErr;
    message_t * packet;
    atomic {
      packetErr = sendErr;
      packet = m_msg;
    }
    if(call SplitControlState.isState(S_STOPPING)) {
      shutdown();
      
    } else {
      call SplitControlState.forceState(S_STARTED);
    }
    
    signal Send.sendDone( packet, packetErr );
  }

  task void startDone_task() {
    call SubControl.start();
#ifdef DUTY_CYCLE_BENCHMARK
    radioStartedAt = call Counter.get();
#endif
    call CC2420Power.rxOn();
    call Resource.release();
    call SplitControlState.forceState(S_STARTED);
    signal RadioPowerControl.startDone( SUCCESS );
  }
  
  task void stopDone_task() {
#ifdef DUTY_CYCLE_BENCHMARK
    radioStopCount++;
    radioStoppedAt = call Counter.get();
    vDutyCycle += (oscStartedAt - vStartedAt);
    oscDutyCycle += (radioStartedAt - oscStartedAt);
    radioDutyCycle += (radioStoppedAt - radioStartedAt);
#endif
    call SplitControlState.forceState(S_STOPPED);
    signal RadioPowerControl.stopDone( SUCCESS );
  }
  
  
  /***************** Functions ****************/
  /**
   * Shut down all sub-components and turn off the radio
   */
  void shutdown() {
    call SubControl.stop();
    call CC2420Power.stopVReg();
    post stopDone_task();
  }

  /***************** Defaults ***************/
  default event void RadioPowerControl.startDone(error_t error) {
  }
  
  default event void RadioPowerControl.stopDone(error_t error) {
  }
  
}

