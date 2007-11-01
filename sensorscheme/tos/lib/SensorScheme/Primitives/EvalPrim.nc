/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration EvalPrim {
  provides interface SSPrimitive;
}

implementation {
  components EvalPrimM;
  components SensorSchemeC;
  
  SSPrimitive = EvalPrimM;
  EvalPrimM.SSRuntime -> SensorSchemeC;
}
