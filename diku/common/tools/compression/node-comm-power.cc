#include "node-comm.hh"
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "daq_lib.h"

//#define DAQ

// This mutex basically protects teh access to value and count, but is
// also used to block the power thread when it should not be running.
pthread_mutex_t run_power_mutex = PTHREAD_MUTEX_INITIALIZER;
double value;
int count;

bool run_power_thread = false;
bool continue_thread = true;
pthread_t power_thread;

const char *DAQ_CARD = "/home/ksm/ixpci0";
const int INVERSE_RATE = 0xFFFF;

void *power(void *)
{
#ifdef DAQ
  daq_card_t daq;

  if (daq_open(DAQ_CARD, &daq)) {
    perror("Error opening daq device");
    return 0;
  }
#endif

  while (continue_thread) {
    pthread_mutex_lock(&run_power_mutex);
#ifndef DAQ
    while (run_power_thread) {
      value += rand();
      count++;      
    }
#else 
    /* Setup the scan */
    if (daq_clear_scan(&daq)) {
      perror("Error clearing the scan");
      return 0;
    }

    if (daq_add_scan(&daq, 0, DG_1, DR_UNIPOL10V)) {
      perror("Error adding volt scan");
      return 0;
    }

    if (daq_add_scan(&daq, 16, DG_1000, DR_UNIPOL10V)) {
      perror("Error adding amp scan");
      return 0;
    }

    if (daq_start_scan(&daq, INVERSE_RATE)) { 
      perror("Error starting scan");
      return 0;
    }    

    // Throw away the first set of data.
    {
      uint16_t sample;
      int res;
      if ((res = daq_get_scan_sample(&daq, &sample))) {
	fprintf(stderr, "Error getting sample. res = %d", res);
	return 0;
      }
      if ((res = daq_get_scan_sample(&daq, &sample))) {
	fprintf(stderr, "Error getting sample. res = %d", res);
	return 0;
      }
    }

    while (run_power_thread) {
      int res;
      uint16_t sample_volts, sample_amps;
      if ((res = daq_get_scan_sample(&daq, &sample_volts))) {
	fprintf(stderr, "Error getting volts sample. res = %d", res);
	return 0;
      }

      if ((res = daq_get_scan_sample(&daq, &sample_amps))) {
	fprintf(stderr, "Error getting amps sample. res = %d", res);
	return 0;
      }
      
      double volts = daq_convert_result(&daq, sample_volts, DG_1, DR_UNIPOL10V);
      double amps = daq_convert_result(&daq, sample_amps, DG_1000, DR_UNIPOL10V) * 1000.0;

      //      value += amps;
      value += volts * amps;
      count++;
      usleep(6000);
    }
#endif
    pthread_mutex_unlock(&run_power_mutex);
  }
  return 0;
}

void init_power()
{
  // Initialize the mutex, in order to stop the new thread
  // immediately.
  pthread_mutex_lock(&run_power_mutex);
  run_power_thread = false;

  pthread_create(&power_thread, 0, power, 0);
}

void start_power()
{
  value = 0;
  count = 0;
  run_power_thread = true;
  pthread_mutex_unlock(&run_power_mutex);  
}

double stop_power()
{
  run_power_thread = false;
  pthread_mutex_lock(&run_power_mutex);

  // Now we have access to value and count.
  return value / count;
}

void halt_power()
{
  continue_thread = false;
  run_power_thread = false;
  pthread_mutex_unlock(&run_power_mutex);
  pthread_join(power_thread, 0);  
}
