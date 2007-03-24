/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * @author David Moss
 */
 
#ifndef BLACKBOOK_H
#define BLACKBOOK_H

/**
 * Blackbook Definitions v.6
 * @author David Moss (dmm@rincon.com)
 */

#include "BlackbookConst.h"
#include "BDictionary.h"

#define UQ_BDICTIONARY "BDictionary"
#define UQ_BFILEDELETE "BFileDelete"
#define UQ_BFILEDIR "BFileDir"
#define UQ_BFILEREAD "BFileRead"
#define UQ_BFILEWRITE "BFileWrite"

#ifndef BLACKBOOK_TOTAL_ERASEBLOCKS
#define BLACKBOOK_TOTAL_ERASEBLOCKS 16
#endif

/** 
 * This is a complete name of a file that we can pass around Blackbook
 * and not worry about whether or not enough bytes were allocated for
 * the filename.
 */
typedef struct filename_t {

  /** The name of a file */
  char getName[FILENAME_LENGTH];

} filename_t;


/** flashnode_t flags */
typedef enum {
  NO_FLAGS = 0x0,
  DICTIONARY = 0x1,
  RESERVED0 = 0x2,
  RESERVED1 = 0x4,
  RESERVED2 = 0x8,
  RESERVED3 = 0x10,
  RESERVED4 = 0x20,
  RESERVED5 = 0x40,
  RESERVED6 = 0x80,
} flashnode_flags_enum;
  
  
/** 
 * This is the nodemeta information kept at the start of each 
 * flashnode_t on flash
 */
typedef struct nodemeta_t {

  /** Magic number to detect valid metadata. This is after dataCrc for finalizing */
  uint16_t magicNumber;
  
  /** Length of the space reserved for this flashnode_t on flash */
  uint32_t reserveLength;
  
  /** The CRC of the filename this flashnode_t is associated with */
  uint16_t filenameCrc;
  
  /** The element of the file this flashnode_t represents, 0 for the first flashnode_t */
  uint16_t fileElement;
  
  /** Node flags */
  flashnode_flags_enum nodeflags;
  
} nodemeta_t;


/** 
 * This is the filemeta information located directly after nodemeta
 * information for the first flashnode_t of a file on flash
 */
typedef struct filemeta_t {

  /** Name of the file */
  struct filename_t name;
  
} filemeta_t;



/** Possible flashnode_t States */
typedef enum {
  /** The flashnode_t can be used by anything */
  NODE_EMPTY,
  
  /** This is a special constructing flashnode_t that is to be deleted if the mote is rebooted */
  NODE_CONSTRUCTING,
  
  /** The flashnode_t is valid and can be written to */
  NODE_VALID,

  /** This flashnode_t is valid and cannot be written to */
  NODE_LOCKED,
  
  /** This flashnode_t exists virtually, but no info has been written to flash */
  NODE_TEMPORARY,
  
  /** This flashnode_t was found on flash, but is not valid */
  NODE_DELETED,
  
  /** This flashnode_t is valid and booting */
  NODE_BOOTING,
} flashnode_state_enum;

/** 
 * This is the flashnode_t information kept in memory for each node
 */
typedef struct flashnode_t {
  /** The address of this flashnode_t on flash */
  uint32_t flashAddress;
  
  /** The next flashnode_t in the file after this one */
  struct flashnode_t *nextNode;
  
  /** The total length of valid data written to this flashnode_t */
  uint16_t dataLength;

  /** The total length of space reserved for this flashnode_t */
  uint32_t reserveLength;
  
  /** The current CRC of the flashnode_t */
  uint16_t dataCrc;

  /** The CRC of the filename from the file this flashnode_t is associated with */
  uint16_t filenameCrc;
  
  /** The state of the flashnode_t */
  flashnode_state_enum nodestate;

  /** flashnode flags */
  flashnode_flags_enum nodeflags;
  
  /** The index this flashnode_t belongs to in its entire file */
  uint8_t fileElement;

} flashnode_t;




