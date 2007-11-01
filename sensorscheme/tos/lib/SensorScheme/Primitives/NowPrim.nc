/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration NowPrim {
  provides interface SSPrimitive;
}

implementation {
  components NowPrimM;
  components SensorSchemeC;
  
  SSPrimitive = NowPrimM;
  NowPrimM.SSRuntime -> SensorSchemeC;

}
