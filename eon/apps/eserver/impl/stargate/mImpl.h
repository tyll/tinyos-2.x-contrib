#ifndef _MIMPL_H_
#define _MIMPL_H_

#include "mNodes.h"
#include "runtime/rt_structs.h"
#include "mStructs.h"
void init (int argc, char **argv);
int Reply (Reply_in * in, Reply_out * out);
int ReadRequest (ReadRequest_in * in, ReadRequest_out * out);
void BadRequest (ReadRequest_in * in, int err);
int Handler (Handler_in * in, Handler_out * out);
int Listen (Listen_out * out);
int Page (Page_in * in, Page_out * out);
int ReadWrite (ReadWrite_in * in, ReadWrite_out * out);
void FourOhFor (ReadWrite_in * in, int err);
int Unavailable (Unavailable_in * in, Unavailable_out * out);
#endif // _MIMPL_H_
