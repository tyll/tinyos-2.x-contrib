#ifndef PLATFORM_H
#define PLATFORM_H

#define AVRMOTE 1
#define TELOS   2
#define MICAZ   3

#if !defined(__CYGWIN__)
#include <inttypes.h>
#else //__CYGWIN
#include <sys/types.h>
// Earlier cygwins do not define uint8_t & co
#ifndef _STDINT_H
#ifndef __uint32_t_defined
#define __uint32_t_defined
typedef u_int32_t uint32_t;
#endif
#endif

#endif //__CYGWIN

extern uint32_t platform;

#endif
