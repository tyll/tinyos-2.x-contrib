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
 * @version $Revision$ $Date$
 */

module CC2420CsmaP @safe() {
  provides interface RadioPowerControl;
  provides interface AsyncSend as Send;

  uses interface Resource;
  uses interface CC2420Power;
  uses interface AsyncStdControl as SubControl;
  uses interface CC2420Transmit;
  uses interface Random;
  uses interface Leds;
  uses interface CC2420Packet;
  uses interface CC2420PacketBody;
  uses interface State as SplitControlState;
  
#ifdef CC2420_ACCOUNTING
  uses interface Counter<T32khz, uint32_t>;
  uses interface Alarm<TMilli, uint16_t>;
  provides interface CC2420Accounting;
#endif
}

implementation {
#ifdef CC2420_ACCOUNTING
  norace uint32_t vRegStartedAt, oscStartedAt, radioStartedAt, radioStoppedAt;
  uint32_t vRegTime, oscTime, radioTime;
#endif

  enum {
    S_STOPPED,
    S_STARTING,
    S_STARTED,
    S_STOPPING,
    S_TRANSMITTING,
  };

  message_t* ONE_NOK m_msg;  
  
  error_t sendErr = SUCCESS;
  
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
#ifdef CC2420_ACCOUNTING
      call Alarm.start(1024UL);
      vRegStartedAt = call Counter.get();
#endif
      call CC2420Power.startVReg();
      return SUCCESS;
    
    } else if(call SplitControlState.isState(S_STARTED)) {
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
#ifdef CC2420_ACCOUNTING
      call Alarm.stop();
#endif
      call SplitControlState.forceState(S_STOPPING);
      shutdown();
      return SUCCESS;
      
    } else if(call SplitControlState.isState(S_STOPPED)) {
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

    header->length = len + CC2420_SIZE;
#ifdef CC2420_HW_SECURITY
    header->fcf &= ((1 << IEEE154_FCF_ACK_REQ)|(1 << IEEE154_FCF_SECURITY_ENABLED));
#else
    header->fcf &= 1 << IEEE154_FCF_ACK_REQ;
#endif
    header->fcf |= ( ( IEEE154_TYPE_DATA << IEEE154_FCF_FRAME_TYPE ) |
		     ( 1 << IEEE154_FCF_INTRAPAN ) |
		     ( IEEE154_ADDR_SHORT << IEEE154_FCF_DEST_ADDR_MODE ) |
		     ( IEEE154_ADDR_SHORT << IEEE154_FCF_SRC_ADDR_MODE ) );
		     
    metadata->ack = FALSE;
    metadata->rssi = 0;
    metadata->lqi = 0;
    //metadata->timesync = FALSE;
    metadata->timestamp = CC2420_INVALID_TIMESTAMP;
    
    call CC2420Transmit.send( p_msg );
    return SUCCESS;

  }

  async command void* Send.getPayload(message_t* m, uint8_t len) {
    if (len <= call Send.maxPayloadLength()) {
      return (void* COUNT_NOK(len ))(m->data);
    }
    else {
      return NULL;
    }
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
#ifdef CC2420_ACCOUNTING
    oscStartedAt = call Counter.get();
#endif
    call CC2420Power.startOscillator();
  }

  async event void CC2420Power.startOscillatorDone() {
    post startDone_task();
  }
    
  
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

#ifdef CC2420_ACCOUNTING
  async event void Alarm.fired() {
    uint32_t now = call Counter.get();
    vRegTime += (now - vRegStartedAt);
    oscTime += (now - oscStartedAt);
    radioTime += (now - radioStartedAt);
    vRegStartedAt = oscStartedAt = radioStartedAt = now;
    call Alarm.start(1024UL);
  }
#endif

  task void startDone_task() {
    call SubControl.start();
#ifdef CC2420_ACCOUNTING
    radioStartedAt = call Counter.get();
#endif
    call CC2420Power.rxOn();
    call Resource.release();
    call SplitControlState.forceState(S_STARTED);
    signal RadioPowerControl.startDone( SUCCESS );
  }
  
  task void stopDone_task() {
#ifdef CC2420_ACCOUNTING
    atomic {
      uint32_t vRegDelta = radioStoppedAt - vRegStartedAt;
      uint32_t oscDelta = radioStoppedAt - oscStartedAt;
      uint32_t radioDelta = radioStoppedAt - radioStartedAt;
    
      vRegTime += vRegDelta;
      oscTime += oscDelta;
      radioTime += radioDelta;
    }
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
#ifdef CC2420_ACCOUNTING
 	radioStoppedAt = call Counter.get();
#endif
    post stopDone_task();
  }

  /***************** Defaults ***************/
  default event void RadioPowerControl.startDone(error_t error) {
  }
  
  default event void RadioPowerControl.stopDone(error_t error) {
  }
  
#ifdef CC2420_ACCOUNTING
  async event void Counter.overflow() { }
  
  command uint32_t CC2420Accounting.voltageRegulator() { atomic return vRegTime; }
  command uint32_t CC2420Accounting.oscillator() { atomic return oscTime; }
  command uint32_t CC2420Accounting.radio() { atomic return radioTime; }
#endif  
}

