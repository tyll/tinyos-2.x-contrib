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
 * The compression uses a combination of techniques.
 * For discrete entities (type, resource, activity), we 
 * use an 8-bit Move To Front encoder followed by an Elias-gamma
 * encoder. For continuous entities (time and icount), we
 * use a simple delta encoder followed by Elias-gamma encoding
 * as well. Since EG can't encode 0, we add 1 to some of these.
 * The decoding process is the reverse transformations. 
 */



/* This function reverses what the encoder does. It must match
 * what QuantoLogCompressedMyUartWriterP.CompressTask does.
 */
int 
decode_block (bitBuf* buf, entry_t* block, int block_size, bool is_mtf_init)
{
   int i;
   uint32_t d;
   uint8_t  m;
   static mtf_encoder mtf;

   static uint32_t last_time = 0;
   static uint32_t last_icount = 0;

   if (is_mtf_init) {
      mtf_init(&mtf);
   } 
   
   //decode type    (EG(MTF+1))'
   //mtf_init(&mtf);
   for (i = 0; i < block_size; i++) {
      if (! (d = elias_gamma_decode(buf)))
         break;
      d -= 1;
      m = mtf_decode(&mtf, (uint8_t)d); 
      block[i].type = m;
   }
   if (i < block_size) return 0;

   //decode resource (EG(MTF+1))'
   //mtf_init(&mtf);
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
   //mtf_init(&mtf);
   for (i = 0; i < block_size; i++) {
      if (!(d = elias_gamma_decode(buf)))
         break;
      d -= 1;
      m = mtf_decode(&mtf, (uint8_t)d); 
      block[i].act = ((uint16_t)m << 8);
   }
   if (i < block_size) return 0;

   //decode activity LSB (EG(MTF+1))'
   //mtf_init(&mtf);
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
   entry_t *block = 0;  //decoded log entries
   char line_buf[BITBUFSIZE*3];
   char* p;

   int line_count = 0;
   int skipped_lines = 0;
   int total_bytes = 0;

   int header;
   bool is_mtf_init;

   bool syncd = 0;
   int block_size = 0;
   unsigned int s;
   uint8_t b;

   buf = bitBuf_new(BITBUFSIZE); 

   memset(line_buf, 0, sizeof(line_buf));
   while (fgets(line_buf, sizeof(line_buf), stdin) != NULL) {
      fprintf(stderr, "line: %s", line_buf);
      p = line_buf;
      
      bitBuf_clear(buf);
      //fill BitBuffer
      while ( sscanf(p, "%X", &s) == 1) {
         b = (uint8_t)s;
         p += 3;
         bitBuf_putByte(buf, b);
         fprintf(stderr, "%02X ", b);
      }
      fprintf(stderr, "\n");
      fprintf(stderr, "read %d bytes\n", bitBuf_length(buf));

      // Guess the block size
      if (block_size == 0) {
         int count = 0;
         fprintf(stderr, "guessing block size...");
         for (count = 0; elias_gamma_decode(buf) != 0; count++);
         if (count % 6 != 1) {
            fprintf(stderr, " read %d integers, not 6b+1, confused.\n", count);
            exit(1);
         } else {
            block_size = count / 6;
            fprintf(stderr, " cool, block size is %d!\n", block_size);
         }
         //pretend it never happened
         bitBuf_resetReadPos(buf);
         //alocate block
         block = (entry_t*)malloc(block_size*sizeof(entry_t));
      }

      //decode header
      header = elias_gamma_decode(buf);
      if (header == 1) {
         is_mtf_init = 0;
      } else if (header == 2) {
         is_mtf_init = 1;
      } else {
         fprintf(stderr, "This can't happen, header is not 1 or 2 (it is %d)\n", header);
         exit(2);
      }

      syncd |= is_mtf_init;
     
      if (!syncd) {
         fprintf(stderr, "waiting for MTF sync...\n");
         continue;
      }

      //we are syncd!
      line_count++;
      
      //decode block
      if (!decode_block(buf, block, block_size, is_mtf_init)) {
         fprintf(stderr, "Error decoding line %d\n!!!", line_count);
         skipped_lines++;
      } else {
         total_bytes += bitBuf_length(buf);
         print_block_hex(stdout, block, block_size);
      }

      //just to make sure...
      memset(line_buf, 0, sizeof(line_buf));
   }
   free(block);
   //print some stats
   total_bytes += line_count - skipped_lines; 
   fprintf(stderr, "Total lines: %d ( %d error ). Block size: %d Compr. Bytes: %d Decoded Bytes: %d Compression Factor: %f\n",
           line_count, skipped_lines, block_size, total_bytes, 12*block_size*(line_count - skipped_lines),
           ((line_count - skipped_lines)*12.0*block_size)/total_bytes);
   exit(0);
}

