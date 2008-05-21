/* Copyright (c) 2006, Jan Flora <janflora@diku.dk>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 *  - Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *  - Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *  - Neither the name of the University of Copenhagen nor the names of its
 *    contributors may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
  @author Jan Flora <janflora@diku.dk>
*/

#ifndef _MC13192CONST_H_
#define _MC13192CONST_H_

/**************************************************************
*   Defines
*   MC13192 status register interrupt masks.
**************************************************************/

	// MC13192 Register 05
	#define TIMER1_IRQMASK_BIT        0x0001
	#define TIMER2_IRQMASK_BIT        0x0002
	#define TIMER3_IRQMASK_BIT        0x0004
	#define TIMER4_IRQMASK_BIT        0x0008
	#define DOZE_IRQMASK_BIT          0x0010
	#define LO1_LOCK_IRQMASK_BIT      0x0200
	#define STRM_DATA_IRQMASK_BIT     0x0400
	#define ARB_BUSY_IRQMASK_BIT      0x0800
	#define RAM_ADDR_IRQMASK_BIT      0x1000
	#define ATTN_IRQMASK_BIT          0x8000
	
	// MC13192 Register 24
	#define CRC_VALID_MASK            0x0001
	#define CCA_STATUS_MASK           0x0002
	#define TIMER2_IRQ_MASK           0x0004
	#define TIMER4_IRQ_MASK           0x0008
	#define TIMER3_IRQ_MASK           0x0010
	#define CCA_IRQ_MASK              0x0020
	#define TX_IRQ_MASK               0x0040
	#define RX_IRQ_MASK               0x0080
	#define TIMER1_IRQ_MASK           0x0100
	#define DOZE_IRQ_MASK             0x0200
	#define ATTN_IRQ_MASK             0x0400
	#define HG_IRQ_MASK               0x0800
	#define STRM_DATA_ERR_IRQ_MASK    0x1000
	#define STRM_RX_DONE_IRQ_MASK     0x2000
	#define ARB_BUSY_ERR_IRQ_MASK     0x2000
	#define STRM_TX_DONE_IRQ_MASK     0x4000
	#define RAM_ADDR_ERR_IRQ_MASK     0x4000
	#define LO_LOCK_IRQ_MASK          0x8000

	// MC13192 Register 25
	#define RESET_BIT_MASK            0x0080

/**************************************************************
*   Defines
*   The MC13192 transceiver register map.
**************************************************************/

	/******** MC13192 soft reset **********/
	#define RESET                     0x00

	/******** Packet RAM **********/
	#define RX_PKT_RAM                0x01 // RX Packet RAM
	#define RX_STATUS                 0x2D // RX Packet RAM Length [6:0]
	#define TX_PKT_RAM                0x02 // TX Packet RAM
	#define TX_PKT_CTL                0x03 // TX Packet RAM Length

	/******** IRQ Status Register *******/
	#define IRQ_MASK                  0x05
	#define IRQ_STATUS                0x24
	#define RST_IND                   0x25

	/******** Control Registers **********/
	#define CONTROL_A                 0x06
	#define CONTROL_B                 0x07
	#define CONTROL_C                 0x09
	#define LO1_COURSE_TUNE           0x8000

	/******** Main Timer **********/
	#define CURRENT_TIME_A            0x26
	#define CURRENT_TIME_B            0x27
	#define TIMESTAMP_A               0x2E
	#define TIMESTAMP_B               0x2F
	#define TIMESTAMP_HI_MASK         0x00FF

	/******** frequency ***************/
	#define CLKO_CTL                  0x0A
	#define LO1_INT_DIV               0x0F
	#define LO1_NUM                   0x10

	/******** Timer comparators **********/
	#define TMR_CMP1_A                0x1B	
	#define TMR_CMP1_B                0x1C
	#define TMR_CMP2_A                0x1D
	#define TMR_CMP2_B                0x1E
	#define TMR_CMP3_A                0x1F
	#define TMR_CMP3_B                0x20
	#define TMR_CMP4_A                0x21
	#define TMR_CMP4_B                0x22
	#define TC2_PRIME                 0x23

	/******** CCA **********/
	#define CCA_THRESH                0x04

	/******** TX ***********/
	#define PA_LVL                    0x12

	/******* GPIO **********/
	#define GPIO_DIR                  0x0B
	#define GPIO_DATA_OUT             0x0C
	#define GPIO_DATA_IN              0x28
	#define GPIO_DATA_MASK            0x003F

	/******* version *******/
	#define CHIP_ID                   0x2C
	#define MASK_SET_ID_MASK          0xE000
	#define VERSION_MASK              0x1C00
	#define MANUFACTURER_ID_MASK      0x0380

/**************************************************************
*   Defines
*   Modes for the MC13192 transceiver.
**************************************************************/

	// These modes corresponds to register 6 settings.
	// Remember to set the hidden bit 14.
	#define IDLE_MODE                 0x4000
	#define CCA_MODE                  0x4411
	#define ED_MODE                   0x4421
	#define RX_MODE                   0x4102  // Was: 0x4102
	#define TX_MODE                   0x4203  // Was: 0x4203
	
	#define TX_STRM_MODE              0x5200
	#define RX_STRM_MODE              0x4922

	#define INIT_MODE                 0x80

// Define CCA types.
	#define CLEAR_CHANNEL_ASSESSMENT  0x01
	#define ENERGY_DETECT             0x02
	
// Timer macros.
	#define NUMTIMERS                 4
	#define TIMER1                    0
	#define TIMER2                    1
	#define TIMER3                    2
	#define TIMER4                    3

//Default channel
#ifndef MC13192_DEF_CHANNEL                                                      
#define MC13192_DEF_CHANNEL 7                                                   
#endif  

#endif
