includes structs;

configuration UnitTestLZSS
{
  provides
  {
    interface StdControl;
    interface UnitTest;
  }
}
implementation
{
  components UnitTestLZSSM, LZSS;

  StdControl = UnitTestLZSSM.StdControl;
  StdControl = LZSS.StdControl;
  
  
  UnitTest = UnitTestLZSSM.UnitTest;
  
  UnitTestLZSSM.ILZSS -> LZSS.ILZSS;

}
