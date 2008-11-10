#include "Tnbrhood.h"
#include "OTime.h"
#ifndef TS_BEACON_STRUCTS
enum { AM_BEACON=40,
       AM_BEACON_PROBE=41,
       AM_PROBE_ACK=42,
       AM_PROBE_DEBUG=43,
       AM_NEIGHBOR=44,
       AM_NEIGHBOR_DEBUG=45,
       AM_SKEW=47,
       AM_UART=50
     };   // please change if needed

// DebugMsg is generated only in testing versions
typedef struct beaconDebugMsg {
  uint16_t sndId;     // id of sender
  uint8_t  type;      // a one-byte "type" of debugging
  uint8_t  stuff[25]; // anything can go here
  } beaconDebugMsg;  // 28 bytes of debugging data   
typedef beaconDebugMsg * beaconDebugMsgPtr;

// sent only by probeTsync to test accuracy
typedef struct beaconProbeMsg { 
  uint16_t count; 
  uint32_t RecClock;  // local clock at instant of receipt (just ClockL) 
  } beaconProbeMsg;
typedef beaconProbeMsg * beaconProbeMsgPtr;

// response to probe message
typedef struct beaconProbeAck {
  uint16_t count;
  uint16_t sndId;    // id of sender
  timeSync_t Local;  // local clock for Ack (48 bit, H and L)
  timeSync_t Virtual; // virtual time for Ack (48 bit, H and L)
  float skew;      // current skew adjustment factor 
  float calibRatio;  // current OTime.calibrate() value
  uint8_t mode;    // mode of mote (important only for spy)
  } beaconProbeAck;
typedef beaconProbeAck * beaconProbeAckPtr; 

// the Beacon Message
typedef struct beaconMsg {
  uint16_t sndId;     // Id of sender
  int16_t  prevDiff;  // difference of most recent received Beacon
  timeSync_t Local;   // local clock of sender (48 bit, H and L) 
  timeSync_t Virtual; // virtual time of sender (48 bit, H and L)
  timeSync_t Xor;     // XOR of Local and Virtual (for error check)
  uint8_t mode;       // sender's mode 
  uint8_t NbrSize;    // neighborhood size of sender
  // Delay is **VIRTUAL FIELD**
  // uint32_t Delay;     // processing and MAC delay of sending beacon 
} beaconMsg; // 28 byte payload 
typedef beaconMsg * beaconMsgPtr;

// the Neighborhood Message
typedef struct neighborMsg {
  uint16_t sndId;     // Id of sender
  uint16_t nodes[NUM_NEIGHBORS];  // neighbors heard from recently
} neighborMsg;
typedef neighborMsg * neighborMsgPtr; 

// Skew diffusion/gossip message
typedef struct skewMsg {
  uint16_t sndId;    // Id of sender
  uint16_t rootId;   // Id of "root" initiator of diffusion
  uint16_t minId;    // Id of node with minimum known skew 
  timeSync_t initStamp;   // Vclock of initiation
  float skewMin;     // minimum known skew
  uint8_t seqno;     // sequence number (for repeats)
  } skewMsg;
typedef skewMsg * skewMsgPtr;
#define TS_BEACON_STRUCTS
#endif
