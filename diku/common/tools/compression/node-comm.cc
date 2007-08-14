#include <sys/stat.h>
#include <termios.h>
#include <time.h>
#include <stdio.h>
#include <getopt.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/types.h>
#include <fcntl.h>
#include <inttypes.h>
#include <string>
#include <errno.h>
#include "node-comm.hh"
#include "crc.h"

/*
 * Define "NO_NODE_POWER" to disable power measurement via DAQ
 * This requires a specific DAQ and a bunch very shaky drivers
 */
#ifndef NO_NODE_POWER
#define NO_NODE_POWER
#endif

/**************************************************************************
 *
 * struct timeval functions
 *
 *************************************************************************/
const int usecs_pr_sec = 1000000;

void normalize_timeval(struct timeval &res)
{
  while (res.tv_usec > usecs_pr_sec) {
    res.tv_usec -= usecs_pr_sec;
    res.tv_sec += 1;
  }

  while (res.tv_usec < 0) {
    res.tv_usec += usecs_pr_sec;
    res.tv_sec -= 1;
  }
}

struct timeval operator+(const struct timeval& a, const struct timeval &b)
{
  struct timeval res;
  
  res.tv_sec = a.tv_sec + b.tv_sec;
  res.tv_usec = a.tv_usec + b.tv_usec;

  normalize_timeval(res);
  
  return res;
}

struct timeval operator-(const struct timeval& a, 
			 const struct timeval& b)
{
  struct timeval res;
  
  res.tv_sec = a.tv_sec - b.tv_sec;
  res.tv_usec = a.tv_usec - b.tv_usec;

  normalize_timeval(res);
  
  return res;
}

double tv2f(const struct timeval &t)
{
  return (double)t.tv_sec + (double)t.tv_usec / (double)usecs_pr_sec;
}

/**************************************************************************
 *
 * Input file handling
 *
 *************************************************************************/

bool parse_line(char *buffer, int *res)
{
  char *colon = buffer;

  for (int i = 0; i < 6; i++) {
    colon = strchr(colon, ';');
    
    if (!colon)
      return false;

    colon++;

    res[i] = atoi(colon);
  }

  return true;
}

int count_lines = 0;

bool fill_buffer(FILE *f, uint16_t *buf)
{
  char buffer[1024];

  uint16_t *buf_pos = buf;

  for (int i = 0; i < 42; ) {
    if (fgets(buffer, 1024, f)) {
      int val[6];
      
      if (parse_line(buffer, val)) {
	*buf_pos++ = val[1];
	*buf_pos++ = val[2];
	*buf_pos++ = val[3];
	i++;
	count_lines++;
      }
    } else {
      return false;
    }
  }
  return true;
}

/**************************************************************************
 *
 * Serial communication
 *
 *************************************************************************/
char line[1024];
char *linepos = line;

void flush_serial(int fd)
{
  linepos = line;
  read(fd, line, 1024);
}

char *read_line(int fd, struct timeval *tv)
{
  static char res[1024];
  fd_set rfds;

  /* Do we already have a new line? */
  char * pos;
  
  pos = strchr(line, '\n');
  if (pos) {
    *pos = '\0';
    
    strncpy(res, line, 1024);
    
    memmove(line, pos + 1, 1024 - (pos - line) - 1);
    linepos -= pos - line + 1;
    return res;
  }

  while (1) {
    FD_ZERO(&rfds);
    FD_SET(fd, &rfds);
    int retval = select(fd + 1, &rfds, NULL, NULL, tv);
    if (retval != 0) {
      retval = read(fd, linepos, 1024 - (linepos - line));
      if (retval) {
	linepos += retval;
	*linepos = '\0';
	
	pos = strchr(line, '\n');
	if (pos) {
	  *pos = '\0';
	  
	  strncpy(res, line, 1024);
	  
	  memmove(line, pos + 1, 1024 - (pos - line) - 1);
	  linepos -= pos - line + 1;
	  return res;
	}
      }
    } else {
      return 0;
    }
  } 
}

uint8_t *read_256bytes(int fd)
{
  static uint8_t buffer[256];
  uint8_t *buffer_pos = buffer;
  int retval;
  fd_set rfds;

  while (buffer_pos != buffer + 256) {
    FD_ZERO(&rfds);
    FD_SET(fd, &rfds);
    retval = select(fd + 1, &rfds, NULL, NULL, 0);
    if (retval != 0) {
      retval = read(fd, buffer_pos, 256 - (buffer_pos - buffer));
      
      if (retval) {
	buffer_pos += retval;
      }
    }
  }
  return buffer;
}

