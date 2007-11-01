/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration CarPrim {
  provides interface SSPrimitive;
}

implementation {
  components CarPrimM;
  components SensorSchemeC;
  
  SSPrimitive = CarPrimM;
  CarPrimM.SSRuntime -> SensorSchemeC;

}
