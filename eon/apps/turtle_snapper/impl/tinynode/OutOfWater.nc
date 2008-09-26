configuration OutOfWater
{
  provides
  {
    interface StdControl;
    interface IOutOfWater;
  }
}
implementation
{
  components OutOfWaterM, TimerC, Water;

  StdControl = OutOfWaterM.StdControl;
  StdControl = TimerC.StdControl;
  StdControl = Water.StdControl;
  
  IOutOfWater = OutOfWaterM.IOutOfWater;
  OutOfWaterM.Timer -> TimerC.Timer[unique("Timer")];
  OutOfWaterM.getLevel -> Water.getLevel;
}
