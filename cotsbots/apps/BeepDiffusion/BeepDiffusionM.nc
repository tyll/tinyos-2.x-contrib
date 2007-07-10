/*
 * Authors:		Sarah Bergbreiter
 * Date last modified:  10/23/03
 *
 */

/** 
 *
 * @author Sarah Bergbreiter
 **/

includes BeepDiffusionMsg;

module BeepDiffusionM { 
  provides interface StdControl;
  uses {
    interface Leds;
    interface SlotRing;
    interface StdControl as SlotControl;
    interface AcousticBeacon;
    interface StdControl as BeaconControl;
    interface AcousticSampling;
    interface StdControl as SamplingControl;
    interface ReceiveMsg as BeepMsg;
    interface StdControl as RadioControl;
    interface Robot;
    interface Obstacle;
    interface StdControl as ObstacleControl;
    interface Timer as ObstacleTimer;
    interface StdControl as TimerControl;
    interface ReceiveMsg as ResetMsg;
  }
}

implementation {

  enum {
    NUM_BEEPS = 7,
    SAMPLE_TIME = 1500,
    OBSTACLE_REVERSE_TIME = 1500,
    INIT_SLOT_TIME = 1000,

    IDLE = 1,
    BEEPING = 2,
    CALIBRATING = 3,
    LISTENING = 4,
    DRIVING = 5,
    OBSTACLE = 6,
    STABILIZING = 7,

    OFF = 0,
    SPEED = 50,
    REVERSE_SPEED = 65,
    STRAIGHT = 30,
    RIGHT = 50,
    FORWARD = 1,
    REVERSE = 0,
  };

  uint8_t state;
  uint8_t mySlot;
  uint16_t BEEP_TIMING[] __attribute__((C)) = {
    100, 200, 100, 200, 100, 200, 100,
  };

  /** 
   * Initialization for the application:
   *  1. Initialize module static variables
   *  2. Initialize SlotControl
   *  @return Returns <code>SUCCESS</code> or <code>FAILED</code>
   **/
  command result_t StdControl.init() {
    state = IDLE;
    call SlotControl.init();
    call BeaconControl.init();
    call SamplingControl.init();
    call RadioControl.init();
    call Robot.init();
    call ObstacleControl.init();
    call TimerControl.init();
    return SUCCESS;
  }

  /** start application and timers **/
  command result_t StdControl.start(){
    call SlotRing.setTickLength(INIT_SLOT_TIME);
    call BeaconControl.start();
    call SamplingControl.start();
    call RadioControl.start();
    call Robot.setSpeedTurnDirection(OFF, STRAIGHT, FORWARD);
    call Obstacle.setThreshold(5,3);
    call Obstacle.calibrate();
    state = CALIBRATING;
    call Leds.redOn();
    return SUCCESS;
  }

  /** stop application **/
  command result_t StdControl.stop(){
    call SlotControl.stop();
    call BeaconControl.stop();
    call SamplingControl.stop();
    call RadioControl.stop();
    call ObstacleControl.stop();
    call ObstacleTimer.stop();
    return SUCCESS;
  } 

  void stopDriving() {
    state = IDLE;
    call ObstacleControl.stop();
    call Robot.setSpeedTurnDirection(OFF, STRAIGHT, FORWARD);
    call Leds.redOff();
    call Leds.yellowOff();
  }

  void startDriving() {
    state = DRIVING;
    call ObstacleControl.start();
    call Leds.redOn();
    call Robot.setSpeedTurnDirection(SPEED, STRAIGHT, FORWARD);
  }

  /** signaled when my slot period is beginning **/
  event result_t SlotRing.startSlotPeriod(uint8_t slotPosition) {
    // could be in idle, driving, or obstacle states
    mySlot = slotPosition;
    if ((state == DRIVING) || (state == OBSTACLE)) stopDriving();
    if (state == IDLE) {
      call AcousticBeacon.send(NUM_BEEPS, BEEP_TIMING);
      state = BEEPING;
    }
    return call Leds.greenOn();
  }

  /** signaled when my slot period has ended **/
  event result_t SlotRing.endSlotPeriod(uint8_t slotPosition) {
    if ((state == DRIVING) || (state == OBSTACLE)) stopDriving();
    if (slotPosition == mySlot)
      call Leds.greenOff();
    return SUCCESS;
  }

  event result_t AcousticBeacon.sendDone(uint16_t* time) {
    state = IDLE;
    return SUCCESS;
  }

  event result_t AcousticSampling.doneCalibrating(uint16_t value) {
    state = IDLE;
    return SUCCESS;
  }

  event result_t AcousticSampling.doneSampling(bool heardBeep) {
    //call Leds.yellowOff();
    state = IDLE;
    if (heardBeep)
      startDriving();
    return SUCCESS;
  }

  event TOS_MsgPtr BeepMsg.receive(TOS_MsgPtr m) {
    if ((state == DRIVING) || (state == OBSTACLE)) stopDriving();
    if (state != IDLE) return m;
    //call Leds.yellowOn();
    state = LISTENING;
    call AcousticSampling.startSampling(SAMPLE_TIME);
    return m;
  }

  event result_t Obstacle.calibrateDone(uint16_t zeroX, uint16_t zeroY) {
    call SlotControl.start();
    call Leds.redOff();
    state = STABILIZING;
    return SUCCESS;
  }

  event result_t Obstacle.obstacleDetected(uint16_t value, uint8_t direction) {
    if (state == DRIVING) {
      call Leds.yellowOn();
      state = OBSTACLE;
      call Robot.setSpeedTurnDirection(REVERSE_SPEED,RIGHT,REVERSE);
      call ObstacleTimer.start(TIMER_ONE_SHOT, OBSTACLE_REVERSE_TIME);
    }
    return SUCCESS;
  }

  event result_t ObstacleTimer.fired() {
    stopDriving();
    return SUCCESS;
  }

  event TOS_MsgPtr ResetMsg.receive(TOS_MsgPtr m) {
    BeepDiffusionResetMsg *message = (BeepDiffusionResetMsg *)m->data;
    int16_t newTick = message->tickLength;
    if (newTick > 0) {
      call SlotRing.setTickLength(newTick);
    } else {
      state = IDLE;
    }
    
    return m;
  }

} // end of implementation
