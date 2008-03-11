/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration LtPrim {
  provides interface SSPrimitive;
}

implementation {
  components LtPrimM;
  components SensorSchemeC;
  
  SSPrimitive = LtPrimM;
  LtPrimM.SSRuntime -> SensorSchemeC;

}
