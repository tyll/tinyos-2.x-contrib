/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration CallCCPrim {
  provides interface SSPrimitive;
}

implementation {
  components CallCCPrimM;
  components SensorSchemeC;
  
  SSPrimitive = CallCCPrimM;
  CallCCPrimM.SSRuntime -> SensorSchemeC;
}
