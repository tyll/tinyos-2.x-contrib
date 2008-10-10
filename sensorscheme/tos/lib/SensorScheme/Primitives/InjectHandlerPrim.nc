/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration InjectHandlerPrim {
  provides interface SSPrimitive;
}

implementation {
  components InjectHandlerPrimM;
  components SensorSchemeC;
  
  SSPrimitive = InjectHandlerPrimM;
  InjectHandlerPrimM.SSRuntime -> SensorSchemeC;
}
