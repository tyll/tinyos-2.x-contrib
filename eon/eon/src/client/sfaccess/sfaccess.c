#include <stdio.h>
#include <stdlib.h>

#include "telossource.h"

int main(int argc, char **argv)
{
	int fd;

	if (argc != 3)
	{
      fprintf(stderr, "Usage: %s <host> <port> - dump packets from a serial forwarder\n", argv[0]);
      exit(2);
    }
  fd = open_telos_source(argv[1], atoi(argv[2]));
  if (fd < 0)
    {
      fprintf(stderr, "Couldn't open serial forwarder at %s:%s\n",
	      argv[1], argv[2]);
      exit(1);
    }
  for (;;)
    {
      int len, i;
      const telospacket *packet = read_telos_packet(fd);

      if (!packet)
	exit(0);
      printf("\n");
      printf("length = %i\n",packet->length);
      printf("dsn = %i\n",packet->dsn);
      printf("addr = %i\n",packet->addr);
      printf("type = %i\n",packet->type);
      for (i = 0; i < packet->length; i++)
	printf("%02x ", packet->data[i]);
      putchar('\n');
      fflush(stdout);
      free((void *)packet);
    }
}
