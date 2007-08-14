/**
 * Blink without timer
 **/

/*
 * @author Martin Leopold
 */

#include "Timer.h"

module BlinkNoTimerC
{
  uses interface HalMcs51Led as Led1;
  uses interface HalMcs51Led as Led3;
  uses interface Boot;
}
implementation
{
  event void Boot.booted() {
    uint16_t i,j;
    call Led1.on();
    call Led3.off();
    while(1) {
      for (i=0 ; i< 0xFFFFU ; i++) {
	for (j=0 ; j<0xA ; j++) {
	  1;
	}
      }
      call Led1.toggle();
      call Led3.toggle();
    }

  }

}

