

configuration GPRSSend
{
	provides
	{
		interface StdControl;
		interface IGPRSSend;
	}
}
implementation
{
  components GPRSSendM, GPRSModem, TimerC, AckStoreC, ObjLogC, SrcAccumC; 
	components RadioComm;
  
  StdControl = TimerC.StdControl;
  StdControl = GPRSSendM.StdControl;
  
  IGPRSSend = GPRSSendM.IGPRSSend;
  GPRSSendM.GPRS -> GPRSModem.GPRS;
  
  GPRSSendM.ModemControl -> GPRSModem.StdControl;

  GPRSSendM.Timer -> TimerC.Timer[unique("Timer")];
  GPRSSendM.AckStore -> AckStoreC.AckStore;
  GPRSSendM.ObjLog -> ObjLogC.ObjLog[unique("ObjLog")];
  GPRSSendM.SendMsg -> RadioComm.SendMsg[45];
  GPRSSendM.IAccum -> SrcAccumC.IAccum;
}
