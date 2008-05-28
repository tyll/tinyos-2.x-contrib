#ifndef CAMERA_CMD_H
#define CAMERA_CMD_H

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <libmote/sfsource.h>

int sf_fd;
enum {
  IMG_TYPE_COL=1,
  IMG_TYPE_JPG=2,
};

typedef struct{
  int node_id;
  int type;
  bool is_progressive;
  int data_size;
  int width;
  int height;
} img_stat_t;

typedef struct {
  int packet_size;
  int num_packets;
  unsigned char *is_received;
  unsigned char *data;
} packet_buffer_t;

void comm_init(char* host, int port);
int send_img_cmd(int node_id, int type);
int receive_img(int session_id, bool progressive, char *filename, void (*_callback)(int, char *, bool));
int save_img_jpg(char *filebase, unsigned char *img_buffer, int width, int height, int is_color);
int receive_ctp_info_pckts();
int send_CTP_info_cmd(int node_id);
bool is_parent_process();
bool do_fork();

#endif //CAMERA_CMD_H
