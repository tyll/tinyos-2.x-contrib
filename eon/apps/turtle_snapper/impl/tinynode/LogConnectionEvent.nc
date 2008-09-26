configuration LogConnectionEvent
{
  provides
  {
    interface StdControl;
    interface ILogConnectionEvent;
  }
}
implementation
{
  components LogConnectionEventM, BitVecM, SequenceMgrC;

  StdControl = LogConnectionEventM.StdControl;
  ILogConnectionEvent = LogConnectionEventM.ILogConnectionEvent;
  
  LogConnectionEventM.BitVec -> BitVecM.BitVec;
  LogConnectionEventM.getNextSeq -> SequenceMgrC.getNextSeq;
}
