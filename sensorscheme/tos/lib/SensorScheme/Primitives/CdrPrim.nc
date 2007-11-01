/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration CdrPrim {
  provides interface SSPrimitive;
}

implementation {
  components CdrPrimM;
  components SensorSchemeC;
  
  SSPrimitive = CdrPrimM;
  CdrPrimM.SSRuntime -> SensorSchemeC;

}
