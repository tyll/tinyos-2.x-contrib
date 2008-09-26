configuration LZSS
{
  provides
  {
    interface StdControl;
    interface ILZSS;
  }
}
implementation
{
  components LZSSM;

  StdControl = LZSSM.StdControl;
  ILZSS = LZSSM;
}
