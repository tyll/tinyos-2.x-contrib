#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <time.h>
#include <sys/time.h>
#include <unistd.h>
#include "serialsource.h"
#ifndef NO_JPEG
#include "jpeglib.h"
#endif
#include "camera_cmd.h"
#include "img_stat.h"
#include "cmd_msg.h"
#include "status.h"
#include "bigmsg_frame_part.h"
#include "tinyos_macros.h"
#include "jpeghdr.h"
#include "jpegTOS.h"
#include "jpegUncompress.h"
#include "quanttables.h"
//#include <syslog.h>

int has_forked = 0;
int is_parent_proc = 1; // used to track whether this is the parent of child thread
              // when forking during progressive jpg downloads

unsigned char first_packets_mask=255;
void write_img_file(img_stat_t *is, packet_buffer_t *pkt_buf, char *filename);
long tv_udiff(struct timeval *start, struct timeval *end)
{
  return (end->tv_sec - start->tv_sec)*1000000L + (end->tv_usec - start->tv_usec);
}

int do_fork() {
  //printf("do_fork (pid %d, has_forked %d, is_parent_proc %d)\n",getpid(), has_forked, is_parent_proc);
  int pID = fork();
  
  if (pID == 0)
    is_parent_proc = 0;
  else
    nice(10); // give child process enough cycles to render the page

  //printf("do_forked (pid %d, has_forked %d, is_parent_proc %d)\n",getpid(), has_forked, is_parent_proc);

  return 1;
}

void comm_init(char* host, int port)
{
  sf_fd = open_sf_source(host, port);

  if (sf_fd==-1){
    fprintf(stderr, "Couldn't open serial forwarder at %s:%d\n", host, port);
    exit(1);
  }
}

int send_packet(unsigned char *packet, int count)
{
  return write_sf_packet(sf_fd, packet, count);
}

void* read_packet(int *len)
{
  struct timeval deadline;
  deadline.tv_sec = 3;
  deadline.tv_usec = 0;

  fd_set fds;
  FD_ZERO(&fds);
  FD_SET(sf_fd, &fds);
  int cnt = select(sf_fd+1, &fds, NULL, NULL, &deadline);

  if (cnt <= 0)
    return NULL;

  return read_sf_packet(sf_fd, len);

}

unsigned char cmd_packet[8+CMD_MSG_SIZE];

void init_cmd_packet(int node_id, int cmd_type, int val1, int val2)
{
  unsigned char am=CMD_MSG_AM_TYPE;
  unsigned char len=CMD_MSG_SIZE;
  memset(cmd_packet,0,sizeof(cmd_packet));
  cmd_packet[1]=0xFF;
  cmd_packet[2]=0xFF;
  cmd_packet[3]=0xFF;
  cmd_packet[4]=0xFF;
  cmd_packet[5]=len;
  cmd_packet[7]=am;
  tmsg_t *tmsg = new_tmsg((void *)&cmd_packet[8], len);  
  cmd_msg_node_id_set(tmsg, node_id);
  cmd_msg_cmd_set(tmsg,cmd_type);
  cmd_msg_node_id_set(tmsg, node_id);
  cmd_msg_val1_set(tmsg,val1);
  cmd_msg_val2_set(tmsg,val2);
  free_tmsg(tmsg);
}

int send_img_cmd(int node_id, int img_type)
//types: ~0x01 - bw,  0x01 - col
//       ~0x02 - raw, 0x02 -jpg
// e.g. 2 = bw_jpg, 3 = col_jpg
{
  init_cmd_packet( node_id, img_type, 0, 0);
  return send_packet(cmd_packet, sizeof(cmd_packet));
}

int send_img_part_cmd(int node_id, int idx, int num_parts)
{
  init_cmd_packet( node_id, 5, idx, num_parts);
  return send_packet( cmd_packet, sizeof(cmd_packet));
}


//Sends a request to camera nodes to return its parent and ETX in the CTP collection tree. 
int send_CTP_info_cmd(int node_id){
  init_cmd_packet(node_id, 8, 5, 0); 
  return send_packet( cmd_packet, sizeof(cmd_packet));
}

//Listens for a single command packet with CTP routing information
const unsigned char *receive_ctp_info_packet()
{
  //listen for one second
  time_t t;
  t = time(NULL);
  
  while( ((time(NULL))-t) <3 ){
    int len;
    const unsigned char *packet = read_packet(&len);

    //if am check fails, try to receive next packet
    if (packet)
    {
      
      if( (len<9) || (packet[7]!=STATUS_AM_TYPE))
      {
        free((void *)packet);
      }
      else
      {
        return packet;
      }
    }
  }
  //printf("No packet received in 1 sec!, %d vs %d",t,time(NULL));
  return NULL;
}

