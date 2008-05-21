
// This file is a copy of the tinyos tos.h header. It adds a
// combine function for booleans

#if !defined(__CYGWIN__)
#if defined(__MSP430__)
#include <sys/inttypes.h>
#else
#include <inttypes.h>
#endif
#else //cygwin
#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#endif

#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <stddef.h>
#include <ctype.h>


typedef uint8_t bool __attribute__((combine(bcombine)));
enum { FALSE = 0, TRUE = 1 };

bool bcombine(bool r1, bool r2)
/* Returns: r1 if r1 == r2, FALSE otherwise. This is the standard error
     combination function: two successes, or two identical errors are
     preserved, while conflicting errors are represented by FALSE.
*/
{
  return r1 == r2 ? r1 : FALSE;
}

typedef nx_int8_t nx_bool;
uint16_t TOS_NODE_ID = 1;

/* This macro is used to mark pointers that represent ownership
   transfer in interfaces. See TEP 3 for more discussion. */
#define PASS

struct @atmostonce { };
struct @atleastonce { };
struct @exactlyonce { };

/* This platform_bootstrap macro exists in accordance with TEP
   107. A platform may override this through a platform.h file. */
#include <platform.h>
#ifndef platform_bootstrap
#define platform_bootstrap() {}
#endif

#ifndef TOSSIM
#define dbg(s, ...)
#define dbgerror(s, ...)
#define dbg_clear(s, ...)
#define dbgerror_clear(s, ...)
#endif

