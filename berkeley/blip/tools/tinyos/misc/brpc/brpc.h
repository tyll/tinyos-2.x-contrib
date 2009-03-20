#ifndef BRPC_H
#define BRPC_H

#include <sys/socket.h>
#include <arpa/inet.h>
#include <stdint.h>
typedef uint16_t r_error_t;

#define SUCCESS 0
#define EFAIL 399
#define ESHORT  400
#define EWRONGIFACE 401
#define EWRONGFUNC 402

#endif
