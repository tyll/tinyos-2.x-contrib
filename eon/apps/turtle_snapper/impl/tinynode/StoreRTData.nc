configuration StoreRTData
{
  provides
  {
    interface StdControl;
    interface IStoreRTData;
  }
}
implementation
{
	components StoreRTDataM, SequenceMgrC, BitVecM, SrcAccumC;

  StdControl = StoreRTDataM.StdControl;
  IStoreRTData = StoreRTDataM.IStoreRTData;
  
  
  
  StoreRTDataM.BitVec -> BitVecM.BitVec;
  StoreRTDataM.IAccum -> SrcAccumC.IAccum;
  StoreRTDataM.getNextSeq -> SequenceMgrC.getNextSeq;
  
} 

