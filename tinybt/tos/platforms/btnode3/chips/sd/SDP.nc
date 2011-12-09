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
 * Operations for communciating with an SD card via a standard sd card slot.
 *
 * functional pieces based upon or copied from Texas Instruments sample code
 *
 */
/**                                   
 * @author Steve Ayer
 * @author Konrad Lorincz
 * @date March 25, 2008 - ported to TOS 2.x
 */

#include "SD.h"
#include "printf.h"
module SDP 
{
  provides interface SD;
  uses interface GeneralIO as SS;
  uses interface GeneralIO as SCK;
  uses interface GeneralIO as CD;
  uses interface GpioInterrupt as CDInt;
  uses interface SpiPacket as Packet;
  uses interface SpiByte as Byte;
  //uses interface Atm128Spi as SpiBus;
  uses interface Leds;
  uses interface Resource;
  uses interface Timer<TMilli> as Timer0;
  uses interface SDByte;
}
implementation 
{                          
  sd_packet_t send_packet,recv_packet;
  sd_packet_t* cmdptr = &send_packet;
  sd_packet_t* recvptr = &recv_packet;
  enum {
    SD_waitForWrite = 0,
    SD_waitForRead = 1,
    SD_None = 2
  };
  bool init = FALSE, card = FALSE;
  uint8_t card_type, wait_type;
  task void card_check_task();
  void initSetToIdle();
  void initClockDelay();
  event void Timer0.fired() {
    bool _init;  
    atomic _init = init;
    if (!_init) {
      atomic {
      card_type = SD_TYPE_MMC;
      wait_type = SD_None;
    }
      initClockDelay();
      call Timer0.startOneShot(500);
    }
  }
  void card_check() {
	    atomic{
	      card = !call CD.get();
	      if (card) {
	        call Timer0.startOneShot(10);
	        call CDInt.enableRisingEdge();
	        }
	      else {
	        init = FALSE;
	        signal SD.cardRemoved();
	        call CDInt.enableFallingEdge();
	        }
		}
   post card_check_task();
  }
  task void card_check_task() {
    //printf("Card Move.\r\n");
    //printfflush();
  }
  async event void CDInt.fired() {
    card_check();
  }
  //async event void SpiBus.dataReady(uint8_t) { /* Data Packets to be handled by SPIPacketC */ }
  async event void Packet.sendDone(uint8_t* txBuf, uint8_t* rxBuf, uint16_t len, error_t error ) {
    //    spiBusy = FALSE;
  }
  void spiFlush(uint8_t cycles) {
    call SS.set();
    while (cycles--)
      call Byte.write(SD_BLANK_BYTE);
    call SS.clr();
  }
  bool getSignature(uint8_t* response, uint8_t signature, uint8_t mask) {
    uint8_t i = 32;
    // Wait for signature block
    call SS.clr();
    while (i && (((*response = call Byte.write(SD_BLANK_BYTE)) & mask) != signature ))
      i--;
      //if (response != 0xff)
      //printf("%.2X ",response);
      //else printf(". ");
    return i?SD_SUCCESS:SD_SIGNATURE_ERROR;
  }//
  bool waitBusy() {
    uint8_t i = 255;
    while (!(call Byte.write(SD_BLANK_BYTE)) && i--);
    return i?SD_SUCCESS:SD_TIMEOUT_ERROR;
  }
    void swapOut(uint16_t length, uint8_t* resptr) {
    uint16_t i;
    for (i=0;i<length;i++)
      call Byte.write(resptr[i]);
  }
  void swapIn(uint16_t length, uint8_t* resptr) {
    uint16_t i;
    for (i=0;i<length;i++)
      resptr[i] = call Byte.write(SD_BLANK_BYTE);
  }
  sderror_t getResponse(uint8_t rtype, uint8_t* resptr)
  {
    //    while (((resptr[0] = call Byte.write(SD_BLANK_BYTE)) & (1 << SD_RESPONSE_START_BIT)) && --i){
    //      // Wait for response until start bit is 0.
    //      if (resptr[0] != 0xff) printf("wash: %.2X; ",resptr[0]);
    //      //      printfflush();
    //    }
    if(getSignature(resptr,SD_ZEROES, (1 << SD_RESPONSE_START_BIT))) return SD_RESPONSE_ERROR;
    swapIn((rtype - 1),(resptr + 1)); 
    call SS.set();
    return SD_SUCCESS;
  }


  void sendCmd(uint8_t cmd, uint32_t arg, uint8_t crc) {
    uint8_t tmp_arg[4], i;
    for(i = 0; i < 4; i++)
      tmp_arg[3 - i] = (uint8_t)(arg >> 8 * i);
    spiFlush(3);
    call Byte.write(cmd);
    //printf("s %.2X -",cmd);
    for(i = 0; i < 4; i++) {
      //printf(" %.2X",tmp_arg[i]);
      call Byte.write(tmp_arg[i]);
    }
    call Byte.write(crc);
    call SS.set();
    //printf(" %.2X\r\n",crc);
    //        printf("sendCmd: %.2X %.2X %.2X %.2X %.2X %.2X \r\n",
    //        cmd,tmp_arg[0],tmp_arg[1],tmp_arg[2],tmp_arg[3],crc);
    //        printfflush();
    //    while(spiBusy == TRUE) ;
  }
  
  void initClockDelay() {
    uint8_t i = 5;
    atomic if (!card) return;
    atomic init = TRUE;
    // Set clock speed to f_osc/64 (125kHz) according to ATmega128 specifications
    //call SpiBus.setClock(3);
    // 10 Blank bytes is equivalent to 80 clock cycles
    // Messy way of waiting for 74 clock cycles.
    spiFlush(12);
    while (i--)
      call Byte.write(SD_BLANK_BYTE);
    //call Leds.led1On();
    initSetToIdle();
 
  }
  
  command void SD.init() {

  	call SS.makeOutput();
    call SS.clr();
    call CD.makeInput();
    call CD.set();
    card_check();
  }
  
  void initSetToIdle() {
    uint8_t response[5];
    uint8_t i;
 
    i = 0xFF;
    do { sendCmd(SD_GO_IDLE_STATE,0,SD_ZERO_ARG_CRC); 
         getResponse(SD_RESPONSE_R1,response);
    } while (response[0] != (1 << SD_RESPONSE_IDLE) && --i);
    // confirm that card is READY 
    if (!i) {
    printf("t-cmd0: %.2X\r\n",response[0]);
    printfflush();
 
      return;
    }
    sendCmd(SD_GO_IDLE_STATE,0,SD_ZERO_ARG_CRC); 
    getResponse(SD_RESPONSE_R1,response);
 
    //printf("cmd0: %.2X\r\n",response[0]);
    sendCmd(SD_SEND_IF_COND,SD_SEND_IF_COND_ARG, SD_SEND_IF_COND_CRC);
    getResponse(SD_RESPONSE_R7,response);
    //printf("cmd8: %.2X %.2X %.2X %.2X %.2X\r\n", response[0], response[1], response[2], response[3], response[4]);
    if (!(response[0] & ((1 << SD_RESPONSE_ILLEGAL) | (1 << SD_RESPONSE_START_BIT))))
      card_type = SD_TYPE_SD2;
    else
      printf("il-cmd8: %.2X\r\n", response[0]);

    i = 0xFF;
    do{
      sendCmd(SD_APP_CMD,0,SD_BLANK_CRC);
      getResponse(SD_RESPONSE_R1,response);
      //printf("cmd55: %.2X\r\n",response[0]);
      if (!(response[0] & ((1 << SD_RESPONSE_ILLEGAL) | (1 << SD_RESPONSE_START_BIT)))) {
        card_type = SD_TYPE_SD1;
      }
      else {
        card_type = SD_TYPE_MMC;
        break;
      } 
      sendCmd(SD_ACMD41_SEND_OP_COND,0, SD_BLANK_CRC);
      getResponse(SD_RESPONSE_R1,response);
      //printf("acmd41: %.2X\r\n",response[0]);
    } while((response[0] & (1 << SD_RESPONSE_IDLE)) && --i);
    if (!i) {
    printf("t-acmd41: %.2X\r\n",response[0]);
    printfflush();
      return;
    }
 
    i =0xFF;
    if (card_type == SD_TYPE_MMC) {
      do {
        sendCmd(SD_SEND_OP_COND,0, SD_BLANK_CRC);
        getResponse(SD_RESPONSE_R1,response);
        //printf("cmd1: %.2X\r\n",response[0]);
      } while (response[0] && --i);
      if (!i){
      printf("t-cmd1: %.2X\r\n",response[0]);
      printfflush();
        return;              
      }
    }
    i = 0xFF;
    do{
      sendCmd(SD_READ_OCR,0, SD_ZERO_ARG_CRC);
      getResponse(SD_RESPONSE_R3,response);
      //printf("cmd58: %.2X %.2X %.2X %.2X %.2X\r\n", response[0], response[1], response[2], response[3], response[4]);
    } while((response[0] > (1 << SD_RESPONSE_IDLE)) && --i);
    if (!i) {
    printf("t-cmd58: %.2X\r\n",response[0]);
    printfflush();
      return;
    }
    call SS.set();
    call Byte.write(SD_BLANK_BYTE);
    call Timer0.stop();
    printf("SD.initialised()\r\n");
    signal SD.initialised();
  }
  sderror_t SD_setBlockLength (const uint16_t len) {
    uint8_t response;
    //if (!card) return SD_NOCARD_ERROR;
    sendCmd(SD_SET_BLOCKLEN, len, SD_BLANK_BYTE);

    // get response from card, should be 0; so, shouldn't this be 'while'?
    // Might not be necessary
    //    
    //    if(response[0] == SD_RESPONSE_READY){
    //      initSetToIdle();
    //      sendCmd(SD_SET_BLOCKLEN, len, SD_BLANK_BYTE);
    //      getResponse(SD_RESPONSE_R1,response);
    //    } 
    // Send 8 Clock pulses of delay.
    // Might not be necessary
    // call Byte.write(SD_BLANK_BYTE);
    getResponse(SD_RESPONSE_R1,&response);
    if(response != SD_RESPONSE_READY){
      //printf("blockseterror\r\n");
      //printfflush();           
      return SD_BLOCK_SET_ERROR;
    }
    //printf("Got Block Length");
    return SD_SUCCESS;
  }
  // see macro in module for writing to a sector instead of an address
  sderror_t SD_readBlock(const uint32_t address, const uint16_t count, uint8_t * buffer){
    uint8_t response[5];
    // Set the block length to read
    atomic if (!card) return SD_NOCARD_ERROR;
    if(SD_setBlockLength(count) != SD_SUCCESS){
      //printf("b_s_err\r\n");
      //printfflush();    
      return SD_BLOCK_SET_ERROR;
    }
    // block length can be set
    sendCmd(SD_READ_SINGLE_BLOCK, address, SD_BLANK_BYTE);
    // Send 8 Clock pulses of delay, check if the MMC acknowledged the read block command
    // it will do this by sending an affirmative response in the R1 format (0x00 is no errors)
    getResponse(SD_RESPONSE_R1,response);
    if(response[0] != SD_RESPONSE_READY) return SD_RESPONSE_ERROR;
    //spiFlush(127);
    // now look for the data token to signify the start of the data
    //For some reason the 0xFE block can't be found.
    call SS.clr();
    if (getSignature(response, SD_START_DATA_BLOCK_TOKEN,SD_BLANK_BYTE)) return SD_DATA_TOKEN_ERROR;
    swapIn(count,buffer);
      //    if(getSignature(SD_START_DATA_BLOCK_TOKEN) != SD_START_DATA_BLOCK_TOKEN)
      //      return SD_DATA_TOKEN_ERROR;
      //    call Packet.send(buffer, buffer, count);   // is executed with card inserted
      //
      //    // get CRC bytes (not really needed by us, but required by MMC)
      call Byte.write(SD_BLANK_BYTE);
      call Byte.write(SD_BLANK_BYTE);
      //    call Byte.write(SD_BLANK_BYTE);struct __file
      signal SD.readBlockComplete();
      return SD_SUCCESS;
  }

  sderror_t SD_writeBlock(const uint32_t address, const uint16_t count, uint8_t * buffer){
    uint8_t response[1];
    // Set the block length to write
    if(SD_setBlockLength (count) != SD_SUCCESS)  // block length could be set
    return SD_BLOCK_SET_ERROR;
    //      call Leds.yellowOn();
    sendCmd(SD_WRITE_BLOCK, address, SD_BLANK_BYTE);
    // check if the MMC acknowledged the write block command
    // it will do this by sending an affirmative response
    // in the R1 format (0x00 is no errors)
    getResponse(SD_RESPONSE_R1,response);
    if(response[0] != SD_RESPONSE_READY) return SD_RESPONSE_ERROR;
    
    call SS.clr();
    // Send N_wr
    call Byte.write(SD_BLANK_BYTE);
    // send the data token to signify the start of the data
    call Byte.write(SD_START_DATA_BLOCK_TOKEN);
    swapOut(count,buffer);
    //    // clock the actual data transfer and transmitt the bytes
    //
    //    call Packet.send(buffer, buffer, count);        
    //
    //    // put CRC bytes (not really needed by us, but required by MMC)
    //        
    //        call Byte.write(SD_BLANK_BYTE);
    //    // read the data response xxx0<status>1 : status 010: Data accected, status 101: Data
    //    //   rejected due to a crc error, status 110: Data rejected due to a Write error.
    if (getSignature(response,SD_DATA_ACK,SD_DATA_ACK_MASK)) return SD_SIGNATURE_ERROR;   
    else if ((response[0] & SD_DATA_ACK_CHKBITS) != SD_DATA_ACCEPTED)
      return SD_WRITE_ERROR;
    //Wait for SD Card to process writing. This is synchonous due to bit-bang :(
    
    if (waitBusy() != SD_SUCCESS)
    return SD_WRITE_ERROR;
    signal SD.writeBlockComplete();
      return SD_SUCCESS;
      
    //    // Send 8 Clock pulses of delay.
    //    call Byte.write(SD_BLANK_BYTE);
    //    call Leds.greenOn();

 
  }

  command error_t SD.readBlock(const uint32_t sector, void *bufferPtr)
  {
   atomic if (!card) return FAIL;
    if (SD_readBlock(sector * 512, 512, bufferPtr) == SD_SUCCESS)
      return SUCCESS;
    else
      return FAIL;
  }


  command error_t SD.writeBlock(const uint32_t sector, void *bufferPtr)
  {
   atomic if (!card) return FAIL;
    if (SD_writeBlock(sector * 512, 512, bufferPtr) == SD_SUCCESS)
      return SUCCESS;
    else
      return FAIL;
  }


  // register read of length len into buffer
  sderror_t SD_readRegister(const uint8_t reg, const uint8_t len, uint8_t * buffer){
    uint8_t uc;
    uint8_t response[5];
    if((SD_setBlockLength (len)) != SD_SUCCESS)
      return SD_TIMEOUT_ERROR;
    // CRC not used: 0xff as last byte
    sendCmd(reg, 0, SD_BLANK_BYTE);

    // wait for response
    // in the R1 format (0x00 is no errors)
    getResponse(SD_RESPONSE_R1,response);
    if(response[0] != SD_RESPONSE_READY) return SD_RESPONSE_ERROR;
    if(getSignature(response,SD_START_DATA_BLOCK_TOKEN,SD_BLANK_BYTE)) return SD_DATA_TOKEN_ERROR;
    swapIn((uint16_t) len,buffer);
    //    if(response[0] != SD_RESPONSE_READY)
    //      return SD_RESPONSE_ERROR;
    //    if(getSignature(SD_START_DATA_BLOCK_TOKEN) != SD_START_DATA_BLOCK_TOKEN)
    //      return SD_DATA_TOKEN_ERROR;
    //    for(uc = 0; uc < len; uc++)
    //      buffer[uc] = call Byte.write(SD_BLANK_BYTE);  
    //
    //    // get CRC bytes (not really needed by us, but required by MMC)
    //    call Byte.write(SD_BLANK_BYTE);
    //    call Byte.write(SD_BLANK_BYTE);
    //    // Send 8 Clock pulses of delay.
    //    call Byte.write(SD_BLANK_BYTE);
    return SD_SUCCESS;
  } 

  // Read the Card Size from the CSD Register
  // this command is unsupported on sdio-only, like sandisk micro sd cards
  command uint32_t SD.readCardSize(){
    // Read contents of Card Specific Data (CSD)

    uint32_t SD_CardSize = 0;
    uint16_t i = 0;
    uint16_t j, sd_C_SIZE;
    uint8_t sd_READ_BL_LEN, sd_C_SIZE_MULT;
    uint8_t response[16];
    atomic if (!card) return 0;
    sendCmd(SD_SEND_CSD,0,SD_BLANK_BYTE); // Query for CSD: Card Specific Data
    getResponse(SD_RESPONSE_R1,response);
    // data transmission always starts with 0xFE
    if(response[0] != SD_RESPONSE_READY) return SD_RESPONSE_ERROR;
    if(getSignature(response,SD_START_DATA_BLOCK_TOKEN,SD_BLANK_BYTE)) return SD_DATA_TOKEN_ERROR;
      swapIn(16, response);
      sd_READ_BL_LEN = response[5] & 0x0f;
      sd_C_SIZE = ((uint32_t)(response[6] & 0x03)) << 10;
      sd_C_SIZE += ((uint32_t) response[7]) << 2;
      sd_C_SIZE += response[8] >> 6;
 
      sd_C_SIZE_MULT = (response[9] & 0x03) << 1;
      sd_C_SIZE_MULT += response[10] >> 7;
      //      // bits 127:87
      //      for(j = 0; j < 5; j++)          // Host must keep the clock running for at
      //      b = call Byte.write(SD_BLANK_BYTE);
      //
      //
      //      // 4 bits of READ_BL_LEN
      //      // bits 84:80
      //      b = call Byte.write(SD_BLANK_BYTE);  // lower 4 bits of CCC and
      //      sd_READ_BL_LEN = b & 0x0f;
      //
      //      b = call Byte.write(SD_BLANK_BYTE);
      //
      //      // bits 73:62  C_Size
      //      // xxCC CCCC CCCC CC
      //      sd_C_SIZE = (b & 0x03) << 10;
      //      b = call Byte.write(SD_BLANK_BYTE);
      //      sd_C_SIZE += b << 2;
      //      b = call Byte.write(SD_BLANK_BYTE);
      //      sd_C_SIZE += b >> 6;
      //
      //      // bits 55:53
      //      b = call Byte.write(SD_BLANK_BYTE);
      //
      //      // bits 49:47
      //      sd_C_SIZE_MULT = (b & 0x03) << 1;
      //      b = call Byte.write(SD_BLANK_BYTE);
      //      sd_C_SIZE_MULT += b >> 7;
      //
      //      // bits 41:37
      //      b = call Byte.write(SD_BLANK_BYTE);
      //
      //      b = call Byte.write(SD_BLANK_BYTE);
      //
      //      b = call Byte.write(SD_BLANK_BYTE);
      //
      //      b = call Byte.write(SD_BLANK_BYTE);
      //
      //      b = call Byte.write(SD_BLANK_BYTE);
      //
      //      for(j = 0; j < 4; j++)          // Host must keep the clock running for at
      //      b = call Byte.write(SD_BLANK_BYTE);  // least Ncr (max = 4 bytes) cycles after
      //      // the card response is received
      //      b = call Byte.write(SD_BLANK_BYTE);
      //
      SD_CardSize = (sd_C_SIZE + 1);
      for(i = 2, j = sd_C_SIZE_MULT + 2; j > 1; j--)
        i <<= 1;
      SD_CardSize *= i;
      for(i = 2,j = sd_READ_BL_LEN; j > 1; j--)
        i <<= 1;
      SD_CardSize *= i;
    return SD_CardSize;
  }
  event void Resource.granted() {
     
  }
  event void SDByte.idle() {
    uint8_t _wait_type;
    atomic _wait_type = wait_type;
    switch (_wait_type) {
      case SD_waitForRead: break;
      case SD_waitForWrite: break;   
    }
  }
}

