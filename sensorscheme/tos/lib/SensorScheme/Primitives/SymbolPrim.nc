/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration SymbolPrim {
  provides interface SSPrimitive;
}

implementation {
  components SymbolPrimM;
  components SensorSchemeC;
  
  SSPrimitive = SymbolPrimM;
  SymbolPrimM.SSRuntime -> SensorSchemeC;
}
