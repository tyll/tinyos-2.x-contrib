/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration CallAtTimePrim {
  provides interface SSPrimitive;
}

implementation {
  components CallAtTimePrimM;
  components SensorSchemeC;
  
  SSPrimitive = CallAtTimePrimM;
  CallAtTimePrimM.SSRuntime -> SensorSchemeC;

}
