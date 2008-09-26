#include "mImpl.h"
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/select.h>
#include <sys/stat.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <netdb.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <poll.h>
#define SERVER_PORT 80
#define BUFFER_SIZE 8192

const uint8_t minPathState[NUMPATHS] =
  { STATE_BASE, STATE_BASE, STATE_BASE, STATE_BASE, STATE_BASE, STATE_TEXT,
STATE_TEXT, STATE_TEXT, STATE_TEXT, STATE_TEXT, STATE_TEXT, STATE_TEXT, STATE_TEXT, STATE_TEXT, STATE_TEXT,
STATE_TEXT, STATE_TEXT, STATE_BASE };
#include "mImpl.h"

int socket_in_use[1024], s, root_len;
struct sockaddr_in server_addr;
fd_set read_fds;
char *root;

int suffixTest(char *val, char *suffix) {
  int len = strlen(val);
  int s_len = strlen(suffix);
  int i;
  
  for (i=0;i<s_len;i++) {
    if (val[len-i]!=suffix[s_len-i])
      return 0;
  }
  return 1;
}

void closeSocket(int socket) {
  close(socket);
  if (socket > -1) {
    if (socket < 1024)
      socket_in_use[socket] = 2;
    else 
      printf("ERR, socket to large\n");
  }
}

void returnSocket(int socket) {
  socket_in_use[socket] = 0;
}


void writeHeaders(int socket_in, bool close, int length, char *content) {
  char msg[128];
  
  sprintf(msg, "Content-Length: %d\r\n", length);
  write(socket_in, msg, strlen(msg));
  sprintf(msg, "Server: Markov 0.1\r\n");
  write(socket_in, msg, strlen(msg));
  sprintf(msg, "Content-Type: %s\r\n", content);
  write(socket_in, msg, strlen(msg));
  if (close)
    write(socket_in, "Connection: close\r\n",19); 
  write(socket_in, "\r\n", 2);
}

void
init (int argc, char **argv)
{
 int old_flags, i;

  for (i=0;i<1024;i++)
    socket_in_use[i] = 2;

  s = socket(AF_INET,SOCK_STREAM,0);
  int val = 1;
    if (setsockopt(s, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val)) < 0)
    {
        perror("setsockopt: ");
        exit(1);
    }
 
  if (argc < 3) {
     fprintf (stderr, "Usage: %s <root-dir> <port-number> \n", argv[0]);
     exit(1);
  }

  server_addr.sin_family = AF_INET;
  server_addr.sin_port = htons(SERVER_PORT);
  server_addr.sin_addr.s_addr = htonl(INADDR_ANY);

  FD_ZERO(&read_fds);
  FD_SET(s, &read_fds);
  
  root = argv[1];
  root_len = strlen(root);
    
  if ((bind(s,(struct sockaddr*) &server_addr, sizeof(struct sockaddr))) < 0) {
    perror("Bind: ");
    return;
  }
  if (listen(s,50000)<0) {
    perror("Listen : ");
    return;
  }
  if (server_addr.sin_addr.s_addr) {
    fprintf (stderr, "listening on address %s, port %d\n",
	     server_addr.sin_addr.s_addr, SERVER_PORT);
  } else {
    fprintf (stderr, "listening on address (NULL), port %d\n",SERVER_PORT);
  }

}

// IN:  [int socket, bool close, int length, char* content, char* output]
// OUT: []
int
Reply (Reply_in * in, Reply_out * out)
{
  //if (in->close) {
    closeSocket(in->socket);
  //}
  //else 
    //returnSocket(in->socket);

  return 0;
}

