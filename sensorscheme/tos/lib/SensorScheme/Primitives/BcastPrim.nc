/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration BcastPrim {
  provides interface SSPrimitive;
}

implementation {
  components BcastPrimM;
  components SensorSchemeC;
  
  SSPrimitive = BcastPrimM;
  BcastPrimM.SSRuntime -> SensorSchemeC;
}
