/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration SubPrim {
  provides interface SSPrimitive;
}

implementation {
  components SubPrimM;
  components SensorSchemeC;
  
  SSPrimitive = SubPrimM;
  SubPrimM.SSRuntime -> SensorSchemeC;

}
