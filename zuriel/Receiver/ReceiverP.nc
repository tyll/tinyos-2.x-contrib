/*
 * Copyright (c) 2010, Department of Information Engineering, University of Padova.
 * All rights reserved.
 *
 * This file is part of Zuriel.
 *
 * Zuriel is free software: you can redistribute it and/or modify it under the terms
 * of the GNU General Public License as published by the Free Software Foundation,
 * either version 3 of the License, or (at your option) any later version.
 *
 * Zuriel is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
 * PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Zuriel.  If not, see <http://www.gnu.org/licenses/>.
 *
 * ===================================================================================
 */

/**
 *
 * This is the application of the controlled device (receiver)
 *
 * @date 30/09/2010 10:59
 * @author Filippo Zanella <filippo.zanella@dei.unipd.it>
 * @version $Revision$
 */

module ReceiverP
{
	uses
	{
		interface Leds;
		interface Boot;

		interface CC2420Config;
		interface CC2420Packet as InfoRadio;
		interface SplitControl as AMCtrlRadio;

		interface Receive as AMReceiverMoteCtrl;
	}
}


implementation
{
	message_t moteCtrlPkt;									
	bool      lockedRadio;									
	state_t curState;										
	uint8_t   cmd;											

	event void Boot.booted() {
		call Leds.set(ZERO);
		lockedRadio = FALSE;
		curState = IDLE;

		call CC2420Config.setChannel(CHANNEL_RADIO);
		call CC2420Config.sync();
	}

	event void CC2420Config.syncDone(error_t error) {
		if (error == SUCCESS) {
			call AMCtrlRadio.start();
		}
		else
			call CC2420Config.sync();
	}

	event void AMCtrlRadio.startDone(error_t error) {
		if (error == SUCCESS) {
			//     call Leds.led1On();
		}
		else
			call AMCtrlRadio.start();
	}

	event void AMCtrlRadio.stopDone(error_t error) {}

	event message_t* AMReceiverMoteCtrl.receive(message_t* msg, void* payload, uint8_t len) {
		if (len == sizeof(mote_ctrl_msg)) {
			mote_ctrl_msg* rcm = (mote_ctrl_msg*)payload;

			uint8_t newCmd = rcm->work;

			if(cmd!=newCmd) {
				switch(newCmd) {
					case START:
					{
						call Leds.set(111);
						curState = ACTIVE;
						break;
					}
					case STOP:
					{
						call Leds.set(ZERO);
						curState = IDLE;
						break;
					}
				}
			}
		}
		return msg;
	}
}
