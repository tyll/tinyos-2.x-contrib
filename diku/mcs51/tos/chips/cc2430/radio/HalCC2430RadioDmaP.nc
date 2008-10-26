
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
 * @author Martin Leopold <leopold@diku.dk>
 * @author Marcus Chang <marcus@diku.dk>
 * @author Klaus S. Madsen <klaussm@diku.dk>
 */

#include <CC2430_CSP.h>

module HalCC2430RadioDmaP {
    provides {
      interface HALCC2420;
      interface StdControl as HALCC2420Control;
      interface Init;
    }
    uses {
      interface GpioInterrupt as InterruptTXDone;
      interface GpioInterrupt as InterruptRFErr;
      interface Dma as DmaSend;
      interface Dma as DmaReceive;
      interface StdOut;
    }
}

implementation {

#include "hplcc2420.h"
#include "packet.h"
#include "dma.h"

#define debug_fsm(x) //call StdOut.print("FSM: "); call StdOut.printHexword(call HPLCC2420.read(CC_REG_FSMSTATE)); call StdOut.print("\r\n");

  void CC2430SetPanid(uint16_t id);
  void CC2430SetShortaddr(uint16_t shortAddr);
  void CC2420SetIEEEAddr(ieee_mac_addr_t extAddress);
  void CC2430Reset();
  void CC2430RFEnable();
  void CC2430RFDisable();
  void CC2430ExternalOscillator();
  void CC2430RxEnable();
  void CC2430RxDisable();
  void CC2430ChannelSet(uint8_t channel);
  void CC2430PALevelSet(uint8_t new_power);
  void CC2430ControlSet();
  void CC2430TxWait();
  void wait(uint16_t u);


  task void transmitTaskBeforeDMA();
  task void transmitTaskAfterDMA();


/*************************************************************************************************
*** StdControl
**************************************************************************************************/
    // uint16_t mcr0 = 0x0AE2, iocfg0 = 0x007F;
    uint16_t mcr0 = 0x0000, iocfg0 = 0x007F;
    MDMCTRL0_t * mcr0Ptr;

    ieee_mac_addr_t ieeeAddress;
    mac_addr_t shortAddress, panid;

    bool rxEnabled = FALSE;

    uint8_t receivedPacket[128];
    uint8_t * receivedPacketPtr;
    uint8_t packet_buf_real[PACKET_MAX_PAYLOAD];

    dma_config_t * dmaConfigSend, * dmaConfigReceive;


    /**********************************************************************
     * Init
     *********************************************************************/
    command error_t Init.init() 
    {
        receivedPacketPtr = receivedPacket;
        
        /* setup DMA for send */
        dmaConfigSend = call DmaSend.getConfig();
    
        dmaConfigSend->DESTADDR  = (uint16_t) 0xDFD9;    
        dmaConfigSend->LEN       = 128;
        dmaConfigSend->VLEN      = VLEN_1_P_VALOFFIRST;
        dmaConfigSend->IRQMASK   = TRUE;          
        dmaConfigSend->DESTINC   = DESTINC_0;     
        dmaConfigSend->SRCINC    = SRCINC_1;      
        dmaConfigSend->TRIG      = DMATRIG_NONE;  
        dmaConfigSend->WORDSIZE  = WORDSIZE_BYTE; 
        dmaConfigSend->TMODE     = TMODE_BLOCK_REPEATED;   
        
        call DmaSend.armChannel();

        /* setup DMA for receive */
        dmaConfigReceive = call DmaReceive.getConfig();

        dmaConfigReceive->SRCADDR  = (uint16_t) 0xDFD9;    
        dmaConfigReceive->DESTADDR = (uint32_t) receivedPacketPtr;
        dmaConfigReceive->LEN = 128;
        dmaConfigReceive->VLEN      = VLEN_1_P_VALOFFIRST;
        dmaConfigReceive->IRQMASK   = TRUE;          
        dmaConfigReceive->DESTINC   = DESTINC_1;     
        dmaConfigReceive->SRCINC    = SRCINC_0;      
        dmaConfigReceive->TRIG      = DMATRIG_RADIO;  
        dmaConfigReceive->WORDSIZE  = WORDSIZE_BYTE; 
        dmaConfigReceive->TMODE     = TMODE_SINGLE;   
        
        /* Chipcons manufacture ID */
        ieeeAddress[0] = 0x10;
        ieeeAddress[1] = 0x3d;
        ieeeAddress[2] = 0x23;

        /* no unique ID use TOS_NODE_ID instead */
        ieeeAddress[3] = 0;
        ieeeAddress[4] = 0;
        ieeeAddress[5] = 0;
        ieeeAddress[6] = TOS_NODE_ID >> 8;
        ieeeAddress[7] = TOS_NODE_ID;
        
        /* Power cycle radio*/
        CC2430Reset();
        
        /* turn on oscillator, enabling RAM access */
        CC2430ExternalOscillator();

        /******************************************
        ** RAM related                           **
        ******************************************/

        /* Write IEEE adress to radio */
        CC2420SetIEEEAddr(ieeeAddress);
        
        /* Write lowest bits as default shortAdr */     
        shortAddress = ((uint16_t) ieeeAddress[6]) << 8 | ieeeAddress[7];
        CC2430SetShortaddr(shortAddress);

        /* Write scan address in PAN ID */
        panid = shortAddress;
        CC2430SetPanid(panid);

        /******************************************
        ** Register related                      **
        ******************************************/
        /* Set control registers */
        CC2430ControlSet();

        /* Set channel */
        CC2430ChannelSet(CC2420_DEFAULT_CHANNEL);

        /* Set transmitter power */
        CC2430PALevelSet(CC2420_DEFAULT_POWER);

        call InterruptTXDone.enableRisingEdge();
        call InterruptRFErr.enableRisingEdge();
        
        return SUCCESS;
    }

    /**********************************************************************
    * Start
    *********************************************************************/
    command error_t HALCC2420Control.start()
    {       
      /* Turn radio on */
      CC2430RFEnable();

      /* Enable receiver */
      CC2430RxEnable();

      return SUCCESS;
    }
       
  /**********************************************************************
   * Stop
   *********************************************************************/
  command error_t HALCC2420Control.stop()
  {
    /* Wait if radio is transmitting */
    CC2430TxWait();
    CC2430RFDisable();
    return SUCCESS;
  }
    

/*************************************************************************************************
*** Transmit/receive related
**************************************************************************************************/
    /**********************************************************************
    * sendPacket
    *********************************************************************/
    uint8_t * transmitPacketPtr;
    bool transmitInProgress = FALSE;

    command error_t HALCC2420.sendPacket(uint8_t * packet) 
    {
        transmitPacketPtr = packet;

        dmaConfigSend->SRCADDR = (uint32_t) packet;

        post transmitTaskBeforeDMA();
    
        return SUCCESS;
    }


    task void transmitTaskBeforeDMA()
    {
        bool oldRxEnabled;

        /***********************************************
        * Check if channel is clear - If radio is not in 
        * receive mode, turn on receiver to gather RSSI
        ***********************************************/
        oldRxEnabled = rxEnabled;
        if (!rxEnabled)
        {
            /* turn on receiver */
            CC2430RxEnable();
        }

        /* wait 8 symbol periods (128 us) */
        wait(128);
        
        /* check if channel is busy */
        if ( !(_CC2430_RFSTATUS & _BV(CC2430_RFSTATUS_CCA)) ) {

            /* restore previous state before returning call */
            if (!oldRxEnabled)
            {
                /* turn off receiver */
                CC2430RxDisable();
            }

            signal HALCC2420.sendPacketDone(transmitPacketPtr, CC2420_ERROR_CCA);

            return;
        }


        /***********************************************
        ** Clear to send packet
        ***********************************************/

        /* flush TX fifo */
        RFST = _CC2430_ISFLUSHTX;

        /* put packet in transmit buffer */
        call DmaSend.startTransfer();        
    }

    async event void DmaSend.transferDone() {
        post transmitTaskAfterDMA();
    }

    task void transmitTaskAfterDMA() {
        uint8_t i, status, counter;
    
        /* Wait for it to send the packet */
        i = 0;
        while (i++ < 3) 
        {
            RFST = _CC2430_ISTXON;
            counter = 0;

            do {
                status = _CC2430_RFSTATUS;
            }while ( !(status & _BV(CC2430_RFSTATUS_TX_ACTIVE))  && (counter++ < 200));

            if (status & _BV(CC2430_RFSTATUS_TX_ACTIVE)) 
                break;
        }

        /***********************************************
        ** Check if packet is being transmitted
        ***********************************************/    
        if (!(status & _BV(CC2430_RFSTATUS_TX_ACTIVE))) {

            /* flush transmit buffer */
            RFST = _CC2430_ISFLUSHTX;

            signal HALCC2420.sendPacketDone(transmitPacketPtr, CC2420_ERROR_TX);

            return;
        }

        atomic transmitInProgress = TRUE;
    
        return;
    }

    /**********************************************************************
    * setChannel
    *********************************************************************/   
    command error_t HALCC2420.setChannel(uint8_t channel) 
    {
        if ( (channel < 11) || (channel > 26) ) 
            return FAIL;
        else {
            /* Wait if radio is transmitting */
            CC2430TxWait();
            if (rxEnabled) 
            {
                CC2430RxDisable();
                /* set channel */
                CC2430ChannelSet(channel);
                CC2430RxEnable();
            } else
                /* set channel */
                CC2430ChannelSet(channel);
        }

        return SUCCESS;
    }
    
    /**********************************************************************
    * setTransmitPower
    *********************************************************************/
    command error_t HALCC2420.setTransmitPower(uint8_t power)
    {
        if (power > 100) 
            return FAIL;
        else 
            CC2430PALevelSet(power);
            
        return SUCCESS;
    }
    

    /**********************************************************************
    * rxEnable
    *********************************************************************/
    command error_t HALCC2420.rxEnable()
    {
        /* turn on receiver */
        CC2430RxEnable();
        
        return SUCCESS;
    }
    
    /**********************************************************************
    * rxDisable
    *********************************************************************/
    command error_t HALCC2420.rxDisable()
    {
        /* ignore call if radio is already off */
        if (rxEnabled) 
        {
            CC2430RxDisable();
        }
        
        return SUCCESS;
    }

/*************************************************************************************************
*** Adressing
**************************************************************************************************/

    /**********************************************************************
     * setShortAddress
     *********************************************************************/
    command error_t HALCC2420.setAddress(mac_addr_t *addr)
    {
        shortAddress = *addr;
        _CC2430_SHORTADDR = (*addr);

        return SUCCESS;
    }

    /**********************************************************************
     * getShortAddress
     *********************************************************************/
    command const mac_addr_t * HALCC2420.getAddress()
    {
        return &shortAddress;
    }
    
    /**********************************************************************
     * setPANAddress
     *********************************************************************/
    command error_t HALCC2420.setPanAddress(mac_addr_t *addr)
    {
        panid = *addr;
        _CC2430_PANID = panid;

        return SUCCESS;
    }
    
    /**********************************************************************
     * getShortAddress
     *********************************************************************/
    command const mac_addr_t * HALCC2420.getPanAddress()
    {
        return &panid;
    }
    
    /**********************************************************************
     * getExtAddress
     *********************************************************************/
    command const ieee_mac_addr_t * HALCC2420.getExtAddress()
    {
        return (const ieee_mac_addr_t *) &ieeeAddress;
    }

    /**********************************************************************
     * Hardware Address Filtering
     *********************************************************************/
    command error_t HALCC2420.addressFilterEnable()
    {
        _CC2430_MDMCTRL0H |= _BV(CC2430_MDMCTRL0H_ADDR_DECODE);
        
        return SUCCESS;
    }
    
    command error_t HALCC2420.addressFilterDisable()
    {
        _CC2430_MDMCTRL0H &= ~_BV(CC2430_MDMCTRL0H_ADDR_DECODE);

        return SUCCESS;
    }

    void CC2430SetPanid(uint16_t id)
    {
        _CC2430_PANID = id;
    }

    void CC2430SetShortaddr(uint16_t shortAddr)
    {
        _CC2430_SHORTADDR = shortAddr;
    }

    void CC2420SetIEEEAddr(ieee_mac_addr_t extAddress)
    {
        _CC2430_IEEE_ADDR7 = extAddress[7];
        _CC2430_IEEE_ADDR6 = extAddress[6];
        _CC2430_IEEE_ADDR5 = extAddress[5];
        _CC2430_IEEE_ADDR4 = extAddress[4];
        _CC2430_IEEE_ADDR3 = extAddress[3];
        _CC2430_IEEE_ADDR2 = extAddress[2];
        _CC2430_IEEE_ADDR1 = extAddress[1];
        _CC2430_IEEE_ADDR0 = extAddress[0];
    }

/*************************************************************************************************
*** Interrupt handler
**************************************************************************************************/

    task void receivedPacketTaskAfterDMA();
    task void flushBufferTask();
    task void sendPacketDoneTask();
    bool flushBufferTaskPosted = FALSE; 

    /**************************************************************************
    * TXDone fired
    **************************************************************************/
    async event void InterruptTXDone.fired()
    {

      if (transmitInProgress) {
        transmitInProgress = FALSE;
        post sendPacketDoneTask();
      } else {
        call StdOut.print("MAC: Unscheduled transmit\n");
      }
      
    }

    task void sendPacketDoneTask() {
        signal HALCC2420.sendPacketDone(transmitPacketPtr, SUCCESS);
    }

    /**************************************************************************
    * DMA triggered by radio
    **************************************************************************/  
    async event void DmaReceive.transferDone() {
        post receivedPacketTaskAfterDMA();
    }
    
    task void receivedPacketTaskAfterDMA() {
        uint8_t correlation, frameLength;

        frameLength = receivedPacketPtr[0];

        /* read CORRELATION */
        correlation = receivedPacketPtr[frameLength];
                
        /***********************************************
        ** Process this frame
        ***********************************************/

        /* only signal packet if not corrupt */        
        if (correlation & FCS_CRC_OK_MASK) 
        {
            receivedPacketPtr = signal HALCC2420.receivedPacket(receivedPacketPtr);            

        } else {

            call StdOut.print("MAC: CRC Failed\n\r");

            /* corrupt packet might indicate misaligned frame */        
            atomic {
                flushBufferTaskPosted = TRUE;
                post flushBufferTask();
            }
            return;
        }

        /***********************************************
        ** Check if other frames are available
        ***********************************************/
        atomic {
        
            /* if there are more bytes in rxfifo then get them */
            if ( (_CC2430_RXFIFOCNT > 0) && (_CC2430_RXFIFOCNT < 129) ) {
            
                /* DMA triggers are disabled when buffer is overflow */
                /* use block transfer until RX fifo has been flushed */
                if (flushBufferTaskPosted)
                    dmaConfigReceive->TMODE = TMODE_BLOCK;   

                /* rearm and fire DMA transfer */            
                call DmaReceive.armChannel();        
                call DmaReceive.startTransfer();

            /* check if buffer has overrun while processing frame   */
            /* and post flushBufferTask if it has                   */
            } else if (flushBufferTaskPosted) {
                flushBufferTaskPosted = TRUE;
                post flushBufferTask();

            } else {
                call DmaReceive.armChannel();        
            }
        }

    }
  
    /**************************************************************************
    * RFErr fired
    **************************************************************************/
    async event void InterruptRFErr.fired() {

        call StdOut.print("MAC: Buffer overrun\r\n");

        /* buffer overrun detected      *
         * if no receivedPacketTask is posted,  *
         * then flush buffer            *
         * else flag buffer to be flushed   */   
        if (!flushBufferTaskPosted) 
        {
//           post flushBufferTask();
        }

        flushBufferTaskPosted = TRUE;
    }
  

    task void flushBufferTask() 
    {
        if (rxEnabled) 
        {
            /* turn off receiver */
            CC2430RxDisable();

            /* flush buffer - done when enabling/disabling receiver */
            RFST = _CC2430_ISFLUSHRX;
            RFST = _CC2430_ISFLUSHRX;

            /* reset transfer mode to single transfer instead of block mode */
            dmaConfigReceive->TMODE = TMODE_SINGLE;   

            /* enable receiver */
            CC2430RxEnable();
        } else
        {
          /* flush buffer */
          RFST = _CC2430_ISFLUSHRX;
          RFST = _CC2430_ISFLUSHRX;
        }

        atomic flushBufferTaskPosted = FALSE;

        call StdOut.print("MAC: Buffer flushed\r\n");

    }


/*************************************************************************************************
*** Internal utility functions
**************************************************************************************************/
    /**********************************************************************
    **
    ** Internal CC2420 utility functions
    **
    **********************************************************************/

    /********************
    ********************/
    void CC2430Reset()
    {
      // Power cycle voltage regulator
      _CC2430_RFPWR &= ~_BV(CC2430_RFPWR_RREG_RADIO_PD);
      _CC2430_RFPWR |= _BV(CC2430_RFPWR_RREG_RADIO_PD); 

      // RFPWR contains the register ADI_RADIO_PD as a delayed version
      // The manual however waits for the IF
      while ( RFIF & _BV(CC2430_RFIF_RREG_ON) ) {
      }
    }

    /********************
    ** Enable radio and wait for boot up
    ********************/
    void CC2430RFEnable()
        {
      // Set delay an power up radio
      _CC2430_RFPWR = 0x04; // Power up radio and set delay

      // Wait for radio to power up.
      // Wait by delay time in RFPWR_RREG_DELAY
      // One or the other should be good enough..
      while((_CC2430_RFPWR & 0x10)){}
    }

    /********************
    ********************/
    void CC2430RFDisable()
        {
      _CC2430_RFPWR |= _BV(CC2430_RFPWR_RREG_RADIO_PD);
    }


    /********************
    ********************/
    void CC2430InternalRCOscillator()
    {
        CLKCON |= _BV(CC2430_CLKCON_CLKSPD); // Select clock source = int. RC osc
        SLEEP  |= _BV(CC2430_SLEEP_OSC_PD); // Power down external osc
        // Wait for RC osc stable
        while (!(SLEEP & _BV(CC2430_SLEEP_HFRC_STB))); 
    }

    
    /********************
    ** Switch clock source to high-power, high-precision crystal 
    ** and wait for it to stable 
    *********************/
    void CC2430ExternalOscillator()
    {
      SLEEP  &= ~_BV(CC2430_SLEEP_OSC_PD); // Power up external osc
      CLKCON &= ~_BV(CC2430_CLKCON_CLKSPD); // Select clock source  = ext osc
      // Wait for XOSC powered up and stable
      while (!(SLEEP & _BV(CC2430_SLEEP_XOSC_STB))); 
    }

    /********************
    **
    ********************/
    void CC2430RxEnable()
    {
      /* flush rx buffer */
      RFST = _CC2430_ISFLUSHRX;
      RFST = _CC2430_ISFLUSHRX;

      /* enable interrupts */
      call DmaReceive.armChannel();                

      /* Enable receiver */
      RFST = _CC2430_ISRXON;
      
      rxEnabled = TRUE;
    }

    /********************
    **
    ********************/
    void CC2430RxDisable()
    {
      RFST = _CC2430_ISRFOFF;

      /* disable interrupts */
      call DmaReceive.disarmChannel();                

      rxEnabled = FALSE;
    }

    /********************
    **
    ********************/
    void CC2430ChannelSet(uint8_t channel)
    {
        uint16_t freq;
        
        /* Channel values: 11-26 */
        freq = (uint16_t) channel - 11;
        freq *= 5;  /* channel spacing */
        freq += 357;    /* correct channel range */
        freq |= 0x4000; /* LOCK_THR = 1 */

        _CC2430_FSCTRL = freq;
    }

    /********************
    **
    ********************/
    void CC2430PALevelSet(uint8_t new_power)
    {
        uint16_t power;
        
        power = new_power * 0x1F; // 0x1F ~ 100% power level
        power /= 100;

        _CC2430_TXCTRL = (_CC2430_TXCTRL & ~0x1F) | (power & 0x1F);
    }

    /***********************************************
    ** Set the correlation threshold = 20          
    ** Turn off "Security enable"
    ** Set the FIFOP threshold to maximum
    ***********************************************/
    void CC2430ControlSet()
    {
        /* disable address recognition */
        _CC2430_MDMCTRL0H &= ~_BV(CC2430_MDMCTRL0H_ADDR_DECODE);
//        _CC2430_MDMCTRL0H |= _BV(CC2430_MDMCTRL0H_ADDR_DECODE);
        
        /* enable auto-crc */
        _CC2430_MDMCTRL0L |= _BV(CC2430_MDMCTRL0L_AUTOCRC);

//        _CC2430_MDMCTRL0 = mcr0; 


        /* set FIFOP threshold to 0x7F */
        _CC2430_IOCFG0  = 0x7F;

        /* */
        _CC2430_TXCTRL = 0x050F;
        
        return;
    }

    /***********************************************
    ** Wait while radio is transmitting
    ***********************************************/
    void CC2430TxWait()
    {
        uint8_t i = 0;

        while ( (_CC2430_RFSTATUS & _BV(CC2430_RFSTATUS_TX_ACTIVE) ) && (i < 50) ) 
        {
            wait(100);
            i++;
        } 
        
        return;
    }

    /**********************************************************************
    * wait
    * Guess: loop size is perhaps 10 cycles including load/store of 16 bit value
    * 32 MHz equals 32 cycles pr. us. 
    *********************************************************************/
    inline void wait(uint16_t u)
    {
      uint8_t j;
      uint16_t i;
 
      u = u >> 3; // devide by 8 ~ 10 =]

      // (u*32) cycles / 10 (cyles/loop)
 
      for (i = 0; i < u; i++) {
        for (j = 0; j < 32;) {
            j++;
        }
      }
    }

/*************************************************************************************************
*** Event stubs
**************************************************************************************************/


    /**********************************************************************
     * StdOut
     *********************************************************************/
    async event void StdOut.get(uint8_t data)
    {

    }
    
}
