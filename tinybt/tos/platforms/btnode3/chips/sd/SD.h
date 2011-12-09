/* ***********************************************************
* THIS PROGRAM IS PROVIDED "AS IS". TI MAKES NO WARRANTIES OR
* REPRESENTATIONS, EITHER EXPRESS, IMPLIED OR STATUTORY, 
* INCLUDING ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS 
* FOR A PARTICULAR PURPOSE, LACK OF VIRUSES, ACCURACY OR 
* COMPLETENESS OF RESPONSES, RESULTS AND LACK OF NEGLIGENCE. 
* TI DISCLAIMS ANY WARRANTY OF TITLE, QUIET ENJOYMENT, QUIET 
* POSSESSION, AND NON-INFRINGEMENT OF ANY THIRD PARTY 
* INTELLECTUAL PROPERTY RIGHTS WITH REGARD TO THE PROGRAM OR 
* YOUR USE OF THE PROGRAM.
*
* IN NO EVENT SHALL TI BE LIABLE FOR ANY SPECIAL, INCIDENTAL, 
* CONSEQUENTIAL OR INDIRECT DAMAGES, HOWEVER CAUSED, ON ANY 
* THEORY OF LIABILITY AND WHETHER OR NOT TI HAS BEEN ADVISED 
* OF THE POSSIBILITY OF SUCH DAMAGES, ARISING IN ANY WAY OUT 
* OF THIS AGREEMENT, THE PROGRAM, OR YOUR USE OF THE PROGRAM. 
* EXCLUDED DAMAGES INCLUDE, BUT ARE NOT LIMITED TO, COST OF 
* REMOVAL OR REINSTALLATION, COMPUTER TIME, LABOR COSTS, LOSS 
* OF GOODWILL, LOSS OF PROFITS, LOSS OF SAVINGS, OR LOSS OF 
* USE OR INTERRUPTION OF BUSINESS. IN NO EVENT WILL TI'S 
* AGGREGATE LIABILITY UNDER THIS AGREEMENT OR ARISING OUT OF 
* YOUR USE OF THE PROGRAM EXCEED FIVE HUNDRED DOLLARS 
* (U.S.$500).
*
* Unless otherwise stated, the Program written and copyrighted 
* by Texas Instruments is distributed as "freeware".  You may, 
* only under TI's copyright in the Program, use and modify the 
* Program without any charge or restriction.  You may 
* distribute to third parties, provided that you transfer a 
* copy of this license to the third party and the third party 
* agrees to these terms by its first use of the Program. You 
* must reproduce the copyright notice and any other legend of 
* ownership on each copy or partial copy, of the Program.
*
* You acknowledge and agree that the Program contains 
* copyrighted material, trade secrets and other TI proprietary 
* information and is protected by copyright laws, 
* international copyright treaties, and trade secret laws, as 
* well as other intellectual property laws.  To protect TI's 
* rights in the Program, you agree not to decompile, reverse 
* engineer, disassemble or otherwise translate any object code 
* versions of the Program to a human-readable form.  You agree 
* that in no event will you alter, remove or destroy any 
* copyright notice included in the Program.  TI reserves all 
* rights not specifically granted under this license. Except 
* as specifically provided herein, nothing in this agreement 
* shall be construed as conferring by implication, estoppel, 
* or otherwise, upon you, any license or other right under any 
* TI patents, copyrights or trade secrets.
*
* You may not use the Program in non-TI devices.
* ********************************************************* */

/*
 * Copyright (c) 2006, Intel Corporation
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * Redistributions of source code must retain the above copyright notice, 
 * this list of conditions and the following disclaimer. 
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution. 
 *
 * Neither the name of the Intel Corporation nor the names of its contributors
 * may be used to endorse or promote products derived from this software 
 * without specific prior written permission. 
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * copied and edited from Texas Instruments sample code
 *
 * @author Steve Ayer
 * @date May 2006
 */
#ifndef SD_H
#define SD_H

#define SD_START_DATA_BLOCK_TOKEN          0xfe   // Data token start byte, Start Single Block Read
#define SD_COMMAND_LENGTH 6
typedef uint8_t sderror_t;
#define SD_SUCCESS           0x00
#define SD_BLOCK_SET_ERROR   0x01
#define SD_RESPONSE_ERROR    0x02
#define SD_DATA_TOKEN_ERROR  0x03
#define SD_INIT_ERROR        0x04
#define SD_CRC_ERROR         0x10
#define SD_WRITE_ERROR       0x11
#define SD_OTHER_ERROR       0x12
#define SD_NOCARD_ERROR      0x13
#define SD_SIGNATURE_ERROR   0x14
#define SD_TIMEOUT_ERROR     0xFF

