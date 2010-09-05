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
 * This is the application of the remote controller (transmitter)
 *
 * @date 30/09/2010 10:59
 * @author Filippo Zanella <filippo.zanella@dei.unipd.it>
 * @version $Revision$
 */

module TransmitterP
{
	uses
	{
		interface Leds;
		interface Boot;

		interface CC2420Config;
		interface CC2420Packet as InfoRadio;
		interface SplitControl as AMCtrlRadio;

		interface AMSend as AMTransmitterMoteCtrl;
		interface AMPacket;

		interface Get<button_state_t> as GetBS;
		interface Notify<button_state_t> as NotifyBS;
	}
}


implementation
{
	message_t moteCtrlPkt;									
	bool      lockedRadio;									
	cmd_t curCmd;											

	task void sendMoteCtrlMsg();

	event void Boot.booted() {
		call Leds.set(ZERO);
		lockedRadio = FALSE;
		curCmd = STOP;

		call CC2420Config.setChannel(CHANNEL_RADIO);
		call CC2420Config.sync();

		call NotifyBS.enable();
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
		}
		else
			call AMCtrlRadio.start();
	}

	event void AMCtrlRadio.stopDone(error_t error) {}

	task void sendMoteCtrlMsg() {
		if(lockedRadio) {
			return;
		}
		else {
			mote_ctrl_msg* rpm = (mote_ctrl_msg*)(call AMTransmitterMoteCtrl.getPayload(&moteCtrlPkt,  sizeof(mote_ctrl_msg)));

			atomic
			{
				rpm->work = curCmd;
			}
			if (call AMTransmitterMoteCtrl.send(AM_BROADCAST_ADDR, &moteCtrlPkt, sizeof(mote_ctrl_msg)) == SUCCESS) {
				lockedRadio = TRUE;
				call Leds.led1Toggle();
			}
		}
	}

	event void AMTransmitterMoteCtrl.sendDone(message_t* msg, error_t error) {
		if (&moteCtrlPkt == msg) {
			lockedRadio = FALSE;
		}
	}

	event void NotifyBS.notify(button_state_t state) {
		if (state == BUTTON_PRESSED) {
			if(curCmd==STOP)
				{curCmd = START;}
				else if(curCmd==START)
					{curCmd = STOP;}
					post sendMoteCtrlMsg();
		}
		else if (state == BUTTON_RELEASED) {}
	}
}
