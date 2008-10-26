/**
 *
 */

#include <stdio.h>
#include <signal.h>
#include <stdlib.h>
#include <unistd.h>

#include <sys/time.h>
#include <time.h>

#include "daq_lib.h"

#define DOWNSAMPLE_BY 1

struct config {
  FILE *f;
  char *filename;
  int channel;
  daq_gain_t gain;
  daq_range_t range;
  char *unit;
  double multiplier;
  double sum;
};

struct config cfg[] = { { 0, "micro4.dumpV", 0, DG_1, DR_UNIPOL10V, "V", 1.0, 0.0 },
			{ 0, "micro4.dumpA", 16, DG_100, DR_UNIPOL10V, "mA", 1000.0, 0.0 } };
//			{ 0, "node1.dumpV", 8, DG_1, DR_UNIPOL10V, "V", 1.0, 0.0 },
//			{ 0, "node1.dumpA", 24, DG_100, DR_UNIPOL10V, "mA", 1000.0, 0.0 } };

#define NUM_CONFIGS (sizeof(cfg) / sizeof(struct config))

void sigint(int signum)
{
  int i;
  for (i = 0; i < NUM_CONFIGS; ++i) {
    if (cfg[i].f)
      fclose(cfg[i].f);
  }
  exit(0);
}
  
int main(int argc, char *argv[])
{
  daq_card_t daq;
  int count = 0;
  int i;
  int res;
  struct sigaction act;

  if (argc != 2) {
    fprintf(stderr, "Too few arguments\n");
    return 1;
  }

  if (daq_open(argv[1], &daq)) {
    perror("Error opening daq device");
    return 1;
  }

  /* Setup signal handler */
  act.sa_handler = sigint;
  sigemptyset(&act.sa_mask);
  act.sa_flags = 0;

  sigaction(SIGINT, &act, 0);

  /* Setup the scan */
  if (daq_clear_scan(&daq)) {
    perror("Error clearing the scan");
    return 1;
  }

  res = 0;
  for (i = 0; i < NUM_CONFIGS; ++i) 
    res += daq_add_scan(&daq, cfg[i].channel, cfg[i].gain, cfg[i].range);

  if (res) {
    perror("Error configuring scan");
    return 1;
  }

  /* Open files */
  for (i = 0; i < NUM_CONFIGS; ++i) {
    cfg[i].f = fopen(cfg[i].filename, "w");
    if (!cfg[i].f) {
      fprintf(stderr, "Error opening file %s for writing", cfg[i].filename);
      return 1;
    }
    cfg[i].sum = 0.0;
  }
    
  if (daq_start_scan(&daq, 0x2000)) { 
    perror("Error starting scan");
    return 1;
  }    

  /* Throw away the first set of data. They are usually wrong */
  for (i = 0; i < NUM_CONFIGS; ++i) {
    uint16_t sample;
    res = daq_get_scan_sample(&daq, &sample);
    
    if (res) {
      fprintf(stderr, "Error getting sample. res = %d", res);
      exit(1);
    }
  }

  while(1) {
    uint16_t sample;
    struct timeval tv;

    for (i = 0; i < NUM_CONFIGS; ++i) {
      res = daq_get_scan_sample(&daq, &sample);
      
      if (res) {
	fprintf(stderr, "Error getting sample. res = %d", res);
	exit(1);
      }

      cfg[i].sum += daq_convert_result(&daq, sample, cfg[i].gain, cfg[i].range);
    }

    count++;
    if ((count % DOWNSAMPLE_BY) == 0) {
      gettimeofday(&tv, NULL);
      for (i = 0; i < NUM_CONFIGS; ++i) {
	fprintf(cfg[i].f, "%09li%06li: %01.4f%s\n", tv.tv_sec, tv.tv_usec, 
		(cfg[i].sum / (double)DOWNSAMPLE_BY) * cfg[i].multiplier, cfg[i].unit);
	cfg[i].sum = 0.0;
      }
    }

    if ((count % 100) == 0) {
      printf(".");
      fflush(stdout);
    }
    //    usleep(500);
  }
  return 0;
}
    

  
