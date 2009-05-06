#include <time.h>
#include "camera_cmd.h"
void callback(int percentage, char* filename){
  //((part_idx*100)/max_row)
  printf("\b\b\b\b\b%4d%%",percentage);
  fflush(stdout);
}

int main(int argc, char **argv)
{
  if (argc != 3 && argc != 4)
  {
      fprintf(stderr,
	      "Usage: %s <ip_port> <mote_id> [<img_type>]\n\t where img_type: 2=bw_jpg(default) 3=col_jpg 0=bw_raw 1=col_raw",
	      argv[0]);
      exit(2);
    } 

  int port = atoi(argv[1]);
  printf("connecting to serialforwarder: localhost:%d\n",port);
  comm_init("localhost", port);
  int node_id = atoi(argv[2]);
  int img_type = 2;
  
  if (argc==4)
    img_type=atoi(argv[3]);

  char filename[1024];
  int ret=0;

  sprintf(filename,"./test%d",(int)time(NULL));
  printf("sending img request to node %d: ",node_id);
  printf("%d\n",send_img_cmd(node_id, img_type));

  printf("img:     0%%");
  ret = receive_img(node_id, 0, filename, &callback);
  printf("\n");
  if (ret==-1)
    printf("no pkts received!\n");

  return 0;
}

