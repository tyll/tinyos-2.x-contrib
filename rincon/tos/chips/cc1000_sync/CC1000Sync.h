
#ifndef CC1000SYNC_H
#define CC1000SYNC_H

enum {
  SYNC_NUM_TIMERS = 5,
  SYNC_NUM_NEIGHBORS = 7,
  LIFE_INCREMENT = 32,
  LIFE_DECREMENT = 1,
  
  /*
   * PREEMPTIVE_DELAY is the number of microseconds before the next receive 
   * check to start sending the message.  Ideally, it should be about the
   * same amount of time to send a full message, plus some padding.
   * Too high, and you'll send the message too early which wastes energy.
   * Too low, and you could send the message too late, which really wastes
   * energy.  Err on the side of too high.  Keep in mind clock skew and
   * algorithm munching.
   */
  PREEMPTIVE_DELAY = 50,
};
  
/**
 * List of neighbors and whether or not they're valid.
 * There are two extra entries than the number of timers we have
 * available, to help distribute the timers to the most active addresses
 */
typedef struct SyncNeighbor {
  am_addr_t address;
  uint8_t life;
  bool isValid;
  bool isQueued;
} SyncNeighbor;
  
/**
 * Timer slot to keep track of which timer runs which synchronization send
 */
typedef struct TimerSlot {
  SyncNeighbor *neighbor;
} TimerSlot;
   
#endif

