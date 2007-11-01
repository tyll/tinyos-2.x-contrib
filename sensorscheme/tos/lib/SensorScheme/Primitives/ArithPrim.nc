/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration ArithPrim {
  provides interface SSPrimitive;
}

implementation {
  components ArithPrimM;
  components SensorSchemeC;
  
  SSPrimitive = ArithPrimM;
  ArithPrimM.SSRuntime -> SensorSchemeC;

}
