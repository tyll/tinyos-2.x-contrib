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

int main(int argc, char *argv[])
{
  daq_card_t daq;
  int count = 0;
  struct sigaction act;

  if (argc != 2) {
    fprintf(stderr, "Too few arguments\n");
    return 1;
  }

  if (daq_open(argv[1], &daq)) {
    perror("Error opening daq device");
    return 1;
  }

  if (daq_clear_scan(&daq)) {
    perror("Error cleaning scan");
    return 1;
  }

  if (daq_stop_scan(&daq)) {
    perror("Error cleaning scan");
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

  while(1) {
    int res;
    uint16_t sample;

    move(11, 5);
    printw("Count=%ld\n", count++);

    res = daq_config_channel(&daq, 0, DG_1, DR_BIPOL5V);
    res += daq_get_sample(&daq, &sample);

    if (!res) {
      move(12, 5);
      printw("CAL:0=0x%04x\n", sample);
    } else {
      endwin();
      printf("(5.0V Range, CH:0) Error reading sample\n");
      exit(1);
    }

    res = daq_config_channel(&daq, 1, DG_1, DR_BIPOL5V);
    res += daq_get_sample(&daq, &sample);

    if (!res) {
      move(13, 5);
      printw("CAL:1=0x%04x\n", sample);
    } else {
      endwin();
      printf("(5.0V Range, CH:1) Error reading sample\n");
      exit(1);
    }

    res = daq_config_channel(&daq, 0, DG_1, DR_UNIPOL10V);
    res += daq_get_sample(&daq, &sample);

    if (!res) {
      move(14, 5);
      printw("CAL:2=0x%04x\n", sample);
    } else {
      endwin();
      printf("(10.0V Range, CH:0) Error reading sample\n");
      exit(1);
    }

    res = daq_config_channel(&daq, 2, DG_1000, DR_BIPOL5V);
    res += daq_get_sample(&daq, &sample);

    if (!res) {
      move(15, 5);
      printw("CAL:3=0x%04x\n", sample);
    } else {
      endwin();
      printf("(5.0V Range, CH:2) Error reading sample\n");
      exit(1);
    }

    move(17, 1);
    printw("Press CTRL+C to exit\n");

    refresh();
    //    daq_wait_usec(&daq, 500);
  }
  endwin();
  return 0;
}
    

  
