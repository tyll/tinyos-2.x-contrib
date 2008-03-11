/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration InterceptReceiver {
  provides interface SSReceiver;
}

implementation {
  components InterceptC;
  
  SSReceiver = InterceptC.SSReceiver;
}
