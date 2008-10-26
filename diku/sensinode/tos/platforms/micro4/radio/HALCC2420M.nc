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


module HALCC2420M {
    provides {
        interface HALCC2420;
        interface Init;
        interface StdControl as HALCC2420Control;
    }
    uses {
        interface StdControl as HPLCC2420Control;
        interface HPLCC2420;
        interface HPLCC2420RAM;
        interface HPLCC2420FIFO;
        interface HPLCC2420Status;
        interface GpioInterrupt as MSP430Interrupt;
        interface Spi;
        interface BusArbitration;
        interface StdOut;
        interface HPL1wire;
//      interface HPL16MhzCrystal;
    }
}

implementation {

#include "HPLSpi.h"
#include "hplcc2420.h"

#define MCU_ENABLE_IRQ(x) call MSP430Interrupt.enableFallingEdge();
#define MCU_DISABLE_IRQ(x) call MSP430Interrupt.disable();

#define CC2420_READ_STATUS(x) call HPLCC2420.cmd(CC_REG_SNOP)
#define CC2420_OSCILLATOR_DISABLE(x) call HPLCC2420.cmd(CC_REG_SXOSCOFF)

#define CRYSTAL_OSCILLATOR_ENABLE(x)    P1OUT &= ~0x40; /* turn on crystal oscillator */
#define CRYSTAL_OSCILLATOR_DISABLE(X)   P1OUT |= 0x40; /* turn off crystal oscillator */

#define debug_fsm(x) //call StdOut.print("FSM: "); call StdOut.printHexword(call HPLCC2420.read(CC_REG_FSMSTATE)); call StdOut.print("\r\n");


    void CC2420_SET_PANID(uint16_t panid);
    void CC2420_SET_SHORTADDR(uint16_t shortAddr);
    void CC2420_SET_IEEEADDR(ieee_mac_addr_t extAddress);

    void CC2420_RX_ENABLE();
    void CC2420_RX_DISABLE();
    int8_t CC2420_CHANNEL_SET(uint8_t channel);
    int8_t CC2420_POWER_SET(uint8_t new_power);
    bool CC2420_OSCILLATOR_ENABLE();
    void CC2420_CONTROL_SET();
    void CC2420_RESET();
    void CC2420_TX_WAIT();
    
    task void startTask();
    task void stopTask();
    task void initTask();
    task void transmitTask();
    task void setChannelTask();
    task void setTransmitPowerTask();
    task void rxEnableTask();
    task void rxDisableTask();
    task void addressEnableTask();
    task void addressDisableTask();
    task void setShortAddressTask();
    task void setPanAddressTask();


/*************************************************************************************************
*** Queue related
**************************************************************************************************/
#define QUEUE_SIZE 0x0C

    enum
    {
        TASK_START      = 0x01,
        TASK_STOP       = 0x02,
        TASK_INIT       = 0x03,
        TASK_SET_POWER      = 0x04,
        TASK_SET_CHANNEL    = 0x05,
        TASK_TRANSMIT       = 0x06,
        TASK_RX_ENABLE      = 0x07,
        TASK_RX_DISABLE     = 0x08,
        TASK_ADDR_ENABLE    = 0x09,
        TASK_ADDR_DISABLE   = 0x0A,
        TASK_SET_SHORT      = 0x0B,
        TASK_SET_PANID      = 0x0C,
        
        /* High-priority task - skip the queue */
        /* TASK_FLUSH_BUFFER    = 0x0C, */
        /* TASK_RECEIVED_PACKET = 0x0D, */
    };

    bool taskPosted[QUEUE_SIZE];
    uint8_t queue[QUEUE_SIZE];
    uint8_t first, last, recent;

    bool queuePut(uint8_t id) {

        if ( (queue[id] != 0) || (last == id) || (id > QUEUE_SIZE - 1) )
            return FALSE;

        if (first == 0) {
            first = id;
            last = id;
        } else {
        
            if (recent == id) {
                queue[id] = first;
                first = id;
            } else {
                queue[last] = id;   
                last = id;
            }
        }

        return TRUE;
    }

    uint8_t queueGet() {
        uint8_t retval;
        
        retval = first;
        first = queue[retval];
        queue[retval] = 0;

        if (first == 0) {
            last = 0;
            recent = 0;
        } else {
            recent = retval;
        }
        
        return retval;
    }

    bool queueEmpty() {
        if (first == 0) {
            return TRUE;
        } else {
            return FALSE;
        }
    }
    
    void postNextTask() {
        uint8_t id;
        
        id = queueGet();

        switch(id) {
            case TASK_START:
                post startTask();
                break;
            
            case TASK_STOP:
                post stopTask();
                break;
                
            case TASK_INIT:
                post initTask();
                break;

            case TASK_SET_POWER:
                post setTransmitPowerTask();
                break;

            case TASK_SET_CHANNEL:
                post setChannelTask();
                break;

            case TASK_TRANSMIT:
                post transmitTask();
                break;

            case TASK_RX_ENABLE:
                post rxEnableTask();
                break;

            case TASK_RX_DISABLE:
                post rxDisableTask();
                break;

            case TASK_ADDR_ENABLE:
                post addressEnableTask();
                break;

            case TASK_ADDR_DISABLE:
                post addressDisableTask();
                break;

            case TASK_SET_SHORT:
                post setShortAddressTask();
                break;

            case TASK_SET_PANID:
                post setPanAddressTask();
                break;

            default:
                break;
        }
    
            
        return;
    }

/*************************************************************************************************
*** Bus arbitration
**************************************************************************************************/
    event error_t BusArbitration.busFree()
    {
        if (!queueEmpty())
            postNextTask();

        return SUCCESS;
    }


/*************************************************************************************************
*** StdControl
**************************************************************************************************/
    // uint16_t mcr0 = 0x0AE2, iocfg0 = 0x007F;
    uint16_t mcr0 = 0x0000, iocfg0 = 0x007F;
    MDMCTRL0_t * mcr0Ptr;

    ieee_mac_addr_t ieeeAddress;
    mac_addr_t shortAddress, panid;

    bool radioOn;
    bool rxEnabled;

    uint8_t receivedPacket[128];
    uint8_t * receivedPacketPtr;

    /**********************************************************************
     * Init
     *********************************************************************/
    command error_t Init.init() 
    {
        receivedPacketPtr = receivedPacket;
        
        mcr0Ptr = (MDMCTRL0_t *) &mcr0;

        /* No auto Ack. Preamble length: 3 zero bytes. */
        mcr0Ptr->preamble_length = LEADING_ZERO_BYTES_3;
        mcr0Ptr->autoack = FALSE;
        mcr0Ptr->autocrc = TRUE;
        mcr0Ptr->cca_mode = 3;
        mcr0Ptr->cca_hyst = CCA_HYST_2DB;
        mcr0Ptr->adr_decode = TRUE;
        mcr0Ptr->pan_coordinator = FALSE;
        mcr0Ptr->reserved_frame_mode = FALSE;
        
        post initTask();
        
        return SUCCESS;
    }

    task void initTask()
    {
        b1w_reg devices[2];
        bool foundId = FALSE;
        uint8_t n_devices = 0, retry = 0, i;
        uint16_t tmp;
        
        /***********************************************
        ** Reserve bus (1-wire and SPI)
        ***********************************************/
        if (call BusArbitration.getBus() != SUCCESS) {
            queuePut(TASK_INIT);
            return;
        }

        /******************************************
        ** 1-wire related                        **
        ******************************************/

        /* read lowest unique ID from device(s) */
        while(!n_devices && (retry++ < 5))
        {
            call HPL1wire.enable();
            n_devices = call HPL1wire.search(devices, 2);
            call HPL1wire.disable();
        }
    
        /* use ID in IEEE address if successfull */
        for (i = 0; i < n_devices; i++)
        {
            if ((devices[i][0] != 0xFF) 
                && (devices[i][1] != 0xFF) 
                && (devices[i][2] != 0xFF) 
                && (devices[i][3] != 0xFF) 
                && (devices[i][4] != 0xFF) 
                && (devices[i][5] != 0xFF) 
                && (devices[i][6] != 0xFF) 
                && (devices[i][7] != 0xFF) ) 
            {
                /* ieeeAddress[3] = devices[0][2];
                   ieeeAddress[4] = devices[0][3];
                   ieeeAddress[5] = devices[0][4];
                   ieeeAddress[6] = devices[0][5];
                   ieeeAddress[7] = devices[0][6]; */
                memcpy( &(ieeeAddress[3]), &(devices[i][2]), 5);
                foundId = TRUE;
            }
        }

        if (!foundId)
        {
            /* if no unique ID use TOS instead */
            ieeeAddress[3] = 0;
            ieeeAddress[4] = 0;
            ieeeAddress[5] = 0;
            ieeeAddress[6] = TOS_NODE_ID >> 8;
            ieeeAddress[7] = TOS_NODE_ID;
        }

        /******************************************
        ** Enable SPI                            **
        ******************************************/
        call Spi.enable(BUS_STE | BUS_PHASE_INVERT, 1);

        /* reset radio with SPI */
        CC2420_RESET();
        
        /* turn on oscillator, enabling RAM access */
        CC2420_OSCILLATOR_ENABLE();

        /******************************************
        ** RAM related                           **
        ******************************************/

        /* read and add manufacture ID to IEEE */
        tmp = call HPLCC2420.read(CC_REG_MANFIDH);
        ieeeAddress[0] = tmp >> 8;
        tmp = call HPLCC2420.read(CC_REG_MANFIDL);
        ieeeAddress[1] = tmp >> 8;
        ieeeAddress[2] = tmp;

        /* Write IEEE adress to radio */
        CC2420_SET_IEEEADDR(ieeeAddress);
        
        /* Write lowest bits as default shortAdr */     
        shortAddress = ieeeAddress[6];
        shortAddress = (shortAddress << 8) + ieeeAddress[7];
        CC2420_SET_SHORTADDR(shortAddress);

        /* Write scan address in PAN ID */
        panid = shortAddress;
        CC2420_SET_PANID(panid);

        /* disable oscillator (ram access) */
        CC2420_OSCILLATOR_DISABLE();

        /* disable crystal */
        CRYSTAL_OSCILLATOR_DISABLE();

        radioOn = FALSE;
        rxEnabled = FALSE;

        /******************************************
        ** Register related                      **
        ******************************************/
        /* Set control registers */
        CC2420_CONTROL_SET();

        /* Set channel */
        CC2420_CHANNEL_SET(CC2420_DEFAULT_CHANNEL);

        /* Set transmitter power */
        CC2420_POWER_SET(CC2420_DEFAULT_POWER);

        /***********************************************
        ** Release bus
        ***********************************************/
        taskPosted[TASK_INIT] = FALSE;

debug_fsm();

        call Spi.disable();
        call BusArbitration.releaseBus();

    }

    /**********************************************************************
     * Start
     *********************************************************************/
    command error_t HALCC2420Control.start()
    {       

        if (!taskPosted[TASK_START]) {
            taskPosted[TASK_START] = TRUE;
            
            if (queueEmpty()) {
                post startTask();
            } else {
                queuePut(TASK_START);
            }

            return SUCCESS;
        } else {
            return FAIL;
        }
    }
    
    task void startTask()
    {
        /***********************************************
        ** Reserve SPI bus
        ***********************************************/
        if (call BusArbitration.getBus() != SUCCESS) {
            queuePut(TASK_START);
            return;
        }

        /* Turn on crystal */
        CRYSTAL_OSCILLATOR_ENABLE();

        /***********************************************
        ** select SPI bus, module 1 (micro4) and radio
        ***********************************************/
        call Spi.enable(BUS_STE | BUS_PHASE_INVERT, 1);
        TOSH_uwait(100);

debug_fsm();
        /* Turn on oscillator */
        CC2420_OSCILLATOR_ENABLE();
debug_fsm();

        /* Enable receiver */
        CC2420_RX_ENABLE();
debug_fsm();

        /* Enable interrupts */
        MCU_ENABLE_IRQ();

        radioOn = TRUE;
debug_fsm();

        /***********************************************
        ** Release bus
        ***********************************************/
        taskPosted[TASK_START] = FALSE;

        call Spi.disable();
        call BusArbitration.releaseBus();

        return;
    }

    /**********************************************************************
     * Stop
     *********************************************************************/
    command error_t HALCC2420Control.stop()
    {
        if (!taskPosted[TASK_STOP]) {
            taskPosted[TASK_STOP] = TRUE;
            
            if (queueEmpty()) {
                post stopTask();
            } else {
                queuePut(TASK_STOP);
            }

            return SUCCESS;
        } else {
            return FAIL;
        }
    }
    
    task void stopTask()
    {       
        /***********************************************
        ** Reserve SPI bus
        ***********************************************/
        if (call BusArbitration.getBus() != SUCCESS) {
            queuePut(TASK_STOP);
            return;
        }

        /***********************************************
        ** select SPI bus, module 1 (micro4) and radio
        ***********************************************/
        call Spi.enable(BUS_STE | BUS_PHASE_INVERT, 1);
        TOSH_uwait(100);

        /* Wait if radio is transmitting */
        CC2420_TX_WAIT();
        
        /* disable oscillator */
        CC2420_OSCILLATOR_DISABLE();

        /* Turn off crystal */
        CRYSTAL_OSCILLATOR_DISABLE();
        
        /* disable interrupts */
        MCU_DISABLE_IRQ();

        radioOn = FALSE;
        
        /***********************************************
        ** Release bus
        ***********************************************/
        taskPosted[TASK_STOP] = FALSE;

        call Spi.disable();
        call BusArbitration.releaseBus();

        return;
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

        if (!taskPosted[TASK_TRANSMIT]) {
            taskPosted[TASK_TRANSMIT] = TRUE;
            
            atomic transmitPacketPtr = packet;

            if (queueEmpty()) {
                post transmitTask();
            } else {
                queuePut(TASK_TRANSMIT);
            }

            return SUCCESS;
        } else {
            return FAIL;
        }

    }

    task void transmitTask()
    {
        bool oldRxEnabled;
        uint8_t i, status, counter;

        /***********************************************
        ** Reserve SPI bus
        ***********************************************/
        if (call BusArbitration.getBus() != SUCCESS) {
            queuePut(TASK_TRANSMIT);
            return;
        }

        /***********************************************
        ** select SPI bus and module 1 (micro4)
        ***********************************************/
        call Spi.enable(BUS_STE | BUS_PHASE_INVERT, 1);

debug_fsm();
        
        /***********************************************
        ** check if radio is on
        ***********************************************/
        if (!radioOn)
        {

            signal HALCC2420.sendPacketDone(transmitPacketPtr, CC2420_ERROR_RADIO_OFF);

            /***********************************************
            ** Release bus
            ***********************************************/
            taskPosted[TASK_TRANSMIT] = FALSE;

            call Spi.disable();
            call BusArbitration.releaseBus();

            return;
        }

        /***********************************************
        ** check if channel is clear 
        ***********************************************/
        /* if radio is not in receive mode, turn on receiver to gather RSSI */
        oldRxEnabled = rxEnabled;
        
        if (!rxEnabled)
        {
            /* turn on receiver */
            // call HPLCC2420.cmd(CC_REG_SRXON);
            CC2420_RX_ENABLE();
        }

        /* check if RSSI is valid */
        status = call HPLCC2420.cmd(CC_REG_SNOP);
        if (!(status & CC2420_RSSI_VALID)) {

            /* wait 8 symbol periods (128 us) */
            TOSH_uwait(128);
        }
debug_fsm();

        /* check if channel is clear */
        if (!call HPLCC2420Status.CCA()) {

            /* restore previous state before returning call */
            if (!oldRxEnabled)
            {
                /* turn off receiver */
                // call HPLCC2420.cmd(CC_REG_SRFOFF);
                CC2420_RX_DISABLE();
            }
                
            signal HALCC2420.sendPacketDone(transmitPacketPtr, CC2420_ERROR_CCA);

            /***********************************************
            ** Release bus
            ***********************************************/
            taskPosted[TASK_TRANSMIT] = FALSE;

            call Spi.disable();
            call BusArbitration.releaseBus();

            return;
        }

debug_fsm();

        /***********************************************
        ** Clear to send packet
        ***********************************************/

        /* put packet in transmit buffer */
        call HPLCC2420.cmd(CC_REG_SFLUSHTX);
debug_fsm();
        call HPLCC2420FIFO.writeTXFIFO(transmitPacketPtr[0], transmitPacketPtr);
debug_fsm();
        

        /* Wait for it to send the packet */
        i= 0;
        while (i++ < 3) {

debug_fsm();
            call HPLCC2420.cmd(CC_REG_STXONCCA);
            counter = 0;    
            do {
                status = call HPLCC2420.cmd(CC_REG_SNOP);
                status = call HPLCC2420.cmd(CC_REG_SNOP);
            }while ( !(status & CC2420_TX_ACTIVE)  && (counter++ < 200));
debug_fsm();
            if (status & CC2420_TX_ACTIVE) 
                break;
        }

        /***********************************************
        ** Check if packet is being transmitted
        ***********************************************/    
        if (!(status & CC2420_TX_ACTIVE))   {

            /* flush transmit buffer */
            call HPLCC2420.cmd(CC_REG_SFLUSHTX);

            signal HALCC2420.sendPacketDone(transmitPacketPtr, CC2420_ERROR_TX);

            /***********************************************
            ** Release bus
            ***********************************************/
            taskPosted[TASK_TRANSMIT] = FALSE;

            call Spi.disable();
            call BusArbitration.releaseBus();

            return;
        }

        atomic transmitInProgress = TRUE;

        /***********************************************
        ** Release bus
        ***********************************************/
        taskPosted[TASK_TRANSMIT] = FALSE;

        call Spi.disable();
        call BusArbitration.releaseBus();

        return;
    }

    /**********************************************************************
     * setChannel
     *********************************************************************/
    uint8_t currentChannel;
    
    command error_t HALCC2420.setChannel(uint8_t channel) 
    {

        if ( (channel < 11) || (channel > 26) ) 
            return FAIL;
        else {
            currentChannel = channel;

            if (!taskPosted[TASK_SET_CHANNEL]) {
                taskPosted[TASK_SET_CHANNEL] = TRUE;

                if (queueEmpty()) {
                    post setChannelTask();
                } else {
                    queuePut(TASK_SET_CHANNEL);
                }

                return SUCCESS;
            } else {
                return FAIL;
            }
        }

        return SUCCESS;
    }
    
    task void setChannelTask()
    {
        /***********************************************
        ** Reserve SPI bus
        ***********************************************/
        if (call BusArbitration.getBus() != SUCCESS) {
            queuePut(TASK_SET_CHANNEL);
            return;
        }

        /***********************************************
        ** select SPI bus and module 1 (micro4)
        ***********************************************/
        call Spi.enable(BUS_STE | BUS_PHASE_INVERT, 1);
        TOSH_uwait(100);

        /* Wait if radio is transmitting */
        CC2420_TX_WAIT();

        if (rxEnabled) 
        {
            CC2420_RX_DISABLE();

            /* set channel */
            CC2420_CHANNEL_SET(currentChannel);

            CC2420_RX_ENABLE();
        } else
            /* set channel */
            CC2420_CHANNEL_SET(currentChannel);

        /***********************************************
        ** Release bus
        ***********************************************/
        taskPosted[TASK_SET_CHANNEL] = FALSE;

        call Spi.disable();
        call BusArbitration.releaseBus();
    }
    
    /**********************************************************************
     * setTransmitPower
     *********************************************************************/
    uint8_t currentPower;
    
    command error_t HALCC2420.setTransmitPower(uint8_t power)
    {
        if (power > 100) 
            return FAIL;
        else {
            currentPower = power;

            if (!taskPosted[TASK_SET_POWER]) {
                taskPosted[TASK_SET_POWER] = TRUE;

                if (queueEmpty()) {
                    post setTransmitPowerTask();
                } else {
                    queuePut(TASK_SET_POWER);
                }

                return SUCCESS;
            } else {
                return FAIL;
            }
        }
    }
    
    task void setTransmitPowerTask()
    {
        /***********************************************
        ** Reserve SPI bus
        ***********************************************/
        if (call BusArbitration.getBus() != SUCCESS) {
            queuePut(TASK_SET_POWER);
            return;
        }

        /***********************************************
        ** select SPI bus and module 1 (micro4)
        ***********************************************/
        call Spi.enable(BUS_STE | BUS_PHASE_INVERT, 1);

        /* set power output */
        CC2420_POWER_SET(currentPower);

        /***********************************************
        ** Release bus
        ***********************************************/
        taskPosted[TASK_SET_POWER] = FALSE;

        call Spi.disable();
        call BusArbitration.releaseBus();
    }

    /**********************************************************************
     * rxEnable
     *********************************************************************/
    command error_t HALCC2420.rxEnable()
    {
        /* ignore call if radio is already on */
        if (!rxEnabled) 
        {
            if (!taskPosted[TASK_RX_ENABLE]) {
                taskPosted[TASK_RX_ENABLE] = TRUE;

                if (queueEmpty()) {
                    post rxEnableTask();
                } else {
                    queuePut(TASK_RX_ENABLE);
                }

                return SUCCESS;
            } else {
                return FAIL;
            }
        } else
            return FAIL;
    }
    
    task void rxEnableTask()
    {
        /***********************************************
        ** Reserve SPI bus
        ***********************************************/
        if (call BusArbitration.getBus() != SUCCESS) {
            queuePut(TASK_RX_ENABLE);
            return;
        }

        /***********************************************
        ** select SPI bus and module 1 (micro4)
        ***********************************************/
        call Spi.enable(BUS_STE | BUS_PHASE_INVERT, 1);

        /* turn on receiver */
        CC2420_RX_ENABLE();

        /***********************************************
        ** Release bus
        ***********************************************/
        taskPosted[TASK_RX_ENABLE] = FALSE;

        call Spi.disable();
        call BusArbitration.releaseBus();
    }

    /**********************************************************************
     * rxDisable
     *********************************************************************/
    command error_t HALCC2420.rxDisable()
    {
        /* ignore call if radio is already off */
        if (rxEnabled) 
        {
            if (!taskPosted[TASK_RX_DISABLE]) {
                taskPosted[TASK_RX_DISABLE] = TRUE;

                if (queueEmpty()) {
                    post rxDisableTask();
                } else {
                    queuePut(TASK_RX_DISABLE);
                }

                return SUCCESS;
            } else {
                return FAIL;
            }
        } else
            return FAIL;
    }

    task void rxDisableTask()
    {
        /***********************************************
        ** Reserve SPI bus
        ***********************************************/
        if (call BusArbitration.getBus() != SUCCESS) {
            queuePut(TASK_RX_DISABLE);
            return;
        }

        /***********************************************
        ** select SPI bus and module 1 (micro4)
        ***********************************************/
        call Spi.enable(BUS_STE | BUS_PHASE_INVERT, 1);

        /* turn off receiver */
        CC2420_RX_DISABLE();

        /***********************************************
        ** Release bus
        ***********************************************/
        taskPosted[TASK_RX_DISABLE] = FALSE;

        call Spi.disable();
        call BusArbitration.releaseBus();
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

        if (!taskPosted[TASK_SET_SHORT]) {
            taskPosted[TASK_SET_SHORT] = TRUE;

            if (queueEmpty()) {
                post setShortAddressTask();
            } else {
                queuePut(TASK_SET_SHORT);
            }

            return SUCCESS;
        } else {
            return FAIL;
        }
    }
    
    task void setShortAddressTask() 
    {
        /***********************************************
        ** Reserve SPI bus
        ***********************************************/
        if (call BusArbitration.getBus() != SUCCESS) {
            queuePut(TASK_SET_SHORT);
            return;
        }

        /***********************************************
        ** select SPI bus and module 1 (micro4)
        ***********************************************/
        call Spi.enable(BUS_STE | BUS_PHASE_INVERT, 1);
        TOSH_uwait(100);

        CC2420_SET_SHORTADDR(shortAddress);
        
        /***********************************************
        ** Release bus
        ***********************************************/
        taskPosted[TASK_SET_SHORT] = FALSE;

        call Spi.disable();
        call BusArbitration.releaseBus();
    }

    /**********************************************************************
     * getShortAddress
     *********************************************************************/
    command const mac_addr_t * HALCC2420.getAddress()
    {
        return &shortAddress;
    }
    
    task void getShortAddressTask() 
    {
        if (call BusArbitration.getBus() != SUCCESS) return;
        call Spi.enable(BUS_STE | BUS_PHASE_INVERT, 1);
        
        call HPLCC2420RAM.read(CC_ADDR_SHORTADDR, 2, (uint8_t *) &shortAddress);

        call Spi.disable();
        call BusArbitration.releaseBus();
    }

    /**********************************************************************
     * setPANAddress
     *********************************************************************/
    command error_t HALCC2420.setPanAddress(mac_addr_t *addr)
    {
        panid = *addr;

        if (!taskPosted[TASK_SET_PANID]) {
            taskPosted[TASK_SET_PANID] = TRUE;

            if (queueEmpty()) {
                post setPanAddressTask();
            } else {
                queuePut(TASK_SET_PANID);
            }

            return SUCCESS;
        } else {
            return FAIL;
        }
    }
    
    task void setPanAddressTask() 
    {
        /***********************************************
        ** Reserve SPI bus
        ***********************************************/
        if (call BusArbitration.getBus() != SUCCESS) {
            queuePut(TASK_SET_PANID);
            return;
        }

        /***********************************************
        ** select SPI bus and module 1 (micro4)
        ***********************************************/
        call Spi.enable(BUS_STE | BUS_PHASE_INVERT, 1);
        TOSH_uwait(100);

        CC2420_SET_PANID(panid);
        
        /***********************************************
        ** Release bus
        ***********************************************/
        taskPosted[TASK_SET_PANID] = FALSE;

        call Spi.disable();
        call BusArbitration.releaseBus();
    }

    /**********************************************************************
     * getShortAddress
     *********************************************************************/
    command const mac_addr_t * HALCC2420.getPanAddress()
    {
        return &panid;
    }
    
    task void getPanAddressTask() 
    {
        if (call BusArbitration.getBus() != SUCCESS) return;
        call Spi.enable(BUS_STE | BUS_PHASE_INVERT, 1);
        
        call HPLCC2420RAM.read(CC_ADDR_PANID, 2, (uint8_t *) &panid);

        call Spi.disable();
        call BusArbitration.releaseBus();
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
        if (!taskPosted[TASK_ADDR_ENABLE]) {
            taskPosted[TASK_ADDR_ENABLE] = TRUE;

            if (queueEmpty()) {
                post addressEnableTask();
            } else {
                queuePut(TASK_ADDR_ENABLE);
            }

            return SUCCESS;
        } else {
            return FAIL;
        }
    }
    
    task void addressEnableTask() 
    {
        /***********************************************
        ** Reserve SPI bus
        ***********************************************/
        if (call BusArbitration.getBus() != SUCCESS) {
            queuePut(TASK_ADDR_ENABLE);
            return;
        }

        /***********************************************
        ** select SPI bus and module 1 (micro4)
        ***********************************************/
        call Spi.enable(BUS_STE | BUS_PHASE_INVERT, 1);

        mcr0Ptr->adr_decode = TRUE;

        call HPLCC2420.write(CC_REG_MDMCTRL0, mcr0); 

        /***********************************************
        ** Release bus
        ***********************************************/
        taskPosted[TASK_ADDR_ENABLE] = FALSE;

        call Spi.disable();
        call BusArbitration.releaseBus();
    }

    command error_t HALCC2420.addressFilterDisable()
    {
        if (!taskPosted[TASK_ADDR_DISABLE]) {
            taskPosted[TASK_ADDR_DISABLE] = TRUE;

            if (queueEmpty()) {
                post addressDisableTask();
            } else {
                queuePut(TASK_ADDR_DISABLE);
            }

            return SUCCESS;
        } else {
            return FAIL;
        }
    }

    task void addressDisableTask() 
    {
        /***********************************************
        ** Reserve SPI bus
        ***********************************************/
        if (call BusArbitration.getBus() != SUCCESS) {
            queuePut(TASK_ADDR_DISABLE);
            return;
        }

        /***********************************************
        ** select SPI bus and module 1 (micro4)
        ***********************************************/
        call Spi.enable(BUS_STE | BUS_PHASE_INVERT, 1);

        mcr0Ptr->adr_decode = FALSE;

        call HPLCC2420.write(CC_REG_MDMCTRL0, mcr0); 

        /***********************************************
        ** Release bus
        ***********************************************/
        taskPosted[TASK_ADDR_DISABLE] = FALSE;

        call Spi.disable();
        call BusArbitration.releaseBus();
    }

    
    void CC2420_SET_PANID(uint16_t id)
    {
        uint16_t tmp;
    
        /* reverse bit order - CC2420 not following IEEE address standard */
        tmp = id;
        tmp = (tmp << 8) + (id >> 8);

        call HPLCC2420RAM.write(CC_ADDR_PANID, 2, (uint8_t *) &id);
    }

    void CC2420_SET_SHORTADDR(uint16_t shortAddr)
    {
        uint16_t tmp;
    
        /* reverse bit order - CC2420 not following IEEE address standard */
        tmp = shortAddr;
        tmp = (tmp << 8) + (shortAddr >> 8);

        call HPLCC2420RAM.write(CC_ADDR_SHORTADDR, 2, (uint8_t *) &tmp);
    }

    void CC2420_SET_IEEEADDR(ieee_mac_addr_t extAddress)
    {
        ieee_mac_addr_t buffer;

        /* reverse bit order - CC2420 not following IEEE address standard */
        buffer[0] = extAddress[7];
        buffer[1] = extAddress[6];
        buffer[2] = extAddress[5];
        buffer[3] = extAddress[4];
        buffer[4] = extAddress[3];
        buffer[5] = extAddress[2];
        buffer[6] = extAddress[1];
        buffer[7] = extAddress[0];

        call HPLCC2420RAM.write(CC_ADDR_IEEEADDR, 8, buffer);
    }

/*************************************************************************************************
*** Interrupt handler
**************************************************************************************************/

    /**********************************************************************
     * MSP430Interrupt
     *********************************************************************/
    task void receivedPacketTask();
    task void flushBufferTask();
    bool receivedPacketTaskPosted = FALSE, flushBufferTaskPosted = FALSE; 
    uint8_t framesInFifo = 0;

    async event void MSP430Interrupt.fired()
    {

        if (transmitInProgress) {
            transmitInProgress = FALSE;

            signal HALCC2420.sendPacketDone(transmitPacketPtr, SUCCESS);
        } else if (call HPLCC2420Status.FIFOP() && !call HPLCC2420Status.FIFO()) {

//            call StdOut.print("MAC: buffer overrun\r\n");

            /* buffer overrun detected      *
             * if no receivedPacketTask is posted,  *
             * then flush buffer            *
             * else flag buffer to be flushed   */   
            if (!receivedPacketTaskPosted && !flushBufferTaskPosted) {

                post flushBufferTask();
            }

            flushBufferTaskPosted = TRUE;

        } else if (call HPLCC2420Status.FIFOP() && call HPLCC2420Status.FIFO()) {


            /* frame received */
            if (!receivedPacketTaskPosted) {

                receivedPacketTaskPosted = TRUE;
                post receivedPacketTask();
            } 

            framesInFifo++;
            
        } else {
        
            if (flushBufferTaskPosted) {
//                call StdOut.print("RX buffer flushed\r\n");
            } else {

            }
        }

    }

    task void flushBufferTask() 
    {
        /***********************************************
        ** Reserve SPI bus
        ***********************************************/
        if (call BusArbitration.getBus() != SUCCESS) {

            post flushBufferTask();
            return;
        }

        /***********************************************
        ** select SPI bus and module 1 (micro4)
        ***********************************************/
        call Spi.enable(BUS_STE | BUS_PHASE_INVERT, 1);

        if (rxEnabled) 
        {
            /* turn off receiver */
            CC2420_RX_DISABLE();

            /* flush buffer */
            call HPLCC2420.cmd(CC_REG_SFLUSHRX);
            call HPLCC2420.cmd(CC_REG_SFLUSHRX);

            /* enable receiver */
            CC2420_RX_ENABLE();
        } else
        {
            /* flush buffer */
            call HPLCC2420.cmd(CC_REG_SFLUSHRX);
            call HPLCC2420.cmd(CC_REG_SFLUSHRX);
        }

        atomic flushBufferTaskPosted = FALSE;

        /***********************************************
        ** Release bus
        ***********************************************/
        call Spi.disable();
        call BusArbitration.releaseBus();

    }

    task void receivedPacketTask()
    {
        uint8_t length, correlation;
    
        /***********************************************
        ** Reserve SPI bus
        ***********************************************/
        if (call BusArbitration.getBus() != SUCCESS) {

            post receivedPacketTask();
            return;
        }

        /***********************************************
        ** select SPI bus and module 1 (micro4)
        ***********************************************/
        call Spi.enable(BUS_STE | BUS_PHASE_INVERT, 1);

        /* read frame from receive buffer */
        call HPLCC2420FIFO.readRXFIFO(128, receivedPacketPtr);

        /***********************************************
        ** Release bus
        ***********************************************/
        call Spi.disable();
        call BusArbitration.releaseBus();

        /***********************************************
        ** Process this frame
        ***********************************************/
        /* read length and CORRELATION */
        length = receivedPacketPtr[0];
        correlation = receivedPacketPtr[length];
        
        /* filter corrupt packets */        
        if (correlation & FCS_CRC_OK_MASK) 
        {
            receivedPacketPtr = signal HALCC2420.receivedPacket(receivedPacketPtr);
        }

        /***********************************************
        ** Check if other frames are available
        ***********************************************/
        atomic {
            framesInFifo--;
        
            if (framesInFifo > 0) 
            {
                post receivedPacketTask();
            } else 
            {
                receivedPacketTaskPosted = FALSE;

                /* check if buffer has overrun while processing frame   */
                /* and post flushBufferTask if it has           */
                if (flushBufferTaskPosted) 
                {
                    post flushBufferTask();
                }
            }
        }
    }


/*************************************************************************************************
*** Internal utility functions
**************************************************************************************************/
    /**********************************************************************
    **
    ** Internal CC2420 utility functions
    **
    **********************************************************************/

    void CC2420_RESET()
    {
        /* Reset CC2420 using SPI*/
        call HPLCC2420.write(CC_REG_MAIN, 0x0000);
        call HPLCC2420.write(CC_REG_MAIN, 0xF801);  /*bit 1 activates external clock*/

        TOSH_uwait(2 * 1024);
    }

    /********************
    ********************/
    bool CC2420_OSCILLATOR_ENABLE()
    {
        uint8_t i = 0, status = 0;

        /* Turn oscillator on */
        call HPLCC2420.cmd(CC_REG_SXOSCON); 
        TOSH_uwait(1024);

        /* Wait until oscillator is stable */
        do 
        {
            /* Read status register */
            status = CC2420_READ_STATUS();
            TOSH_uwait(128);

        } while ( !(status & CC2420_XOSC16M_STABLE) && (i++ < 160));


        if (i >= 160) {
            return FALSE;
        } else {
            return TRUE;
        }
    }

    /********************
    **
    ********************/
    void CC2420_RX_ENABLE()
    {
        /* Enable receiver */
        call HPLCC2420.cmd(CC_REG_SRXON);
        call HPLCC2420.cmd(CC_REG_SFLUSHRX);

        rxEnabled = TRUE;
    }

    /********************
    **
    ********************/
    void CC2420_RX_DISABLE()
    {
        call HPLCC2420.cmd(CC_REG_SRFOFF);

        rxEnabled = FALSE;
    }

    /********************
    **
    ********************/
    int8_t CC2420_CHANNEL_SET(uint8_t channel)
    {
        uint16_t freq;
        
        /* Channel values: 11-26 */
        freq = (uint16_t) channel - 11;
        freq *= 5;  /*channel spacing*/
        freq += 357; /*correct channel range*/
        freq |= 0x4000; /*LOCK_THR = 1*/

        call HPLCC2420.write(CC_REG_FSCTRL, freq);
    
        return (int8_t) channel;
    }

    /********************
    **
    ********************/
    int8_t CC2420_POWER_SET(uint8_t new_power)
    {
        uint16_t power;
        
        power = 31 * new_power;
        power /= 100;
        power += 0xA0E0;
        
        /* Set transmitter power */
        call HPLCC2420.write(CC_REG_TXCTRL, power);

        return new_power;
    }

    void CC2420_CONTROL_SET()
    {
        /***********************************************
        ** Set the correlation threshold = 20          
        ** Turn off "Security enable"
        ** Set the FIFOP threshold to maximum
        ***********************************************/
        call HPLCC2420.write(CC_REG_MDMCTRL0, mcr0); 
        call HPLCC2420.write(CC_REG_IOCFG0, iocfg0);   
        call HPLCC2420.write(CC_REG_MDMCTRL1, 0x0500); 
        call HPLCC2420.write(CC_REG_SECCTRL0, 0x01C4); 
        
        return;
    }

    void CC2420_TX_WAIT()
    {
        uint8_t i = 0, status;

        /***********************************************
        ** Wait if radio is transmitting
        ***********************************************/
        status = call HPLCC2420.cmd(CC_REG_SNOP);
        
        while ( (status & CC2420_TX_ACTIVE) && (i < 50) ) 
        {
            TOSH_uwait(100);
            status = call HPLCC2420.cmd(CC_REG_SNOP);
            i++;
        } 
        
        return;
    }

/*************************************************************************************************
*** Event stubs
**************************************************************************************************/

    /**********************************************************************
     * CC2420FIFO
     *********************************************************************/
    async event error_t HPLCC2420FIFO.TXFIFODone(uint8_t length, uint8_t *data)
    {
        return SUCCESS;
    }

    async event error_t HPLCC2420FIFO.RXFIFODone(uint8_t length, uint8_t *data)
    {
        return SUCCESS;
    }

    /**********************************************************************
     * CC2420RAM
     *********************************************************************/
    async event error_t HPLCC2420RAM.writeDone(uint16_t addr, uint8_t length, uint8_t* buf)
    {
        return SUCCESS;
    }

    async event error_t HPLCC2420RAM.readDone(uint16_t addr, uint8_t length, uint8_t* buf)
    {
        return SUCCESS;
    }

    /**********************************************************************
     * StdOut
     *********************************************************************/
    async event void StdOut.get(uint8_t data)
    {

    }
    
}