//Debugging,, no data returned, just displayed on the standard output.  
int receive_ctp_info_pckts()
{
  time_t t;
  int node_id, seqNo, parent, ETX;
  t = time(NULL);
  printf("Waiting for Routing Info.\n");
  while( ((time(NULL))-t) <20 ){ //Wait 10 seconds for routing information
    const unsigned char *packet = receive_ctp_info_packet();
    if (!packet)
      break;

    //Extract sender, parent, and ETX from the packet and display
    tmsg_t *ctp_info = new_tmsg((void *)&packet[8], STATUS_SIZE);
    node_id=status_node_id_get(ctp_info);
    seqNo=status_seqNo_get(ctp_info);
    parent=status_parent_get(ctp_info);
    ETX=status_ETX_get(ctp_info);
    free_tmsg(ctp_info);
    printf("Routing info for node: %d, parent: %d, ETX: %d.\n", node_id, parent, ETX);
  }
  return 0;
}

void (*callback_function)(int, char *) = NULL;

int receive_img_stat_packet(int session_id, img_stat_t *is)
{
  //i do it with time  deadline here  - want to wait for the right img_stat, 
  //even if there is other traffic in the air
  struct timeval start;
  gettimeofday(&start,0);

  const unsigned char *packet = NULL;
  int len;
  while(1) // 1 sec
  {
    packet = read_packet(&len);

    if (packet)
    { 
      //      printf("am type: %d, looking for: %d\n",packet[7],IMG_STAT_AM_TYPE);
      if (len<9 || packet[7]!=IMG_STAT_AM_TYPE)
        free((void *)packet);
      else
      {
        tmsg_t *img_stat_msg = new_tmsg((void *)&packet[8], len);
        if (img_stat_node_id_get(img_stat_msg) == session_id)
        {
          is->node_id = img_stat_node_id_get(img_stat_msg);
          is->type = img_stat_type_get(img_stat_msg);
          is->data_size = img_stat_data_size_get(img_stat_msg);
          is->width = img_stat_width_get(img_stat_msg);
          is->height = img_stat_height_get(img_stat_msg);
          free_tmsg(img_stat_msg);
          free((void *)packet);
          return 0;
        }
        free_tmsg(img_stat_msg);
        free((void *)packet);
      }
    }
    struct timeval now;
    gettimeofday(&now,0);
    if (tv_udiff(&start,&now)>5000000L) // 5 sec
      return -1;
  }
  //printf("No packet received in 1 sec!\n");
  return -1;
}

int tmp=0;
const unsigned char *receive_img_packet()
{
  //listen for one second
  struct timeval start;
  gettimeofday(&start,0);

  while(1){
    int len;
    const unsigned char *packet = read_packet(&len);

    //if am check fails, try to receive next packet
    if (packet)
    {
      //printf("am type: %d, looking for: %d\n",packet[7],BIGMSG_FRAME_PART_AM_TYPE);
      if( (len<9) || (packet[7]!=BIGMSG_FRAME_PART_AM_TYPE))
        free((void *)packet);
      else
        return packet;
    }
    
    struct timeval now;
    gettimeofday(&now,0);
    if (tv_udiff(&start,&now)>1000000L) // 1 sec
      return NULL;
  }
  return NULL;
}

