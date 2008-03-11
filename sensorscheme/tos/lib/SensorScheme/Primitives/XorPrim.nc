/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration XorPrim {
  provides interface SSPrimitive;
}

implementation {
  components XorPrimM;
  components SensorSchemeC;
  
  SSPrimitive = XorPrimM;
  XorPrimM.SSRuntime -> SensorSchemeC;

}
