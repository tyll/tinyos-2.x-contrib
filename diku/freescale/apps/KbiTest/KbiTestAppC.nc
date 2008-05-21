configuration KbiTestAppC {}

implementation
{
  components MainC, Hcs08KbiC, ConsoleC, KbiTestC;
  
  ConsoleC.StdControl <- KbiTestC.ConsoleControl;
  ConsoleC <- KbiTestC.Out;
  MainC.Boot <- KbiTestC;
  
  Hcs08KbiC.StdControl <- KbiTestC.KbiControl;
  Hcs08KbiC.Hcs08Kbi <- KbiTestC;
}