uint8_t *read_block(int fd)
{
  const int block_size = 259;
  static uint8_t buffer[block_size];
  uint8_t *buffer_pos = buffer;
  int retval;
  fd_set rfds;
  struct timeval tv;

  memset(buffer, 0xAA, block_size);

  while (buffer_pos - buffer < block_size) {
    FD_ZERO(&rfds);
    FD_SET(fd, &rfds);
    if (buffer_pos == buffer) {
      tv.tv_sec = 1;
      tv.tv_usec = 0;
    } else {
      tv.tv_sec = 5;
      tv.tv_usec = 0;
    }

    retval = select(fd + 1, &rfds, NULL, NULL, &tv);
    if (retval > 0) {
      retval = read(fd, buffer_pos, block_size - (buffer_pos - buffer));
      
      if (retval > 0) {
				buffer_pos += retval;
				if ((buffer_pos - buffer) == 2 && buffer[0] == 'f' 
						&& buffer[1] == '\n') {
					return 0;
				} 
      } else if (retval < 0) {
				throw std::string(std::string("Error reading: ") + strerror(errno));
      } else if (retval == 0) {
				fprintf(stderr, "Strange, read 0 bytes?\n");
      }
    } else if (retval == 0) {
      if (buffer_pos == buffer) {
				write(fd, "!", 1);
      } else {
				throw std::string("Timeout reading block");
      }
    } else {
      throw std::string("Select error");
    }
  }

  uint16_t crc = 0xFFFF;
  
	//	fprintf(stderr, "\n");
  for (size_t j = 0; j < block_size - 2; j++) {
		/*		fprintf(stderr, " %02X", ((uint8_t*)buffer)[j]);
		if (j % 16 == 15) 
		fprintf(stderr, "\n");*/
		
    crc = crcByte(crc, ((uint8_t*)buffer)[j]);
	}

  if (crc != *(uint16_t*)(buffer + block_size - 2)) {
    char buf[1024];
    snprintf(buf, 1024, "CRC in packet is 0x%04X. Should have been 0x%04X\n", 
	     *(uint16_t*)(buffer + block_size - 2), crc);
    throw std::string(buf);
  }

  return buffer + 1;
}

uint16_t real_buffer[4 * 239 * 256 / sizeof(uint16_t)];

void sync_with_node(int fd)
{
  printf("Syncing with node... ");
  fflush(stdout);

  while (1) {
    flush_serial(fd);
    write(fd, "p", 1);
    struct timeval tv;
    tv.tv_sec = 1;
    tv.tv_usec = 0;

    char *line = read_line(fd, &tv);
    if (line == 0) {
      uint8_t buf[256];
      memset(buf, 0, 256);
      write(fd, buf, 256);
      continue;
    }
      
    if (strcmp(line, "pong") == 0) {
      break;
    }
  }

  printf("done\n");
}

void flush_node(int fd) 
{
  printf("Flushing... ");
  write(fd, "f", 2);
  char *line = read_line(fd, 0);

  if (strcmp(line, "done") != 0) {
    printf("Got \"%s\" instead of done. Bailing out\n", line);
    exit(1);
  }
  printf("done\n");  
}

const uint16_t total_pages = 4096 / 256;

void really_write(int fd, const void *buf, size_t len)
{
  size_t left = len;
  do {
    size_t res = write(fd, (const uint8_t*)buf + (len - left), left);
    /*
    for (uint8_t* i = (uint8_t*)buf + (len - left) ;
	 i< (uint8_t*)buf+len ;
	 i++) {
      printf("%c", buf);
      }*/

    if (res > 0) {
      left -= res;
    } else if (res < 0) {
      if (errno == EINTR) {
	continue;
      } else {
	perror("Error writing to node");
	    exit(1);
      }
    }
  } while (left > 0);
}

int uploaded_pages;

