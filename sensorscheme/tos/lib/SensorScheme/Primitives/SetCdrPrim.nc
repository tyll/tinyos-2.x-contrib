/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration SetCdrPrim {
  provides interface SSPrimitive;
}

implementation {
  components SetCdrPrimM;
  components SensorSchemeC;
  
  SSPrimitive = SetCdrPrimM;
  SetCdrPrimM.SSRuntime -> SensorSchemeC;
}