// IN:  [int socket]
// OUT: [int socket, bool close, char* file]
int
ReadRequest (ReadRequest_in * in, ReadRequest_out * out)
{
char buf[BUFFER_SIZE];
  int rd,i;
  int length = 0; 
  int doneRequest = 0;
  out->file = 0;
  out->close = 0;

  //DEBUG printf("ReadRequest in\n");
  do {
    rd = read(in->socket, buf+length, BUFFER_SIZE-length);
    if (rd == -1) {
      perror("Reading request");
      closeSocket(in->socket);
      return -1;
    } 
    else if (!rd) {
      usleep(1000*10);
    }
    else {
      char *start = buf;
      char *end;
      for (i=0;i<rd;i++) {
	if (buf[i] == '\r') {
	  buf[i++] = 0;
	  buf[i] = 0; // Get rid of the \n
	  //DEBUG printf("%s\n", start);
	  if (length == 0) { // We're done...
	    doneRequest = 1;
	    break;
	  }
	  else if (start[0] == 'G' && start[1] == 'E' && start[2] == 'T') {
	    start = strchr(start, ' ')+1;
	    end = strchr(start+1, ' ');
	    *end = 0;
	    while (*end != 'H')
	      end++;
	    while (*end != '/')
	      end++;
	    end++;
	    int major = *end-'0'; // HACK HACK HACK Assumes ASCII
	    end+=2;
	    int minor = *end-'0'; // HACK HACK HACK Assumes ASCII
	    if (major != 1 || (minor > 1))
	      printf("Urm, HTTP version: %d.%d we may be in trouble...\n", 
		     major, minor);
	    if (major == 1 && minor == 0) {
	      out->close = 1;
	    }
	    
	    if (*start == '/')
	      start++;
	    out->file = strdup(start);
	  }
	  else if (start[0] == 'C' && start[1] == 'o' && start[2] == 'n' &&
		   strstr(start, "close")) {
	    out->close = 1;
	  }
	  start=buf+i+1;
	  length = 0;
	}
	else {
	  length++;
	}
      }
      if (!doneRequest) {
	strncpy(buf, start, length);
      }
    }  
  } while (!doneRequest);

  if (!out->file) {
    out->file = "/sys_error.html";
  }

  out->socket = in->socket;
  // DEBUG printf("Request:%s:\n", out->request);
  return 0;
}

// IN:  [int socket]
void
BadRequest (ReadRequest_in * in, int err)
{
 char *msg = "HTTP/1.1 404 File not found\r\n";
  write(in->socket, msg, strlen(msg));
  msg = "<html><body><h2>404 File Not Found!</h2><br>ReadRequest error</body></html>\n";
  writeHeaders(in->socket, 1,strlen(msg), "text/html");
  write(in->socket, msg, strlen(msg));
  closeSocket(in->socket);
}

// IN:  [int socket, bool close, char* file]
// OUT: []
int
Handler (Handler_in * in, Handler_out * out)
{

}

// IN:  []
// OUT: [int socket]
int
Listen (Listen_out * out)
{
//out->type = in->type;
	
/*	int bind_socket = -1;
	
//	out->type = in->type;
//	out->filename = in->request.url;
	
	struct sockaddr_in server_addr;
	bind_socket =  socket(AF_INET, SOCK_STREAM, 0);
	
	int val = 1;
	if (setsockopt(bind_socket, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val)) < 0)
	{
		perror("setsockopt: ");
		exit(1);
	}
	server_addr.sin_family = AF_INET;
	server_addr.sin_port = htons(SERVER_PORT);
	server_addr.sin_addr.s_addr = htonl(INADDR_ANY);

	if ((bind(bind_socket,(struct sockaddr*) &server_addr, sizeof(struct sockaddr))) < 0) {
		perror("Bind: ");
		return -1;
	}
	if (listen(bind_socket,500)<0) {
		perror("Listen : ");
		return -1;
	}
	printf ("listening on address %X, port %d\n", server_addr.sin_addr.s_addr, SERVER_PORT);
	
	struct timeval select_timeout;
	
	select_timeout.tv_sec = 5;
	select_timeout.tv_usec = 0; 

	fd_set read_fds;
	FD_ZERO(&read_fds);
	FD_SET(bind_socket, &read_fds);
	int max = bind_socket;
*/
//	int sel;
//	if ( sel=select(max+1, &read_fds, NULL, NULL, &select_timeout) > 0)
//	{
		socklen_t length =  sizeof(struct sockaddr);
		out->socket = accept(s, (struct sockaddr *)&server_addr,&length);
		if(out->socket==-1)
			return -1;
		int optval = 1;
		if (setsockopt (out->socket, SOL_TCP, TCP_NODELAY, &optval, sizeof (optval)) < 0)
		{
			perror("setsockopt");
		}
		
		//socket_in_use[out->socket] = 1;
		
//	}
	
	return 0;
}

// IN:  [int socket]
// OUT: []
int
Page (Page_in * in, Page_out * out)
{

}

