/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration NotPrim {
  provides interface SSPrimitive;
}

implementation {
  components NotPrimM;
  components SensorSchemeC;
  
  SSPrimitive = NotPrimM;
  NotPrimM.SSRuntime -> SensorSchemeC;

}
