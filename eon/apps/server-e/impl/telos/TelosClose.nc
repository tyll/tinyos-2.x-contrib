configuration TelosClose
{
  provides
  {
    interface StdControl;
    interface ITelosClose;
  }
}
implementation
{
  components TelosCloseM;

  StdControl = TelosCloseM.StdControl;
  ITelosClose = TelosCloseM.ITelosClose;
}
