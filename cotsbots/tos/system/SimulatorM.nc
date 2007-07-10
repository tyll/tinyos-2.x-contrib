/* PlayerStageM.nc
 * 
 * Actual Implementation of the Simulator
 * (Don't know Why we have to abstract to 3 levels grumble grumble)
 *
 * Jameson J Lee
 * 2006, Dec 25
 *
 * provides Robot interface
 *
 */

module SimulatorM {
 provides interface Robot;
}
implementation {
 
 //Speed, Turning Angle(in Radians)
 float cur_speed = 0; //Speed is lower by factor of 50
 float cur_turn = 0; //Radians, convert turn angle to radians
 int cur_direction = 1; //positive is forward, negative is backwards, 0 is off.
 
 command error_t Robot.init() {
 /* Startup the Playerstage Unit 
  *  
  * Problems: 1. Keeping Track of the Robot(?)
  *           2. How To Determine which robot is doing this(?)
  */
  dbg("RobotDBG", "Simulator Booted(Initialized)");
  
  //SIM_FILE is a script created by this that will need to fixed so it can run for playerstage.
  dbg("SIM_FILE", "from playerc import *\n");
  dbg("SIM_FILE", "import time\n");   
  dbg("SIM_FILE", "CLIENT_X = playerc_client(None, HOSTNAME, PORT)\n");
  dbg("SIM_FILE", "if CLIENT_X.connect() != 0: raise playerc_error_str()\n");
  
  dbg("SIM_FILE", "CLI_POS_X = playerc_position2d(CLIENT_X,0)\n");
  dbg("SIM_FILE", "if CLI_POS_X.subscribe(PLAYERC_OPEN_MODE) != 0: raise playerc_error_str()\n");
  
  dbg("SIM_FILE", "BUMPER_X = playerc_bumper(CLIENT_X,0)\n");
  dbg("SIM_FILE", "if BUMPER_X.subscribe(PLAYERC_OPEN_MODE) != 0: raise playerc_error_str()\n");
  return SUCCESS;
 }
 
 command error_t Robot.setSpeed(uint8_t speed){
  dbg("RobotDBG", "Speed changed to: %d\n", speed);
  cur_speed = speed / 50; 
  dbg("SIM_FILE", "time.sleep(%s)\n", sim_time_string());
  dbg("SIM_FILE", "CLI_POS_X.set_cmd_vel(%.3f, 0, %.3f, 1)\n", cur_speed, cur_turn);
  return SUCCESS;
 }
 
 command error_t Robot.setDir(uint8_t dir){
  dbg("RobotDBG", "direction changed: %d\n", dir);
  
  if (dir == 0 && cur_speed > 0){
   cur_speed = -cur_speed;
   cur_direction = -1;
  } else if (dir == 1 && cur_speed <= 0){
   cur_speed = -cur_speed;
   cur_direction = 1;
  } else {
    //Do Nothing
    // This is when cur_speed <= 0, and intended direction is reverse
    // This is when cur_speed > 0, and intended direction is forward
  }

  dbg("SIM_FILE", "time.sleep(%s)\n", sim_time_string());
  dbg("SIM_FILE", "CLI_POS_X.set_cmd_vel(%.3f, 0, %.3f, 1)\n", cur_speed, cur_turn);
  return SUCCESS; 
 }
 
 command error_t Robot.setTurn(uint8_t turn){
  dbg("RobotDBG", "turn angle changed: %d\n",turn);
  cur_turn = turn;
  if (cur_turn >= 60){
   cur_turn = 60;
  }
  if (cur_turn <= 0){
   cur_turn = 0;
  }
  cur_turn = cur_turn - 30;
//  cur_turn = cur_turn * -1;
  
  cur_turn = cur_turn * ( 3.141 / 180 );
  dbg("SIM_FILE", "time.sleep(%s)\n", sim_time_string());
  dbg("SIM_FILE", "CLI_POS_X.set_cmd_vel(%.3f, 0, %.3f, 1)\n", cur_speed, cur_turn);
  return SUCCESS;
 }
 
 command error_t Robot.setSpeedTurnDirection(uint8_t speed, uint8_t turn, uint8_t dir){
  dbg("RobotDBG", "speed, turn, direction all changed:\n %d, %d, %d\n", speed, turn, dir);

  cur_turn = turn;
  if (cur_turn >= 60){
   cur_turn = 60;
  }
  if (cur_turn <= 0){
   cur_turn = 0;
  }
  cur_turn = cur_turn - 30;
//  cur_turn = cur_turn * -1;  
  cur_turn = cur_turn * (3.141 / 180);
  
  cur_speed = speed / 50;
  
  if (dir == 0 && cur_speed > 0){
   cur_speed = -cur_speed;
   cur_direction = -1;
  } else if (dir == 1 && cur_speed <= 0){
   cur_speed = -cur_speed;
   cur_direction = 1;
  } else {
    //Do Nothing
    // This is when cur_speed <= 0, and intended direction is reverse
    // This is when cur_speed > 0, and intended direction is forward
  }

  dbg("SIM_FILE", "time.sleep(%s)\n", sim_time_string());
  dbg("SIM_FILE", "CLI_POS_X.set_cmd_vel(%.3f, 0, %.3f, 1)\n", cur_speed, cur_turn);
  return SUCCESS; 
 }
 
}
