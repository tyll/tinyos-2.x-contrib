
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
 * @author Marcus Chang
 *
 */

module DmaP {

  provides interface Init;
  provides interface Dma[uint8_t id];

}

implementation
{

#include "dma.h"

    dma_config_t dmaChannel0;
    dma_config_t dmaChannel1to4[4];
    
    command error_t Init.init() {
        uint8_t i;

        /* Clearing all channels */
        memset((void*) &dmaChannel0, 0, sizeof(dmaChannel0));
        memset((void*) dmaChannel1to4, 0, sizeof(dmaChannel1to4));

        /* set default values */
        dmaChannel0.VLEN      = VLEN_USE_LEN;  // Using LEN to determine how many bytes to transfer
        dmaChannel0.PRIORITY  = PRI_HIGH;      // High priority over CPU
        dmaChannel0.M8        = M8_USE_8_BITS; // Irrelevant since length is determined by the LEN
        dmaChannel0.IRQMASK   = TRUE;          // Issue an IRQ upon completion.
        dmaChannel0.DESTINC   = DESTINC_1;     // The destination address is to be incremented by 1 after each transfer
        dmaChannel0.SRCINC    = SRCINC_1;      // The source address inremented by 1 byte after each transfer
        dmaChannel0.TRIG      = DMATRIG_NONE;  // The DMA channel will be started manually
        dmaChannel0.TMODE     = TMODE_BLOCK;   // The number of bytes specified by LEN is transferred
        dmaChannel0.WORDSIZE  = WORDSIZE_BYTE; // One byte is transferred each time.

        for (i = 0; i < 4; i++) {
            dmaChannel1to4[i].VLEN      = VLEN_USE_LEN;  // Using LEN to determine how many bytes to transfer
            dmaChannel1to4[i].PRIORITY  = PRI_HIGH;      // High priority over CPU
            dmaChannel1to4[i].M8        = M8_USE_8_BITS; // Irrelevant since length is determined by the LEN
            dmaChannel1to4[i].IRQMASK   = TRUE;          // Issue an IRQ upon completion.
            dmaChannel1to4[i].DESTINC   = DESTINC_1;     // The destination address is to be incremented by 1 after each transfer
            dmaChannel1to4[i].SRCINC    = SRCINC_1;      // The source address inremented by 1 byte after each transfer
            dmaChannel1to4[i].TRIG      = DMATRIG_NONE;  // The DMA channel will be started manually
            dmaChannel1to4[i].TMODE     = TMODE_BLOCK;   // The number of bytes specified by LEN is transferred
            dmaChannel1to4[i].WORDSIZE  = WORDSIZE_BYTE; // One byte is transferred each time.
        }
        
        /* Clearing any arming of channels 0 to 4 */
        DMAARM = 0;

        /* Clearing all starting of DMA channels 0 to 4 */
        DMAREQ = 0;

        /* Clearing all DMA interrupt flags of channels 0 to 4 */
        DMAIRQ = 0;

        /* Clearing the interrupt flag of the DMA and enabling DMA interrupt */
        DMAIF = 0;
        DMAIE = 1;

        /* Setting the address of the DMA descriptors */
        DMA_SET_ADDR_DESC0(&dmaChannel0);
        DMA_SET_ADDR_DESC1234(dmaChannel1to4);

        return SUCCESS;
    }

    /**************************************************************************
    ** DMA
    **************************************************************************/
    command dma_config_t * Dma.getConfig[uint8_t id]() {
    
        switch(id) {

            case 0:
                return &dmaChannel0;
                        
            case 1:
                return &dmaChannel1to4[0];
                
            case 2:
                return &dmaChannel1to4[1];
                
            case 3:
                return &dmaChannel1to4[2];
                
            case 4:
                return &dmaChannel1to4[3];

            default:
                return 0;
        }
    }


    command error_t Dma.armChannel[uint8_t id]() {
    
        if (id > 4)
            return FAIL;

        // Stop transfers 
        DMA_ABORT_CHANNEL(id);
        
        // Arm the DMA channel.
        DMA_ARM_CHANNEL(id);

        // Clearing DMA complete flags 
        DMAIRQ = 0x01 << id;
        
        return SUCCESS;
    }

    command error_t Dma.disarmChannel[uint8_t id]() {
    
        if (id > 4)
            return FAIL;

        // Stop transfers 
        DMA_ABORT_CHANNEL(id);    
        
        return SUCCESS;
    }
    
    command bool Dma.isArmed[uint8_t id]() {
        uint8_t channel;
    
        if (id > 4)
            return FALSE;
            
        channel = (0x01 << id) & 0x1F;
            
        return ((DMAARM & channel) == channel);    
    }
    
    command error_t Dma.startTransfer[uint8_t id]() {
    
        if (id > 4)
            return FAIL;

        DMA_START_CHANNEL(id);
        
        return SUCCESS;
    }
    
    command error_t Dma.stopTransfer[uint8_t id]() {

        if (id > 4)   
            return FAIL;

        // Stop transfers 
        DMA_ABORT_CHANNEL(id);

        return SUCCESS;
    }

    /**************************************************************************
    ** DMA Interrupt
    **************************************************************************/
    MCS51_INTERRUPT(SIG_DMA) { 

        atomic {
            // Clearing the interrupt flag.
            DMAIF = 0;

            if(DMAIRQ & DMA_CHANNEL_0){
                // Clearing interrupt flag
                DMAIRQ &= ~DMA_CHANNEL_0;

                signal Dma.transferDone[0]();
            }

            if(DMAIRQ & DMA_CHANNEL_1){
                // Clearing interrupt flag
                DMAIRQ &= ~DMA_CHANNEL_1;

                signal Dma.transferDone[1]();
            }

            if(DMAIRQ & DMA_CHANNEL_2){
                // Clearing interrupt flag
                DMAIRQ &= ~DMA_CHANNEL_2;

                signal Dma.transferDone[2]();
            }

            if(DMAIRQ & DMA_CHANNEL_3){
                // Clearing interrupt flag
                DMAIRQ &= ~DMA_CHANNEL_3;

                signal Dma.transferDone[3]();
            }

            if(DMAIRQ & DMA_CHANNEL_4){
                // Clearing interrupt flag
                DMAIRQ &= ~DMA_CHANNEL_4;

                signal Dma.transferDone[4]();
            }

        }
    }
    
    default async event void Dma.transferDone[uint8_t id]() {

    }
  
}
