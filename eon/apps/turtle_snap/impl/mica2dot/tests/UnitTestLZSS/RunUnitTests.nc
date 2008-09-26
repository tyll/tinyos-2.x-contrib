configuration RunUnitTests
{
  
}
implementation
{
  components Main, RunUnitTestsM, UnitTestLZSS;

  Main.StdControl -> UnitTestLZSS.StdControl;
  Main.StdControl -> RunUnitTestsM.StdControl;
 
  
  RunUnitTestsM.UnitTest[unique("TestCase")] -> UnitTestLZSS.UnitTest;
  
}
