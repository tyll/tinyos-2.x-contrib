interface HplOutput {

	command void dOutputInit();
	command void dOutputExit();

	command void dOutputCtrl();
	command void dOutputGetMotorParameters(UBYTE *CurrentMotorSpeed, SLONG *TachoCount, SLONG *BlockTachoCount, UBYTE *RunState, UBYTE *MotorOverloaded, SLONG *RotationCount);
	command void dOutputSetMode(UBYTE Motor, UBYTE Mode);
	command void dOutputSetSpeed (UBYTE MotorNr, UBYTE NewMotorRunState, SBYTE Speed, SBYTE TurnParameter);
	command void dOutputEnableRegulation(UBYTE Motor, UBYTE RegulationMode);
	command void dOutputDisableRegulation(UBYTE Motor);
	command void dOutputSetTachoLimit(UBYTE Motor, ULONG TachoCntToTravel);
	command void dOutputResetTachoLimit(UBYTE Motor);
	command void dOutputResetBlockTachoLimit(UBYTE Motor);
	command void dOutputResetRotationCaptureCount(UBYTE MotorNr);
	command void dOutputSetPIDParameters(UBYTE Motor, UBYTE NewRegPParameter, UBYTE NewRegIParameter, UBYTE NewRegDParameter); 

	command void dOutputRegulateMotor(UBYTE MotorNr);
	//command void dOutputCalculateRampUpParameter(UBYTE MotorNr, ULONG NewTachoLimit);
	command void dOutputRampDownFunction(UBYTE MotorNr);
	command void dOutputRampUpFunction(UBYTE MotorNr);
	command void dOutputTachoLimitControl(UBYTE MotorNr);
	command void dOutputCalculateMotorPosition(UBYTE MotorNr);
	command void dOutputSyncMotorPosition(UBYTE MotorOne, UBYTE MotorTwo);
	command void dOutputMotorReachedTachoLimit(UBYTE MotorNr);
	command void dOutputMotorIdleControl(UBYTE MotorNr);
	command void dOutputSyncTachoLimitControl(UBYTE MotorNr);
	command void dOutputMotorSyncStatus(UBYTE MotorNr, UBYTE *SyncMotorOne, UBYTE *SyncMotorTwo);
	command void dOutputResetSyncMotors(UBYTE MotorNr);
	
	command void dOutputRampDownSynch(UBYTE MotorNr);
}
