/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration BitwiseNotPrim {
  provides interface SSPrimitive;
}

implementation {
  components BitwiseNotPrimM;
  components SensorSchemeC;
  
  SSPrimitive = BitwiseNotPrimM;
  BitwiseNotPrimM.SSRuntime -> SensorSchemeC;

}
