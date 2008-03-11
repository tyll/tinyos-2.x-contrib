/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration CollectSender {
  provides interface SSSender;
} 

implementation {
  components CollectC;
  
  SSSender = CollectC.SSSender;
}
