/*
 * Author:		Sarah Bergbreiter
 * Date last modified:  10/2/2003
 *
 */

// The message type for Slot-Ring Protocol Management (SlotManager)


/**
 * @author Sarah Bergbreiter
 */

enum {
  MAX_NODES_IN_RING = 8
};

typedef struct SlotMsg {
  int16_t src;
  uint8_t sync;
  int16_t table[MAX_NODES_IN_RING];
  int16_t tickLength; // in milliseconds
} SlotMsg;

typedef struct NewTickMsg {  
  int16_t tickLength; // in milliseconds
} NewTickMsg;

typedef struct StartMsg {
  int16_t tickLength;
  int16_t numPackets;
} StartMsg;

typedef struct TestMsg {
  int16_t src;
  uint16_t seqno;
} TestMsg;

enum {
  AM_SLOTMSG = 131,
  AM_TICKMSG = 132,
  AM_TESTMSG = 133,
  AM_STARTMSG = 134
};
