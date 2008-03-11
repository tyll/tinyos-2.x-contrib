/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration AddPrim {
  provides interface SSPrimitive;
}

implementation {
  components AddPrimM;
  components SensorSchemeC;
  
  SSPrimitive = AddPrimM;
  AddPrimM.SSRuntime -> SensorSchemeC;

}
