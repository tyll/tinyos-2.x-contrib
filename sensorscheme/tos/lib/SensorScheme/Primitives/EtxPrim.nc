/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration EtxPrim {
  provides interface SSPrimitive;
}

implementation {
  components CollectionM;

  SSPrimitive = CollectionM.Etx;
}
