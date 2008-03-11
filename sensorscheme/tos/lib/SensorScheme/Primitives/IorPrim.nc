/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration IorPrim {
  provides interface SSPrimitive;
}

implementation {
  components IorPrimM;
  components SensorSchemeC;
  
  SSPrimitive = IorPrimM;
  IorPrimM.SSRuntime -> SensorSchemeC;

}
