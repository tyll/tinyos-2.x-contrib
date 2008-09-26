configuration RunUnitTests
{
  
}
implementation
{
  components Main, RunUnitTestsM, UnitTestBeacon;

  Main.StdControl -> UnitTestBeacon.StdControl;
  Main.StdControl -> RunUnitTestsM.StdControl;
 
  
  RunUnitTestsM.UnitTest[unique("TestCase")] -> UnitTestBeacon.UnitTest;
  
}
