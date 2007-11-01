/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration LogicPrim {
  provides interface SSPrimitive;
}

implementation {
  components LogicPrimM;
  components SensorSchemeC;
  
  SSPrimitive = LogicPrimM;
  LogicPrimM.SSRuntime -> SensorSchemeC;

}
