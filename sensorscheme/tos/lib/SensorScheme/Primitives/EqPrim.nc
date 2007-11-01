/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration EqPrim {
  provides interface SSPrimitive;
}

implementation {
  components EqPrimM;
  components SensorSchemeC;
  
  SSPrimitive = EqPrimM;
  EqPrimM.SSRuntime -> SensorSchemeC;
}
