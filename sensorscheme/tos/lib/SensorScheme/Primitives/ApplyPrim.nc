/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration ApplyPrim {
  provides interface SSPrimitive;
}

implementation {
  components ApplyPrimM;
  components SensorSchemeC;
  
  SSPrimitive = ApplyPrimM;
  ApplyPrimM.SSRuntime -> SensorSchemeC;
}
