/**
 * Implementation for Blink application.  Toggle the red LED when a
 * Timer fires.
 **/

#include "Timer.h"

module BlinkC
{
	uses{
		interface Job as Job0;
		interface msleep as msleep0;

		interface Leds;
		interface Boot;
	}
}
implementation
{
  #define J0_STACK_SIZE 128
  volatile uint8_t j0_stack[J0_STACK_SIZE];

  
  event void Boot.booted()
  {
    call Job0.postJob(STACK_TOP(j0_stack));
  }

  event void Job0.runJob() {
	while(1) {
		call msleep0.sleep(call Job0.getID(),250);
		call Leds.led0Toggle();
	}
  }  

}

