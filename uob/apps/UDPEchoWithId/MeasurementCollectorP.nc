
module MeasurementCollectorP {
  uses {
    interface Read<uint16_t> as ReadTemp;
    interface Read<uint16_t> as ReadHum;
    interface Read<uint16_t> as ReadVolt;
    interface Read<uint16_t> as ReadTSR;
    interface Read<uint16_t> as ReadPAR;

    interface Leds;
  }
  provides interface MeasurementCollector;

} implementation {

  bool temp_finished;
  bool hum_finished;
  bool volt_finished;
  bool tsr_finished;
  bool par_finished;

  bool temp_valid;
  bool hum_valid;
  bool volt_valid;
  bool tsr_valid;
  bool par_valid;

  uint16_t temp;
  uint16_t hum;
  uint16_t volt;
  uint16_t tsr;
  uint16_t par;

  command void MeasurementCollector.readAllSensors() {

    temp_finished = FALSE;
    hum_finished  = FALSE;
    volt_finished = FALSE;
    tsr_finished  = FALSE;
    par_finished  = FALSE;

    temp_valid = FALSE;
    hum_valid  = FALSE;
    volt_valid = FALSE;
    tsr_valid  = FALSE;
    par_valid  = FALSE;

    call Leds.led1Toggle(); // green

    call ReadTemp.read();
    call ReadHum.read();
    call ReadVolt.read();
    call ReadTSR.read();
    call ReadPAR.read();
  }

  void areAllDone() {
    call Leds.led0Toggle(); // red

    if ((temp_finished == TRUE) &&
	(hum_finished  == TRUE) &&
	(volt_finished == TRUE) &&
	(tsr_finished  == TRUE) &&
	(par_finished  == TRUE)) {
      call Leds.led2Toggle(); // blue

      signal MeasurementCollector.allMeasurementsDone(temp, hum, volt,
						      tsr, par,
						      temp_valid << 4 | \
						      hum_valid << 3 | \
						      volt_valid << 2 | \
						      tsr_valid << 1 | \
						      par_valid);
    }
  }

  event void ReadTemp.readDone(error_t result, uint16_t val) {
    temp_finished = TRUE;
    if (result == SUCCESS) {
      temp_valid = TRUE;
      temp = val;
    }
    areAllDone();
  }

  event void ReadHum.readDone(error_t result, uint16_t val) {
    hum_finished  = TRUE;
    if (result == SUCCESS) {
      hum_valid  = TRUE;
      hum = val;
    }
    areAllDone();
  }

  event void ReadVolt.readDone(error_t result, uint16_t val) {
    volt_finished = TRUE;
    if (result == SUCCESS) {
      volt_valid = TRUE;
      volt = val;
    }
    areAllDone();
  }

  event void ReadTSR.readDone(error_t result, uint16_t val) {
    tsr_finished  = TRUE;
    if (result == SUCCESS) {
      tsr_valid  = TRUE;
      tsr = val;
    }
    areAllDone();
  }

  event void ReadPAR.readDone(error_t result, uint16_t val) {
    par_finished  = TRUE;
    if (result == SUCCESS) {
      par_valid  = TRUE;
      par = val;
    }
    areAllDone();
  }

}
