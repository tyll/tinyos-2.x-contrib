/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration DefinedPrim {
  provides interface SSPrimitive;
}

implementation {
  components DefinedPrimM;
  components SensorSchemeC;
  
  SSPrimitive = DefinedPrimM;
  DefinedPrimM.SSRuntime -> SensorSchemeC;
}
