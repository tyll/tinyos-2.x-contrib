#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "tinystream.h"

/*void cb(int id, uint8_t *data, int length)
{
	int i;
	printf("recv cb (%i, %i)\n",id,length);
	for (i=0; i < length; i++)
	{
		printf("%02x ", data[i]);
	}
	printf("\n");
}*/

int main(int argc, char **argv)
{
  int fd;
  int count = 0;
  int cid;

  if (argc != 3)
    {
      fprintf(stderr, "Usage: %s <host> <port> - dump packets from a serial forwarder\n", argv[0]);
      exit(2);
    }
  fd = tinystream_init(argv[1], atoi(argv[2]));
  if (fd < 0)
    {
      fprintf(stderr, "Couldn't start tinystream at %s:%s\n",
	      argv[1], argv[2]);
      exit(1);
    }
    sleep(2);
  printf("try to connect...fd=%i\n",fd);
  cid = tinystream_connect(0);
  printf("cid = %i\n",cid);
  for (;;)
    {
      uint8_t buf[10];
      int i;
      tinystream_read(cid,buf, 10);
      printf("Stream read\n");
      for (i=0; i < sizeof(buf); i++)
      {
      	printf("%02x ", buf[i]);
      }
      printf("Done\n");
    }
  tinystream_destroy();
}