int receive_img_packets(img_stat_t *is, packet_buffer_t *pkt_buf, char *filename, int max_part_id)
{
  int session_id = is->node_id;
  int part_id=0;
  
  int iter = 1;
  int inc_amt = (pkt_buf->num_packets / 5);

  while (part_id<max_part_id){
    const unsigned char *packet = receive_img_packet();
    if (!packet)
    {
      free((void *)packet);
      break;
    }
    
    tmsg_t *bigmsg = new_tmsg((void *)&packet[8], BIGMSG_FRAME_PART_SIZE);
    //printf("session id: %d, looking for: %d\n",bigmsg_frame_part_node_id_get(bigmsg),session_id );
    if (bigmsg_frame_part_node_id_get(bigmsg) != session_id) // ignore messages not meant for us
    {
      free_tmsg(bigmsg);
      free((void *)packet);
      continue;
    }

    part_id = bigmsg_frame_part_part_id_get(bigmsg);
    if (part_id<8)
      first_packets_mask &= ~(1<<part_id);

    const unsigned char *buf = &packet[8+bigmsg_frame_part_buf_offset(0)];

    //printf("part id: %d, max: %d\n", part_id, pkt_buf->num_packets);
    if (part_id>=pkt_buf->num_packets)
    {
      free_tmsg(bigmsg);
      free((void *)packet);
      return -1;
    }

    memcpy(&pkt_buf->data[part_id*pkt_buf->packet_size], buf, pkt_buf->packet_size);
    pkt_buf->is_received[part_id] = 1;
    
    if (callback_function!=NULL)
    {
      int percentage = (part_id*100)/(pkt_buf->num_packets);
      percentage = (percentage>=100)?99:percentage;
      if(is->is_progressive && part_id >= iter*inc_amt)
      {
        iter++;
        is->data_size=part_id*64;
        if (!first_packets_mask)
          write_img_file(is, pkt_buf, filename);
        //syslog(0,"receive: callback(1)(pid %d)\n",getpid());

        callback_function(percentage, filename);
        
        if (!has_forked)
        {
          has_forked = do_fork();
          
          if (is_parent_proc)
          {
            //syslog(0,"stopping parent process(pid %d)\n",getpid());
            free_tmsg(bigmsg);
            free((void *)packet);
            return 0;
          }
        }
      }
      else if (!is->is_progressive)
      {
        //printf("receive: callback(2)(pid %d)\n",getpid());
        callback_function(percentage, filename);
      }
    }

    free_tmsg(bigmsg);
    free((void *)packet);
  }
  //printf("receive: done(pid %d)\n",getpid());

  return 0;
}

int reliable_receive_img_packets(img_stat_t *is, char *filename, void (*_callback)(int, char *))
{
  packet_buffer_t pkt_buf;
  pkt_buf.packet_size = 64;
  pkt_buf.num_packets = is->data_size/64+((is->data_size%64==0)?0:1);

  int pkt_buf_size=(pkt_buf.packet_size+1)*pkt_buf.num_packets;
  unsigned char *p_buffer = (unsigned char*)calloc(pkt_buf_size, sizeof(char));
  memset(p_buffer, 0, pkt_buf_size);
  pkt_buf.is_received=p_buffer;
  pkt_buf.data=&p_buffer[pkt_buf.num_packets];

  callback_function = _callback;

  int retries = 10;
  int part_idx = 0;
  first_packets_mask = 255;

  //syslog(0,"receive_img_packets attmpt 1");
  receive_img_packets(is, &pkt_buf, filename, pkt_buf.num_packets-1);
  //syslog(0,"receive_img_packets attmpt 1 done");
  --retries;

  while (retries>0 && part_idx<pkt_buf.num_packets
  && (!is_parent_proc||!is->is_progressive)){
    if (!pkt_buf.is_received[part_idx]){
      //syslog(0,"query missing packets");
      send_img_part_cmd(is->node_id, part_idx, 10);
      //syslog(0, "receive_img_packets, attempt %d",11-retries);
      receive_img_packets(is, &pkt_buf, filename,part_idx+9);
      //syslog(0, "receive_img_packets, attempt %d done",11-retries);
      --retries;
    }
    else
      ++part_idx;
  }

  if (is->is_progressive && is_parent_proc) {
    //syslog(0,"reliable_receive: exiting parent process!(pid %d)\n",getpid());
    free(p_buffer);
    //exit(0);
    return 0;
  }
  else
  {
    //syslog(0, "reliable_receive: callback!(pid %d)\n",getpid());
    is->data_size=part_idx*64;
    if (!first_packets_mask)
      write_img_file(is, &pkt_buf, filename);
    callback_function(100, filename);
    if (!is_parent_proc)
      exit(0);
  }

  free(p_buffer);

  return part_idx;
}


int packets2col_img(packet_buffer_t *pkt_buf, 
    unsigned char *img_buffer, int width, int height){
  int idx;
  int packet_buf_size = pkt_buf->packet_size*pkt_buf->num_packets;

  for (idx=0; idx<packet_buf_size; idx+=2){
    unsigned char byte = pkt_buf->data[idx];
    unsigned char byte2 = pkt_buf->data[idx+1];
    unsigned char byteR =  (byte2&0xF8)>>3;
    unsigned char byteG = ((byte2&0x07)<<3) | ((byte&0xE0)>>5);
    unsigned char byteB = byte&0x1F;
      
    img_buffer[idx/2*3]  =byteR<<3;
    img_buffer[idx/2*3+1]=byteG<<2;
    img_buffer[idx/2*3+2]=byteB<<3;
  }

  return 0;
}

