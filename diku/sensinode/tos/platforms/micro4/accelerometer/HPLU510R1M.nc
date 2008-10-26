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




module HPLU510R1M {
    provides {
        interface ThreeAxisAccel;
    }

    uses {
        interface Timer<TMilli>;
        interface Spi;
        interface BusArbitration;
        interface StdOut;
        interface LocalTime<TMicro>;
    }
}

implementation {

#include "HPLSpi.h"

#define CYPRESS_STARTUP_TIME 9
#define CYPRESS_SPI_ENABLE 300
#define CYPRESS_SPI_INTERVAL 100
#define CYPRESS_SPI_STATUS 500

    bool sensorQueue = FALSE, startQueue = FALSE, setRangeQueue = FALSE;

    int16_t x = 0, y = 0, z = 0;
    uint8_t status = 0, range = 0;
    
    task void startTask();
    task void sensorTask();
    task void signalTask();
    task void setRangeTask();

    /**********************************************************************
    ** BusArbitration
    **********************************************************************/
    event error_t BusArbitration.busFree()
    {
        if (startQueue) {
            startQueue = FALSE;
            
            post startTask();
        }

        if (sensorQueue) {
            sensorQueue = FALSE;
            
            post sensorTask();
        }

        if (setRangeQueue) {
            setRangeQueue = FALSE;
            
            post setRangeTask();
        }

        return SUCCESS;
    }


    /**********************************************************************
    ** Timer
    **********************************************************************/
    event void Timer.fired()
    {
        post sensorTask();
    }

    /**********************************************************************
    ** ThreeAxisAccel
    **********************************************************************/
    command error_t ThreeAxisAccel.getData() 
    {
        post startTask();

        return SUCCESS;
    }

    task void startTask()
    {       
        if (call BusArbitration.getBus() == FAIL) {
            startQueue = TRUE;
            return;
        }

        /***********************************************
        ** select SPI bus and module 3 (U510R1)
        ***********************************************/
        call Spi.enable(BUS_CLOCK_115kHZ, 3);
        TOSH_uwait(CYPRESS_SPI_ENABLE);

        /* turn on PSoC */
        call Spi.write(0xA3);
        TOSH_uwait(CYPRESS_SPI_INTERVAL);

        /* begin conversion */
        call Spi.write(0xA3);
        TOSH_uwait(CYPRESS_SPI_INTERVAL);
            
        call Spi.disable();
        call BusArbitration.releaseBus();
        
        call Timer.startOneShot(CYPRESS_STARTUP_TIME);
    }

    task void sensorTask()
    {
        uint8_t byte = 0; 
        uint16_t i = 0;

        status = ACCEL_STATUS_CONVERSION_FAILED;

//      uint32_t t0 = 0, t1 = 0, t2 = 0, t3 = 0;

        if (call BusArbitration.getBus() == FAIL) 
        {
            sensorQueue = TRUE;
            return;
        }

        /***********************************************
        ** select SPI bus and module 3 (U510R1)
        ***********************************************/
        call Spi.enable(BUS_CLOCK_115kHZ, 3);
        TOSH_uwait(CYPRESS_SPI_ENABLE);

        /***********************************************
        ** Read Accelerometer
        ***********************************************/

//      call Spi.write(0xA1);
//      TOSH_uwait(CYPRESS_SPI_STARTUP);

//t0 = call LocalTime.read();

        /* wait until status is 0x70, ie. conversion complete */
        do {
            byte = call Spi.write(0x00);
            TOSH_uwait(CYPRESS_SPI_STATUS);
        } while ( ((byte & 0x70) != 0x70) && (i++ < 50));

//t1 = call LocalTime.read();

        /* only read value if conversion was successful */      
        if ((byte & 0x70) == 0x70)
        {
            /* begin block mode readout and wait until ready */
            byte = call Spi.write(0xAE);
            TOSH_uwait(CYPRESS_SPI_INTERVAL);

//t2 = call LocalTime.read();

//          i = 0;
//            while ( byte != 0xB8 && i++ < 50) {
                byte = call Spi.write(0x00);
                TOSH_uwait(CYPRESS_SPI_STATUS);
//            }

//t3 = call LocalTime.read();

            /* block mode ready */
//            if (byte == 0xB8)
            {
                /* read xyz-acceleration as signed 12bit int */
                x = call Spi.write(0x00);
                TOSH_uwait(CYPRESS_SPI_INTERVAL);
                x <<= 8;
                x += call Spi.write(0x00);
                TOSH_uwait(CYPRESS_SPI_INTERVAL);

                y = call Spi.write(0x00);
                TOSH_uwait(CYPRESS_SPI_INTERVAL);
                y <<= 8;
                y += call Spi.write(0x00);
                TOSH_uwait(CYPRESS_SPI_INTERVAL);

                z = call Spi.write(0x00);
                TOSH_uwait(CYPRESS_SPI_INTERVAL);
                z <<= 8;
                z += call Spi.write(0x00);
                TOSH_uwait(CYPRESS_SPI_INTERVAL);
                
                status = ACCEL_STATUS_SUCCESS;
            }
//            else { status = ACCEL_STATUS_BLOCKMODE_FAILED; }
        }

        /* shut down accelerometer board */     
        call Spi.write(0xA0);
        TOSH_uwait(CYPRESS_SPI_INTERVAL);

        call Spi.disable();
        call BusArbitration.releaseBus();

//      call StdOut.printBase10uint32(t1-t0);
//      call StdOut.print(" ");
//      call StdOut.printBase10uint32(t3-t2);
//      call StdOut.print(" ");

        post signalTask();
    }

    task void signalTask()
    {
        uint16_t ux, uy, uz;

        /* convert signed 12-bit to unsigned 12-bit */      
        ux = (uint16_t) (x + 0x0800);
        uy = (uint16_t) (y + 0x0800);
        uz = (uint16_t) (z + 0x0800);

        /* check if value indeed is 12-bit */
        if ( ((0xF000 & ux) != 0) || ((0xF000 & uy) != 0) || ((0xF000 & uz) != 0) )
            status |= ACCEL_STATUS_OUT_OF_BOUNCE;
        
        /* return acceleration value and status */
        signal ThreeAxisAccel.dataReady(ux, uy, uz, status);
    }

    /**************************************************************************/
    command error_t ThreeAxisAccel.setRange(uint8_t new_range)
    {
        range = new_range;
        
        post setRangeTask();
        
        return SUCCESS;
    }

    task void setRangeTask()
    {
        if (call BusArbitration.getBus() == FAIL) 
        {
            setRangeQueue = TRUE;
            return;
        }

        /***********************************************
        ** select SPI bus and module 3 (U510R1)
        ***********************************************/
        call Spi.enable(BUS_CLOCK_115kHZ, 3);
        TOSH_uwait(CYPRESS_SPI_ENABLE);

//      call Spi.write(0xA1);
//      TOSH_uwait(CYPRESS_SPI_INTERVAL);

        call Spi.write(0xB0 | (range & 0x03) );
        TOSH_uwait(CYPRESS_SPI_INTERVAL);

//      call Spi.write(0xA0);

        call Spi.disable();
        call BusArbitration.releaseBus();
    }

    /**********************************************************************
    ** StdOut
    **********************************************************************/
    async event void StdOut.get(uint8_t data) {

    }

}
