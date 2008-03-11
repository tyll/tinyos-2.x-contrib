/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration NullPrim {
  provides interface SSPrimitive;
}

implementation {
  components NullPrimM;
  components SensorSchemeC;
  
  SSPrimitive = NullPrimM;
  NullPrimM.SSRuntime -> SensorSchemeC;
}
