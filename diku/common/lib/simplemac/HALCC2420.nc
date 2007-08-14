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



includes cc2420;

interface HALCC2420
{
	/**
	 * sendPacket will perform a CCA, put the device into transmit mode,
	 * send the packet and return. If the SPI bus is not free or CCA
	 * fails, the sending of the packet is delayed. The contents
	 * of the packet must not be changed after the call to sendPacket.
	 *
	 * @param uint8_t * packet The packet that should be sent.
	 * @return error_t If the packet was queued for sending successfully.
	 */
	command error_t sendPacket(uint8_t * packet);

	/**
	 * sendPacketDone is signaled when a packet have been sent successfully.
	 *
	 * @param packet_t *packet The packet that have been sent.
	 * @param error_t result If the packet was sent successfully.
	 */
	async event void sendPacketDone(uint8_t * packet, error_t result);

	/**
	 * receivedPacket is signalled when the radio have received a full
	 * packet.  The function must return a free uint8_t * to the radio
	 * stack. This can be the same packet that have been signaled
	 *
	 * @param uint8_t *packet The received packet
	 * @return uint8_t* A free packet
	 */
	event uint8_t * receivedPacket(uint8_t * packet);

	command error_t setChannel(uint8_t channel);
	command error_t setTransmitPower(uint8_t power);

	command error_t setAddress(mac_addr_t *addr);
	command const mac_addr_t * getAddress();
	command const ieee_mac_addr_t * getExtAddress();

	command error_t rxEnable();
	command error_t rxDisable();

	command error_t addressFilterEnable();
	command error_t addressFilterDisable();

	command error_t setPanAddress(mac_addr_t *addr);
	command const mac_addr_t * getPanAddress();

}
