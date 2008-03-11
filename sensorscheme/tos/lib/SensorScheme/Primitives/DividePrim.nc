/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration DividePrim {
  provides interface SSPrimitive;
}

implementation {
  components DividePrimM;
  components SensorSchemeC;
  
  SSPrimitive = DividePrimM;
  DividePrimM.SSRuntime -> SensorSchemeC;

}
