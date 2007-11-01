/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration ConsPrim {
  provides interface SSPrimitive;
}

implementation {
  components ConsPrimM;
  components SensorSchemeC;
  
  SSPrimitive = ConsPrimM;
  ConsPrimM.SSRuntime -> SensorSchemeC;
}
