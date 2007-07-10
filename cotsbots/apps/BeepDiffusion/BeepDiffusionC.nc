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

configuration BeepDiffusionC { 
}

implementation {
  components Main, BeepDiffusionM, SlotManagerC, AcousticBeaconC, LedsC,
    GenericComm as Comm, ToneSamplingC, RobotC, ObstacleC, TimerC;

  Main.StdControl -> BeepDiffusionM;

  BeepDiffusionM.Leds -> LedsC;

  BeepDiffusionM.SlotRing -> SlotManagerC;
  BeepDiffusionM.SlotControl -> SlotManagerC;

  BeepDiffusionM.AcousticBeacon -> AcousticBeaconC;
  BeepDiffusionM.BeaconControl -> AcousticBeaconC;

  BeepDiffusionM.RadioControl -> Comm.Control;
  BeepDiffusionM.BeepMsg -> Comm.ReceiveMsg[AM_BEEPDIFFUSIONMSG];

  BeepDiffusionM.AcousticSampling -> ToneSamplingC;
  BeepDiffusionM.SamplingControl -> ToneSamplingC;

  BeepDiffusionM.Robot -> RobotC;

  BeepDiffusionM.Obstacle -> ObstacleC;
  BeepDiffusionM.ObstacleControl -> ObstacleC;

  BeepDiffusionM.ObstacleTimer -> TimerC.Timer[unique("Timer")];
  BeepDiffusionM.TimerControl -> TimerC;

  BeepDiffusionM.ResetMsg -> Comm.ReceiveMsg[AM_BEEPDIFFUSIONRESETMSG];

} // end of implementation
