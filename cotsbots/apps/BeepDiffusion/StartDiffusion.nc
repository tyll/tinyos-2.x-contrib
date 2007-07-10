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

configuration StartDiffusion { 
}

implementation {
  components Main, StartDiffusionM, GenericComm as Comm, TimerC, LedsC;

  Main.StdControl -> StartDiffusionM;
  Main.StdControl -> Comm.Control;
  Main.StdControl -> TimerC;

  StartDiffusionM.Leds -> LedsC;

  StartDiffusionM.SendMsg -> Comm.SendMsg[AM_BEEPDIFFUSIONRESETMSG];

  StartDiffusionM.MsgTimer -> TimerC.Timer[unique("Timer")];

} // end of implementation
