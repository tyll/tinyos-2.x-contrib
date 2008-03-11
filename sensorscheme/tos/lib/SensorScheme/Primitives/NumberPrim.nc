/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration NumberPrim {
  provides interface SSPrimitive;
}

implementation {
  components NumberPrimM;
  components SensorSchemeC;
  
  SSPrimitive = NumberPrimM;
  NumberPrimM.SSRuntime -> SensorSchemeC;
}
