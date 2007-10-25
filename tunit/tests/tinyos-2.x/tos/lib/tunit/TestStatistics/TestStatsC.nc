
/** 
 * This test makes sure Statistics works, and demonstrates how to properly
 * setup Statistics logging for your own tests.
 *
 * A statistics messages only has so many bytes in it, so the title of the
 * statistics being logged is whatever you rename your StatisticsC instances
 * as, and the units are defined within the test.  This allows TUnit to 
 * keep track of individual characteristics over time.  
 * 
 * @author David Moss
 */
configuration TestStatsC {
}

implementation {
  components TestStatsP,
      new TestCaseC() as LogStatsC,
      new TestCaseC() as MakeSureAllStatsWereLoggedC,
      
      new StatisticsC() as Stats1C,
      new StatisticsC() as Stats2C,
      new StatisticsC() as Stats3C,
      new StatisticsC() as Stats4C,
      new StatisticsC() as Stats5C,
      new StatisticsC() as Stats6C,
      new StatisticsC() as Stats7C;
      
      
  TestStatsP.LogStats -> LogStatsC;
  TestStatsP.MakeSureAllStatsWereLogged -> MakeSureAllStatsWereLoggedC;
  
  // Pick a TestCaseC instance at random and wire SetUpOneTime to it.
  TestStatsP.SetUpOneTime -> LogStatsC.SetUpOneTime;
  
  TestStatsP.Stats1 -> Stats1C;
  TestStatsP.Stats2 -> Stats2C;
  TestStatsP.Stats3 -> Stats3C;
  TestStatsP.Stats4 -> Stats4C;
  TestStatsP.Stats5 -> Stats5C;
  TestStatsP.Stats6 -> Stats6C;
  TestStatsP.Stats7 -> Stats7C;
  
  components RandomC;
  TestStatsP.Random -> RandomC;
  
  components new TimerMilliC();
  TestStatsP.Timer -> TimerMilliC;
  
  
}

