configuration TxOp
{
  provides
  {
    interface StdControl;
    interface ITxOp;
  }
}
implementation
{
  components TxOpM, ConnMgrC;

  StdControl = TxOpM.StdControl;
  ITxOp = TxOpM.ITxOp;
  
  TxOpM.TxTime -> ConnMgrC.TxTime;
}
