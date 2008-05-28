#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <signal.h>

#include "sfsource.h"
#include "tinyos_macros.h"
#include "jpeghdr.h"
#include "BigMsg.h"

unsigned char bw_img[320*240*3];
unsigned char col_img[320*240*3];
code_header_t bw_header, col_header;
int noise_limit=100;

int fake_read;
int fake_write;
int server_socket;
int packets_read, packets_written, num_clients;

struct client_list
{
  struct client_list *next;
  int fd;
} *clients;

int unix_check(const char *msg, int result)
{
  if (result < 0)
    {
      perror(msg);
      exit(2);
    }

  return result;
}

void *xmalloc(size_t s)
{
  void *p = malloc(s);

  if (!p)
    {
      fprintf(stderr, "out of memory\n");
      exit(2);
    }
  return p;
}

void fd_wait(fd_set *fds, int *maxfd, int fd)
{
  if (fd > *maxfd)
    *maxfd = fd;
  FD_SET(fd, fds);
}

void pstatus(void)
{
  printf("clients %d, read %d, wrote %d\n", num_clients, packets_read,
	 packets_written);
}

void forward_packet(const unsigned char *packet, int len);


void add_client(int fd)
{
  struct client_list *c = xmalloc(sizeof *c);

  c->next = clients;
  clients = c;
  num_clients++;
  pstatus();

  c->fd = fd;
}

void rem_client(struct client_list **c)
{
  struct client_list *dead = *c;

  *c = dead->next;
  num_clients--;
  pstatus();
  close(dead->fd);
  free(dead);
}

void new_client(int fd)
{
  fcntl(fd, F_SETFL, 0);
  if (init_sf_source(fd) < 0)
    close(fd);
  else
    add_client(fd);
}

void check_clients(fd_set *fds)
{
  struct client_list **c;

  for (c = &clients; *c; )
    {
      int next = 1;

      if (FD_ISSET((*c)->fd, fds))
    	{
    	  int len;
    	  const void *packet = read_sf_packet((*c)->fd, &len);

    	  if (packet)
    	    {
    	      forward_packet(packet, len);
    	      free((void *)packet);
    	    }
    	  else
    	    {
    	      rem_client(c);
    	      next = 0;
    	    }
    	}
      if (next)
      {
      	c = &(*c)->next;
      	if (!c)
          return;
      }
    }
}

void wait_clients(fd_set *fds, int *maxfd)
{
  struct client_list *c;

  for (c = clients; c; c = c->next)
    fd_wait(fds, maxfd, c->fd);
}

void dispatch_packet(const void *packet, int len)
{
  struct client_list **c;

  for (c = &clients; *c; )
    if (write_sf_packet((*c)->fd, packet, len) >= 0)
      c = &(*c)->next;
    else
      rem_client(c);
}

void open_server_socket(int port)
{
  struct sockaddr_in me;
  int opt;

  server_socket = unix_check("socket", socket(AF_INET, SOCK_STREAM, 0));
  unix_check("socket", fcntl(server_socket, F_SETFL, O_NONBLOCK));
  memset(&me, 0, sizeof me);
  me.sin_family = AF_INET;
  me.sin_port = htons(port);

  opt = 1;
  unix_check("setsockopt", setsockopt(server_socket, SOL_SOCKET, SO_REUSEADDR,
				     (char *)&opt, sizeof(opt)));
                                                                           
  unix_check("bind", bind(server_socket, (struct sockaddr *)&me, sizeof me));
  unix_check("listen", listen(server_socket, 5));
}

void check_new_client(void)
{
  int clientfd = accept(server_socket, NULL, NULL);

  if (clientfd >= 0)
    new_client(clientfd);
}

void big_msg_hdr_p(char *packet, int *len, int idx)
{
  char tmp_packet[] = {
    0x00, 0x07, 0xba, 0x00, 0x02, 0x1b, 0x00, 0x6e,
    idx>>8,idx&0xFF, //part id
    0x00, 0x00        //node id
  };
  *len=sizeof(tmp_packet);
  memcpy(packet, tmp_packet, *len);
}

void img_stat_p(code_header_t *header, char *packet, int *len)
{
  char tmp_packet[] = {
    0x00, 0x07, 0xba, 0x00, 0x02, 0x1b, 0x00, 0x05,
    0x00, 0x00, 0x02+header->is_color, //node id(2), type(1)
    header->width>>8, header->width&0xFF, header->height>>8, header->height&0xFF,//width, height
    0x00, 0x00, header->totalSize>>8, header->totalSize&0xFF,//data size
    0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  };
  *len=sizeof(tmp_packet);
  memcpy(packet, tmp_packet, *len);
}

