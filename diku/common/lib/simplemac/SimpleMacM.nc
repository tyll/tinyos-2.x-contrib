/*
  Copyright (C) 2004 Klaus S. Madsen <klaussm@diku.dk>
  Copyright (C) 2006 Marcus Chang <marcus@diku.dk>

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/


module SimpleMacM {
	provides {
		interface SimpleMac;
        interface Init;
		interface StdControl as SimpleMacControl;
	}
	uses {
		interface HALCC2420;
        interface StdControl as HALCC2420Control;
 		interface StdOut;
	}
}

implementation {

	packet_t receivedPacket;
	packet_t * receivedPacketPtr;
	
	const mac_addr_t * shortAddress;

/*************************************************************************************************
*** StdControl
**************************************************************************************************/

	task void initTask();
	/**********************************************************************
	 * Init
	 *********************************************************************/
	command error_t Init.init() 
	{
		post initTask();
		receivedPacketPtr = &receivedPacket;
	
		return SUCCESS;
	}

	task void initTask()
	{
		shortAddress = call HALCC2420.getAddress();
	}

	/**********************************************************************
	 * Start/Stop
	 *********************************************************************/
	command error_t SimpleMacControl.start()
	{		
		return call HALCC2420Control.start();	
	}
	
	command error_t SimpleMacControl.stop()
	{		
		return call HALCC2420Control.stop();
	}


/*************************************************************************************************
*** Transmit related
**************************************************************************************************/
	/**********************************************************************
	 * sendPacket
	 *********************************************************************/
	uint8_t transmitbuffer[128];
	packet_t * sendPacketPtr;
	
	command error_t SimpleMac.sendPacket(packet_t * packet) 
	{
		uint8_t i, length;

		atomic sendPacketPtr = packet;

		/* Repack from packet_t to uint8_t array */		
		length = packet->length;

		transmitbuffer[0] = length;
		
		/* use beacon packets to circumvent 802.15.4 addressing */
		/* set bit 0-2 low in FCF to indicate beacon packet     */
		/* the last 13 bits can be used at leisure              */
		transmitbuffer[1] = (packet->fcf & 0x00F8); // set bit 0-2 low to indicate beacon packet
		transmitbuffer[2] = (packet->fcf >> 8);
		
		transmitbuffer[3] = packet->data_seq_no;

		transmitbuffer[4] = (packet->dest & 0x00FF);
		transmitbuffer[5] = (packet->dest >> 8);

		transmitbuffer[6] = *shortAddress & 0x00FF; // (transmitPacketPtr->src & 0x00FF);
		transmitbuffer[7] = *shortAddress >> 8; // (transmitPacketPtr->src >> 8);

		for (i = 8; i < length - 1; i++) 
		{
			transmitbuffer[i] = packet->data[i - 8];
		}
		
		transmitbuffer[length - 1] = 0; // transmitPacketPtr->fcs.rssi;
		transmitbuffer[length] = 0; // transmitPacketPtr->fcs.correlation;

		return call HALCC2420.sendPacket(transmitbuffer);
	}

	error_t sendPacketResult;
	
	task void signalSendPacketDone()
	{
		error_t tmp;
		
		atomic tmp = sendPacketResult;
		
		signal SimpleMac.sendPacketDone(sendPacketPtr, tmp);
	}

	async event void HALCC2420.sendPacketDone(uint8_t * packet, error_t result)
	{
		atomic sendPacketResult = result;

		post signalSendPacketDone();
	}

	/**********************************************************************
	 * setChannel
	 *********************************************************************/
	command error_t SimpleMac.setChannel(uint8_t channel) 
	{
		return call HALCC2420.setChannel(channel);
	}
	
	
	/**********************************************************************
	 * setTransmitPower
	 *********************************************************************/
	command error_t SimpleMac.setTransmitPower(uint8_t power)
	{
		return call HALCC2420.setTransmitPower(power);
	}
	

	/**********************************************************************
	 * rxEnable
	 *********************************************************************/
	command error_t SimpleMac.rxEnable()
	{
		return call HALCC2420.rxEnable();
	}
	

	/**********************************************************************
	 * rxDisable
	 *********************************************************************/
	command error_t SimpleMac.rxDisable()
	{
		return call HALCC2420.rxDisable();
	}

/*************************************************************************************************
*** Receive related
**************************************************************************************************/
	event uint8_t * HALCC2420.receivedPacket(uint8_t * packet)
	{
		uint8_t length, i;
		uint16_t tmp;

		/* Repack from uint8_t array to packet_t */
		length = packet[0];
	
		receivedPacketPtr->length = length;

		tmp = packet[2];
		tmp = (tmp << 8) + packet[1];
		receivedPacketPtr->fcf = tmp;

		receivedPacketPtr->data_seq_no = packet[3];

		tmp = packet[5];
		tmp = (tmp << 8) + packet[4];
		receivedPacketPtr->dest = tmp;

		tmp = packet[7];
		tmp = (tmp << 8) + packet[6];
		receivedPacketPtr->src = tmp;

		for (i = 8; i < length - 1; i++) 
		{
			receivedPacketPtr->data[i - 8] = packet[i];
		}

		receivedPacketPtr->fcs.rssi = packet[length - 1];
		receivedPacketPtr->fcs.correlation = packet[length];

		receivedPacketPtr = signal SimpleMac.receivedPacket(receivedPacketPtr);
		
		return packet;
	}


/*************************************************************************************************
*** Adressing
**************************************************************************************************/

	/**********************************************************************
	 * setShortAddress
	 *********************************************************************/
	command error_t SimpleMac.setAddress(mac_addr_t *addr)
	{
		return call HALCC2420.setAddress(addr);
	}
	

	/**********************************************************************
	 * getShortAddress
	 *********************************************************************/
	command const mac_addr_t * SimpleMac.getAddress()
	{
		return call HALCC2420.getAddress();
	}
	
	/**********************************************************************
	 * setPANAddress
	 *********************************************************************/
	command error_t SimpleMac.setPanAddress(mac_addr_t *addr)
	{
		return call HALCC2420.setPanAddress(addr);
	}
	

	/**********************************************************************
	 * getShortAddress
	 *********************************************************************/
	command const mac_addr_t * SimpleMac.getPanAddress()
	{
		return call HALCC2420.getPanAddress();
	}
	
	/**********************************************************************
	 * getExtAddress
	 *********************************************************************/
	command const ieee_mac_addr_t * SimpleMac.getExtAddress()
	{
		return call HALCC2420.getExtAddress();
	}

	/**********************************************************************
	 * Hardware Address Filtering
	 *********************************************************************/
	command error_t SimpleMac.addressFilterEnable()
	{
		return call HALCC2420.addressFilterEnable();
	}
	
	command error_t SimpleMac.addressFilterDisable()
	{
		return call HALCC2420.addressFilterDisable();
	}

/*************************************************************************************************
** StdOut
*************************************************************************************************/
	
	async event void StdOut.get(uint8_t data) {

	}

}
