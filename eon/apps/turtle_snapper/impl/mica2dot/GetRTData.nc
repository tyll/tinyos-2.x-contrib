configuration GetRTData
{
  provides
  {
    interface StdControl;
    interface IGetRTData;
  }
}
implementation
{
  components GetRTDataM;

  StdControl = GetRTDataM.StdControl;
  IGetRTData = GetRTDataM.IGetRTData;
}
