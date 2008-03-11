/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration InterceptSender {
  provides interface SSSender;
} 

implementation {
  components InterceptC;  
  
  SSSender = InterceptC.SSSender;
}
