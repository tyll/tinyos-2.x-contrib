configuration GPSError
{
  provides
  {
    interface StdControl;
    interface IGPSError;
    interface IEnergyCost;
  }
}
implementation
{
  components GPSErrorM;

  StdControl = GPSErrorM.StdControl;
  IGPSError = GPSErrorM.IGPSError;
  IEnergyCost = GPSErrorM.IEnergyCost;
}
