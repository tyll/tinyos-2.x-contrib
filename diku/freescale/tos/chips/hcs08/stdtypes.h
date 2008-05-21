/* $Id$ */
/* Some defines that HCS08 needs to compile..  We can't just copy the
   stuff, because that would be a copyright violation.

   @author Mads Bondo Dydensborg, madsdyd@diku.dk.

   Note: these are default assumptions. It is possibly to redefine all
   this, but it will bite ya.

*/

#ifdef WE_DO_NOT_NEED_THESE_CW_HAVE_DEFAULTS
#ifdef __STDTYPES_H__
#define __STDTYPES_H__

/* 8bit types */
typedef unsigned char Byte;
typedef signed char sByte;

/* 16 bit types */
typedef unsigned short Word;
typedef signed short sWord;

/* 32 bit types */
typedef unsigned long LWord;
typedef signed long sLWord;

/* Varios */
typedef  unsigned char uchar;
typedef  signed char schar;

typedef  unsigned int uint;
typedef  signed int sint;

typedef  unsigned long ulong;
typedef  signed long slong;

/** Defines the enum_t type. */
#warning Defining enum to 32 bit unsigned!
typedef sLWord  enum_t;

/* I wonder if this is used anywhere at all? */
typedef int Bool;
#define TRUE  1
#define FALSE 0

#endif

#endif /* WE DO NOT NEED THIS */
