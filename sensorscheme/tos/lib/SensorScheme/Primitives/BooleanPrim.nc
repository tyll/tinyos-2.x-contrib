/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration BooleanPrim {
  provides interface SSPrimitive;
}

implementation {
  components BooleanPrimM;
  components SensorSchemeC;
  
  SSPrimitive = BooleanPrimM;
  BooleanPrimM.SSRuntime -> SensorSchemeC;
}
