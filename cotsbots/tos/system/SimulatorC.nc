/* PlayerStageC.nc
 * Abstractions for Playerstage Simulator. 
 * 
 * Jaameson J Lee
 * 2006, Dec 25
 * 
 * Inteded to replace Robot,RobotM,RobotC acoordingly.
 */


configuration SimulatorC {
  provides interface Robot;
}
implementation{
  components SimulatorM;
  Robot = SimulatorM.Robot; 
}
