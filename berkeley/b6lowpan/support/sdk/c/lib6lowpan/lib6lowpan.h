/*
 * "Copyright (c) 2008 The Regents of the University  of California.
 * All rights reserved."
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */
#ifndef _LIB6LOWPAN_H_
#define _LIB6LOWPAN_H_

#include <stdint.h>
#include <stddef.h>

/* #if __BYTE_ORDER == __BIG_ENDIAN */
/* #define ntoh16(X)   (X) */
/* #define hton16(X)   (X) */
/* #define ntoh32(X)   (X) */
/* #define hton32(X)   (X) */
/* #define leton16(X)  (((((uint16_t)(X)) << 8) | ((uint16_t)(X) >> 8)) & 0xffff) */
/* #define htole16(X)  leton16(X) */

/* #else */

#define ntoh16(X)   (((((uint16_t)(X)) >> 8) | ((uint16_t)(X) << 8)) & 0xffff)
#define hton16(X)   (((((uint16_t)(X)) << 8) | ((uint16_t)(X) >> 8)) & 0xffff)
#define leton16(X)  hton16(X)
#define htole16(X)  (X)
#define ntoh32(X)   ((((uint32_t)(X) >> 24) & 0x000000ff)| \
                     ((((uint32_t)(X) >> 8)) & 0x0000ff00) | \
                     ((((uint32_t)(X) << 8)) & 0x00ff0000) | \
                     ((((uint32_t)(X) << 24)) & 0xff000000))

#define hton32(X)   ((((uint32_t)(X) << 24) & 0xff000000)| \
                     ((((uint32_t)(X) << 8)) & 0x00ff0000) | \
                     ((((uint32_t)(X) >> 8)) & 0x0000ff00) | \
                     ((((uint32_t)(X) >> 24)) & 0x000000ff))


/* #endif */

/*
 * This interface implements the 6loWPAN header structures.  Support
 * for the HC1 and HC2 compressed IP and UDP headers is also
 * available, and the interface is presented in lib6lowpanIP.h.
 *
 */
#include "6lowpan.h"
#include "lib6lowpanIP.h"

// only 16-bit address handling modes
#define __6LOWPAN_16BIT_ADDRESS


/*
 * Some disgusting macros for reading unaligned values.  We only use
 * these where it's a lot easier; things are mostly byte-aligned.
 *
 */

// read a 16 bit value from an arbitrary offset.  If your compiler is
// working, this should produce a HOST value since it assumes
// canonical byte order on the part of the buffer.
#define READ16(buf, bits)  ((uint16_t)(buf[((bits) / 8)])     << (((bits) % 8) + 8)  | \
                            (uint16_t)((buf[((bits) / 8) + 1]) << ((bits) % 8))  | \
                            (uint16_t)(buf[((bits) / 8) + 2]) >> (8 - ((bits) % 8))  )  

#define READ4(buf, bits)    ((buf[(bits) / 8] >> (4 - ((bits) % 8))) & 0x0f)

#define WRITE16(buf, bits, val) (buf[(bits) / 8]     &= 0xff << (8 - ((bits) % 8))); \
                                (buf[(bits) / 8 + 2] &= 0xff >> ((bits) % 8));  \
                                (buf[(bits) / 8]     |= (val) >> (8 + ((bits) % 8))); \
                                (buf[(bits) / 8 + 1]  = ((val) >> ((bits) % 8)) & 0xff); \
                                (buf[(bits) / 8 + 2] |= ((val) << (8 - ((bits) % 8))) & 0xff);


#define WRITE8(buf, bits, val)  (buf[(bits) / 8] &= 0xff << ((bits) % 8)); \
                                (buf[(bits) / 8] |= (val) >> ((bits) % 8)); \
                                (buf[(bits) / 8 + 1] &= 0xff >> (8 - ((bits) % 8))); \
                                (buf[(bits) / 8 + 1] |= (val) << (8 - ((bits) % 8)));
// write a half-byte aligned value
#define WRITE4(buf, bits, val)  (buf[(bits) / 8] &= 0xff << (8 - (bits) % 8));   \
                                (buf[(bits) / 8] &= 0xff >> (4 - ((bits) % 8))); \
                                (buf[(bits) / 8] |= (val)  << (4 - ((bits) % 8))); 
/*
 *  Library implementation of packing of 6lowpan packets.  
 *
 *  This should allow uniform code treatment between pc and mote code;
 *  the goal is to write ANSI C here...  This means no nx_ types,
 *  unfortunately.
 */


uint16_t getHeaderBitmap(packed_lowmsg_t *lowmsg);
/*
 * Return the length of the buffer required to pack lowmsg
 *  into a buffer.
 */

uint8_t *getLowpanPayload(packed_lowmsg_t *lowmsg);

/*
 * Initialize the header bitmap in 'packed' so that
 *  we know how long the headers are.
 *
 * @return FAIL if the buffer is not long enough.
 */
uint8_t setupHeaders(packed_lowmsg_t *packed, uint16_t headers);

/*
 * Test if various protocol features are enabled
 */
uint8_t hasMeshHeader(packed_lowmsg_t *msg);
uint8_t hasBcastHeader(packed_lowmsg_t *msg);
uint8_t hasFrag1Header(packed_lowmsg_t *msg);
uint8_t hasFragNHeader(packed_lowmsg_t *msg);

/*
 * Mesh header fields
 *
 *  return FAIL if the message doesn't have a mesh header
 */
uint8_t getMeshHopsLeft(packed_lowmsg_t *msg, uint8_t *hops);
uint8_t getMeshOriginAddr(packed_lowmsg_t *msg, hw_addr_t *origin);
uint8_t getMeshFinalAddr(packed_lowmsg_t *msg, hw_addr_t *final);

uint8_t setMeshHopsLeft(packed_lowmsg_t *msg, uint8_t hops);
uint8_t setMeshOriginAddr(packed_lowmsg_t *msg, hw_addr_t origin);
uint8_t setMeshFinalAddr(packed_lowmsg_t *msg, hw_addr_t final);

/*
 * Broadcast header fields
 */
uint8_t getBcastSeqno(packed_lowmsg_t *msg, uint8_t *seqno);

uint8_t setBcastSeqno(packed_lowmsg_t *msg, uint8_t seqno);

/*
 * Fragmentation header fields
 */
uint8_t getFragDgramSize(packed_lowmsg_t *msg, uint16_t *size);
uint8_t getFragDgramTag(packed_lowmsg_t *msg, uint16_t *tag);
uint8_t getFragDgramOffset(packed_lowmsg_t *msg, uint8_t *size);

uint8_t setFragDgramSize(packed_lowmsg_t *msg, uint16_t size);
uint8_t setFragDgramTag(packed_lowmsg_t *msg, uint16_t tag);
uint8_t setFragDgramOffset(packed_lowmsg_t *msg, uint8_t size);

#endif
