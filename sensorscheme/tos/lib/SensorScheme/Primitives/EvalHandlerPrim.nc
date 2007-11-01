/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration EvalHandlerPrim {
  provides interface SSPrimitive;
}

implementation {
  components EvalHandlerPrimM;
  components SensorSchemeC;
  
  SSPrimitive = EvalHandlerPrimM;
  EvalHandlerPrimM.SSRuntime -> SensorSchemeC;
}
