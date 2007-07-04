
/**
 * @author David Moss
 */
configuration TestC {
}

implementation {
  components new TestCaseC() as TestSetC;
    
  components TestP,
      ActiveMessageAddressC;
      
  TestP.TestSet -> TestSetC;
  TestP.ActiveMessageAddress -> ActiveMessageAddressC;
  
}
