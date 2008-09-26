configuration StoreGPSData
{
  provides
  {
    interface StdControl;
    interface IStoreGPSData;
  }
}
implementation
{
	components StoreGPSDataM, SequenceMgrC, BitVecM;

  StdControl = StoreGPSDataM.StdControl;
  IStoreGPSData = StoreGPSDataM.IStoreGPSData;
  
  StoreGPSDataM.BitVec -> BitVecM.BitVec;
  
  StoreGPSDataM.getNextSeq -> SequenceMgrC.getNextSeq;
  
} 

