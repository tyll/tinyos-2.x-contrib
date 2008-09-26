configuration RunUnitTests
{
  
}
implementation
{
  components Main, RunUnitTestsM, UnitTestGPS;

  Main.StdControl -> UnitTestGPS.StdControl;
  Main.StdControl -> RunUnitTestsM.StdControl;
 
  
  RunUnitTestsM.UnitTest[unique("TestCase")] -> UnitTestGPS.UnitTest;
  
}
