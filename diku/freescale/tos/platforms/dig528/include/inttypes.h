/**
 * @author Mads Bondo Dydensborg
 * @author Jan Flora
 */

#ifndef _INTTYPES_H
#define _INTTYPES_H	1

#include <stdtypes.h>
#ifndef __uint8_t_defined
#define __uint8_t_defined
// typedef Byte uint8_t;
typedef unsigned char uint8_t;
#endif

#ifndef __int8_t_defined
#define __int8_t_defined
// typedef sByte int8_t;
typedef signed char int8_t;
#endif

#ifndef __uint16_t_defined
#define __uint16_t_defined
// typedef Word uint16_t;
typedef unsigned short uint16_t;
#endif

#ifndef __int16_t_defined
#define __int16_t_defined
// typedef sWord int16_t;
typedef signed short int16_t;
#endif

// hc08 CW _always_ assume size_t is unsigned int
typedef unsigned int size_t;

#ifndef __uint32_t_defined
#define __uint32_t_defined
// #warning uint32_t defined to LWord
// typedef LWord uint32_t;
typedef unsigned long uint32_t;
#endif

#ifndef __int32_t_defined
#define __int32_t_defined
// typedef sLWord int32_t;
typedef signed long int32_t;
#endif

#ifndef __uint64_t_defined
#define __uint64_t_defined
#warning uint64_t defined to unsigned long long
typedef unsigned long long uint64_t;
#endif

#ifndef __int64_t_defined
#define __int64_t_defined
#warning int64_t defined to signed long long
typedef signed long long int64_t;
#endif

#endif
