#define NUM_CHANNELS 4

typedef struct channelopts_t {
  uint8_t channel;
  uint8_t options;
}

typedef struct streamconfigmsg_t {
  uint8_t checksum8;
  uint8_t command;
  uint8_t numchansplusthree;
  uint8_t extcommand;
  uint16_t checksum16;
  uint8_t numchannels;
  uint8_t resolution;
  uint8_t settlingtime;
  uint8_t scanconfig;
  uint16_t scaninterval;
  struct channelopts_t [NUM_CHANNELS];
} streamconfigmsg_t;
