#include  "c_output.iom"
#include  "c_output.h"
#include  "d_output.h"

module HalOutputP {
	provides {
		interface HalOutput;
	}
	uses {
	  interface HplOutput;
	  interface Boot;
  }
}
implementation{

	IOMAPOUTPUT   IOMapOutput;
	VARSOUTPUT    VarsOutput;

/*
	const     HEADER       cOutput =
	{
		0x00020001L,
		"Output",
		cOutputInit,
		cOutputCtrl,
		cOutputExit,
		(void *)&IOMapOutput,
		(void *)&VarsOutput,
		(UWORD)sizeof(IOMapOutput),
		(UWORD)sizeof(VarsOutput),
		0x0000                      //Code size - not used so far
	};
*/
  void cOutputInit();  
  
  event void Boot.booted() {
		  cOutputInit();
  }

	void      cOutputInit()//void* pHeader)
	{
		UBYTE   Tmp;

		for(Tmp = 0; Tmp < NO_OF_OUTPUTS; Tmp++)
		{
			IOMapOutput.Outputs[Tmp].Mode  = 0x00;
			IOMapOutput.Outputs[Tmp].Speed = 0x00;
			IOMapOutput.Outputs[Tmp].ActualSpeed = 0x00;
			IOMapOutput.Outputs[Tmp].TachoCnt = 0x00;
			IOMapOutput.Outputs[Tmp].RunState = 0x00;
			IOMapOutput.Outputs[Tmp].TachoLimit = 0x00;
			IOMapOutput.Outputs[Tmp].RegPParameter = DEFAULT_P_GAIN_FACTOR;
			IOMapOutput.Outputs[Tmp].RegIParameter = DEFAULT_I_GAIN_FACTOR;
			IOMapOutput.Outputs[Tmp].RegDParameter = DEFAULT_D_GAIN_FACTOR;
		}
		VarsOutput.TimeCnt = 0;
		call HplOutput.dOutputInit();
	}

	void cOutputCtrl()
	{
		UBYTE Tmp;

		for(Tmp = 0; Tmp < NO_OF_OUTPUTS; Tmp++)
		{
			if (IOMapOutput.Outputs[Tmp].Flags != 0)
			{
				if (IOMapOutput.Outputs[Tmp].Flags & UPDATE_RESET_ROTATION_COUNT)
				{
					IOMapOutput.Outputs[Tmp].Flags &= ~UPDATE_RESET_ROTATION_COUNT;
					call HplOutput.dOutputResetRotationCaptureCount(Tmp);
				}
				if (IOMapOutput.Outputs[Tmp].Flags & UPDATE_RESET_COUNT)
				{
					IOMapOutput.Outputs[Tmp].Flags &= ~UPDATE_RESET_COUNT;
					call HplOutput.dOutputResetTachoLimit(Tmp);
				}
				if (IOMapOutput.Outputs[Tmp].Flags & UPDATE_RESET_BLOCK_COUNT)
				{
					IOMapOutput.Outputs[Tmp].Flags &= ~UPDATE_RESET_BLOCK_COUNT;
					call HplOutput.dOutputResetBlockTachoLimit(Tmp);
				}
				if (IOMapOutput.Outputs[Tmp].Flags & UPDATE_SPEED)
				{
					IOMapOutput.Outputs[Tmp].Flags &= ~UPDATE_SPEED;
					if (IOMapOutput.Outputs[Tmp].Mode & MOTORON)
					{
						call HplOutput.dOutputSetSpeed (Tmp, IOMapOutput.Outputs[Tmp].RunState, IOMapOutput.Outputs[Tmp].Speed, IOMapOutput.Outputs[Tmp].SyncTurnParameter);
					}
				}
				if (IOMapOutput.Outputs[Tmp].Flags & UPDATE_TACHO_LIMIT)
				{
					IOMapOutput.Outputs[Tmp].Flags &= ~UPDATE_TACHO_LIMIT;
					call HplOutput.dOutputSetTachoLimit(Tmp, IOMapOutput.Outputs[Tmp].TachoLimit);
				}
				if (IOMapOutput.Outputs[Tmp].Flags & UPDATE_MODE)
				{
					IOMapOutput.Outputs[Tmp].Flags &= ~UPDATE_MODE;
					if (IOMapOutput.Outputs[Tmp].Mode & BRAKE)
					{
						// Motor is Braked
						call HplOutput.dOutputSetMode(Tmp, BRAKE);
					}
					else
					{
						// Motor is floated
						call HplOutput.dOutputSetMode(Tmp, 0x00);
					}
					if (IOMapOutput.Outputs[Tmp].Mode & MOTORON)
					{
						if (IOMapOutput.Outputs[Tmp].Mode & REGULATED)
						{
							call HplOutput.dOutputEnableRegulation(Tmp, IOMapOutput.Outputs[Tmp].RegMode);
						}
						else
						{
							call HplOutput.dOutputDisableRegulation(Tmp);
						}
					}
					else
					{
						call HplOutput.dOutputSetSpeed(Tmp, 0x00, 0x00, 0x00);
						call HplOutput.dOutputDisableRegulation(Tmp);
					}
				}
				if (IOMapOutput.Outputs[Tmp].Flags & UPDATE_PID_VALUES)
				{
					IOMapOutput.Outputs[Tmp].Flags &= ~UPDATE_PID_VALUES;
					call HplOutput.dOutputSetPIDParameters(Tmp, IOMapOutput.Outputs[Tmp].RegPParameter, IOMapOutput.Outputs[Tmp].RegIParameter, IOMapOutput.Outputs[Tmp].RegDParameter);
				}
			}
		}
		call HplOutput.dOutputCtrl();
		call HalOutput.cOutputUpdateIomap();
	}

	command void HalOutput.cOutputUpdateIomap()
	{
		UBYTE TempCurrentMotorSpeed[NO_OF_OUTPUTS];
		UBYTE TempRunState[NO_OF_OUTPUTS];
		UBYTE TempMotorOverloaded[NO_OF_OUTPUTS];
		SLONG TempTachoCount[NO_OF_OUTPUTS];
		SLONG TempBlockTachoCount[NO_OF_OUTPUTS];
		SLONG TempRotationCount[NO_OF_OUTPUTS];

		UBYTE Tmp;

		call HplOutput.dOutputGetMotorParameters(TempCurrentMotorSpeed, TempTachoCount, TempBlockTachoCount, TempRunState, TempMotorOverloaded,TempRotationCount);

		for(Tmp = 0; Tmp < NO_OF_OUTPUTS; Tmp++)
		{
			IOMapOutput.Outputs[Tmp].ActualSpeed = TempCurrentMotorSpeed[Tmp];
			IOMapOutput.Outputs[Tmp].TachoCnt = TempTachoCount[Tmp];
			IOMapOutput.Outputs[Tmp].BlockTachoCount = TempBlockTachoCount[Tmp];
			IOMapOutput.Outputs[Tmp].RotationCount = TempRotationCount[Tmp];
			IOMapOutput.Outputs[Tmp].Overloaded = TempMotorOverloaded[Tmp];
			if (!(IOMapOutput.Outputs[Tmp].Flags & PENDING_UPDATES))
			{
				IOMapOutput.Outputs[Tmp].RunState = TempRunState[Tmp];
			}
		}
	}

	void      cOutputExit()
	{
		call HplOutput.dOutputExit();
	}
}
