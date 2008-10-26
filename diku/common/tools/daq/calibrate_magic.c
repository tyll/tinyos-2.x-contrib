/**
 * Calibration program.
 *
 * Does the same as DEMO19.C
 *
 * In order to calibrate the board, perform the following steps:
 *
 * Step 1: Apply 0V to channel 0
 * Step 2: Apply 4.996V to channel 1
 * Step 3: Apply 4.996mV to channel 2
 * Step 4: Adjust VR101 until CAL:0 = 0x7FF or 0x800.
 * Step 5: Adjust VR100 until CAL:1 = 0xFFE or 0xFFF.
 * Step 6: Repeat step 4 and 5 until both values are fine.
 * Step 7: Adjust VR2 until CAL:2 = 0x000 or 0x001.
 * Step 8: Adjust VR1 until CAL:3 = 0xFFE or 0xFFF.
 *
 */

#include <stdio.h>
#include <curses.h>
#include <signal.h>
#include <stdlib.h>

#include "daq_lib.h"

void sigint(int signum)
{
  endwin();
  exit(0);
}

struct config {
  int channel;
  daq_gain_t gain;
  daq_range_t range;
};

struct config cfg[4] = { { 0, DG_10, DR_BIPOL5V },
			 { 8, DG_1, DR_BIPOL10V },
			 { 24, DG_10, DR_BIPOL5V },
			 { 16, DG_1, DR_BIPOL10V } };

int main(int argc, char *argv[])
{
  daq_card_t daq;
  int count = 0;
  int res;
  int i;
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

  initscr();
  nonl();
  cbreak();
  noecho();
  move(1,1);

  printw("A/D Calibration Program:\n");
  printw("step 1: apply 0V to channel 0.\n");
  printw("step 2: apply 4.996V to channel 1.\n");
  printw("step 3: apply 4.996mV to channel 2.\n");
  printw("step 4: adjust VR101 until CAL:0 = 0x7ff or 0x800.\n");
  printw("step 5: adjust VR100 until CAL:1 = 0xffe or 0xfff.\n");
  printw("step 6: repeat step 4 and step 5 until all OK.\n");
  printw("step 7: adjust VR2 until CAL:2 = 0x000 or 0x001.\n");
  printw("step 8: adjust VR1 until CAL:3 = 0xffe or 0xfff.\n");

  /* Setup the scan */
  if (daq_clear_scan(&daq)) {
    perror("Error clearing the scan");
    return 1;
  }

  res = 0;
  for (i = 0; i < 4; ++i) 
    res += daq_add_scan(&daq, cfg[i].channel, cfg[i].gain, cfg[i].range);

  if (res) {
    perror("Error configuring scan");
    return 1;
  }

  if (daq_start_scan(&daq, 0xFFFF)) {
    perror("Error starting scan");
    return 1;
  }    

  while(1) {
    uint16_t sample;

    move(11, 5);
    printw("Count=%ld\n", count++);

    for (i = 0; i < 4; ++i) {
      res = daq_get_scan_sample(&daq, &sample);
      
      if (!res) {
	move(12 + i, 5);
	printw("CAL:0=0x%04x   VAL:0=%02.6f\n", sample,
	       daq_convert_result(&daq, sample, cfg[i].gain, cfg[i].range));
      } else {
	endwin();
	printf("(5.0V Range, CH:0) Error reading sample (Count=%d, res=%d)\n", count, res);
	perror("exiting");
	exit(1);
      }
    }

    move(17, 1);
    printw("Press CTRL+C to exit\n");

    refresh();
  }
  endwin();
  return 0;
}
    

  
