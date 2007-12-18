#ifndef D_OUTPUT_H
#define D_OUTPUT_H

//// d_output.h ////
//Constant reffering to new motor
#define REG_CONST_DIV           32            // Constant which the PID constants value will be divided with
#define DEFAULT_P_GAIN_FACTOR		96//3
#define DEFAULT_I_GAIN_FACTOR		32//1
#define DEFAULT_D_GAIN_FACTOR		32//1
#define MIN_MOVEMENT_POWER      10
#define MAX_CAPTURE_COUNT       100

//Constant reffering to RegMode parameter
#define REGSTATE_IDLE           0x00
#define REGSTATE_REGULATED      0x01
#define REGSTATE_SYNCHRONE      0x02

//Constant reffering to RunState parameter
#define MOTOR_RUN_STATE_IDLE      0x00
#define MOTOR_RUN_STATE_RAMPUP    0x10
#define MOTOR_RUN_STATE_RUNNING   0x20
#define MOTOR_RUN_STATE_RAMPDOWN  0x40
#define MOTOR_RUN_STATE_HOLD      0x60

enum
{
  MOTOR_A,
  MOTOR_B,
  MOTOR_C
};

#endif
