
#ifndef SINGLE_STREAM_H
#define SINGLE_STREAM_H

#include "common_header.h"
#include "sizes.h"
//includes common_header;

// stream_t
typedef struct _stream
{
	flashptr_t tail;
	bool doEcc;
	flashptr_t traverse;
} stream_t;


#endif
