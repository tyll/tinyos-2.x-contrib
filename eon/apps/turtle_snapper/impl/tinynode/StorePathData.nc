configuration StorePathData
{
  provides
  {
    interface StdControl;
    interface IStorePathData;
  }
}
implementation
{
	components StorePathDataM, SequenceMgrC, BitVecM, RuntimeM;

  StdControl = StorePathDataM.StdControl;
  IStorePathData = StorePathDataM.IStorePathData;
  
  
  StorePathDataM.IPathDone -> RuntimeM.IPathDone;
  StorePathDataM.BitVec -> BitVecM.BitVec;
  StorePathDataM.getNextSeq -> SequenceMgrC.getNextSeq;
  
} 