bool upload_pages(int fd, FILE *data_file)
{
  struct timeval tv;
  tv.tv_sec = 1;
  tv.tv_usec = 0;
  // Read potential left-over data from the node.
  char *line = read_line(fd, &tv);

  printf("Preparing for data upload... ");
  write(fd, "a", 2);
  line = read_line(fd, 0);

  if (strcmp(line, "ok") != 0) {
    printf("Got \"%s\" instead of ok. Bailing out\n", line);
    exit(1);
  }

  printf("done\n");

  printf("Uploading pages");

  uint16_t *buffer = real_buffer;

  bool more_data = true;

  uploaded_pages = 0;

  for (int i = 0; i < total_pages; i++) {
    bool retry = false;

    more_data = fill_buffer(data_file, buffer);
    do {
      if (retry) {
				sleep(1);
				flush_serial(fd);
      }
      really_write(fd, "b", 1);
      really_write(fd, buffer, 256);
	    
      uint16_t crc = 0xFFFF;

      for (size_t j = 0; j < 256; j++)
				crc = crcByte(crc, ((uint8_t*)buffer)[j]);

      really_write(fd, &crc, 2);

      struct timeval tv;
      tv.tv_sec = 1;
      tv.tv_usec = 0;
      
      char * line = read_line(fd, &tv);
      if (!line) {
				printf("Node did not respond in a timely manner. Trying again.\n");
				char buf[256];
				memset(buf, 0, 256);
				write(fd, buf, 256);
				read_line(fd, &tv);
				retry = true;
      } else {
				if (strcmp(line, "ok") != 0) {
					retry = true;
					printf("Node responded with \"%s\". Trying again (CRC 0x%X).\n", line, crc);
				} else {
					printf(".");
					fflush(stdout);
					retry = false;
					uploaded_pages++;
				}
      }
    } while (retry);
    buffer += 256 / sizeof(*buffer);
    if (!more_data)
      break;
  }
	
  write(fd, "x", 1);
  printf(" done\n");
  return more_data;
}

void read_uploaded_pages(int fd)
{
  printf("Reading pages back");

  uint16_t *buffer = real_buffer;
  
  for (int i = 0; i < uploaded_pages; i++) {
    write(fd, "r", 1);
    
    uint8_t *buf = read_256bytes(fd);
    
    if (memcmp(buffer, buf, 256) == 0) {
      printf(".");
      fflush(stdout);
    } else {
      printf("\nPosition %d did not match\n", i);

      printf("Data sent to node:\n");

      for (int j = 0; j < 256; j++) {
	printf("%02x ", ((uint8_t*)buffer)[j]);
	if ((j + 1) % 16 == 0)
	  printf("\n");
      }

      printf("\n");

      printf("Data received from node:\n");

      for (int j = 0; j < 256; j++) {
	printf("%02x ", ((uint8_t*)buf)[j]);
	if ((j + 1) % 16 == 0)
	  printf("\n");
      }

      printf("\n");
			exit(1);
    }
    buffer += 256 / sizeof(*buffer);
  }
  
  write(fd, "x", 1);
  
  printf("\n");
}

double total_time = 0;
double total_watt = 0;
int count_watt = 0;

void do_compress(int fd, FILE *out_file, bool cont)
{
  struct timeval start_time, end_time;

  if (out_file) {
    write(fd, "C", 1);
  } else {
    write(fd, "c", 1);
  }
#ifndef NO_NODE_POWER
  start_power();
#endif
  gettimeofday(&start_time, 0);

  printf("Compressing data");
  fflush(stdout);
  
  uint8_t *data = 0;
  do {
    try {
      data = read_block(fd);
    } catch (std::string &e) {
      printf(("\nLost sync with node (error: " + e 
	      + "). Flushing, and requesting resend.\n").c_str());
      sleep(1);
      uint8_t buf[1024];
      printf("Read %d bytes while flushing.\n", read(fd, buf, 1024));
      write(fd, "a", 1);
      data = buf;
      continue;
    }
    if (out_file && data) {
      write(fd, "o", 1);
      fwrite(data, 256, 1, out_file);
      printf(".");
      fflush(stdout);
    }
  } while (data != 0);

  gettimeofday(&end_time, 0);
#ifndef NO_NODE_POWER
  double power = stop_power();
#endif
  printf("\nReceived end signal\n");
  fflush(stdout);

  printf("Compression took: %6.4f seconds.", 
	 tv2f(end_time - start_time));

#ifndef NO_NODE_POWER
   printf(" Average power: %6.4f mW", power);
#endif
     
  printf("\n");

  total_time += tv2f(end_time - start_time);
#ifndef NO_NODE_POWER
  total_watt += power;
  count_watt++;
#endif

  if (!cont && out_file) {
    write(fd, "F", 1);
    try {
      data = read_block(fd);
      fflush(stdout);
    } catch (std::string &e) {
      printf(("Error: " + e + "\n").c_str());
      exit(0);
    }
    if (data) {
      fwrite(data, 256, 1, out_file);
    }
  }
}

