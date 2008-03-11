/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration ModuloPrim {
  provides interface SSPrimitive;
}

implementation {
  components ModuloPrimM;
  components SensorSchemeC;
  
  SSPrimitive = ModuloPrimM;
  ModuloPrimM.SSRuntime -> SensorSchemeC;

}