int save_img_pnm(char *filebase, unsigned char *img_buffer, int width, int height, int is_color){
  FILE *fd;
  int i,j,k;
  char *filename = (char *)calloc(strlen(filebase)+5,sizeof(char));
  char *ext = is_color?".ppm":".pgm";
  strcpy(filename, filebase);
  strcat(filename,ext);
  
  if (!(fd = fopen(filename, "w"))) {
    fprintf(stderr, "Can't open data: %s\n", strerror(errno));
    free(filename);
    return -1;
  }
  free(filename);

  if (!is_color)
    fprintf(fd, "P2\r\n320 240\r\n255\r\n");
  else
    fprintf(fd, "P3\r\n320 240\r\n255\r\n");
  
  int pixels_width = is_color?3:1;
  for (i=0; i<height; i++){
    for (j=0; j<width; j++)
      for (k=0; k<pixels_width; k++){
  unsigned char byte = img_buffer[i*width*pixels_width+j*pixels_width+k];
  fprintf(fd, "%d ", byte);
      }
    fprintf(fd,"\r\n");
  }

  fclose(fd);
  return 0;
}

#ifndef NO_JPEG
int save_img_jpg(char *filebase, unsigned char *img_buffer, int width, int height, int is_color){
  FILE *fd;
  struct jpeg_compress_struct cinfo;
  struct jpeg_error_mgr jerr; 
  JSAMPROW row_pointer[1];
  int row_stride = is_color?width*3:width;
  
  char *filename = (char *)calloc(strlen(filebase)+5,sizeof(char));
  char *ext = ".jpg";
  strcpy(filename, filebase);
  strcat(filename,ext);

  if ((fd = fopen(filename, "wb")) == NULL) {
    fprintf(stderr, "can't open %s\n", filename);
    return -1;
  }
  free(filename);

  cinfo.err = jpeg_std_error(&jerr);
  jpeg_create_compress(&cinfo);  
  jpeg_stdio_dest(&cinfo, fd);   

  cinfo.image_width = width;
  cinfo.image_height = height;
  cinfo.input_components = is_color?3:1;
  cinfo.in_color_space = is_color?JCS_RGB:JCS_GRAYSCALE;
  jpeg_set_defaults(&cinfo);
  jpeg_set_quality(&cinfo, 90, TRUE);
  jpeg_start_compress(&cinfo, TRUE); 
  
  while (cinfo.next_scanline < cinfo.image_height) {
    row_pointer[0] = & img_buffer[cinfo.next_scanline * row_stride];
    (void) jpeg_write_scanlines(&cinfo, row_pointer, 1);
  } 

  jpeg_finish_compress(&cinfo);
  fclose(fd);
  jpeg_destroy_compress(&cinfo);
  
  return 0;
}
#endif

void write_img_file(img_stat_t *is, packet_buffer_t *pkt_buf, char *filename){
  //fprintf(stderr,"rendering at %d %%: %s\n", percentage, filename);
  unsigned char *img_buffer = (unsigned char*)calloc(is->width*is->height*3,sizeof(char));

  if (is->type&IMG_TYPE_JPG)
  {
    code_header_t header;
    //printf("decoding data size %d\n",is->data_size);
    decodeJpegBytes(pkt_buf->data, is->data_size, img_buffer, &header);
    //printf("jpg decoded header: W=%d H=%d qual=%d COL=%d size=%d\n",header.width, header.height, header.quality, header.is_color, header.totalSize);

    #ifndef NO_JPEG
      save_img_jpg(filename, img_buffer, header.width, header.height, header.is_color);
    #else
      save_img_pnm(filename, img_buffer, header.width, header.height, header.is_color);
    #endif
  }
  else if(is->type&IMG_TYPE_COL)
  {
    packets2col_img(pkt_buf, img_buffer, is->width, is->height);
    save_img_pnm(filename, img_buffer, is->width, is->height, 1);
    #ifndef NO_JPEG
      save_img_jpg(filename, img_buffer, is->width, is->height, 1);
    #endif
  }
  else
  {
    save_img_pnm(filename, pkt_buf->data, is->width, is->height, 0);
    #ifndef NO_JPEG
      save_img_jpg(filename, pkt_buf->data, is->width, is->height, 0);
    #endif
  }

  free(img_buffer);
}


int receive_img(int session_id, int progressive, char * filename, void (*_callback)(int, char *))
{
  img_stat_t is;

  //syslog(0,"receving image");
  if (receive_img_stat_packet(session_id, &is)!=0)
    return -1;
  is.is_progressive=progressive;
  
  //printf("img stat: id: %d, type: %d, progress: %d, size: %d\n", is.node_id, is.type, is.is_progressive, is.data_size);
  
  //syslog(0,"img from node: %d, progressive: %d", is.node_id, is.is_progressive);
  reliable_receive_img_packets(&is, filename, _callback);
  //syslog(0,"reliable_receive done!");

  return 0;
}