// Borrowed from miniterm.c
int cook_baud(int baud)
{
    int cooked_baud = 0;
    switch ( baud )
    {
    case     50: cooked_baud =     B50; break;
    case     75: cooked_baud =     B75; break;
    case    110: cooked_baud =    B110; break;
    case    134: cooked_baud =    B134; break;
    case    150: cooked_baud =    B150; break;
    case    200: cooked_baud =    B200; break;
    case    300: cooked_baud =    B300; break;
    case    600: cooked_baud =    B600; break;
    case   1200: cooked_baud =   B1200; break;
    case   1800: cooked_baud =   B1800; break;
    case   2400: cooked_baud =   B2400; break;
    case   4800: cooked_baud =   B4800; break;
    case   9600: cooked_baud =   B9600; break;
    case  19200: cooked_baud =  B19200; break;
    case  38400: cooked_baud =  B38400; break;
    case  57600: cooked_baud =  B57600; break;
    case 115200: cooked_baud = B115200; break;
    case 230400: cooked_baud = B230400; break;
    }
    return cooked_baud;
}

int main(int argc, char * argv[]) 
{
  struct termios oldtio, newtio;
  int fd, ser_speed=cook_baud(230400);
  char *input_file_name = NULL;
  char *output_file_name = NULL;
  char *serial_device = NULL;
  int max_runs = -1;
  FILE *data_file;
  FILE *out_file = 0;

  int c;

  while ((c = getopt(argc, argv, "hr:d:o:s:")) != EOF ){
    switch (c) {
    case 'h':
      printf("Usage: node-comm input-file [-d device] [-s speed] [-r runs] [-o ouput file]\n\n"
	     " -h             This help message\n"
	     " -d             The serial device to communicate with the mote\n"
	     " -s             The transfer rate of the serial device (speed) \n"
	     " -r             Maximum number of blocks to compress\n"
	     " -o             Output file\n"
	     );
      return 0;
      break;
    case 'r':
      max_runs = atoi(optarg);
      break;
    case 'd':
      serial_device = optarg;
      break;
    case 's':
      if ( (ser_speed = cook_baud(atoi(optarg))) == 0 ) {
	printf("Bad serial speed\n");
	return -1;
      }
      break;
    case 'o':
      output_file_name = optarg;
      break;
    }
  }
  if (optind >= argc) {
    fprintf(stderr, "You must specify a file to upload (-h for help)\n");
    return -1;
  } else {
    input_file_name = argv[optind];
  }


  if (output_file_name != NULL) {
    out_file = fopen(output_file_name, "w");
    if (!out_file) {
      perror("Cannot open output file");
    }
  }

  data_file = fopen(input_file_name, "r");
  if (!data_file) {
    perror("Cannot open data file");
    exit(1);
  }

  if (serial_device == NULL){
    serial_device = "/dev/ttyUSB0";
  }
  fd = open(serial_device, O_RDWR);
  if (fd < 0) {
    perror("Cannot open serial port");
    exit(1);
  }

  tcgetattr(fd, &oldtio);	/* save current serial port settings */
  memset(&newtio, 0, sizeof (newtio));

  //newtio.c_cflag = B230400 | CS8 | CLOCAL | CREAD | HUPCL;
  newtio.c_cflag = ser_speed | CS8 | CLOCAL | CREAD | HUPCL;
  newtio.c_iflag = IGNBRK;
  newtio.c_oflag = 0;
  newtio.c_lflag = 0;//FLUSHO;

  //  tcflush(fd, TCIOFLUSH);
  tcsetattr(fd, TCSANOW, &newtio);

  tcflush(fd, TCIOFLUSH);

#ifndef NO_NODE_POWER
  init_power();
#endif
   
  sync_with_node(fd);

  flush_node(fd);

  bool cont = true;
  int cnt=0;
  while (cont) {
    cont = upload_pages(fd, data_file);
    read_uploaded_pages(fd);
    do_compress(fd, out_file, cont);
    cnt++;
    if (max_runs>0) {
      if (cnt >= max_runs) {
	cont = false;
      }
    }
  }

  printf("End results:\n");
  printf("  Compressed lines: %d\n", count_lines);
  printf("  Compression time: %6.4f s\n", total_time);
#ifndef NO_NODE_POWER
  printf("  Average Power   : %6.4f mW\n", total_watt / count_watt);
  halt_power();
#endif

  return 0;
}
