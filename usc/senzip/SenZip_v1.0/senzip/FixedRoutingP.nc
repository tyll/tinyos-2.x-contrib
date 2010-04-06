/*
 * SenZip module for providing centrally fixed routing
 *
 * @ author        Sundeep Pattem
 * @ affiliation   Autonomous Networks Research Group
 * @ institution   University of Southern California
*/

#include "FixedRouting.h"
module FixedRoutingP {
  provides {
    interface AggregationInformation as Routing;
  }
  uses {
    interface Receive; // in the absence of routing components
    interface Leds;
  }
}

implementation {

   command error_t Routing.initSettings(uint8_t metric) {
     return SUCCESS;
   }

  event message_t* Receive.receive(message_t* bufPtr, void* payload, uint8_t len) {
    if (len != sizeof(FixRtMsg)) {
      return bufPtr;
    } else {
      FixRtMsg* msg = (FixRtMsg*)payload;
      signal Routing.parentChange(msg->parent, msg->numHops);
      call Leds.led0On();
      return bufPtr;
    }
  }
}