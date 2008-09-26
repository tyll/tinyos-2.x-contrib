#include "mImpl.h"

#include "mImpl.h"
#include <unistd.h>

#include <fcntl.h>

#include <sys/socket.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/types.h>

#include <netinet/tcp.h>
#include <netinet/in.h>

const uint8_t minPathState[NUMPATHS] =
{ STATE_BASE, STATE_BASE, STATE_BASE, STATE_BASE, STATE_BASE, STATE_BASE,
STATE_BASE, STATE_TEXT, STATE_TEXT, STATE_TEXT, STATE_TEXT, STATE_IMAGE_THUMB, STATE_IMAGE_THUMB,
STATE_IMAGE_THUMB, STATE_IMAGE_THUMB, STATE_IMAGE_THUMB, STATE_IMAGE_THUMB, STATE_IMAGE_THUMB,
STATE_IMAGE_THUMB };
#include "mImpl.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
int socket_in_use[1024];
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

void closeSocket(int socket) {
	close(socket);
	if (socket > -1) {
		if (socket < 1024)
			socket_in_use[socket] = 2;
		else 
			printf("ERR, socket to large\n");
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
void init (int argc, char **argv)
{
	int i;
	for (i=0; i<1024; i++)
		socket_in_use[i] = 2;
	
}

// IN:  [uint16_t connid]
// OUT: []
int CloseZigbee (CloseZigbee_in * in, CloseZigbee_out * out)
{
	return 0;
}

// IN:  [uint16_t connid, uint16_t port_num, uint8_t type, request_t request]
// OUT: []
int StargatePage (StargatePage_in * in, StargatePage_out * out)
{
	return 0;
}

// IN:  [uint16_t connid, int socket]
// OUT: [uint16_t connid]
int CloseWifi (CloseWifi_in * in, CloseWifi_out * out)
{
	
	closeSocket(in->socket);
	return 0;
}

// IN:  [uint16_t connid, uint8_t type, request_t request]
// OUT: [uint16_t connid, uint8_t type, char* data, int size]
int ReadText (ReadText_in * in, ReadText_out * out)
{
	out->connid = in->connid;
	out->type = in->type;
	
	int file_size = -1; // file size in bytes -1 by default
	
	// first we get the file size...
	//struct stat *buf = (struct stat *) malloc (sizeof(struct stat)); 
	struct stat buf;
	stat(in->request, &buf);
	
	file_size = buf.st_size;
	if (file_size <= 0)
	{
		printf("SrvImage: error... invalid file size\n");
		free (buf);
		return -1;	
	}
	out->size = file_size;
	// open the file
	int fd = open(in->request, O_RDONLY);
	// now map the file
	out->data = mmap(0, file_size, PROT_READ, MAP_SHARED, fd, 0);
	
	close(fd);
	
	return 0;

}

// IN:  [uint16_t connid, uint8_t type, request_t request]
void SorryErr (ReadText_in * in, int err)
{

}

// IN:  [uint16_t connid, uint8_t type, char* data, int size]
// OUT: [uint16_t connid]
int SendZigbee (SendZigbee_in * in, SendZigbee_out * out)
{
	out->connid = in->connid;


	return 0;
}

// IN:  [uint16_t connid, uint16_t port_num, uint8_t type, request_t request]
// OUT: [uint16_t connid, int socket, uint8_t type, char* filename]
int StargateListen (StargateListen_in * in, StargateListen_out * out)
{
	out->connid = in->connid;
	out->type = in->type;
	
	int bind_socket = -1;
	out->connid = in->connid;
	out->type = in->type;
	out->filename = in->request;
	
	struct sockaddr_in server_addr;
	bind_socket =  socket(AF_INET, SOCK_STREAM, 0);
	
	int val = 1;
	if (setsockopt(bind_socket, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val)) < 0)
	{
		perror("setsockopt: ");
		exit(1);
	}
	server_addr.sin_family = AF_INET;
	server_addr.sin_port = in->port_num;
	server_addr.sin_addr.s_addr = htonl(INADDR_ANY);

	if ((bind(bind_socket,(struct sockaddr*) &server_addr, sizeof(struct sockaddr))) < 0) {
		perror("Bind: ");
		return -1;
	}
	if (listen(bind_socket,50000)<0) {
		perror("Listen : ");
		return -1;
	}
	printf ("listening on address %s, port %d\n", server_addr.sin_addr.s_addr, in->port_num);
	
	struct timeval select_timeout;
	
	select_timeout.tv_sec = 0;
	select_timeout.tv_usec = 10*1000; // Half a second... too short?

	fd_set read_fds;
	FD_ZERO(&read_fds);
	FD_SET(bind_socket, &read_fds);
	int max = bind_socket;

	int sel;
	if ( sel=select(max+1, &read_fds, NULL, NULL, &select_timeout) > 0)
	{
		socklen_t length =  sizeof(struct sockaddr);
		out->socket = accept(bind_socket, (struct sockaddr *)&server_addr,&length);
		int optval = 1;
		if (setsockopt (out->socket, SOL_TCP, TCP_NODELAY, &optval, sizeof (optval)) < 0)
		{
			perror("setsockopt");
		}
		
		socket_in_use[out->socket] = 1;
		
	}
	else
	{
		return -1;
	}
	
	return 0;
	
	
	return 0;
}

// IN:  [uint16_t connid, int socket, uint8_t type, char* filename]
// OUT: [uint16_t connid, int socket, uint8_t type, char* data, int size]
int ReadData (ReadData_in * in, ReadData_out * out)
{
	out->connid = in->connid;
	out->type = in->type;
	out->socket = in->socket;
	
	out->connid = in->connid;
	out->type = in->type;
	
	int file_size = -1; // file size in bytes -1 by default
	
	// first we get the file size...
	//struct stat *buf = (struct stat *) malloc (sizeof(struct stat)); 
	struct stat buf;
	stat(in->filename, &buf);
	
	file_size = buf.st_size;
	if (file_size <= 0)
	{
		printf("SrvImage: error... invalid file size\n");
		free (buf);
		return -1;	
	}
		
	out->size = file_size;
	
	// open the file
	int fd = open(in->filename, O_RDONLY);
	// now map the file
	out->data = mmap(0, file_size, PROT_READ, MAP_SHARED, fd, 0);
	
	
	return 0;
}

// IN:  [uint16_t connid, int socket, uint8_t type, char* data, int size]
// OUT: [uint16_t connid, int socket]
int SendWifi (SendWifi_in * in, SendWifi_out * out)
{
	out->connid = in->connid;
	out->socket = in->socket;
	
	// now we send...
	char *content = "image/jpeg";	
	char hdrs[256];
	sprintf(hdrs, "HTTP/1.1 200 OK\r\nContent-type: %s\r\nServer: eFlux 0.1\r\nConnection: close\r\nContent-Length: %d\r\n\r\n", 
			content, in->size);
	
	int header_len = strlen(hdrs);
	int written = write(in->socket, hdrs, header_len);
	while (written < header_len) 
	{
		if (written < 0) 
		{
			perror("Writing");
			closeSocket(in->socket);
			//int munmap(void *start, size_t length);
			munmap(in->data, in->size);
			return -1;
		}
		written += write(in->socket, 
						 hdrs+written, 
						 header_len-written);
	}
	
	written = write(in->socket, in->data, in->size);
	while (written < in->size) 
	{
		if (written < 0) 
		{
			perror("Writing");
			closeSocket(in->socket);
			munmap(in->data, in->size);
			return -1;
		}
		written += write(in->socket, 
						 in->data + written, 
						 in->size - written);
	}
	munmap(in->data, in->size);

	
	return 0;
}
