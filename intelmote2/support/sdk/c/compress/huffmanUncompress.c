/*************************************************************************
* Name:        huffman.c
* Author:      Marcus Geelnard
* Description: Huffman coder/decoder implementation.
* Reentrant:   Yes
*
* This is a very straight forward implementation of a Huffman coder and
* decoder.
*
* Primary flaws with this primitive implementation are:
*  - Slow bit stream implementation
*  - Maximum tree depth of 32 (the coder aborts if any code exceeds a
*    size of 32 bits). If I'm not mistaking, this should not be possible
*    unless the input buffer is larger than 2^32 bytes, which is not
*    supported by the coder anyway (max 2^32-1 bytes can be specified with
*    an unsigned 32-bit integer).
*
* On the other hand, there are a few advantages of this implementation:
*  - The Huffman tree is stored in a very compact form, requiring only
*    10 bits per symbol (for 8 bit symbols), meaning a maximum of 320
*    bytes overhead.
*  - The code should be fairly easy to follow, if you are familiar with
*    how the Huffman compression algorithm works.
*
* Possible improvements (probably not worth it):
*  - Partition the input data stream into blocks, where each block has
*    its own Huffman tree. With variable block sizes, it should be
*    possible to find locally optimal Huffman trees, which in turn could
*    reduce the total size.
*  - Allow for a few different predefined Huffman trees, which could
*    reduce the size of a block even further.
*-------------------------------------------------------------------------
* Copyright (c) 2003-2006 Marcus Geelnard
*
* This software is provided 'as-is', without any express or implied
* warranty. In no event will the authors be held liable for any damages
* arising from the use of this software.
*
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
*
* 1. The origin of this software must not be misrepresented; you must not
*    claim that you wrote the original software. If you use this software
*    in a product, an acknowledgment in the product documentation would
*    be appreciated but is not required.
*
* 2. Altered source versions must be plainly marked as such, and must not
*    be misrepresented as being the original software.
*
* 3. This notice may not be removed or altered from any source
*    distribution.
*
* Marcus Geelnard
* marcus.geelnard at home.se
*************************************************************************/

/*************************************************************************
* Types used for Huffman coding
*************************************************************************/
#include <inttypes.h>

typedef struct {
    uint8_t *BytePtr;
    uint16_t  BitPos;
} huff_bitstream_t;

typedef struct {
    int16_t Symbol;
    uint16_t Count;
    uint16_t Code;
    uint16_t Bits;
} huff_sym_t;

typedef struct huff_encodenode_struct huff_encodenode_t;

struct huff_encodenode_struct {
    huff_encodenode_t *ChildA, *ChildB;
    int16_t Count;
    int16_t Symbol;
};

typedef struct huff_decodenode_struct huff_decodenode_t;

struct huff_decodenode_struct {
    huff_decodenode_t *ChildA, *ChildB;
    int16_t Symbol;
};


/*************************************************************************
* Constants for Huffman decoding
*************************************************************************/

/* The maximum number of nodes in the Huffman tree is 2^(8+1)-1 = 511 */
#define MAX_TREE_NODES 511



/*************************************************************************
*                           INTERNAL FUNCTIONS                           *
*************************************************************************/


/*************************************************************************
* _Huffman_InitBitstream() - Initialize a bitstream.
*************************************************************************/

static void _Huffman_InitBitstream( huff_bitstream_t *stream,
    uint8_t *buf )
{
  stream->BytePtr  = buf;
  stream->BitPos   = 0;
}


/*************************************************************************
* _Huffman_ReadBit() - Read one bit from a bitstream.
*************************************************************************/

static uint16_t _Huffman_ReadBit( huff_bitstream_t *stream )
{
  uint16_t  x, bit;
  uint8_t *buf;

  /* Get current stream state */
  buf = stream->BytePtr;
  bit = stream->BitPos;

  /* Extract bit */
  x = (*buf & (1<<(7-bit))) ? 1 : 0;
  bit = (bit+1) & 7;
  if( !bit )
  {
    ++ buf;
  }

  /* Store new stream state */
  stream->BitPos = bit;
  stream->BytePtr = buf;

  return x;
}


/*************************************************************************
* _Huffman_Read8Bits() - Read eight bits from a bitstream.
*************************************************************************/

static uint16_t _Huffman_Read8Bits( huff_bitstream_t *stream )
{
  uint16_t  x, bit;
  uint8_t *buf;

  /* Get current stream state */
  buf = stream->BytePtr;
  bit = stream->BitPos;

  /* Extract byte */
  x = (*buf << bit) | (buf[1] >> (8-bit));
  ++ buf;

  /* Store new stream state */
  stream->BytePtr = buf;

  return x;
}

/*************************************************************************
* _Huffman_RecoverTree() - Recover a Huffman tree from a bitstream.
*************************************************************************/

static huff_decodenode_t * _Huffman_RecoverTree( huff_decodenode_t *nodes,
  huff_bitstream_t *stream, uint16_t *nodenum )
{
  huff_decodenode_t * this_node;

  /* Pick a node from the node array */
  this_node = &nodes[*nodenum];
  *nodenum = *nodenum + 1;

  /* Clear the node */
  this_node->Symbol = -1;
  this_node->ChildA = (huff_decodenode_t *) 0;
  this_node->ChildB = (huff_decodenode_t *) 0;

  /* Is this a leaf node? */
  if( _Huffman_ReadBit( stream ) )
  {
    /* Get symbol from tree description and store in lead node */
    this_node->Symbol = _Huffman_Read8Bits( stream );

    return this_node;
  }

  /* Get branch A */
  this_node->ChildA = _Huffman_RecoverTree( nodes, stream, nodenum );

  /* Get branch B */
  this_node->ChildB = _Huffman_RecoverTree( nodes, stream, nodenum );

  return this_node;
}



/*************************************************************************
*                            PUBLIC FUNCTIONS                            *
*************************************************************************/


/*************************************************************************
* Huffman_Uncompress() - Uncompress a block of data using a Huffman
* decoder.
*  in      - Input (compressed) buffer.
*  out     - Output (uncompressed) buffer. This buffer must be large
*            enough to hold the uncompressed data.
*  insize  - Number of input bytes.
*  outsize - Number of output bytes.
*************************************************************************/

void Huffman_Uncompress( uint8_t *in, uint8_t *out,
  uint16_t insize, uint16_t outsize )
{
  huff_decodenode_t nodes[MAX_TREE_NODES], *root, *node;
  huff_bitstream_t  stream;
  uint16_t      k, node_count;
  uint8_t     *buf;

  /* Do we have anything to decompress? */
  if( insize < 1 ) return;

  /* Initialize bitstream */
  _Huffman_InitBitstream( &stream, in );

  /* Recover Huffman tree */
  node_count = 0;
  root = _Huffman_RecoverTree( nodes, &stream, &node_count );

  /* Decode input stream */
  buf = out;
  for( k = 0; k < outsize; ++ k )
  {
    /* Traverse tree until we find a matching leaf node */
    node = root;
    while( node->Symbol < 0 )
    {
      /* Get next node */
      if( _Huffman_ReadBit( &stream ) )
        node = node->ChildB;
      else
        node = node->ChildA;
    }

    /* We found the matching leaf node and have the symbol */
    *buf ++ = (uint8_t) node->Symbol;
  }
}
