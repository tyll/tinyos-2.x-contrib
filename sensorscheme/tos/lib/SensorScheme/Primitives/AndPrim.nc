/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration AndPrim {
  provides interface SSPrimitive;
}

implementation {
  components AndPrimM;
  components SensorSchemeC;
  
  SSPrimitive = AndPrimM;
  AndPrimM.SSRuntime -> SensorSchemeC;

}