// IN:  [int socket, bool close, char* file]
// OUT: [int socket, bool close, int length, char* content, char* output]
int
ReadWrite (ReadWrite_in * in, ReadWrite_out * out)
{
FILE *f;
  int rd;
  struct stat sb;
  int res;
  char file_name[128];
	       
  out->socket = in->socket;
  out->close = in->close;
  sprintf(file_name, "%s/%s", root, in->file);
  //DEBUG printf("Looking for:%s:\n", file_name);
  res = stat(file_name, &sb);
  
  int file_size = sb.st_size;

  if (res < 0) {
    return 404;
  }
  else {
    int ix=0;
    char *ptr;
    int header_len;
    
    if (suffixTest(in->file, ".html")) {
      out->content = "text/html";
    }
    else if (suffixTest(in->file, ".png")) {
      out->content = "image/png";
    }
    else if (suffixTest(in->file, ".jpg") || suffixTest(in->file, ".jpeg")) {
      out->content = "image/jpeg";
    }
    else if (suffixTest(in->file, ".gif")) {
      out->content = "image/gif";
    }
    else if (suffixTest(in->file, ".mp4")) {
      out->content = "video/mp4";
    }
    else if (suffixTest(in->file, ".mpeg")) {
      out->content = "video/mpeg";
    }
    else if (suffixTest(in->file, ".mov")) {
      out->content = "video/mov";
    }
    else if (suffixTest(in->file, ".wav")) {
      out->content = "audio/wav";
    }

    else if (suffixTest(in->file, ".mpeg")) {
      out->content = "video/mpeg";
    }

    else if (suffixTest(in->file, ".gif")) {
      out->content = "image/gif";
    }

    else {
      out->content = "text/plain";
    }
    
    //out->content="text/plain";
    char hdrs[8192];
    if (in->close) {
      sprintf(hdrs, "HTTP/1.1 200 OK\r\nContent-type: %s\r\nServer: Markov 0.1\r\nConnection: close\r\nContent-Length: %d\r\n\r\n", 
	      out->content, file_size);
    }
    else {
      sprintf(hdrs, "HTTP/1.1 200 OK\r\nContent-type: %s\r\nServer: Markov 0.1\r\nContent-Length: %d\r\n\r\n", 
	      out->content, file_size);
    }
    //printf(hdrs);
    header_len = strlen(hdrs);
    int written = write(in->socket, hdrs, header_len);
    while (written < header_len) {
      if (written < 0) {
	perror("Writing");
	closeSocket(in->socket);
	return -1;
      }
      written += write(in->socket, hdrs+written, header_len-written);
    }
    //out->length = sb.st_size+header_len;
    
    int fd = open(file_name, O_RDONLY);
    if (fd < 0) {
      perror("Reading");
      closeSocket(in->socket);
      return -1;
    }
    //out->output = (char *)malloc(out->length);
    //memcpy(out->output, hdrs, header_len);
    //ptr = out->output+strlen(hdrs);
    char *pos;
    do {
      
      if ((rd = read(fd, hdrs, 8192)) < 0) {
	perror("read");
	closeSocket(in->socket);
	return 0;
      }
      ix += rd;
      pos = hdrs;
      while (rd > 0) {
	int ret = write(in->socket, hdrs, rd);
	if (ret < 0) {
	  perror("write");
	  closeSocket(in->socket);
	  close(fd);
	  return 0;
	}
	else if (ret == 0) {
	  rd = 0;
	  break;
	}
	else {
	  pos += ret;
	  rd -= ret;
	}
      }
    } while (ix < sb.st_size);
    close(fd);
  }
  //DEBUG printf("Done reading for:%s:\n", file_name);
  return 0;

}

// IN:  [int socket, bool close, char* file]
void
FourOhFor (ReadWrite_in * in, int err)
{
 char *msg = "HTTP/1.1 404 File not found\r\n";
  write(in->socket, msg, strlen(msg));
  msg = "<html><body><h2>404 File Not Found!</h2><br>ReadWrite Error.</body></html>\n";
  writeHeaders(in->socket, in->close, strlen(msg), "text/html");
  write(in->socket, msg, strlen(msg));
  closeSocket(in->socket);
}

// IN:  [int socket, bool close, char* file]
// OUT: []
int
Unavailable (Unavailable_in * in, Unavailable_out * out)
{
 char *msg;

    msg = "HTTP/1.1 400 Bad Request\r\n";
    if (write(in->socket, msg, strlen(msg)) != -1) {
      msg = "<html><body><h2>400 Bad Request!</h2></body></html>\n";
      writeHeaders(in->socket, 1, strlen(msg), "text/html");
        write(in->socket, msg, strlen(msg));
    }

  closeSocket(in->socket);

}
