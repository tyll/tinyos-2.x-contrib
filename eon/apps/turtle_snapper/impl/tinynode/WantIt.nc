configuration WantIt
{
  provides
  {
    interface StdControl;
    interface IWantIt;
  }
}
implementation
{
  components WantItM, ConnMgrC;

  StdControl = WantItM.StdControl;
  IWantIt = WantItM.IWantIt;
  
  WantItM.ConnMgr -> ConnMgrC.ConnMgr;
  
}