#define SD_GO_IDLE_STATE          0x40     //CMD0
#define SD_SEND_OP_COND           0x41     //CMD1
#define SD_SEND_IF_COND           0x48     //CMD8
#define SD_SEND_CSD               0x49     //CMD9
#define SD_SEND_CID               0x4a     //CMD10
#define SD_STOP_TRANSMISSION      0x4c     //CMD12
#define SD_SEND_STATUS            0x4d     //CMD13
#define SD_SET_BLOCKLEN           0x50     //CMD16 Set block length for next read/write
#define SD_READ_SINGLE_BLOCK      0x51     //CMD17 Read block from memory
#define SD_READ_MULTIPLE_BLOCK    0x52     //CMD18
#define SD_CMD_WRITEBLOCK         0x54     //CMD20 Write block to memory
#define SD_WRITE_BLOCK            0x58     //CMD24
#define SD_WRITE_MULTIPLE_BLOCK   0x59     //CMD25
#define SD_PROGRAM_CSD            0x5b     //CMD27 PROGRAM_CSD
#define SD_SET_WRITE_PROT         0x5c     //CMD28
#define SD_CLR_WRITE_PROT         0x5d     //CMD29
#define SD_SEND_WRITE_PROT        0x5e     //CMD30
#define SD_TAG_SECTOR_START       0x60     //CMD32
#define SD_TAG_SECTOR_END         0x61     //CMD33
#define SD_UNTAG_SECTOR           0x62     //CMD34
#define SD_TAG_EREASE_GROUP_START 0x63     //CMD35
#define SD_TAG_EREASE_GROUP_END   0x64     //CMD36
#define SD_UNTAG_EREASE_GROUP     0x65     //CMD37
#define SD_EREASE                 0x66     //CMD38
#define SD_LOCK_UNLOCK            0x6a     //CMD42
#define SD_ACMD41_SEND_OP_COND    0x69     //ACMD41
#define SD_APP_CMD                0x77     //CMD55
#define SD_READ_OCR               0x7a     //CMD58
#define SD_CRC_ON_OFF             0x7b     //CMD59
#define SD_ZERO_ARG_CRC           0x95     //CRC for zero argument command
#define SD_SEND_IF_COND_CRC       0x87     //CRC for CMD_IF_COND
#define SD_SEND_IF_COND_ARG 0x000001aa     //Arg for checking Voltage
#define SD_BLANK_BYTE             0xFF     //Blank Byte
#define SD_ZEROES                 0x00     //Zeroes
#define SD_BLANK_CRC              0x01     //Blank CRC with stop bit
#define SD_TEST_BYTE              0xaa     //Test Byte shows up asw 10101010 on scope

#define SD_RESPONSE_READY         0x00
#define SD_RESPONSE_IDLE          0x00
#define SD_RESPONSE_ERASE         0x01
#define SD_RESPONSE_ILLEGAL       0x02
#define SD_RESPONSE_CRC           0x03
#define SD_RESPONSE_SEQUENCE      0x04
#define SD_RESPONSE_ADDRESS       0x05
#define SD_RESPONSE_PARAMETER     0x06
#define SD_RESPONSE_START_BIT     0x07

#define SD_RESPONSE_R1            1
#define SD_RESPONSE_R2            2
#define SD_RESPONSE_R3            5
#define SD_RESPONSE_R7            5

#define SD_DATA_ACK               0x01
#define SD_DATA_ACK_MASK          0x11
#define SD_DATA_ACK_CHKBITS       0x1F
#define SD_DATA_ACCEPTED          0x05

#define SD_TYPE_MMC               0
#define SD_TYPE_SD1               1
#define SD_TYPE_SD2               2
typedef struct sd_command_t {
  uint8_t cmd;
  uint32_t arg;
  uint8_t crc;
} __attribute__ ((packed)) sd_command_t;
typedef struct sd_packet_t {
  uint8_t payload[SD_COMMAND_LENGTH];
} __attribute__ ((packed)) sd_packet_t;
#endif
