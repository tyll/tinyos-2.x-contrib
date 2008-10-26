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

struct config cfg[2] = { { 0, DG_1, DR_BIPOL5V },
			 { 16, DG_1000, DR_UNIPOL10V } };

const int cfgs = sizeof(cfg) / sizeof(struct config);

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
  nodelay(stdscr, true);
  move(1,1);

  /* Setup the scan */
  if (daq_clear_scan(&daq)) {
    perror("Error clearing the scan");
    return 1;
  }

  res = 0;
  for (i = 0; i < cfgs; ++i) 
    res += daq_add_scan(&daq, cfg[i].channel, cfg[i].gain, cfg[i].range);

  if (res) {
    perror("Error configuring scan");
    return 1;
  }

  if (daq_start_scan(&daq, 0xFFFF)) {
    perror("Error starting scan");
    return 1;
  }    

  double volts, amps;
  struct timeval start_time;
  int last_count = count;
  bool sec_interval = true;

  gettimeofday(start_time);
  
  while(1) {
    uint16_t sample;

    move(11, 5);
    printw("Count=%ld\n", count++);

    for (i = 0; i < cfgs; ++i) {
      res = daq_get_scan_sample(&daq, &sample);

      if (!res) {
	move(12 + i, 5);
	printw("CAL:%d=0x%04x   VAL:%d=%02.6f", cfg[i].channel,
	       sample, cfg[i].channel,
	       daq_convert_result(&daq, sample, cfg[i].gain, cfg[i].range));

	if (i == 0) {
	  volts += daq_convert_result(&daq, sample, cfg[i].gain, cfg[i].range);
	} if (i == 1) {
	  amps += daq_convert_result(&daq, sample, cfg[i].gain, cfg[i].range);

	  struct timeval now;
	  gettimeofday(&now);

	  if (sec_interval || now.tv_sec != start_time.tv_sec) {
	    int diff = count - last_count;

	    printw("   Power Consumption: %02.6f mW     ", (volts / diff) * (amps / diff) * 1000.0);

	    start_time.tv_sec = now.tv_sec;
	    last_count = count;
	    volts = 0;
	    amps = 0;
	  }

	}

      } else {
	endwin();
	printf("Error reading sample (Cfg=%d, Count=%d, res=%d)\n", i, count, res);
	perror("exiting");
	exit(1);
      }
    }

    move(17, 1);
    printw("Press CTRL+C to exit\n");

    // usleep(10);
    refresh();
    
    int key = getch();
    if (key != ERR) {
      sec_interval = !sec_interval;
    }
    //    usleep(500);
  }
  endwin();
  return 0;
}
    

  
