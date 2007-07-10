/*
 * Authors:		Sarah Bergbreiter
 * Date last modified:  10/25/03
 *
 */

/** 
 *
 * @author Sarah Bergbreiter
 **/

includes BeepDiffusionMsg;

module StartDiffusionM { 
  provides interface StdControl;
  uses {
    interface Leds;
    interface SendMsg;
    interface Timer as MsgTimer;
  }
}

implementation {

  uint16_t ticks;
  TOS_Msg msg;
  bool pending;

  enum {
    SEND_TICKLENGTH = 2,
    SEND_GO = 22,

    TICKLENGTH = 3500,
  };

  command result_t StdControl.init() {
    ticks = 0;
    pending = FALSE;
    return SUCCESS;
  }

  command result_t StdControl.start() {
    call MsgTimer.start(TIMER_REPEAT, 1000);
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    return SUCCESS;
  }

  event result_t MsgTimer.fired() {
    BeepDiffusionResetMsg *message = (BeepDiffusionResetMsg *)msg.data;
    call Leds.redToggle();
    ticks++;
    if (ticks == SEND_TICKLENGTH) {
      message->tickLength = TICKLENGTH;
      call Leds.yellowOn();
    } else if (ticks == SEND_GO) {
      message->tickLength = -1;
      call Leds.greenOn();
    } else {
      return SUCCESS;
    }

    if (!pending) {
      if (call SendMsg.send(TOS_BCAST_ADDR, sizeof(BeepDiffusionResetMsg), &msg))
	pending = TRUE;
      else
	pending = FALSE;
    }

    return SUCCESS;
  }

  event result_t SendMsg.sendDone(TOS_MsgPtr m, bool success) {
    pending = FALSE;
    return success;
  }

} // end of implementation
