#include <stdio.h>

#include "daq_lib.h"

int main(int argc, char *argv[])
{
  daq_card_t daq;
  uint16_t sample;

  if (argc != 2) {
    fprintf(stderr, "Too few arguments\n");
    return 1;
  }

  if (daq_open(argv[1], &daq)) {
    perror("Error opening daq device");
    return 1;
  }

  if (daq_config_channel(&daq, 0, DG_1, DR_BIPOL5V)) {
    perror("Error setting channel");
    return 1;
  }

  if (daq_get_sample(&daq, &sample)) {
    perror("Error getting sample");
    return 1;
  }

  printf("Sample returned: %04x\n", sample);

  if (daq_close(&daq)) {
    perror("Error closing daq device");
    return 1;
  }

  return 0;
}
