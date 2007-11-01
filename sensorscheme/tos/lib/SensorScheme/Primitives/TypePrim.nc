/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration TypePrim {
  provides interface SSPrimitive;
}

implementation {
  components TypePrimM;
  components SensorSchemeC;
  
  SSPrimitive = TypePrimM;
  TypePrimM.SSRuntime -> SensorSchemeC;
}
