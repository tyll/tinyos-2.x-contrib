
interface MeasurementCollector {

  command void readAllSensors();

  event void allMeasurementsDone(uint16_t temp,
				 uint16_t hum,
				 uint16_t volt,
				 uint16_t tsr,
				 uint16_t par,
				 uint8_t valid);
}
