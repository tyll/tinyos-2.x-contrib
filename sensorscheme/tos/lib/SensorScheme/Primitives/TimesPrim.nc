/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration TimesPrim {
  provides interface SSPrimitive;
}

implementation {
  components TimesPrimM;
  components SensorSchemeC;
  
  SSPrimitive = TimesPrimM;
  TimesPrimM.SSRuntime -> SensorSchemeC;

}
