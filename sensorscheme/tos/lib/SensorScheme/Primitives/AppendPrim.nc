/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration AppendPrim {
  provides interface SSPrimitive;
}

implementation {
  components AppendPrimM;
  components SensorSchemeC;
  
  SSPrimitive = AppendPrimM;
  AppendPrimM.SSRuntime -> SensorSchemeC;
}
