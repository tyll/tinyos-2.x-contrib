configuration RunUnitTests
{
  
}
implementation
{
  components Main, RunUnitTestsM, UnitTestInterested;

  Main.StdControl -> UnitTestInterested.StdControl;
  Main.StdControl -> RunUnitTestsM.StdControl;
 
  
  RunUnitTestsM.UnitTest[unique("TestCase")] -> UnitTestInterested.UnitTest;
  
}
