/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration ListPrim {
  provides interface SSPrimitive;
}

implementation {
  components ListPrimM;
  components SensorSchemeC;
  
  SSPrimitive = ListPrimM;
  ListPrimM.SSRuntime -> SensorSchemeC;
}
