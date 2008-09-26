configuration GetNextChunkMsg
{
  provides
  {
    interface StdControl;
    interface IGetNextChunkMsg;
  }
}
implementation
{
  components GetNextChunkMsgM, FlashStore, RadioComm, NoLeds as Leds;

  StdControl = RadioComm;
  StdControl = GetNextChunkMsgM.StdControl;
  
  IGetNextChunkMsg = GetNextChunkMsgM.IGetNextChunkMsg;
  
  GetNextChunkMsgM.MyIndex -> FlashStore.MyIndex;
  GetNextChunkMsgM.SendMsg -> RadioComm.SendMsg[AM_BUNDLE_INDEX_ACK];
  GetNextChunkMsgM.SingleStream -> FlashStore.SingleStream;
  GetNextChunkMsgM.Leds -> Leds;
}
