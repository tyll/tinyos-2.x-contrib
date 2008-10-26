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
 * @author Marcus Chang <marcus@diku.dk>
 * @author Klaus S. Madsen <klaussm@diku.dk>
 */


module HPL1wireM {
	provides interface HPL1wire;
}

implementation {


#define B1W_0() P3OUT &= ~0x02
#define B1W_1() P3OUT |= 0x02
#define B1W_R() (P3IN & 0x04)

	uint8_t read_one_bit();
	void write_one_bit(bool tmp);

	error_t bus_1wire_reset();
	uint8_t bus_1wire_read();
	void bus_1wire_write(uint8_t byte);
	void bus_1wire_crc_add(uint8_t *crc, uint8_t byte);


	/**********************************************************************
	** Bus 1-wire mode enable/disable
	**********************************************************************/
	command error_t HPL1wire.enable()
	{
		P2OUT = (P2OUT & 0x0F); /* dont select a module */

		P3DIR &= ~0x30; /*UART pins inputs*/
		P3SEL &= ~0x30; /*UART pins GPIO*/

		P3SEL &= ~0x0F; /*STE, MISO,MOSI,UCLK = GPIO*/
		P3DIR |= 0x03;	/*MOSI, STE out*/
		P3DIR &= ~0x0C; /*MISO, SCK in*/
		P3OUT |= 0x03;	/*Select 1-wire (STE) and set idle mode (MOSI)*/
	
		B1W_1(); /* power on 1-wire devices */
		TOSH_uwait(500);
	
		return SUCCESS;
	}

	command error_t HPL1wire.disable()
	{
		B1W_0(); /* power off 1-wire devices */

		return SUCCESS;
	}

	/**********************************************************************
	**  Execute 1-wire bus reset sequence
	**
	**	Bus reset and device present pulse detection for 1-wire bus.
	**********************************************************************/
	command error_t HPL1wire.reset() 
	{
		return bus_1wire_reset();
	}

	error_t bus_1wire_reset()
	{
		uint8_t i;
		error_t retval = FAIL;

		/* power off devices for at least 480 microseconds */
		B1W_0();
		TOSH_uwait(500);

		atomic {
			/* power on devices */
			B1W_1();

			/* tPDH: 15-60 us */
//			TOSH_uwait(15);
			TOSH_uwait(50);

			/* scan for 60 microsecond pulse */
			for (i = 0; i < 60; i++) {

				if (B1W_R() == 0)
					retval = SUCCESS;

				TOSH_uwait(1);
			}
		}

		/* total recovery time: ~480 microseconds */
		TOSH_uwait(420);

		TOSH_uwait(500);

		return retval;
	}

	/**********************************************************************
	** Write one byte to 1-wire bus
	**********************************************************************/
	command void HPL1wire.write(uint8_t byte)
	{
		bus_1wire_write(byte);
	}

	void bus_1wire_write(uint8_t byte)
	{
		uint8_t i;

		for (i=0; i<8; i++)
		{
			write_one_bit(byte & 1);
			byte >>= 1;
		}
	}

	/**********************************************************************
	** Read one byte from 1-wire bus
	**********************************************************************/
	command uint8_t HPL1wire.read()
	{
		return bus_1wire_read();
	}

	uint8_t bus_1wire_read()
	{
		uint8_t i, byte = 0;

		for (i = 0; i < 8; i++)
		{
			byte >>= 1;

			if(read_one_bit())
				byte |= 0x80;
		}

		return byte;
	}

	
	/**********************************************************************
	**
	**********************************************************************/
	/**
	 *  Search 1-wire bus
	 *
	 * \param device    array of device structures
	 * \param num_id    size of array
	 *
	 * \return number of devices found on the bus
	 *
	 */		
	command uint8_t HPL1wire.search(b1w_reg *device, uint8_t num_id)
	{
		uint8_t i, tmp, byte_index, bit_mask, crc;
		uint8_t bit = 0, pass = 0, last_miss = 0;
		uint64_t resolved = 0;

		/* each loop detects 1 device */
		while (num_id > pass)
		{

			/* check if there are any devices present */
			if (bus_1wire_reset() == FAIL)
			{
				return 0;
			}

			/* write search-command */
			bus_1wire_write(0xF0);

			/* resume from previous branch point? */
			if (bit > 0) {
			
				/* goto last branch point */
				for (i = 0; i < bit; i++) {

					byte_index = 7 - (i >> 3);
					bit_mask = 0x01 << (i & 7);

					/* read two consecutive bits */
					tmp = read_one_bit() << 1;
					tmp |= read_one_bit();

					/* remember latest unresolved confict */
					if (tmp == 0 && !(resolved & (0x01 << i)) ) 
					{
						last_miss = i;
					}

					/* select devices (branch) */
					write_one_bit(device[pass][byte_index] & bit_mask);
				}

				/* branch point reached, choose 1 this time */ 
				byte_index = 7 - (bit >> 3);
				bit_mask = 0x01 << (bit & 7);
				device[pass][byte_index] |= bit_mask;

				/* read two consecutive bits */
				tmp = read_one_bit() << 1;
				tmp |= read_one_bit();

				/* select devices (branch) */
				write_one_bit(1);
				
				/* mark branch as resolved */
				resolved |= (0x01 << bit);
				
				bit++;
			}

			/* binary search algorithm - queries device's ID 1 bit at a time    *
			 * host selects which devices to include in remainder of the search */
			while (bit < 64)
			{
				tmp = 0;
				byte_index = 7 - (bit >> 3);
				bit_mask = 1 << (bit &  7);

				/* read two consecutive bits */
				tmp = read_one_bit() << 1;
				tmp |= read_one_bit();

				switch(tmp)
				{
					/* conflicting ID bits - choose one, and branch search */
					case 0: //can't tell
					
						/* save latest suitable branch point */
						last_miss = bit;
						
						/* choose 0-branch as default */						

					/* all devices contains a 0 in this ID-bit */
					case 1: 
						tmp = 0;
						device[pass][byte_index] &= ~bit_mask;
						break;

					/* all devices contains a 1 in this ID-bit */
					case 2: 
						tmp = 1;
						device[pass][byte_index] |= bit_mask;
						break;

					case 3: // read error
						bit = 64;
						break;
				}

				/* select devices (branch) */
				write_one_bit(tmp);

				bit++;
			} 
			

			/* check crc */
			crc = 0;
			for (i = 7; i > 0; i--) {
				bus_1wire_crc_add(&crc, device[pass][i]);
			}

			if (crc != device[pass][0]) {
				for (i = 0; i < 8; i++) {
					device[pass][i] = 0xFF;
				}
			}

			/* address scan of one device completed */
			pass++;

			/* check if all devices are detected (no unresolved conflicts) */
			if ( (last_miss == 0) || (num_id <= pass) ) {
				break;
			} else {
				/* back-track */
				bit = last_miss;
				last_miss = 0;

				/* clear resolved branch points that comes after back-track point */
				resolved &= (0xFFFFFFFFFFFFFFFF >> (63 - bit) );

				/* remember last route in search-tree */
				memcpy(device[pass], device[pass - 1], 8);
			}

		}

		/* return number of detected devices */
		return pass;
	}


	/* 
	 * Read one bit
	 *
	 */
	uint8_t read_one_bit()
	{
		uint8_t tmp = 1, i;

		atomic {
			/* initiate read                      */
			B1W_0();

			/* tLOWR: 1 <= t < 15 micro seconds   */
			/* (best to keep it close to 1us)     */
//			TOSH_uwait(1);
			TOSH_uwait(3);

			/* send read pulse                    */
			B1W_1();

			/* tRDV: 15 micro seconds             */
			/* (master sampling window)           */
//			TOSH_uwait(1);
			TOSH_uwait(10);

			/* tRELEASE: 0-45 micro seconds       */
			/* sample for: ~40 us      */
			for (i = 0; i < 40; i++) {

				/* sample value */ 
				if (!B1W_R())
					tmp = 0;

				TOSH_uwait(1);
			}
		}

		/* default time slot total size: 60 us */
		TOSH_uwait(15);

		/* minimum relaxation time: 1 us      */
//		TOSH_uwait(1);
		TOSH_uwait(10);
		
		return tmp;
	}

	/* 
	 * Write one bit
	 *
	 */
	void write_one_bit(bool tmp) 
	{
		atomic {
			/* initiate write                     */
			B1W_0();

			/* sampling occurs 15-60 us after low */
			TOSH_uwait(5);
			if (tmp)
				B1W_1();

			/* default time slot size: 60-120 us  */
			TOSH_uwait(85);

			/* minimum relaxation time: 1 us      */
			B1W_1();
//			TOSH_uwait(1);
			TOSH_uwait(10);
		}
	}


	/**
	 *  Count 8-bit CRC for 1-wire. Variable crc is updated.
	 *
	 * \param crc       checksum variable, set to 0 before adding first byte
	 * \param byte			value to add to checksum
	 *
	 */
	void bus_1wire_crc_add(uint8_t *crc, uint8_t byte)
	{
		uint8_t j, bit;

		for (j = 0; j < 8; j++)
		{
			bit = (byte & 1) ^ (*crc & 1);

			*crc >>= 1;
			if (bit) {
				*crc |= 0x80;
				*crc ^= 0x0C;
			}

			byte >>= 1;
		}
	}

}

