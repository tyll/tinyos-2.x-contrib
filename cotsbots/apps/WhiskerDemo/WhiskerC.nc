/*
*
*
* Actual Whisker Demo with PlayerStage
*
*
*/
includes MotorBoard;
//#include "Timer.h"

module WhiskerC {

 uses interface Boot;
 uses interface Triggerable;
 uses interface Robot;
 uses interface Timer<TMilli> as Timer;

}

implementation{

  uint8_t dir = 0;

  event void Boot.booted() {

   call Timer.startPeriodic( 1000 ); 
   call Robot.init();
   call Robot.setSpeedTurnDirection(100, 60, FORWARD);
   dir = FORWARD;
   dbg("WhiskerDemo", "WhiskerDemo Booted\n");
  }


/****************Triggerable Item Demo Below*************************/
   event void Triggerable.trig(int ID)
  {
   if(dir == FORWARD){
     call Robot.setDir(REVERSE);
     dir = REVERSE;
   } else {
     call Robot.setDir(FORWARD);
     dir = FORWARD;
   }
   dbg("WhiskerDemo", "WhiskerDemo Triggerable Triggered\n");
  }

  void sim_trig_signal(int itemID) __attribute__ ((C, spontaneous)){
   signal Triggerable.trig(itemID);
  }

/****************Triggerable Item Demo Above*************************/

event void Timer.fired() { 
  dbg("WhiskerDemo", "Whisker Demo Timer Fired");
}


}
