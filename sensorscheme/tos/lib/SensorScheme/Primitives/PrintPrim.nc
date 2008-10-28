/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration PrintPrim {
  provides interface SSPrimitive;
}

implementation {
  components PrintPrimM;
  components SensorSchemeC;
  
  SSPrimitive = PrintPrimM;

  PrintPrimM.SSRuntime -> SensorSchemeC;
}
