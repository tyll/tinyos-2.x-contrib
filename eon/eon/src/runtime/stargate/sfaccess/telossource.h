#ifndef TELOSSOURCE_H
#define TELOSSOURCE_H

//THis acts as a layer above sfsource.(c | h)
#include <stdint.h>

typedef struct {
  uint8_t length;
  uint8_t dsn;
  uint16_t addr;
  uint8_t type;
  uint8_t group;
  uint8_t *data;
} telospacket;

#define TELOS_MIN_SIZE 10

int open_telos_source(const char *host, int port);


int init_telos_source(int fd);


telospacket *read_telos_packet(int fd);


int write_telos_packet(int fd, const telospacket *packet);

int free_telos_packet(telospacket **pkt);

#endif