/** Possible file_t States */
typedef enum {
  /** This file index is empty and can be used by anybody */
  FILE_EMPTY,
  
  /** This file exists virtually, but no info has been written to flash */
  FILE_TEMPORARY,
  
  /** This file is valid but not being used */
  FILE_IDLE,
  
  /** The nodes in this file is open for reading */
  FILE_READING,
  
  /** The nodes in this file are open for writing */
  FILE_WRITING,
  
  FILE_READING_AND_WRITING,

} file_state_enum;


/** 
 * This is the information kept for each file in RAM memory 
 */
typedef struct file_t {

  /** The first flashnode_t of this file */
  flashnode_t *firstNode;
  
  /** The calculated crc of the file, so we don't have to calculate it every time */
  uint16_t filenameCrc;
  
  /** The state of this file */
  file_state_enum filestate;
  
} file_t;


/**
 * This is the sector information kept
 * in RAM for every sector on flash.
 */
typedef struct flasheraseblock_t {
  
  /** The starting erase unit in the volume */ 
  uint16_t baseEraseUnit;
  
  /** Next write unit number available for writing */
  uint16_t writeUnit;
  
  /** Total number of erase units in this block */
  uint16_t totalEraseUnits;
  
  /** Total amount of valid nodes on this sector */
  uint16_t totalNodes;
  
  /** This erase unit's ID */
  uint8_t index;
  
  /** FALSE if this sector has no open write files */
  bool inUse;
  
} flasheraseblock_t;



/**
 * This is the checkpoint struct that is inserted
 * into a key-value pair in the Checkpoint file
 */
typedef struct checkpoint_t {

  /** Node's filename CRC for verification */
  uint16_t filenameCrc;
  
  /** The CRC of the data contained up to the dataLength of the flashnode_t */
  uint16_t dataCrc;

  /** Length of the node's data */ 
  uint16_t dataLength;
  
  /** TRUE if this flashnode_t is still available for writing */
  bool writable;
  
} checkpoint_t;



/** Magic Words */
enum {
  /** No flashnode_t exists at this point in the flash */
  META_EMPTY = 0xFFFF,             // binary 1111

  /** This flashnode_t is being constructed. If this is found on boot, delete the flashnode_t */
  META_CONSTRUCTING = 0x7777,      // binary 0111
  
  /** This flashnode_t is finalized on flash and all information is local */
  META_VALID = 0x3333,             // binary 0011
  
  /** This flashnode_t is deleted, mark up the SectorMap and move on */
  META_INVALID = 0x1111,           // binary 0001
  
  /** This is the type of data you'll find when a dataCrc is unfinalized */
  UNFINALIZED_CRC = 0xFFFF,
  
  /** This is the type of data you'll find when a dataLength is unfinalized */
  UNFINALIZED_DATA = 0xFFFF,
};

/** Global state machine for blackbook */
enum {
  S_BLACKBOOK_IDLE = 0,
  
  /** The file system is booting */
  S_BOOT_BUSY,
  
  /** The file system is recovering nodes */
  S_BOOT_RECOVERING_BUSY,
  
  /** The dictionary is in use */
  S_DICTIONARY_BUSY,
  
  /** Write: The general file writer is in use */
  S_WRITE_BUSY,
  
  /** Write: The file writer is saving */
  S_WRITE_SAVE_BUSY,
  
  /** Write: The file writer is closing */
  S_WRITE_CLOSE_BUSY,
  
  /** The file reader is in use */
  S_READ_BUSY,
  
  /** The file dir is in use */
  S_DIR_BUSY,
  
  /** The file delete is in use */
  S_DELETE_BUSY,
  
  /** The garbage collector is running */
  S_GC_BUSY,
  
  BLACKBOOK_STATE = unique("State"),
};

enum {
  INTERNAL_DICTIONARY = unique(UQ_BDICTIONARY),
};


#endif



