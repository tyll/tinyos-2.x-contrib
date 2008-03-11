/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration GtPrim {
  provides interface SSPrimitive;
}

implementation {
  components GtPrimM;
  components SensorSchemeC;
  
  SSPrimitive = GtPrimM;
  GtPrimM.SSRuntime -> SensorSchemeC;

}
