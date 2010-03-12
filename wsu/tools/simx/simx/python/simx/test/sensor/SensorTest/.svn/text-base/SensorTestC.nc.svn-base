#include "Timer.h"

#ifdef TOSSIM
#include <stdio.h>
#endif

module SensorTestC
{
  uses {
    interface Boot;
    interface Timer<TMilli> as Timer1;
    interface Timer<TMilli> as Timer2;
    interface Read<uint16_t> as Read1;
    interface Read<uint32_t> as Read2;
  }
}
implementation
{

  int readCount1;
  int readCount2;

  event void Boot.booted() {
    readCount1 = 0;
    readCount2 = 0;
    call Timer1.startPeriodic(500 + 50 * TOS_NODE_ID);
    call Timer2.startPeriodic(300 + 80 * TOS_NODE_ID);
  }

  event void Timer1.fired() {
    if (call Read1.read() != SUCCESS) {
      dbg("SensorTest", "error with sensor=0\n");
    }
  }

  event void Read1.readDone(error_t result, uint16_t data) {
    dbg_clear("SensorTest", "id=%d sensor=%d data=%05d count=%d err=%02d\n",
              TOS_NODE_ID, 0, data, readCount1, result);
    readCount1++;
  }

  event void Timer2.fired() {
    if (call Read2.read() != SUCCESS) {
      dbg("SensorTest", "error with sensor=1\n");
    }
  }

  event void Read2.readDone(error_t result, uint32_t data) {
    dbg_clear("SensorTest", "id=%d sensor=%d data=%05d count=%d err=%02d\n",
              TOS_NODE_ID, 1, data, readCount2, result);
    readCount2++;
  }

}
