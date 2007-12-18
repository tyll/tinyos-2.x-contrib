#include "d_output.h"
#include  "d_output.r"

#define MAXIMUM_SPEED_FW         100
#define MAXIMUM_SPEED_RW         -100

#define INPUT_SCALE_FACTOR       100

#define MAX_COUNT_TO_RUN         10000000

#define REG_MAX_VALUE            100
#define REG_MIN_VALUE            -100

#define RAMP_TIME_INTERVAL       25           // Measured in 1 mS => 25 mS interval
#define REGULATION_TIME          100          // Measured in 1 mS => 100 mS regulation interval

#define RAMPDOWN_STATE_RAMPDOWN  0
#define RAMPDOWN_STATE_CONTINIUE 1

#define COAST_MOTOR_MODE         0

module HplOutputP {
  provides {
    interface HplOutput;
  }
}
implementation {

	//void dOutputRampDownSynch(UBYTE MotorNr);

	typedef struct
	{
		SBYTE MotorSetSpeed;                        // Motor setpoint in speed
		SBYTE MotorTargetSpeed;                     // Speed order for the movement
		SBYTE MotorActualSpeed;                     // Actual speed for motor (Calculated within the PID regulation)
		SBYTE TurnParameter;                        // Tell the turning parameter used
		UBYTE RegPParameter;                        // Current P parameter used within the regulation
		UBYTE RegIParameter;                        // Current I parameter used within the regulation
		UBYTE RegDParameter;                        // Current D parameter used within the regulation
		UBYTE RegulationTimeCount;                  // Time counter used to evaluate when the regulation should run again (100 mS)
		UBYTE MotorRunState;                        // Hold current motor state (Ramp-up, Running, Ramp-Down, Idle)
		UBYTE RegulationMode;                       // Hold current regulation mode (Position control, Synchronization mode)
		UBYTE MotorOverloaded;                      // Set if the motor speed in regulation is calculated to be above maximum
		UBYTE MotorRunForever;                      // Tell that the motor is set to run forever
		UWORD MotorRampDownCount;                   // Counter to tell if the ramp-down can reach it gaol and therefor need some additional help
		SWORD MotorRampDownIncrement;               // Tell the number of count between each speed adjustment during Ramp-Down
		UWORD MotorRampUpCount;                     // Used to speedup Ramp-Up if position regulation is not enabled
		SWORD MotorRampUpIncrement;                 // Tell the number of count between each speed adjustment during Ramp-up
		SWORD AccError;                             // Accumulated Error, used within the integrator of the PID regulation
		SWORD OldPositionError;                     // Used within position regulation
		SLONG DeltaCaptureCount;                    // Counts within last regulation time-periode
		SLONG CurrentCaptureCount;                  // Total counts since motor counts has been reset
		SLONG MotorTachoCountToRun;                 // Holds number of counts to run. 0 = Run forever
		SLONG MotorBlockTachoCount;                 // Hold CaptureCount for current movement
		SLONG MotorRampTachoCountOld;               // Used to hold old position during Ramp-Up
		SLONG MotorRampTachoCountStart;             // Used to hold position when Ramp-up started
		SLONG RotationCaptureCount;                 // Counter for additional rotation counter
	}MOTORDATA;

	typedef struct
	{
		SLONG SyncTachoDif;
		SLONG SyncTurnParameter;
		SWORD SyncOldError;
		SWORD SyncAccError;
	}SYNCMOTORDATA;

	static    MOTORDATA         MotorData[3];
	static    SYNCMOTORDATA     SyncData;

	command void HplOutput.dOutputInit()
	{
		UBYTE Temp;

		OUTPUTInit;
		ENABLECaptureMotorA;
		ENABLECaptureMotorB;
		ENABLECaptureMotorC;

		for (Temp = 0; Temp < 3; Temp++)
		{
			MotorData[Temp].MotorSetSpeed = 0;
			MotorData[Temp].MotorTargetSpeed = 0;
			MotorData[Temp].MotorActualSpeed = 0;
			MotorData[Temp].MotorRampUpCount = 0;
			MotorData[Temp].MotorRampDownCount = 0;
			MotorData[Temp].MotorRunState = 0;
			MotorData[Temp].MotorTachoCountToRun = 0;
			MotorData[Temp].MotorRunForever = 1;
			MotorData[Temp].AccError = 0;
			MotorData[Temp].RegulationTimeCount = 0;
			MotorData[Temp].RegPParameter = DEFAULT_P_GAIN_FACTOR;
			MotorData[Temp].RegIParameter = DEFAULT_I_GAIN_FACTOR;
			MotorData[Temp].RegDParameter = DEFAULT_D_GAIN_FACTOR;
			MotorData[Temp].RegulationMode = 0; 	
			MotorData[Temp].MotorOverloaded = 0;
			INSERTMode(Temp, COAST_MOTOR_MODE);
			INSERTSpeed(Temp, MotorData[Temp].MotorSetSpeed);
		}
	}

	/* This function is called every 1 mS and will go through all the motors and there dependencies */
	/* Actual motor speed is only passed (updated) to the AVR controller form this function */
	/* DeltacaptureCount used to count number of Tachocount within last 100 mS. Used with position control regulation */
	/* CurrentCaptureCount used to tell total current position. Used to tell when movement has been obtained */
	/* MotorBlockTachoCount tell current position within current movement. Reset when a new block is started from the VM */
	/* RotationCaptureCount is additional counter for the rotationsensor. Uses it own value so it does conflict with other CaptureCount */
	command void HplOutput.dOutputCtrl()
	{
		UBYTE MotorNr;
		SLONG NewTachoCount[3];

		TACHOCaptureReadResetAll(NewTachoCount[MOTOR_A], NewTachoCount[MOTOR_B], NewTachoCount[MOTOR_C]);

		for (MotorNr = 0; MotorNr < 3; MotorNr++)
		{
			MotorData[MotorNr].DeltaCaptureCount += NewTachoCount[MotorNr];
			MotorData[MotorNr].CurrentCaptureCount += NewTachoCount[MotorNr];
			MotorData[MotorNr].MotorBlockTachoCount += NewTachoCount[MotorNr];
			MotorData[MotorNr].RotationCaptureCount += NewTachoCount[MotorNr];
			MotorData[MotorNr].RegulationTimeCount++;

			if (MotorData[MotorNr].MotorRunState == MOTOR_RUN_STATE_RAMPUP)
			{
				call HplOutput.dOutputRampUpFunction(MotorNr);
			}
			if (MotorData[MotorNr].MotorRunState == MOTOR_RUN_STATE_RAMPDOWN)
			{
				call HplOutput.dOutputRampDownFunction(MotorNr);
			}
			if (MotorData[MotorNr].MotorRunState == MOTOR_RUN_STATE_RUNNING)
			{
				call HplOutput.dOutputTachoLimitControl(MotorNr);
			}
			if (MotorData[MotorNr].MotorRunState == MOTOR_RUN_STATE_IDLE)
			{
				call HplOutput.dOutputMotorIdleControl(MotorNr);
			}
			if (MotorData[MotorNr].MotorRunState == MOTOR_RUN_STATE_HOLD)
			{
				MotorData[MotorNr].MotorSetSpeed = 0;
				MotorData[MotorNr].MotorActualSpeed = 0;
				MotorData[MotorNr].MotorTargetSpeed = 0;
				MotorData[MotorNr].RegulationTimeCount = 0;
				MotorData[MotorNr].DeltaCaptureCount = 0;
				MotorData[MotorNr].MotorRunState = MOTOR_RUN_STATE_RUNNING;

			}
			if (MotorData[MotorNr].RegulationTimeCount > REGULATION_TIME)
			{
				MotorData[MotorNr].RegulationTimeCount = 0;
				call HplOutput.dOutputRegulateMotor(MotorNr);
				MotorData[MotorNr].DeltaCaptureCount = 0;
			}
		}
		INSERTSpeed(MOTOR_A, MotorData[MOTOR_A].MotorActualSpeed);
		INSERTSpeed(MOTOR_B, MotorData[MOTOR_B].MotorActualSpeed);
		INSERTSpeed(MOTOR_C, MotorData[MOTOR_C].MotorActualSpeed);
	}

	command void HplOutput.dOutputExit()
	{
		OUTPUTExit;
	}

	/* Called eveyr 1 mS */
	/* Data mapping for controller (IO-Map is updated with these values) */
	command void HplOutput.dOutputGetMotorParameters(UBYTE *CurrentMotorSpeed, SLONG *TachoCount, SLONG *BlockTachoCount, UBYTE *RunState, UBYTE *MotorOverloaded, SLONG *RotationCount)
	{
		UBYTE Tmp;

		for (Tmp = 0; Tmp < 3; Tmp++)
		{
			CurrentMotorSpeed[Tmp] = MotorData[Tmp].MotorActualSpeed;
			TachoCount[Tmp] = MotorData[Tmp].CurrentCaptureCount;
			BlockTachoCount[Tmp] = MotorData[Tmp].MotorBlockTachoCount;
			RotationCount[Tmp] = MotorData[Tmp].RotationCaptureCount;
			RunState[Tmp] = MotorData[Tmp].MotorRunState;
			MotorOverloaded[Tmp] = MotorData[Tmp].MotorOverloaded;
		}
	}

	command void HplOutput.dOutputSetMode(UBYTE Motor, UBYTE Mode)     //Set motor mode (break, Float)
	{
		INSERTMode(Motor, Mode);
	}

	/* Update the regulation state for the motor */
	/* Need to reset regulation parameter depending on current status of the motor */
	/* AccError & OldPositionError used for position regulation and Sync Parameter are used for synchronization regulation */
	command void HplOutput.dOutputEnableRegulation(UBYTE MotorNr, UBYTE RegulationMode)
	{
		MotorData[MotorNr].RegulationMode = RegulationMode;

		if ((MotorData[MotorNr].RegulationMode & REGSTATE_REGULATED) && (MotorData[MotorNr].MotorSetSpeed == 0) && (MotorData[MotorNr].MotorRunState != MOTOR_RUN_STATE_RAMPDOWN))
		{
			MotorData[MotorNr].AccError = 0;
			MotorData[MotorNr].OldPositionError = 0;
		}

		if (MotorData[MotorNr].RegulationMode & REGSTATE_SYNCHRONE)
		{
			if (((MotorData[MotorNr].MotorActualSpeed == 0) || (MotorData[MotorNr].TurnParameter != 0) || (MotorData[MotorNr].TurnParameter == 0)) && (MotorData[MotorNr].MotorRunState != MOTOR_RUN_STATE_RAMPDOWN))
			{
				SyncData.SyncTachoDif = 0;

				SyncData.SyncAccError = 0;
				SyncData.SyncOldError = 0;
				SyncData.SyncTurnParameter = 0;
			}
		}
	}

	/* Disable current regulation if enabled */
	command void HplOutput.dOutputDisableRegulation(UBYTE MotorNr)
	{
		MotorData[MotorNr].RegulationMode = REGSTATE_IDLE;
	}

	/* Calling this function with reset count which tell current position and which is used to tell if the wanted position is obtained */
	/* Calling this function will reset current movement of the motor if it is running */
	command void HplOutput.dOutputResetTachoLimit(UBYTE MotorNr)
	{
		MotorData[MotorNr].CurrentCaptureCount = 0;
		MotorData[MotorNr].MotorTachoCountToRun = 0;

		if (MotorData[MotorNr].RegulationMode & REGSTATE_SYNCHRONE)
		{
			call HplOutput.dOutputResetSyncMotors(MotorNr);
		}

		if (MotorData[MotorNr].MotorRunForever == 1)
		{
			MotorData[MotorNr].MotorRunForever = 0;                   // To ensure that we get the same functionality for all combination on motor durations
		}
	}

	/* MotorBlockTachoCount tells current position in current movement. */
	/* Used within the synchronization to compare current motor position. Reset on every new movement from the VM */
	command void HplOutput.dOutputResetBlockTachoLimit(UBYTE MotorNr)
	{
		MotorData[MotorNr].MotorBlockTachoCount = 0;
	}

	/* Additional counter add to help the VM application keep track of number of rotation for the rotation sensor */
	/* This values can be reset independtly from the other tacho count values used with regulation and position control */
	command void HplOutput.dOutputResetRotationCaptureCount(UBYTE MotorNr)
	{
		MotorData[MotorNr].RotationCaptureCount = 0;
	}

	/* Can be used to set new PID values */
	command void HplOutput.dOutputSetPIDParameters(UBYTE Motor, UBYTE NewRegPParameter, UBYTE NewRegIParameter, UBYTE NewRegDParameter)
	{
		MotorData[Motor].RegPParameter = NewRegPParameter;
		MotorData[Motor].RegIParameter = NewRegIParameter;
		MotorData[Motor].RegDParameter = NewRegDParameter;
	}

	/* Called to set TachoCountToRun which is used for position control for the model */
	/* Must be called before motor start */
	/* TachoCountToRun is calculated as a signed value */
	command void HplOutput.dOutputSetTachoLimit(UBYTE MotorNr, ULONG BlockTachoCntToTravel)
	{
		if (BlockTachoCntToTravel == 0)
		{
			MotorData[MotorNr].MotorRunForever = 1;
		}
		else
		{
			MotorData[MotorNr].MotorRunForever = 0;

			if (MotorData[MotorNr].MotorSetSpeed == 0)
			{
				if (MotorData[MotorNr].MotorTargetSpeed > 0)
				{
					MotorData[MotorNr].MotorTachoCountToRun += BlockTachoCntToTravel;
				}
				else
				{
					MotorData[MotorNr].MotorTachoCountToRun -= BlockTachoCntToTravel;
				}
			}
			else
			{
				if (MotorData[MotorNr].MotorSetSpeed > 0)
				{
					MotorData[MotorNr].MotorTachoCountToRun += BlockTachoCntToTravel;
				}
				else
				{
					MotorData[MotorNr].MotorTachoCountToRun -= BlockTachoCntToTravel;
				}
			}
		}
	}

	/* This function is used for setting up the motor mode and motor speed */
	command void HplOutput.dOutputSetSpeed (UBYTE MotorNr, UBYTE NewMotorRunState, SBYTE Speed, SBYTE NewTurnParameter)
	{
		if ((MotorData[MotorNr].MotorSetSpeed != Speed) || (MotorData[MotorNr].MotorRunState != NewMotorRunState) || (NewMotorRunState == MOTOR_RUN_STATE_IDLE) || (MotorData[MotorNr].TurnParameter != NewTurnParameter))
		{
			if (MotorData[MotorNr].MotorTargetSpeed == 0)
			{
				MotorData[MotorNr].AccError = 0;
				MotorData[MotorNr].OldPositionError = 0;
				MotorData[MotorNr].RegulationTimeCount = 0;
				MotorData[MotorNr].DeltaCaptureCount = 0;
				TACHOCountReset(MotorNr);
			}
			switch (NewMotorRunState)
			{
				case MOTOR_RUN_STATE_IDLE:
				{
					//MotorData[MotorNr].MotorSetSpeed = 0;
					//MotorData[MotorNr].MotorTargetSpeed = 0;
					//MotorData[MotorNr].TurnParameter = 0;
					MotorData[MotorNr].RegulationMode = REGSTATE_IDLE;
				}
				break;

				case MOTOR_RUN_STATE_RAMPUP:
				{
					if (MotorData[MotorNr].MotorSetSpeed == 0)
					{
						MotorData[MotorNr].MotorSetSpeed = Speed;
						MotorData[MotorNr].TurnParameter = NewTurnParameter;
						MotorData[MotorNr].MotorRampUpIncrement = 0;
						MotorData[MotorNr].MotorRampTachoCountStart = MotorData[MotorNr].CurrentCaptureCount;
						MotorData[MotorNr].MotorRampUpCount = 0;
					}
					else
					{
						if (Speed > 0)
						{
							if (MotorData[MotorNr].MotorSetSpeed >= Speed)
							{
								NewMotorRunState = MOTOR_RUN_STATE_RUNNING;
							}
							else
							{
								MotorData[MotorNr].MotorSetSpeed = Speed;
								MotorData[MotorNr].TurnParameter = NewTurnParameter;
								MotorData[MotorNr].MotorRampUpIncrement = 0;
								MotorData[MotorNr].MotorRampTachoCountStart = MotorData[MotorNr].CurrentCaptureCount;
								MotorData[MotorNr].MotorRampUpCount = 0;
							}
						}
						else
						{
							if (MotorData[MotorNr].MotorSetSpeed <= Speed)
							{
								NewMotorRunState = MOTOR_RUN_STATE_RUNNING;
							}
							else
							{
								MotorData[MotorNr].MotorSetSpeed = Speed;
								MotorData[MotorNr].TurnParameter = NewTurnParameter;
								MotorData[MotorNr].MotorRampUpIncrement = 0;
								MotorData[MotorNr].MotorRampTachoCountStart = MotorData[MotorNr].CurrentCaptureCount;
								MotorData[MotorNr].MotorRampUpCount = 0;
							}
						}
					}
				}
				break;

				case MOTOR_RUN_STATE_RUNNING:
				{
					MotorData[MotorNr].MotorSetSpeed = Speed;
					MotorData[MotorNr].MotorTargetSpeed = Speed;
					MotorData[MotorNr].TurnParameter = NewTurnParameter;

					if (MotorData[MotorNr].MotorSetSpeed == 0)
					{
						NewMotorRunState = MOTOR_RUN_STATE_HOLD;
					}
				}
				break;

				case MOTOR_RUN_STATE_RAMPDOWN:
				{
					if (MotorData[MotorNr].MotorTargetSpeed >= 0)
					{
						if (MotorData[MotorNr].MotorSetSpeed <= Speed)
						{
							NewMotorRunState = MOTOR_RUN_STATE_RUNNING;
						}
						else
						{
							MotorData[MotorNr].MotorSetSpeed = Speed;
							MotorData[MotorNr].TurnParameter = NewTurnParameter;
							MotorData[MotorNr].MotorRampDownIncrement = 0;
							MotorData[MotorNr].MotorRampTachoCountStart = MotorData[MotorNr].CurrentCaptureCount;
							MotorData[MotorNr].MotorRampDownCount = 0;
						}
					}
					else
					{
						if (MotorData[MotorNr].MotorSetSpeed >= Speed)
						{
							NewMotorRunState = MOTOR_RUN_STATE_RUNNING;
						}
						else
						{
							MotorData[MotorNr].MotorSetSpeed = Speed;
							MotorData[MotorNr].TurnParameter = NewTurnParameter;
							MotorData[MotorNr].MotorRampDownIncrement = 0;
							MotorData[MotorNr].MotorRampTachoCountStart = MotorData[MotorNr].CurrentCaptureCount;
							MotorData[MotorNr].MotorRampDownCount = 0;
						}
					}
				}
				break;
			}
			MotorData[MotorNr].MotorRunState = NewMotorRunState;
			MotorData[MotorNr].MotorOverloaded = 0;
		}
	}

	/* Function used for controlling the Ramp-up periode */
	/* Ramp-up is done with 1 increment in speed every X number of TachoCount, where X depend on duration of the periode and the wanted speed */
	command void HplOutput.dOutputRampUpFunction(UBYTE MotorNr)
	{
		if (MotorData[MotorNr].MotorTargetSpeed == 0)
		{
			if (MotorData[MotorNr].MotorSetSpeed > 0)
			{
				MotorData[MotorNr].MotorTargetSpeed = MIN_MOVEMENT_POWER;
			}
			else
			{
				MotorData[MotorNr].MotorTargetSpeed = -MIN_MOVEMENT_POWER;
			}
		}
		else
		{
			if (MotorData[MotorNr].MotorRampUpIncrement == 0)
			{
				if (MotorData[MotorNr].MotorSetSpeed > 0)
				{
					MotorData[MotorNr].MotorRampUpIncrement = (SWORD)((MotorData[MotorNr].MotorTachoCountToRun - MotorData[MotorNr].MotorRampTachoCountStart) / (MotorData[MotorNr].MotorSetSpeed - MotorData[MotorNr].MotorTargetSpeed));
				}
				else
				{
					MotorData[MotorNr].MotorRampUpIncrement = (SWORD)(-((MotorData[MotorNr].MotorTachoCountToRun - MotorData[MotorNr].MotorRampTachoCountStart) / (MotorData[MotorNr].MotorSetSpeed - MotorData[MotorNr].MotorTargetSpeed)));
				}
				MotorData[MotorNr].MotorRampTachoCountOld = MotorData[MotorNr].CurrentCaptureCount;
			}
			if (MotorData[MotorNr].MotorSetSpeed > 0)
			{
				if (MotorData[MotorNr].CurrentCaptureCount > (MotorData[MotorNr].MotorRampTachoCountOld + MotorData[MotorNr].MotorRampUpIncrement))
				{
					MotorData[MotorNr].MotorTargetSpeed += 1;
					MotorData[MotorNr].MotorRampTachoCountOld = MotorData[MotorNr].CurrentCaptureCount;
					MotorData[MotorNr].MotorRampUpCount = 0;
				}
				else
				{
					if (!(MotorData[MotorNr].RegulationMode & REGSTATE_REGULATED))
					{
						MotorData[MotorNr].MotorRampUpCount++;
						if (MotorData[MotorNr].MotorRampUpCount > 100)
						{
							MotorData[MotorNr].MotorRampUpCount = 0;
							MotorData[MotorNr].MotorTargetSpeed++;
						}
					}
				}
			}
			else
			{
				if (MotorData[MotorNr].CurrentCaptureCount < (MotorData[MotorNr].MotorRampTachoCountOld + MotorData[MotorNr].MotorRampUpIncrement))
				{
					MotorData[MotorNr].MotorTargetSpeed -= 1;
					MotorData[MotorNr].MotorRampTachoCountOld = MotorData[MotorNr].CurrentCaptureCount;
					MotorData[MotorNr].MotorRampUpCount = 0;
				}
				else
				{
					if (!(MotorData[MotorNr].RegulationMode & REGSTATE_REGULATED))
					{
						MotorData[MotorNr].MotorRampUpCount++;
						if (MotorData[MotorNr].MotorRampUpCount > 100)
						{
							MotorData[MotorNr].MotorRampUpCount = 0;
							MotorData[MotorNr].MotorTargetSpeed--;
						}
					}
				}
			}
		}
		if (MotorData[MotorNr].MotorSetSpeed > 0)
		{
			if ((MotorData[MotorNr].CurrentCaptureCount - MotorData[MotorNr].MotorRampTachoCountStart) >= (MotorData[MotorNr].MotorTachoCountToRun - MotorData[MotorNr].MotorRampTachoCountStart))
			{
				MotorData[MotorNr].MotorTargetSpeed = MotorData[MotorNr].MotorSetSpeed;
				MotorData[MotorNr].MotorRunState = MOTOR_RUN_STATE_IDLE;	
			}
		}
		else
		{
			if ((MotorData[MotorNr].CurrentCaptureCount + MotorData[MotorNr].MotorRampTachoCountStart) <= (MotorData[MotorNr].MotorTachoCountToRun + MotorData[MotorNr].MotorRampTachoCountStart))
			{
				MotorData[MotorNr].MotorTargetSpeed = MotorData[MotorNr].MotorSetSpeed;
				MotorData[MotorNr].MotorRunState = MOTOR_RUN_STATE_IDLE;	
			}
		}
		if (MotorData[MotorNr].MotorSetSpeed > 0)
		{
			if (MotorData[MotorNr].MotorTargetSpeed > MotorData[MotorNr].MotorSetSpeed)
			{
				MotorData[MotorNr].MotorTargetSpeed = MotorData[MotorNr].MotorSetSpeed;
			}
		}
		else
		{
			if (MotorData[MotorNr].MotorTargetSpeed < MotorData[MotorNr].MotorSetSpeed)
			{
				MotorData[MotorNr].MotorTargetSpeed = MotorData[MotorNr].MotorSetSpeed;
			}
		}
		if (MotorData[MotorNr].RegulationMode == REGSTATE_IDLE)
		{
			MotorData[MotorNr].MotorActualSpeed = MotorData[MotorNr].MotorTargetSpeed;
		}
	}

	/* Function used for controlling the Ramp-down periode */
	/* Ramp-down is done with 1 decrement in speed every X number of TachoCount, where X depend on duration of the periode and the wanted speed */
	command void HplOutput.dOutputRampDownFunction(UBYTE MotorNr)
	{
		if (MotorData[MotorNr].MotorRampDownIncrement == 0)
		{
			if (MotorData[MotorNr].MotorTargetSpeed > 0)
			{
				if ((MotorData[MotorNr].MotorTargetSpeed > MIN_MOVEMENT_POWER) && (MotorData[MotorNr].MotorSetSpeed == 0))
				{
					MotorData[MotorNr].MotorRampDownIncrement = ((MotorData[MotorNr].MotorTachoCountToRun - MotorData[MotorNr].CurrentCaptureCount) / ((MotorData[MotorNr].MotorTargetSpeed - MotorData[MotorNr].MotorSetSpeed) - MIN_MOVEMENT_POWER));
				}
				else
				{
					MotorData[MotorNr].MotorRampDownIncrement = ((MotorData[MotorNr].MotorTachoCountToRun - MotorData[MotorNr].CurrentCaptureCount) / (MotorData[MotorNr].MotorTargetSpeed - MotorData[MotorNr].MotorSetSpeed));
				}
			}
			else
			{
				if ((MotorData[MotorNr].MotorTargetSpeed < -MIN_MOVEMENT_POWER) && (MotorData[MotorNr].MotorSetSpeed == 0))
				{
					MotorData[MotorNr].MotorRampDownIncrement = (-((MotorData[MotorNr].MotorTachoCountToRun - MotorData[MotorNr].CurrentCaptureCount) / ((MotorData[MotorNr].MotorTargetSpeed - MotorData[MotorNr].MotorSetSpeed) + MIN_MOVEMENT_POWER)));
				}
				else
				{
					MotorData[MotorNr].MotorRampDownIncrement = (-((MotorData[MotorNr].MotorTachoCountToRun - MotorData[MotorNr].CurrentCaptureCount) / (MotorData[MotorNr].MotorTargetSpeed - MotorData[MotorNr].MotorSetSpeed)));
				}
			}
			MotorData[MotorNr].MotorRampTachoCountOld = MotorData[MotorNr].CurrentCaptureCount;
		}
		if (MotorData[MotorNr].MotorTargetSpeed > 0)
		{
			if (MotorData[MotorNr].CurrentCaptureCount > (MotorData[MotorNr].MotorRampTachoCountOld + (SLONG)MotorData[MotorNr].MotorRampDownIncrement))
			{
				MotorData[MotorNr].MotorTargetSpeed--;
				if (MotorData[MotorNr].MotorTargetSpeed < MIN_MOVEMENT_POWER)
				{
					MotorData[MotorNr].MotorTargetSpeed = MIN_MOVEMENT_POWER;
				}
				MotorData[MotorNr].MotorRampTachoCountOld = MotorData[MotorNr].CurrentCaptureCount;
				MotorData[MotorNr].MotorRampDownCount = 0;
				call HplOutput.dOutputRampDownSynch(MotorNr);
			}
			else
			{
				if (!(MotorData[MotorNr].RegulationMode & REGSTATE_REGULATED))
				{
					MotorData[MotorNr].MotorRampDownCount++;
					if (MotorData[MotorNr].MotorRampDownCount > (UWORD)(30 * MotorData[MotorNr].MotorRampDownIncrement))
					{
						MotorData[MotorNr].MotorRampDownCount = (UWORD)(20 * MotorData[MotorNr].MotorRampDownIncrement);
						MotorData[MotorNr].MotorTargetSpeed++;
					}
				}
			}
		}
		else
		{
			if (MotorData[MotorNr].CurrentCaptureCount < (MotorData[MotorNr].MotorRampTachoCountOld + (SLONG)MotorData[MotorNr].MotorRampDownIncrement))
			{
				MotorData[MotorNr].MotorTargetSpeed++;
				if (MotorData[MotorNr].MotorTargetSpeed > -MIN_MOVEMENT_POWER)
				{
					MotorData[MotorNr].MotorTargetSpeed = -MIN_MOVEMENT_POWER;
				}
				MotorData[MotorNr].MotorRampTachoCountOld = MotorData[MotorNr].CurrentCaptureCount;
				MotorData[MotorNr].MotorRampDownCount = 0;
				call HplOutput.dOutputRampDownSynch(MotorNr);
			}
			else
			{
				if (!(MotorData[MotorNr].RegulationMode & REGSTATE_REGULATED))
				{
					MotorData[MotorNr].MotorRampDownCount++;
					if (MotorData[MotorNr].MotorRampDownCount > (UWORD)(30 * (-MotorData[MotorNr].MotorRampDownIncrement)))
					{
						MotorData[MotorNr].MotorRampDownCount = (UWORD)(20 * (-MotorData[MotorNr].MotorRampDownIncrement));
						MotorData[MotorNr].MotorTargetSpeed--;
					}
				}
			}
		}
		if ((MotorData[MotorNr].RegulationMode & REGSTATE_SYNCHRONE) && (MotorData[MotorNr].TurnParameter != 0))
		{
			call HplOutput.dOutputSyncTachoLimitControl(MotorNr);
			if (MotorData[MotorNr].MotorRunState == MOTOR_RUN_STATE_IDLE)
			{
				call HplOutput.dOutputMotorReachedTachoLimit(MotorNr);
			}
		}
		else
		{
			if (MotorData[MotorNr].MotorTargetSpeed > 0)
			{
				if (MotorData[MotorNr].CurrentCaptureCount >= MotorData[MotorNr].MotorTachoCountToRun)
				{
					call HplOutput.dOutputMotorReachedTachoLimit(MotorNr);
				}
			}
			else
			{
				if (MotorData[MotorNr].CurrentCaptureCount <= MotorData[MotorNr].MotorTachoCountToRun)
				{
					call HplOutput.dOutputMotorReachedTachoLimit(MotorNr);
				}
			}
		}
		if (MotorData[MotorNr].RegulationMode == REGSTATE_IDLE)
		{
			MotorData[MotorNr].MotorActualSpeed = MotorData[MotorNr].MotorTargetSpeed;
		}
	}

	/* Function used to tell whether the wanted position is obtained */
	command void HplOutput.dOutputTachoLimitControl(UBYTE MotorNr)
	{
		if (MotorData[MotorNr].MotorRunForever == 0)
		{
			if (MotorData[MotorNr].RegulationMode & REGSTATE_SYNCHRONE)
			{
				call HplOutput.dOutputSyncTachoLimitControl(MotorNr);
			}
			else
			{
				if (MotorData[MotorNr].MotorSetSpeed > 0)
				{
					if ((MotorData[MotorNr].CurrentCaptureCount >= MotorData[MotorNr].MotorTachoCountToRun))
					{
						MotorData[MotorNr].MotorRunState = MOTOR_RUN_STATE_IDLE;
						MotorData[MotorNr].RegulationMode = REGSTATE_IDLE;
					}
				}
				else
				{
					if (MotorData[MotorNr].MotorSetSpeed < 0)
					{
						if (MotorData[MotorNr].CurrentCaptureCount <= MotorData[MotorNr].MotorTachoCountToRun)
						{
							MotorData[MotorNr].MotorRunState = MOTOR_RUN_STATE_IDLE;
							MotorData[MotorNr].RegulationMode = REGSTATE_IDLE;
						}
					}
				}
			}
		}
		else
		{
			if (MotorData[MotorNr].CurrentCaptureCount > MAX_COUNT_TO_RUN)
			{
				MotorData[MotorNr].CurrentCaptureCount = 0;
			}
			if (MotorData[MotorNr].MotorTargetSpeed != 0)
			{
				MotorData[MotorNr].MotorTachoCountToRun = MotorData[MotorNr].CurrentCaptureCount;
			}
		}
		if (MotorData[MotorNr].RegulationMode == REGSTATE_IDLE)
		{
			MotorData[MotorNr].MotorActualSpeed = MotorData[MotorNr].MotorTargetSpeed;
		}
	}

	/* Function used to decrease speed slowly when the motor is set to idle */
	command void HplOutput.dOutputMotorIdleControl(UBYTE MotorNr)
	{
		INSERTMode(MotorNr, COAST_MOTOR_MODE);

		if (MotorData[MotorNr].MotorActualSpeed != 0)
		{
			if (MotorData[MotorNr].MotorActualSpeed > 0)
			{
				MotorData[MotorNr].MotorActualSpeed--;
			}
			else
			{
				MotorData[MotorNr].MotorActualSpeed++;
			}
		}

		if (MotorData[MotorNr].MotorTargetSpeed != 0)
		{
			if (MotorData[MotorNr].MotorTargetSpeed > 0)
			{
				MotorData[MotorNr].MotorTargetSpeed--;
			}
			else
			{
				MotorData[MotorNr].MotorTargetSpeed++;
			}
		}

		if (MotorData[MotorNr].MotorSetSpeed != 0)
		{
			if (MotorData[MotorNr].MotorSetSpeed > 0)
			{
				MotorData[MotorNr].MotorSetSpeed--;
			}
			else
			{
				MotorData[MotorNr].MotorSetSpeed++;
			}
		}
	}

	/* Function called to evaluate which regulation princip that need to run and which MotorNr to use (I.E.: Which motors are synched together)*/
	command void HplOutput.dOutputRegulateMotor(UBYTE MotorNr)
	{
		UBYTE SyncMotorOne;
		UBYTE SyncMotorTwo;

		if (MotorData[MotorNr].RegulationMode & REGSTATE_REGULATED)
		{
			call HplOutput.dOutputCalculateMotorPosition(MotorNr);
		}
		else
		{
			if (MotorData[MotorNr].RegulationMode & REGSTATE_SYNCHRONE)
			{
				call HplOutput.dOutputMotorSyncStatus(MotorNr, &SyncMotorOne, &SyncMotorTwo);

				if ((SyncMotorOne != 0xFF) &&(SyncMotorTwo != 0xFF))
				{
					call HplOutput.dOutputSyncMotorPosition(SyncMotorOne, SyncMotorTwo);
				}
			}
		}
	}

	/* Regulation function used when Position regulation is enabled */
	/* The regulation form only control one motor at a time */
	command void HplOutput.dOutputCalculateMotorPosition(UBYTE MotorNr)
	{
		SWORD PositionError;
		SWORD PValue;
		SWORD IValue;
		SWORD DValue;
		SWORD TotalRegValue;
		SWORD NewSpeedCount = 0;

		NewSpeedCount = (SWORD)((MotorData[MotorNr].MotorTargetSpeed * MAX_CAPTURE_COUNT)/INPUT_SCALE_FACTOR);

		PositionError = (SWORD)(MotorData[MotorNr].OldPositionError - MotorData[MotorNr].DeltaCaptureCount) + NewSpeedCount;

		//Overflow control on PositionError
		if (MotorData[MotorNr].RegPParameter != 0)
		{
			if (PositionError > (SWORD)(32000 / MotorData[MotorNr].RegPParameter))
			{
				PositionError = (SWORD)(32000 / MotorData[MotorNr].RegPParameter);
			}
			if (PositionError < (SWORD)(-(32000 / MotorData[MotorNr].RegPParameter)))
			{
				PositionError = (SWORD)(-(32000 / MotorData[MotorNr].RegPParameter));
			}
		}
		else
		{
			if (PositionError > (SWORD)32000)
			{
				PositionError = (SWORD)32000;
			}
			if (PositionError < (SWORD)-32000)
			{
				PositionError = (SWORD)-32000;
			}
		}

		PValue = PositionError * (SWORD)(MotorData[MotorNr].RegPParameter/REG_CONST_DIV);
		if (PValue > (SWORD)REG_MAX_VALUE)
		{
			PValue = REG_MAX_VALUE;
		}
		if (PValue <= (SWORD)REG_MIN_VALUE)
		{
			PValue = REG_MIN_VALUE;
		}

		DValue = (PositionError - MotorData[MotorNr].OldPositionError) * (SWORD)(MotorData[MotorNr].RegDParameter/REG_CONST_DIV);
		MotorData[MotorNr].OldPositionError = PositionError;

		MotorData[MotorNr].AccError = (MotorData[MotorNr].AccError * 3) + PositionError;
		MotorData[MotorNr].AccError = MotorData[MotorNr].AccError / 4;

		if (MotorData[MotorNr].AccError > (SWORD)800)
		{
			MotorData[MotorNr].AccError = 800;
		}
		if (MotorData[MotorNr].AccError <= (SWORD)-800)
		{
			MotorData[MotorNr].AccError = -800;
		}
		IValue = MotorData[MotorNr].AccError * (SWORD)(MotorData[MotorNr].RegIParameter/REG_CONST_DIV);

		if (IValue > (SWORD)REG_MAX_VALUE)
		{
			IValue = REG_MAX_VALUE;
		}
		if (IValue <= (SWORD)REG_MIN_VALUE)
		{
			IValue = REG_MIN_VALUE;
		}
		TotalRegValue = (SWORD)((PValue + IValue + DValue)/2);

		if (TotalRegValue > MAXIMUM_SPEED_FW)
		{
			TotalRegValue = MAXIMUM_SPEED_FW;
			MotorData[MotorNr].MotorOverloaded = 1;
		}
		if (TotalRegValue < MAXIMUM_SPEED_RW)
		{
			TotalRegValue = MAXIMUM_SPEED_RW;
			MotorData[MotorNr].MotorOverloaded = 1;
		}
		MotorData[MotorNr].MotorActualSpeed = (SBYTE)TotalRegValue;
	}

	/* Regulation function used when syncrhonization regulation is enabled */
	/* The regulation form controls two motors at a time */
	command void HplOutput.dOutputSyncMotorPosition(UBYTE MotorOne, UBYTE MotorTwo)
	{
		SLONG TempTurnParameter;
		SWORD PValue;
		SWORD IValue;
		SWORD DValue;
		SWORD CorrectionValue;
		SWORD MotorSpeed;

		SyncData.SyncTachoDif = (SLONG)((MotorData[MotorOne].MotorBlockTachoCount) - (MotorData[MotorTwo].MotorBlockTachoCount));

		if (MotorData[MotorOne].TurnParameter != 0)
		{
			if ((MotorData[MotorOne].MotorBlockTachoCount != 0) || (MotorData[MotorTwo].MotorBlockTachoCount))
			{
				if (MotorData[MotorOne].MotorTargetSpeed >= 0)
				{
					if (MotorData[MotorOne].TurnParameter > 0)
					{
						TempTurnParameter = (SLONG)(((SLONG)MotorData[MotorTwo].TurnParameter * (SLONG)MotorData[MotorTwo].MotorTargetSpeed)/100);
					}
					else
					{
						TempTurnParameter = (SLONG)(((SLONG)MotorData[MotorOne].TurnParameter * (SLONG)MotorData[MotorOne].MotorTargetSpeed)/100);
					}
				}
				else
				{
					if (MotorData[MotorOne].TurnParameter > 0)
					{
						TempTurnParameter = (SLONG)(((SLONG)MotorData[MotorOne].TurnParameter * (-(SLONG)MotorData[MotorOne].MotorTargetSpeed))/100);
					}
					else
					{
						TempTurnParameter = (SLONG)(((SLONG)MotorData[MotorTwo].TurnParameter * (-(SLONG)MotorData[MotorTwo].MotorTargetSpeed))/100);
					}
				}
			}
			else
			{
				TempTurnParameter = MotorData[MotorOne].TurnParameter;
			}
		}
		else
		{
			TempTurnParameter = 0;
		}

		SyncData.SyncTurnParameter += (SLONG)(((TempTurnParameter * (MAX_CAPTURE_COUNT))/INPUT_SCALE_FACTOR)*2);
		//SyncTurnParameter should ophold difference between the two motors.

		SyncData.SyncTachoDif += SyncData.SyncTurnParameter;

		if ((SWORD)SyncData.SyncTachoDif > 500)
		{
			SyncData.SyncTachoDif = 500;
		}
		if ((SWORD)SyncData.SyncTachoDif < -500)
		{
			SyncData.SyncTachoDif = -500;
		}

		PValue = (SWORD)SyncData.SyncTachoDif * (SWORD)(MotorData[MotorOne].RegPParameter/REG_CONST_DIV);

		DValue = ((SWORD)SyncData.SyncTachoDif - SyncData.SyncOldError) * (SWORD)(MotorData[MotorOne].RegDParameter/REG_CONST_DIV);
		SyncData.SyncOldError = (SWORD)SyncData.SyncTachoDif;

		SyncData.SyncAccError += (SWORD)SyncData.SyncTachoDif;

		if (SyncData.SyncAccError > (SWORD)900)
		{
			SyncData.SyncAccError = 900;
		}
		if (SyncData.SyncAccError < (SWORD)-900)
		{
			SyncData.SyncAccError = -900;
		}
		IValue = SyncData.SyncAccError * (SWORD)(MotorData[MotorOne].RegIParameter/REG_CONST_DIV);

		CorrectionValue = (SWORD)((PValue + IValue + DValue)/4);

		MotorSpeed = (SWORD)MotorData[MotorOne].MotorTargetSpeed - CorrectionValue;

		if (MotorSpeed > (SWORD)MAXIMUM_SPEED_FW)
		{
			MotorSpeed = MAXIMUM_SPEED_FW;
		}
		else
		{
			if (MotorSpeed < (SWORD)MAXIMUM_SPEED_RW)
			{
				MotorSpeed = MAXIMUM_SPEED_RW;
			}
		}

		if (MotorData[MotorOne].TurnParameter != 0)
		{
			if (MotorData[MotorOne].MotorTargetSpeed > 0)
			{
				if (MotorSpeed > (SWORD)MotorData[MotorOne].MotorTargetSpeed)
				{
					MotorSpeed = (SWORD)MotorData[MotorOne].MotorTargetSpeed;
				}
				else
				{
					if (MotorSpeed < (SWORD)-MotorData[MotorOne].MotorTargetSpeed)
					{
						MotorSpeed = -MotorData[MotorOne].MotorTargetSpeed;
					}
				}
			}
			else
			{
				if (MotorSpeed < (SWORD)MotorData[MotorOne].MotorTargetSpeed)
				{
					MotorSpeed = (SWORD)MotorData[MotorOne].MotorTargetSpeed;
				}
				else
				{
					if (MotorSpeed > (SWORD)-MotorData[MotorOne].MotorTargetSpeed)
					{
						MotorSpeed = -MotorData[MotorOne].MotorTargetSpeed;
					}
				}
			}
		}
		MotorData[MotorOne].MotorActualSpeed = (SBYTE)MotorSpeed;

		MotorSpeed = (SWORD)MotorData[MotorTwo].MotorTargetSpeed + CorrectionValue;

		if (MotorSpeed > (SWORD)MAXIMUM_SPEED_FW)
		{
			MotorSpeed = MAXIMUM_SPEED_FW;
		}
		else
		{
			if (MotorSpeed < (SWORD)MAXIMUM_SPEED_RW)
			{
				MotorSpeed = MAXIMUM_SPEED_RW;
			}
		}

		if (MotorData[MotorOne].TurnParameter != 0)
		{
			if (MotorData[MotorTwo].MotorTargetSpeed > 0)
			{
				if (MotorSpeed > (SWORD)MotorData[MotorTwo].MotorTargetSpeed)
				{
					MotorSpeed = (SWORD)MotorData[MotorTwo].MotorTargetSpeed;
				}
				else
				{
					if (MotorSpeed < (SWORD)-MotorData[MotorTwo].MotorTargetSpeed)
					{
						MotorSpeed = -MotorData[MotorTwo].MotorTargetSpeed;
					}
				}
			}
			else
			{
				if (MotorSpeed < (SWORD)MotorData[MotorTwo].MotorTargetSpeed)
				{
					MotorSpeed = (SWORD)MotorData[MotorTwo].MotorTargetSpeed;
				}
				else
				{
					if (MotorSpeed > (SWORD)-MotorData[MotorTwo].MotorTargetSpeed)
					{
						MotorSpeed = -MotorData[MotorTwo].MotorTargetSpeed;
					}
				}
			}
		}
		MotorData[MotorTwo].MotorActualSpeed = (SBYTE)MotorSpeed;
	}

	//Called when the motor is ramping down
	command void HplOutput.dOutputMotorReachedTachoLimit(UBYTE MotorNr)
	{
		UBYTE MotorOne, MotorTwo;

		if (MotorData[MotorNr].RegulationMode & REGSTATE_SYNCHRONE)
		{
			if (MotorNr == MOTOR_A)
			{
				MotorOne = MotorNr;
				MotorTwo = MotorOne + 1;
				if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
				{
					//Synchronise motor A & B
					MotorData[MotorOne].MotorSetSpeed = 0;
					MotorData[MotorOne].MotorTargetSpeed = 0;
					MotorData[MotorOne].MotorActualSpeed = 0;
					MotorData[MotorOne].MotorRunState = MOTOR_RUN_STATE_IDLE;
					MotorData[MotorOne].RegulationMode = REGSTATE_IDLE;
					MotorData[MotorTwo].MotorSetSpeed = 0;
					MotorData[MotorTwo].MotorTargetSpeed = 0;
					MotorData[MotorTwo].MotorActualSpeed = 0;
					MotorData[MotorTwo].MotorRunState = MOTOR_RUN_STATE_IDLE;
					MotorData[MotorTwo].RegulationMode = REGSTATE_IDLE;
				}
				else
				{
					MotorTwo = MotorOne + 2;
					if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
					{
						//Synchronise motor A & C
						MotorData[MotorOne].MotorSetSpeed = 0;
						MotorData[MotorOne].MotorTargetSpeed = 0;
						MotorData[MotorOne].MotorActualSpeed = 0;
						MotorData[MotorOne].MotorRunState = MOTOR_RUN_STATE_IDLE;
						MotorData[MotorOne].RegulationMode = REGSTATE_IDLE;
						MotorData[MotorTwo].MotorSetSpeed = 0;
						MotorData[MotorTwo].MotorTargetSpeed = 0;
						MotorData[MotorTwo].MotorActualSpeed = 0;
						MotorData[MotorTwo].MotorRunState = MOTOR_RUN_STATE_IDLE;
						MotorData[MotorTwo].RegulationMode = REGSTATE_IDLE;
					}
					else
					{
						//Only Motor A has Sync setting => Stop normal
						MotorData[MotorNr].MotorSetSpeed = 0;
						MotorData[MotorNr].MotorTargetSpeed = 0;
						MotorData[MotorNr].MotorActualSpeed = 0;
						MotorData[MotorNr].MotorRunState = MOTOR_RUN_STATE_IDLE;
						MotorData[MotorNr].RegulationMode = REGSTATE_IDLE;
					}
				}
			}
			if (MotorNr == MOTOR_B)
			{
				MotorOne = MotorNr;
				MotorTwo = MotorOne - 1;
				if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
				{
					//Synchronise motor A & B
					MotorData[MotorOne].MotorSetSpeed = 0;
					MotorData[MotorOne].MotorTargetSpeed = 0;
					MotorData[MotorOne].MotorActualSpeed = 0;
					MotorData[MotorOne].MotorRunState = MOTOR_RUN_STATE_IDLE;
					MotorData[MotorOne].RegulationMode = REGSTATE_IDLE;
					MotorData[MotorTwo].MotorSetSpeed = 0;
					MotorData[MotorTwo].MotorTargetSpeed = 0;
					MotorData[MotorTwo].MotorActualSpeed = 0;
					MotorData[MotorTwo].MotorRunState = MOTOR_RUN_STATE_IDLE;
					MotorData[MotorTwo].RegulationMode = REGSTATE_IDLE;
				}
				MotorTwo = MotorOne + 1;
				if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
				{
					//Synchronise motor B & C
					MotorData[MotorOne].MotorSetSpeed = 0;
					MotorData[MotorOne].MotorTargetSpeed = 0;
					MotorData[MotorOne].MotorActualSpeed = 0;
					MotorData[MotorOne].MotorRunState = MOTOR_RUN_STATE_IDLE;
					MotorData[MotorOne].RegulationMode = REGSTATE_IDLE;
					MotorData[MotorTwo].MotorSetSpeed = 0;
					MotorData[MotorTwo].MotorTargetSpeed = 0;
					MotorData[MotorTwo].MotorActualSpeed = 0;
					MotorData[MotorTwo].MotorRunState = MOTOR_RUN_STATE_IDLE;
					MotorData[MotorTwo].RegulationMode = REGSTATE_IDLE;
				}
				else
				{
					//Only Motor B has Sync settings => Stop normal
					MotorData[MotorNr].MotorSetSpeed = 0;
					MotorData[MotorNr].MotorTargetSpeed = 0;
					MotorData[MotorNr].MotorActualSpeed = 0;
					MotorData[MotorNr].MotorRunState = MOTOR_RUN_STATE_IDLE;
					MotorData[MotorNr].RegulationMode = REGSTATE_IDLE;
				}
			}
			if (MotorNr == MOTOR_C)
			{
				MotorOne = MotorNr;
				MotorTwo = MotorOne - 2;
				if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
				{
					//Synchronise motor A & C
					MotorData[MotorOne].MotorSetSpeed = 0;
					MotorData[MotorOne].MotorTargetSpeed = 0;
					MotorData[MotorOne].MotorActualSpeed = 0;
					MotorData[MotorOne].MotorRunState = MOTOR_RUN_STATE_IDLE;
					MotorData[MotorOne].RegulationMode = REGSTATE_IDLE;
					MotorData[MotorTwo].MotorSetSpeed = 0;
					MotorData[MotorTwo].MotorTargetSpeed = 0;
					MotorData[MotorTwo].MotorActualSpeed = 0;
					MotorData[MotorTwo].MotorRunState = MOTOR_RUN_STATE_IDLE;
					MotorData[MotorTwo].RegulationMode = REGSTATE_IDLE;
				}
				MotorTwo = MotorOne - 1;
				if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
				{
					//Synchronise motor B & C
					MotorData[MotorOne].MotorSetSpeed = 0;
					MotorData[MotorOne].MotorTargetSpeed = 0;
					MotorData[MotorOne].MotorActualSpeed = 0;
					MotorData[MotorOne].MotorRunState = MOTOR_RUN_STATE_IDLE;
					MotorData[MotorOne].RegulationMode = REGSTATE_IDLE;
					MotorData[MotorTwo].MotorSetSpeed = 0;
					MotorData[MotorTwo].MotorTargetSpeed = 0;
					MotorData[MotorTwo].MotorActualSpeed = 0;
					MotorData[MotorTwo].MotorRunState = MOTOR_RUN_STATE_IDLE;
					MotorData[MotorTwo].RegulationMode = REGSTATE_IDLE;
				}
				else
				{
					//Only Motor C has Sync settings => Stop normal
					MotorData[MotorNr].MotorSetSpeed = 0;
					MotorData[MotorNr].MotorTargetSpeed = 0;
					MotorData[MotorNr].MotorActualSpeed = 0;
					MotorData[MotorNr].MotorRunState = MOTOR_RUN_STATE_IDLE;
					MotorData[MotorNr].RegulationMode = REGSTATE_IDLE;
				}
			}
		}
		else
		{
			if (MotorData[MotorNr].MotorSetSpeed == 0)
			{
				MotorData[MotorNr].MotorSetSpeed = 0;
				MotorData[MotorNr].MotorTargetSpeed = 0;
				MotorData[MotorNr].MotorActualSpeed = 0;
			}
			MotorData[MotorNr].MotorRunState = MOTOR_RUN_STATE_IDLE;
			MotorData[MotorNr].RegulationMode = REGSTATE_IDLE;
		}
	}

	/* Function used for control tacho limit when motors are synchronised */
	/* Special control is needed when the motor are turning */
	command void HplOutput.dOutputSyncTachoLimitControl(UBYTE MotorNr)
	{
		UBYTE MotorOne, MotorTwo;

		if (MotorNr == MOTOR_A)
		{
			MotorOne = MotorNr;
			MotorTwo = MotorOne + 1;
			if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
			{
				//Synchronise motor A & B
			}
			else
			{
				MotorTwo = MotorOne + 2;
				if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
				{
					//Synchronise motor A & C
				}
				else
				{
					//Only Motor A has Sync setting => Stop normal
					MotorOne = 0xFF;
					MotorTwo = 0xFF;
				}
			}
		}
		if (MotorNr == MOTOR_B)
		{
			MotorOne = MotorNr;
			MotorTwo = MotorOne - 1;
			if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
			{
				//Synchronise motor A & B, which has already been called when running throught motor A
				//MotorOne = 0xFF;
				//MotorTwo = 0xFF;
			}
			else
			{
				MotorTwo = MotorOne + 1;
				if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
				{
					//Synchronise motor B & C
				}
				else
				{
					//Only Motor B has Sync settings => Stop normal
					MotorOne = 0xFF;
					MotorTwo = 0xFF;
				}
			}
		}
		if (MotorNr == MOTOR_C)
		{
			MotorOne = MotorNr;
			MotorTwo = MotorOne - 2;
			if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
			{
				//Synchronise motor A & C, which has already been called when running throught motor A
				//MotorOne = 0xFF;
				//MotorTwo = 0xFF;
			}
			else
			{
				MotorTwo = MotorOne - 1;
				if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
				{
					//Synchronise motor B & C, which has already been called when running throught motor B
					//MotorOne = 0xFF;
					//MotorTwo = 0xFF;
				}
				else
				{
					//Only Motor C has Sync settings => Stop normal
					MotorOne = 0xFF;
					MotorTwo = 0xFF;
				}
			}
		}

		if ((MotorOne != 0xFF) && (MotorTwo != 0xFF))
		{
			if (MotorData[MotorOne].TurnParameter != 0)
			{
				if (MotorData[MotorOne].TurnParameter > 0)
				{
					if (MotorData[MotorTwo].MotorTargetSpeed >= 0)
					{
						if ((SLONG)(MotorData[MotorTwo].CurrentCaptureCount >= MotorData[MotorTwo].MotorTachoCountToRun))
						{
							MotorData[MotorOne].MotorRunState = MOTOR_RUN_STATE_IDLE;
							MotorData[MotorTwo].MotorRunState = MOTOR_RUN_STATE_IDLE;

							MotorData[MotorOne].CurrentCaptureCount = MotorData[MotorTwo].CurrentCaptureCount;
							MotorData[MotorOne].MotorTachoCountToRun = MotorData[MotorTwo].MotorTachoCountToRun;
						}
					}
					else
					{
						if ((SLONG)(MotorData[MotorOne].CurrentCaptureCount <= MotorData[MotorOne].MotorTachoCountToRun))
						{
							MotorData[MotorOne].MotorRunState = MOTOR_RUN_STATE_IDLE;
							MotorData[MotorTwo].MotorRunState = MOTOR_RUN_STATE_IDLE;

							MotorData[MotorTwo].CurrentCaptureCount = MotorData[MotorOne].CurrentCaptureCount;
							MotorData[MotorTwo].MotorTachoCountToRun = MotorData[MotorOne].MotorTachoCountToRun;
						}
					}
				}
				else
				{
					if (MotorData[MotorOne].MotorTargetSpeed >= 0)
					{
						if ((SLONG)(MotorData[MotorOne].CurrentCaptureCount >= MotorData[MotorOne].MotorTachoCountToRun))
						{
							MotorData[MotorOne].MotorRunState = MOTOR_RUN_STATE_IDLE;
							MotorData[MotorTwo].MotorRunState = MOTOR_RUN_STATE_IDLE;

							MotorData[MotorTwo].CurrentCaptureCount = MotorData[MotorOne].CurrentCaptureCount;
							MotorData[MotorTwo].MotorTachoCountToRun = MotorData[MotorOne].MotorTachoCountToRun;
						}
					}
					else
					{
						if ((SLONG)(MotorData[MotorTwo].CurrentCaptureCount <= MotorData[MotorTwo].MotorTachoCountToRun))
						{
							MotorData[MotorOne].MotorRunState = MOTOR_RUN_STATE_IDLE;
							MotorData[MotorTwo].MotorRunState = MOTOR_RUN_STATE_IDLE;

							MotorData[MotorOne].CurrentCaptureCount = MotorData[MotorTwo].CurrentCaptureCount;
							MotorData[MotorOne].MotorTachoCountToRun = MotorData[MotorTwo].MotorTachoCountToRun;
						}
					}
				}
			}
			else
			{
				if (MotorData[MotorOne].MotorSetSpeed > 0)
				{
					if ((MotorData[MotorOne].CurrentCaptureCount >= MotorData[MotorOne].MotorTachoCountToRun) || (MotorData[MotorTwo].CurrentCaptureCount >= MotorData[MotorTwo].MotorTachoCountToRun))
					{
						MotorData[MotorOne].MotorRunState = MOTOR_RUN_STATE_IDLE;
						MotorData[MotorTwo].MotorRunState = MOTOR_RUN_STATE_IDLE;
					}
				}
				else
				{
					if (MotorData[MotorOne].MotorSetSpeed < 0)
					{
						if ((MotorData[MotorOne].CurrentCaptureCount <= MotorData[MotorOne].MotorTachoCountToRun) || (MotorData[MotorTwo].CurrentCaptureCount <= MotorData[MotorTwo].MotorTachoCountToRun))
						{
							MotorData[MotorOne].MotorRunState = MOTOR_RUN_STATE_IDLE;
							MotorData[MotorTwo].MotorRunState = MOTOR_RUN_STATE_IDLE;
						}
					}
				}
			}
		}
	}

	/* Function which can evaluate which motor are synched */
	command void HplOutput.dOutputMotorSyncStatus(UBYTE MotorNr, UBYTE *SyncMotorOne, UBYTE *SyncMotorTwo)
	{
		if (MotorNr < MOTOR_C)
		{
			if (MotorNr == MOTOR_A)
			{
				*SyncMotorOne = MotorNr;
				*SyncMotorTwo = *SyncMotorOne + 1;
				if (MotorData[*SyncMotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
				{
					//Synchronise motor A & B
				}
				else
				{
					*SyncMotorTwo = *SyncMotorOne + 2;
					if (MotorData[*SyncMotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
					{
						//Synchronise motor A & C
					}
					else
					{
						//Only Motor A has Sync setting => Do nothing, treat motor as motor without regulation
						*SyncMotorTwo = 0xFF;
					}
				}
			}
			if (MotorNr == MOTOR_B)
			{
				*SyncMotorOne = MotorNr;
				*SyncMotorTwo = *SyncMotorOne + 1;
				if (MotorData[*SyncMotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
				{
					if (!(MotorData[MOTOR_A].RegulationMode & REGSTATE_SYNCHRONE))
					{
						//Synchronise motor B & C
					}
				}
				else
				{
					//Only Motor B has Sync settings or Motor is sync. with Motor A and has therefore already been called
					*SyncMotorTwo = 0xFF;
				}
			}
		}
		else
		{
			*SyncMotorOne = 0xFF;
			*SyncMotorTwo = 0xFF;
		}
	}
	/* Function which is called when motors are synchronized and the motor position is reset */
	command void HplOutput.dOutputResetSyncMotors(UBYTE MotorNr)
	{
		UBYTE MotorOne, MotorTwo;

		if (MotorNr == MOTOR_A)
		{
			MotorOne = MotorNr;
			MotorTwo = MotorOne + 1;
			if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
			{
				//Synchronise motor A & B
			}
			else
			{
				MotorTwo = MotorOne + 2;
				if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
				{
					//Synchronise motor A & C
				}
				else
				{
					//Only Motor A has Sync setting => Stop normal
					MotorOne = 0xFF;
					MotorTwo = 0xFF;
				}
			}
		}
		if (MotorNr == MOTOR_B)
		{
			MotorOne = MotorNr;
			MotorTwo = MotorOne - 1;
			if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
			{
				//Synchronise motor A & B
			}
			else
			{
				MotorTwo = MotorOne + 1;
				if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
				{
					//Synchronise motor B & C
				}
				else
				{
					//Only Motor B has Sync settings => Stop normal
					MotorOne = 0xFF;
					MotorTwo = 0xFF;
				}
			}
		}
		if (MotorNr == MOTOR_C)
		{
			MotorOne = MotorNr;
			MotorTwo = MotorOne - 2;
			if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
			{
				//Synchronise motor A & C
			}
			else
			{
				MotorTwo = MotorOne - 1;
				if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
				{
					//Synchronise motor B & C
				}
				else
				{
					//Only Motor C has Sync settings => Stop normal
					MotorOne = 0xFF;
					MotorTwo = 0xFF;
				}
			}
		}

		if ((MotorOne != 0xFF) && (MotorTwo != 0xFF))
		{
			MotorData[MotorOne].CurrentCaptureCount = 0;
			MotorData[MotorOne].MotorTachoCountToRun = 0;
			MotorData[MotorTwo].CurrentCaptureCount = 0;
			MotorData[MotorTwo].MotorTachoCountToRun = 0;
		}
		else
		{
			MotorData[MotorNr].CurrentCaptureCount = 0;
			MotorData[MotorNr].MotorTachoCountToRun = 0;
		}
	}

	/* Function which is called when motors are synchronized and motor is ramping down */
	command void HplOutput.dOutputRampDownSynch(UBYTE MotorNr)
	{
		UBYTE MotorOne, MotorTwo;

		if (MotorNr == MOTOR_A)
		{
			MotorOne = MotorNr;
			MotorTwo = MotorOne + 1;
			if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
			{
				//Synchronise motor A & B
			}
			else
			{
				MotorTwo = MotorOne + 2;
				if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
				{
					//Synchronise motor A & C
				}
				else
				{
					//Only Motor A has Sync setting => Stop normal
					MotorOne = 0xFF;
					MotorTwo = 0xFF;
				}
			}
		}
		if (MotorNr == MOTOR_B)
		{
			MotorOne = MotorNr;
			MotorTwo = MotorOne - 1;
			if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
			{
				//Synchronise motor A & B, which has already been called when running throught motor A
				//MotorOne = 0xFF;
				//MotorTwo = 0xFF;
			}
			else
			{
				MotorTwo = MotorOne + 1;
				if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
				{
					//Synchronise motor B & C
				}
				else
				{
					//Only Motor B has Sync settings => Stop normal
					MotorOne = 0xFF;
					MotorTwo = 0xFF;
				}
			}
		}
		if (MotorNr == MOTOR_C)
		{
			MotorOne = MotorNr;
			MotorTwo = MotorOne - 2;
			if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
			{
				//Synchronise motor A & C, which has already been called when running throught motor A
			}
			else
			{
				MotorTwo = MotorOne - 1;
				if (MotorData[MotorTwo].RegulationMode & REGSTATE_SYNCHRONE)
				{
					//Synchronise motor B & C,, which has already been called when running throught motor B
				}
				else
				{
					//Only Motor C has Sync settings => Stop normal
					MotorOne = 0xFF;
					MotorTwo = 0xFF;
				}
			}
		}

		if ((MotorOne != 0xFF) && (MotorTwo != 0xFF))
		{
			if (MotorData[MotorOne].TurnParameter != 0)
			{
				if (MotorData[MotorOne].TurnParameter > 0)
				{
					if (MotorData[MotorOne].MotorTargetSpeed >= 0)
					{
						if (MotorData[MotorTwo].MotorActualSpeed < 0)
						{
							MotorData[MotorTwo].MotorTargetSpeed--;
						}
					}
					else
					{
						if (MotorData[MotorTwo].MotorActualSpeed > 0)
						{
							MotorData[MotorTwo].MotorTargetSpeed++;
						}
					}
				}
				else
				{
					if (MotorData[MotorOne].MotorTargetSpeed >= 0)
					{
						if (MotorData[MotorTwo].MotorActualSpeed < 0)
						{
							MotorData[MotorTwo].MotorTargetSpeed--;
						}
					}
					else
					{
						if (MotorData[MotorTwo].MotorActualSpeed > 0)
						{
							MotorData[MotorTwo].MotorTargetSpeed++;
						}
					}
				}
			}
		}
	}

}
