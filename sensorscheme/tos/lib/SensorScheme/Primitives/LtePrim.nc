/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration LtePrim {
  provides interface SSPrimitive;
}

implementation {
  components LtePrimM;
  components SensorSchemeC;
  
  SSPrimitive = LtePrimM;
  LtePrimM.SSRuntime -> SensorSchemeC;

}
