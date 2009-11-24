
#include "LCD.h"

module MyWebServerP {

  uses interface Boot;
  uses interface MDNS;
  uses interface Timer<TMilli>;

}

implementation {


  char buffer[12];
  char* type = "_rest-sensor";
  char* name = (char*)&buffer;

  event void Boot.booted() {

    // set hostname to sensor-{TOS_NODE_ID}
    strcat(name, "sensor-");
    itoa(TOS_NODE_ID, &buffer[7], 10);

    // set initial backoff of 20 seconds (for router solicitation)
    call Timer.startOneShot(20000L);

    printf_lcd("MyWebserverC started on %s\n", name);
  }

  event void Timer.fired() {

    // register and publish service
    call MDNS.registerService(name, type, 80);
    call MDNS.publishPeriodic((uint32_t)1024*120);	// every 2 minutes

  }
 

}
