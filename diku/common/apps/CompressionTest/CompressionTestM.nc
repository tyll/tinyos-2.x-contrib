
/*
 * Copyright (c) 2007 University of Copenhagen
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
 * - Neither the name of University of Copenhagen nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY
 * OF COPENHAGEN OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 *
 * @author Klaus S. Madsen <klaussm@diku.dk>
 * @author Martin Leopold <leopold@diku.dk>
 */

module CompressionTestM {
  provides {
    interface Init;
  }
  uses {
    interface GeneralIO as Starter;
    interface SerialByteComm as UART;
    interface CRC16;
    interface Compressor;
    interface Boot;
  }
}

implementation {

  enum state_t {
    ST_Ready,
    ST_Receiving,
    ST_ReceivingWait,
    ST_CRC,
    ST_Compressing,
    ST_CompressingOutput,
    ST_NeedToFinish,
    ST_ReadMem,
    ST_Flush,
    ST_FlushOutput,
  };

  enum state_t state;

  uint8_t recv_buffer[258] __attribute((xdata)); // 256 bytes + 2 bytes for CRC
  uint16_t recv_pos;

  //uint8_t memory_buffer[4096];
  uint8_t memory_buffer[4096] __attribute((xdata));
  uint8_t buffers = sizeof(memory_buffer) / 256;

  uint16_t memslot;
  uint16_t read_memslot;

  uint8_t *send_start;
  uint8_t *send_end;

  error_t uart_put(uint8_t *start, uint8_t *end)
  {
    if (send_start) {
      return(FAIL);
    }
    atomic{
      send_start = start+1;
      send_end = end;
      call UART.put(*start);
    }
    return SUCCESS;
  }

  void print(char* s) {
    uart_put(s, s + strlen(s));
  };
  
  command error_t Init.init()
  {
    state = ST_Ready;
    //call UART.init();
    //call USARTControl.setClockRate(UBR_SMCLK_230400, UMCTL_SMCLK_230400);
    call Compressor.init();
    send_start = 0;

    // Inline workarround
    //print("Booting\n\r");
    {static const char* c = "Booting";
      print((char* )c);}

    state = ST_Ready;	 
    memslot = 0;

    return SUCCESS;
  }

  uint8_t tmp_buffer[259] __attribute((xdata));
  bool halt_compression = FALSE;
  uint16_t do_compress_memslot;
  uint8_t do_compress_pos;


  event void Boot.booted() {
    call Starter.clr();
    call Starter.makeOutput();
    memset(tmp_buffer, 0, sizeof(tmp_buffer));
  }

  task void do_compress() 
  {
    uint16_t i = do_compress_memslot;
    do_compress_memslot = 0;

    for (; i < memslot; i++) {
      uint8_t j;
      uint16_t *b = (uint16_t*)(memory_buffer
				+ (uint16_t)i * 256);

      j = do_compress_pos;
      do_compress_pos = 0;

      for (; j < 42; j++) {
	call Compressor.compress(b[j * 3],
				 b[j * 3 + 1],
				 b[j * 3 + 2]);
	if (halt_compression) {	  
	  j++;
	  do_compress_pos = j;
	  break;
	}
      }
      if (halt_compression) {
	do_compress_memslot = i;
	break;
      }
    }

    /* Compression done */
    if (!halt_compression) {
      call Starter.clr();
      print("f\n");
      state = ST_Ready;
    }
  }

  task void restart_compression() {
    if (halt_compression) {
      halt_compression = FALSE;
      post do_compress();
    }
  }

  void send_buffer() {
    uint8_t *tmp_buffer_end;
    uint16_t crc = call CRC16.calc(tmp_buffer, sizeof(tmp_buffer) - 2);
		tmp_buffer_end = tmp_buffer + sizeof(tmp_buffer);
		/* Bloody stupid MSP430 cannot write a uint16 to an unaligned
			 address, and gcc does not warn about it */
    *(tmp_buffer_end - 1) = crc >> 8;
    *(tmp_buffer_end - 2) = crc & 0xFF;

    uart_put(tmp_buffer, tmp_buffer_end);
  }
  
  task void send_buffer_task() {
    send_buffer();
  }

  async event void UART.putDone()
  {
    atomic{
    if (send_start && send_start < send_end) {
      call UART.put(*send_start);
      send_start++;
    } else {
      send_start = 0;
    }
   }
  }

  event void Compressor.bufferFull(uint8_t *buffer,  uint16_t bytes)
  {
    if (state == ST_CompressingOutput || state == ST_FlushOutput) {
      memcpy(tmp_buffer + 1, buffer, 256);
      tmp_buffer[0] = 'd';
      send_buffer();
      if (state != ST_FlushOutput) {
				halt_compression = TRUE;
      } else {
				state = ST_Ready;
      }
    }
  }

  char to_hex(uint8_t i) {
    if (i<10) {
      return ((char) (i+48));
    } else {
      return ((char) (i+31));
    }
    
  }

  task void handle_packet()
  {
    uint16_t recv_crc;
    uint16_t crc = call CRC16.calc(recv_buffer, 
				   sizeof(recv_buffer) - 2);
    //    uint16_t recv_crc = *(uint16_t*)(recv_buffer 
    //				     + sizeof(recv_buffer) - 2);

    // Network/host order varries from platform to platform
    recv_crc=recv_buffer[sizeof(recv_buffer) - 2];                 // LSB
    recv_crc+=((uint16_t)recv_buffer[sizeof(recv_buffer) - 1])<<8; // MSB

    if (crc == recv_crc) {
      /* Move the received data to the designated memory slot */
      uint8_t slot = memslot;
      
      print("ok\n");
      
      memcpy(memory_buffer + (uint16_t)slot * 256, 
	     recv_buffer, 256);
      
      memslot++;
    } else {
      print("again CRC err\n");
      /*      
      prn_buf[0] = 'a';
      prn_buf[1] = 'g';
      prn_buf[2] = 'a';
      prn_buf[3] = 'i';
      prn_buf[4] = 'n';
      prn_buf[5] = ' ';
      prn_buf[6] = 'C';
      prn_buf[7] = 'R';
      prn_buf[8] = 'C';
      prn_buf[9] = ' ';
      prn_buf[10] = '0';
      prn_buf[11] = 'x';
      prn_buf[12] = to_hex(0x0F & ((uint8_t) (crc>>12)));
      prn_buf[13] = to_hex(0x0F & ((uint8_t) (crc>>8)));
      prn_buf[14] = to_hex(0x0F & ((uint8_t) (crc>>4)));
      prn_buf[15] = to_hex(0x0F & ((uint8_t) crc));
      prn_buf[16] = ' ';
      prn_buf[17] = '0';
      prn_buf[18] = 'x';
      prn_buf[19] = to_hex(0x0F & ((uint8_t) (recv_crc>>12)));
      prn_buf[20] = to_hex(0x0F & ((uint8_t) (recv_crc>>8)));
      prn_buf[21] = to_hex(0x0F & ((uint8_t) (recv_crc>>4)));
      prn_buf[22] = to_hex(0x0F & ((uint8_t) recv_crc));
      prn_buf[23] = '\n';
      prn_buf[24] = 0;

      print(prn_buf);
      */
    }
    
    state = ST_ReceivingWait;
  }

  task void print_data()
  {
    uint8_t slot = read_memslot;
    uint8_t *tmp = memory_buffer + (uint16_t)slot * 256;

    uart_put(tmp, tmp + 256);

    read_memslot++;
  }

  task void start_print_data()
  {
    read_memslot = 0;
    post print_data();
  }

  task void start_compression()
  {
    halt_compression = FALSE;
    do_compress_memslot = 0;
    do_compress_pos = 0;
     
    post do_compress();
    call Starter.set();
  }

  task void start_recv()
  {
    memslot = 0;
    print("ok\n");
  }

  task void flush()
  {
    call Compressor.flush();
    if (state != ST_FlushOutput) {
      state = ST_Ready;
      print("done\n");
    }
  }

  async event void UART.get(uint8_t data)
  {
    //    print("Receiving\n");
    if (state == ST_Ready) {
      switch (data) {
      case 'a':
				post start_recv();
				break;
      case 'b':
				state = ST_Receiving;
				recv_pos = 0;
				break;
      case 'c': 
				state = ST_Compressing;
				post start_compression();
				break;
      case 'C':
				state = ST_CompressingOutput;
				post start_compression();
				break;
      case 'f':
				state = ST_Flush;
				post flush();
				break;
      case 'F':
				state = ST_FlushOutput;
				post flush();
				break;
      case 'p':
				print("pong\n");
				break;
      case 'r':
				state = ST_ReadMem;
				post start_print_data();
				break;
      }
    } else if (state == ST_ReceivingWait) {
      if (data == 'b') {
				state = ST_Receiving;
				recv_pos = 0;
      } else {
				state = ST_Ready;
      }
    } else if (state == ST_Receiving) {
      recv_buffer[recv_pos++] = data;
			
      if (recv_pos == sizeof(recv_buffer)) {
				state = ST_CRC;
				post handle_packet();
      }
    } else if (state == ST_Compressing || state == ST_CompressingOutput) {
      if (data == 'o') {
				// Ok. Restart compression
				post restart_compression();
      } else if (data == 'a') {
				post send_buffer_task();
      } else if (data == 'p') {
				state = ST_Ready;
      }
    } else if (state == ST_ReadMem) {
      if (data == 'r') {
				post print_data();	
      } else {
				state = ST_Ready;
      }
    }
    //return SUCCESS;
  }

}
