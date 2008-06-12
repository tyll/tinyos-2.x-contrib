#include <time.h>
#include "camera_cmd.h"
#include <stdbool.h>

void callback(int percentage, char* filename, bool updated){
  //((part_idx*100)/max_row)
  printf("\b\b\b\b\b%4d%%",percentage);
  fflush(stdout);
}

int main(int argc, char **argv)
{
  if (argc != 5)
  {
      fprintf(stderr,
        "Usage(1): %s <ip_port> <mote_id> <img_type> <progressive_download>\n \t (img_type  0 - bw_raw, 1 - col_raw 2 - bw_jpg, 3 - col_jpg, 4 - ctp_info)\n",
        argv[0]);
      exit(2);
    } 

  int port = atoi(argv[1]);
  printf("connecting to serialforwarder: localhost:%d\n",port);
  comm_init("localhost", port);
  int node_id = atoi(argv[2]);
  int cmd_id = atoi(argv[3]);
  bool is_progressive = (atoi(argv[4])==0)?false:true;
  char filename[1024];
  int ret=0;

  sprintf(filename,"/var/www/sensornet/stargate/tmp/test%d",(int)time(NULL));

  if (cmd_id==2)
    printf("sending bw_jpg request to node %d: ",node_id);
  else if (cmd_id==3)
    printf("sending col_jpg request to node %d: ",node_id);
  else if (cmd_id==4)
    printf("sending ctp_info request to node %d: ",node_id);

  if (cmd_id==4) {
    printf("%d\n",send_CTP_info_cmd(node_id));
    
    //const unsigned char *packet;
    //packet = receive_ctp_info_packet();
    receive_ctp_info_packets();    
    
  } else {
    printf("%d\n",send_img_cmd(node_id, cmd_id));
    printf("jpg:     0%%");
    ret = receive_img(node_id, is_progressive, filename, &callback);
    
    printf("\n");
    if (ret==-1)
      printf("no pkts received!\n");
    else
      printf("written to %s!\n", filename);
  }
  
  return 0;
}

