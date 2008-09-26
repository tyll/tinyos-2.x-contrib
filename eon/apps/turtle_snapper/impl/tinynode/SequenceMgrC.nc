


configuration SequenceMgrC
{
  provides 
  	{
		command uint16_t getNextSeq();
	}
}
implementation
{
  components Main, SequenceMgrM, TimerC, InternalFlashC;

	getNextSeq = SequenceMgrM.getNextSeq;
  	Main.StdControl -> TimerC;
  
  	SequenceMgrM.Timer -> TimerC.Timer[unique("Timer")];
	SequenceMgrM.InternalFlash -> InternalFlashC;
	
}