unsigned char* last_img=bw_img;
void forward_packet(const unsigned char *packet, int len)
{
  code_header_t *h;
  int i, max_idx, img_size;

  if (!packet)
    exit(0);
  printf("fake read:");
  for (i = 0; i < len; i++)
    printf("%02x ", packet[i]);
  putchar('\n');
  fflush(stdout);

  int l;
  char p[100];
  if (packet[10]==0x02)
  {
    h = &bw_header;
    i=0;
    img_size=bw_header.totalSize;
    max_idx=img_size/BIGMSG_DATA_LENGTH+(img_size%BIGMSG_DATA_LENGTH==0?0:1);
    last_img=bw_img;
  }
  else if (packet[10]==0x03)
  {
    h = &col_header;
    i=0;
    img_size=col_header.totalSize;
    max_idx=img_size/BIGMSG_DATA_LENGTH+(img_size%BIGMSG_DATA_LENGTH==0?0:1);
    last_img=col_img;
  }
  else if (packet[10]==0x05)
  {
    i=packet[12]+(packet[11]<<8);
    max_idx=i+packet[14]+(packet[13]<<8);
    img_size = (last_img==bw_img)?bw_header.totalSize:col_header.totalSize;
    printf("requesting lost packets: %d - %d \n",i, max_idx);
  }
  else
  {
    printf("img_stat: not supported image (%d)!\n", packet[10]);
    return;
  }

  //img_stat packet
  if (packet[10]!=0x05)
  {
    img_stat_p(h, p, &l);
    dispatch_packet(p, l);
    printf("img_stat packet len %d written!\n",l);
  }

  //img packets
  while (i<max_idx)
  {
    int part_idx = BIGMSG_DATA_LENGTH*i;
    int part_size=(part_idx+BIGMSG_DATA_LENGTH<=img_size)?BIGMSG_DATA_LENGTH:img_size - part_idx;

    usleep(1000);
    big_msg_hdr_p(p, &l, i);
    memcpy(&(p[l]), &last_img[part_idx], part_size);

    if ((random()%100)<noise_limit)
    {
      dispatch_packet(p, l+part_size);
      if (i%10==0)
        printf("big_msg #%d packet len %d written(part_size %d, l %d,)!\n",i,l+part_size, part_size, l);
    }
    else
      printf("dropping packet\n");
    ++i;
  }
  packets_written++;
  printf("written packets done (%d retries)!\n",packets_written);
}

void parseFile(char* filename, code_header_t *header, unsigned char *data)
{
  FILE *fdIn;
  if (!(fdIn = fopen(filename, "r")) ){
    printf("Can't open %s for reading\n", filename);
    return;
  }

  int count=fread(header, 1, sizeof(code_header_t), fdIn);
  if (count<sizeof(code_header_t))
  {
    printf("too few header bytes read from the img file!\n");
    return;
  }
  printf("decoded header: W=%d H=%d qual=%d COL=%d size=%d\n",header->width, header->height, header->quality, header->is_color, header->totalSize);


  uint8_t line[1024];
  int dataSize;

  dataSize=sizeof(code_header_t);
  memcpy(data, header, sizeof(code_header_t));
  while( (count=fread(line, 1, 1024, fdIn))>0)
  {
    memcpy(&(data[dataSize]),line,count);
		dataSize+=count;
  }
  fclose(fdIn);
}

int main(int argc, char **argv)
{
  if (argc != 3)
    {
      fprintf(stderr,
	      "Usage: %s <port> <noise_limit> - act as a fake sf on <port>\n"
	      "(forwards image data from files coded_bw.huf and coded_jpg.huf)\n"
        "noise_limit:<0,100> is how reliable the data link is (100 means all packets are received)" ,
	      argv[0]);
      exit(2);
    }

  if (signal(SIGPIPE, SIG_IGN) == SIG_ERR)
    fprintf(stderr, "Warning: failed to ignore SIGPIPE.\n");

  open_server_socket(atoi(argv[1]));
  noise_limit = atoi(argv[2]);

  parseFile("coded_bw.huf" ,&bw_header ,bw_img);
  parseFile("coded_col.huf",&col_header,col_img);

  for (;;)
    {
      fd_set rfds;
      int maxfd = -1;
      struct timeval zero;
      int ret;

      zero.tv_sec = zero.tv_usec = 0;

      FD_ZERO(&rfds);
      fd_wait(&rfds, &maxfd, server_socket);
      wait_clients(&rfds, &maxfd);

  	  ret = select(maxfd + 1, &rfds, NULL, NULL, NULL);
      if (ret >= 0)
    	{
    	  if (FD_ISSET(server_socket, &rfds))
    	    check_new_client();

    	  check_clients(&rfds);
    	}
    }
}
