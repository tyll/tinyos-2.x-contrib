/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration PairPrim {
  provides interface SSPrimitive;
}

implementation {
  components PairPrimM;
  components SensorSchemeC;
  
  SSPrimitive = PairPrimM;
  PairPrimM.SSRuntime -> SensorSchemeC;
}
