/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration SetCarPrim {
  provides interface SSPrimitive;
}

implementation {
  components SetCarPrimM;
  components SensorSchemeC;
  
  SSPrimitive = SetCarPrimM;
  SetCarPrimM.SSRuntime -> SensorSchemeC;

}
