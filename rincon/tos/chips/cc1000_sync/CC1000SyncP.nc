/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
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
 * Automatic low power listening synchronized network
 * Improvements would include adding logic to use one Timer so we aren't limited
 * in the number of neighbors we can synchronize with.
 * @author David Moss
 * @author Jared Hill
 */

#include "CC1000Sync.h"

module CC1000SyncP {
  provides {
    interface Send;
    interface Init;
  }
  
  uses {
    interface Send as SubSend;
    interface LowPowerListening;
    interface State;
    interface AMPacket;
    interface PacketAcknowledgements;
    interface Timer<TMilli> as N0Timer;
    interface Timer<TMilli> as N1Timer;
    interface Timer<TMilli> as N2Timer;
    interface Timer<TMilli> as N3Timer;
    interface Timer<TMilli> as N4Timer;
    interface Leds;
  }
}

implementation {

  /** Neighbor table */
  SyncNeighbor syncNeighbor[SYNC_NUM_NEIGHBORS];
  
  /** Timer table */
  TimerSlot timerSlot[SYNC_NUM_TIMERS];
  
  /** Pointer to the message to send synchronously */
  message_t *syncMsg;
  
  /** Length of the message to send synchronously */
  uint8_t syncLen;
  
  /**
   * States
   */
  enum {
    S_IDLE,
    S_BUSY,
  };
  
  /***************** Prototypes ****************/
  void fired(uint8_t id);
  void update(message_t *msg);
  SyncNeighbor *contains(am_addr_t destination);
  void syncSend(message_t *msg, uint8_t len, SyncNeighbor *neighbor);
  SyncNeighbor *getWeakestInvalid();
  SyncNeighbor *getWeakestValid();
  uint8_t getTotalValid();
  TimerSlot *getAvailableTimer();
  TimerSlot *getTimerSlot(SyncNeighbor *neighbor);
  uint8_t getSlotId(TimerSlot *slot);
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    int i;
    for(i = 0; i < SYNC_NUM_NEIGHBORS; i++) {
      syncNeighbor[i].life = 0;
      syncNeighbor[i].isValid = FALSE;
      syncNeighbor[i].isQueued = FALSE;
    }
    
    for(i = 0; i < SYNC_NUM_TIMERS; i++) {
      timerSlot[i].neighbor = NULL;
    }
    
    return SUCCESS;
  }
  
  /***************** Send Commands ****************/
  command error_t Send.send(message_t* msg, uint8_t len) {
    SyncNeighbor *neighbor;
    if(call State.requestState(S_BUSY) == SUCCESS) {
      if((neighbor = contains(call AMPacket.destination(msg))) != NULL) {
        if(call LowPowerListening.getRxSleepInterval(msg) > 0) {
          syncSend(msg, len, neighbor);
          return SUCCESS;
          
        } else {
          return call SubSend.send(msg, len);
        }
        
      } else {
        return call SubSend.send(msg, len);
      }
    }
    
    return FAIL;
  }
  
  command error_t Send.cancel(message_t* msg) {
    if(!call State.isIdle()) {
      // State.toIdle should get called on sendDone
      return call SubSend.cancel(msg);
    }
    return SUCCESS;
  }
  

  command uint8_t Send.maxPayloadLength() {
    return call SubSend.maxPayloadLength();
  }

  command void* Send.getPayload(message_t* msg) {
    return call SubSend.getPayload(msg);
  }
  
  
  /***************** SubSend Events ****************/
  event void SubSend.sendDone(message_t *msg, error_t error) {
    update(msg);
    call Leds.led2Off();
    call State.toIdle();
    signal Send.sendDone(msg, error);
  }
  
  /***************** Timer Events ****************/
  event void N0Timer.fired() {
    fired(0);
  }
  
  event void N1Timer.fired() {
    fired(1);
  }
  
  event void N2Timer.fired() {
    fired(2);
  }
  
  event void N3Timer.fired() {
    fired(3);
  }
  
  event void N4Timer.fired() {
    fired(4);
  }
  
  
  /***************** Functions ****************/
  void fired(uint8_t id) {
    if(timerSlot[id].neighbor->isValid) {
      if(timerSlot[id].neighbor->isQueued) {
        timerSlot[id].neighbor->isQueued = FALSE;
        call Leds.led2On();
        call SubSend.send(syncMsg, syncLen);
      
      } else {
        if(timerSlot[id].neighbor->life > 0) {
          timerSlot[id].neighbor->life--;
          if(timerSlot[id].neighbor->life == 0) {
            timerSlot[id].neighbor->isValid = FALSE;
            timerSlot[id].neighbor = NULL;
          }
        }
      }
    }
  }
  
  void update(message_t *msg) {
    SyncNeighbor *neighbor;
    SyncNeighbor *replaceNeighbor = NULL;
    
    if(call AMPacket.destination(msg) == AM_BROADCAST_ADDR 
        || !call PacketAcknowledgements.wasAcked(msg)
        || call LowPowerListening.getRxSleepInterval(msg) == 0) {
      // No reason to update
      return;
    }
    
    if((neighbor = contains(call AMPacket.destination(msg))) == NULL) {
      // This neighbor isn't anywhere in our table
      if(getTotalValid() == SYNC_NUM_TIMERS) {
        // We're over our timer limit, override some extra neighbor entry
        neighbor = getWeakestInvalid();
        replaceNeighbor = getWeakestValid();
        
      } else {
        // We're under our timer limit, make this a valid neighbor.
        neighbor = getWeakestValid();
        getAvailableTimer()->neighbor = neighbor;
      }
      
      // Initialize this new entry
      neighbor->life = 0;
      neighbor->address = call AMPacket.destination(msg);
      neighbor->isQueued = FALSE;
      
    } else {
      // Neighbor found in the table, check to see if it might become valid
      if(!neighbor->isValid) {
        replaceNeighbor = getWeakestValid();
      }
    }
    
    if(replaceNeighbor != NULL) {
      // We could potentially replace a valid neighbor with our invalid one
      // but it's going to take a rate of at least one extra message per rx 
      // period
      if(replaceNeighbor->life < neighbor->life + 6) {  // 6 = (increment/2)+1
        // Do the replacement
        replaceNeighbor->isValid = FALSE;
        neighbor->isValid = TRUE;
        getTimerSlot(replaceNeighbor)->neighbor = neighbor;
      }
    }
    
    // Update the life
    if(neighbor->life + LIFE_INCREMENT > 0xFF) {
      neighbor->life = 0xFF;
    } else {
      neighbor->life += LIFE_INCREMENT;
    } 
    
    // Resync
    // Oh boy this is fugly, where are my parameterized Timer interfaces?
    if(neighbor->isValid) {
      switch(getSlotId(getTimerSlot(neighbor))) {
      case 0:
        call N0Timer.startPeriodicAt(
            call N0Timer.getNow() 
            + call LowPowerListening.getRxSleepInterval(msg) 
            - PREEMPTIVE_DELAY, 
                call LowPowerListening.getRxSleepInterval(msg));
      
      case 1:
        call N1Timer.startPeriodicAt(
            call N1Timer.getNow() 
            + call LowPowerListening.getRxSleepInterval(msg) 
            - PREEMPTIVE_DELAY, 
                call LowPowerListening.getRxSleepInterval(msg));
      
      case 2:
        call N2Timer.startPeriodicAt(
            call N2Timer.getNow() 
            + call LowPowerListening.getRxSleepInterval(msg) 
            - PREEMPTIVE_DELAY, 
                call LowPowerListening.getRxSleepInterval(msg));
      
      case 3:
        call N3Timer.startPeriodicAt(
            call N3Timer.getNow() 
            + call LowPowerListening.getRxSleepInterval(msg) 
            - PREEMPTIVE_DELAY, 
                call LowPowerListening.getRxSleepInterval(msg));
      
      case 4:
        call N4Timer.startPeriodicAt(
            call N4Timer.getNow() 
            + call LowPowerListening.getRxSleepInterval(msg) 
            - PREEMPTIVE_DELAY, 
                call LowPowerListening.getRxSleepInterval(msg));

      default:
      }
    }
  }
  
  /**
   * @return pointer to the neighbor entry if it exists, NULL if it doesn't
   */
  SyncNeighbor *contains(am_addr_t destination) {
    int i;
    for(i = 0; i < SYNC_NUM_NEIGHBORS; i++) {
      if(syncNeighbor[i].address == destination) {
        return &syncNeighbor[i];
      }
    }
    
    return NULL;
  }
  
  /**
   * Send this message synchronously the next time the neighbor wakes up
   */
  void syncSend(message_t *msg, uint8_t len, SyncNeighbor *neighbor) {
    syncMsg = msg;
    syncLen = len;
    neighbor->isQueued = TRUE;
  }
  
  /**
   * @return the total number of valid neighbors in our table
   */
  uint8_t getTotalValid() {
    int i;
    uint8_t valid = 0;
    for(i = 0; i < SYNC_NUM_NEIGHBORS; i++) {
      if(syncNeighbor[i].isValid) {
        valid++;
      }
    }
    return valid;
  }

  /**
   * @return pointer to the weakest valid neighbor
   */
  SyncNeighbor *getWeakestValid() {
    int i;
    SyncNeighbor *weakest = NULL;
    uint8_t lowestLife = 0xFF;
    for(i = 0; i < SYNC_NUM_NEIGHBORS; i++) {
      if(syncNeighbor[i].isValid
          && syncNeighbor[i].life <= lowestLife) {
        lowestLife = syncNeighbor[i].life;
        weakest = &syncNeighbor[i];
      }
    }
    
    return weakest;
  }
  
  /**
   * @return pointer to the weakest invalid neighbor
   */
  SyncNeighbor *getWeakestInvalid() {
    int i;
    SyncNeighbor *weakest = NULL;
    uint8_t lowestLife = 0xFF;
    for(i = 0; i < SYNC_NUM_NEIGHBORS; i++) {
      if(!syncNeighbor[i].isValid
          && syncNeighbor[i].life <= lowestLife) {
        lowestLife = syncNeighbor[i].life;
        weakest = &syncNeighbor[i];
      }
    }
    
    return weakest;
  }
  
  TimerSlot *getAvailableTimer() {
    int i;
    for(i = 0; i < SYNC_NUM_TIMERS; i++) {
      if(timerSlot[i].neighbor == NULL) {
        return &timerSlot[i];
      }
    }
    return NULL;
  }
  
  TimerSlot *getTimerSlot(SyncNeighbor *neighbor) {
    int i;
    for(i = 0; i < SYNC_NUM_TIMERS; i++) {
      if(timerSlot[i].neighbor == neighbor) {
        return &timerSlot[i];
      }
    }
    return NULL;
  }
  
  uint8_t getSlotId(TimerSlot *slot) {
    int i;
    for(i = 0; i < SYNC_NUM_TIMERS; i++) {
      if(&timerSlot[i] == slot) {
        return (uint8_t) i;
      }
    }
    return 0xFF;
  }
    
  /***************** Defaults ****************
  // Originally tried to do a single parameterized Timer<TMilli> interface,
  // but nesc barfed all over the place
  default command void Timer[uint8_t id].startPeriodic(uint32_t dt) {
  }

  default command void Timer[uint8_t id].startOneShot(uint32_t dt) {
  }

  default command void Timer[uint8_t id].stop() {
  }

  default command bool Timer[uint8_t id].isRunning() {
    return FALSE;
  }

  default command bool Timer[uint8_t id].isOneShot() {
    return FALSE;
  }

  default command void Timer[uint8_t id].startPeriodicAt(uint32_t t0, uint32_t dt) {
  }

  default command void Timer[uint8_t id].startOneShotAt(uint32_t t0, uint32_t dt) {
  }

  default command uint32_t Timer[uint8_t id].getNow() {
    return 0;
  }

  default command uint32_t Timer[uint8_t id].gett0() {
    return 0;
  }

  default command uint32_t Timer[uint8_t id].getdt() {
    return 0;
  }
  */
}

