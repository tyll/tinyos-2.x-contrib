/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration ParentPrim {
  provides interface SSPrimitive;
}

implementation {
  components CollectionM;

  SSPrimitive = CollectionM.Parent;
}
