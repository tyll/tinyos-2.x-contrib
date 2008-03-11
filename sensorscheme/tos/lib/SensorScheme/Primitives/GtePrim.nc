/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration GtePrim {
  provides interface SSPrimitive;
}

implementation {
  components GtePrimM;
  components SensorSchemeC;
  
  SSPrimitive = GtePrimM;
  GtePrimM.SSRuntime -> SensorSchemeC;

}
