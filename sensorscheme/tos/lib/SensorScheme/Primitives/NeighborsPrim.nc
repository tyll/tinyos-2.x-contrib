/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration NeighborsPrim {
  provides interface SSPrimitive;
}

implementation {
  components CollectionM;

  SSPrimitive = CollectionM.Neighbors;
}
