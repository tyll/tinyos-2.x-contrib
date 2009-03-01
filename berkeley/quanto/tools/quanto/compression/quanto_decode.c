/*
 *  Copyright (c) 2009 Rodrigo Fonseca <rodrigo.fonseca@gmail.com>
 * 
 *  Permission is hereby granted, free of charge, to any person obtaining a 
 *  copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation
 *  the rights to use, copy, modify, merge, publish, distribute, sublicense,
 *  and/or sell copies of the Software, and to permit persons to whom the
 *  Software is furnished to do so, subject to the following conditions:
 * 
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 * 
 *  Author: Rodrigo Fonseca <rodrigo.fonseca@gmail.com>
 *
 */


#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define _QUANTO_C

#include "libquantocode.h"
// Includes from the Quanto code:
#include "RawUartMsg.h"
         // defines entry_t
#include "QuantoLogCompressedMyUartWriter.h"
         // defines CBLOCKSIZE, BUFFERSIZE, BITBUFFERSIZE

/* Decodes a stream of quanto log entries encoded by
 * the QuantoLogCompressedMyUartWriter.
 * The program reads from STDIN the output of Listen, and
 * assumes the format: <block size> <bit stream>
 */



/* This function reverses what the encoder does. It must match
 * what QuantoLogCompressedMyUartWriterP.CompressTask does.
 */
int 
decode_block (bitBuf* buf, entry_t* block, int block_size)
{
   int i;
   uint32_t d;
   uint8_t  m;
   mtf_encoder mtf;

   static uint32_t last_time = 0;
   static uint32_t last_icount = 0;
   
   //decode type    (EG(MTF+1))'
   mtf_init(&mtf);
   for (i = 0; i < block_size; i++) {
      if (! (d = elias_gamma_decode(buf)))
         break;
      d -= 1;
      m = mtf_decode(&mtf, (uint8_t)d); 
      block[i].type = m;
   }
   if (i < block_size) return 0;

   //decode resource (EG(MTF+1))'
   mtf_init(&mtf);
   for (i = 0; i < block_size; i++) {
      if (!(d = elias_gamma_decode(buf)))
         break;
      d -= 1;
      m = mtf_decode(&mtf, (uint8_t)d); 
      block[i].res_id = m;
   }
   if (i < block_size) return 0;

   //decode time    (EG(delta))'
   for (i = 0; i < block_size; i++) {
      if (!(d = elias_gamma_decode(buf)))
         break;
      d += last_time;
      block[i].time = d;
      last_time = d;
   }
   if (i < block_size) return 0;

   //decode icount (EG(delta +1))'
   for (i = 0; i < block_size; i++) {
      if (!(d = elias_gamma_decode(buf)))
         break;
      d -= 1;
      d += last_icount;
      block[i].ic = d;
      last_icount = d;
   }
   if (i < block_size) return 0;

   //decode activity MSB (EG(MTF+1))'
   mtf_init(&mtf);
   for (i = 0; i < block_size; i++) {
      if (!(d = elias_gamma_decode(buf)))
         break;
      d -= 1;
      m = mtf_decode(&mtf, (uint8_t)d); 
      block[i].act = ((uint16_t)m << 8);
   }
   if (i < block_size) return 0;

   //decode activity LSB (EG(MTF+1))'
   mtf_init(&mtf);
   for (i = 0; i < block_size; i++) {
      if (!(d = elias_gamma_decode(buf)))
         break;
      d -= 1;
      m = mtf_decode(&mtf, (uint8_t)d); 
      block[i].act |= (uint16_t)m & 0xff;
   }
   if (i < block_size) return 0;
   
   return 1;
}

/* Prints the block of entries emulating the output of the regular logger,
 * a sequence of bytes printed in capital hex representation, one entry 
 * per line. For integers larger than 1 byte we use big-endian, network order,
 * most signigicant byte first. */
void print_block_hex(FILE* f, entry_t* block, int block_size) 
{
   int i;
   for (i = 0; i < block_size; i++) {
      fprintf(f, "%02X %02X %02X %02X %02X %02X %02X %02X %02X %02X %02X %02X\n",
         block[i].type,
         block[i].res_id,
         (uint8_t)(block[i].time >> 24 & 0xff),
         (uint8_t)(block[i].time >> 16 & 0xff),
         (uint8_t)(block[i].time >>  8 & 0xff),
         (uint8_t)(block[i].time       & 0xff),
         (uint8_t)(block[i].ic   >> 24 & 0xff),
         (uint8_t)(block[i].ic   >> 16 & 0xff),
         (uint8_t)(block[i].ic   >>  8 & 0xff),
         (uint8_t)(block[i].ic         & 0xff),
         (uint8_t)(block[i].act  >>  8 & 0xff),
         (uint8_t)(block[i].act        & 0xff)
      );
   }
}

int main() 
{
   bitBuf *buf;      //input from mote
   entry_t *block;  //decoded log entries
   char line_buf[BITBUFSIZE*3];
   char* p;

   int line_count = 0;
   int block_size;
   unsigned int s;
   uint8_t b;

   buf = bitBuf_new(BITBUFSIZE); 

   memset(line_buf, 0, sizeof(line_buf));
   bitBuf_clear(buf);
   while (fgets(line_buf, sizeof(line_buf), stdin) != NULL) {
      line_count++;
      fprintf(stderr, "line %d: %s", line_count, line_buf);
      p = line_buf;
      if (! sscanf(p, "%X", &block_size)) {
         fprintf(stderr,"Invalid block size at line %d\n%s\n", line_count, line_buf);
         break;
      }
      p+=3;
      //fill BitBuffer
      while ( sscanf(p, "%X", &s) == 1) {
         b = (uint8_t)s;
         p += 3;
         bitBuf_putByte(buf, b);
         fprintf(stderr, "%02X ", b);
      }
      fprintf(stderr, "\n");
      fprintf(stderr, "line %d: read %d bytes\n", line_count, bitBuf_length(buf));
   
      //alocate block
      block = (entry_t*)malloc(block_size*sizeof(entry_t));
      
      //decode block
      if (!decode_block(buf, block, block_size)) {
         fprintf(stderr, "Error decoding line %d\n!!!", line_count);
      } else {
         print_block_hex(stdout, block, block_size);
      }

      //cleanup for next line
      free(block);
      memset(line_buf, 0, sizeof(line_buf));
      bitBuf_clear(buf);
   }
   exit(0);
}

