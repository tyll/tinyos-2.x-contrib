
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
 * Log recording layer
 *
 * @author Marcus Chang <marcus@diku.dk>
 * @author Martin Leopold <leopold@diku.dk>
 */


module SimpleMacLoggerP {
    provides interface StdControl as SimpleMacControlLogger;
    provides interface SimpleMac as SimpleMacLogger;
    uses interface StdControl as SimpleMacControl;
    uses interface SimpleMac;    
    uses interface GeneralIO as SendIO;
    uses interface GeneralIO as ReceiveIO;

}

implementation {

    /**********************************************************************
     *********************************************************************/
    command error_t SimpleMacControlLogger.start()
    {       
        call ReceiveIO.set();

        return call SimpleMacControl.start();   
    }
    
    command error_t SimpleMacControlLogger.stop()
    {       
        call ReceiveIO.clr();

        return call SimpleMacControl.stop();
    }


    /**********************************************************************
     *********************************************************************/
    command error_t SimpleMacLogger.sendPacket(packet_t * packet) 
    {
        call ReceiveIO.clr();
        call SendIO.set();

        return call SimpleMac.sendPacket(packet);
    }

    event void SimpleMac.sendPacketDone(packet_t * packet, error_t result)
    {
        call SendIO.clr();
        call ReceiveIO.set();

        signal SimpleMacLogger.sendPacketDone(packet, result);
    }

    event packet_t * SimpleMac.receivedPacket(packet_t * packet)
    {
        return signal SimpleMacLogger.receivedPacket(packet);
    }
    
    /**********************************************************************
     *********************************************************************/
    command error_t SimpleMacLogger.setChannel(uint8_t channel) 
    {
        return call SimpleMac.setChannel(channel);
    }
    
    command error_t SimpleMacLogger.setTransmitPower(uint8_t power)
    {
        return call SimpleMac.setTransmitPower(power);
    }
    

    /**********************************************************************
     *********************************************************************/
    command error_t SimpleMacLogger.rxEnable()
    {
        call ReceiveIO.set();

        return call SimpleMac.rxEnable();
    }
    
    command error_t SimpleMacLogger.rxDisable()
    {
        call ReceiveIO.clr();

        return call SimpleMac.rxDisable();
    }


    /**********************************************************************
     *********************************************************************/
    command error_t SimpleMacLogger.setAddress(mac_addr_t *addr)
    {
        return call SimpleMac.setAddress(addr);
    }
    
    command const mac_addr_t * SimpleMacLogger.getAddress()
    {
        return call SimpleMac.getAddress();
    }
    
    command error_t SimpleMacLogger.setPanAddress(mac_addr_t *addr)
    {
        return call SimpleMac.setPanAddress(addr);
    }
    
    command const mac_addr_t * SimpleMacLogger.getPanAddress()
    {
        return call SimpleMac.getPanAddress();
    }
    
    command const ieee_mac_addr_t * SimpleMacLogger.getExtAddress()
    {
        return call SimpleMac.getExtAddress();
    }

    /**********************************************************************
     *********************************************************************/
    command error_t SimpleMacLogger.addressFilterEnable()
    {
        return call SimpleMac.addressFilterEnable();
    }
    
    command error_t SimpleMacLogger.addressFilterDisable()
    {
        return call SimpleMac.addressFilterDisable();
    }


}
