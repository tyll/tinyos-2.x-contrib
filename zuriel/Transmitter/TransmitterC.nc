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
 * Configuration file of the module TransmitterP.nc
 *
 * @date 30/09/2010 10:59
 * @author Filippo Zanella <filippo.zanella@dei.unipd.it>
 * @version $Revision$
 */

#include <UserButton.h>
#include "../TmoteComm.h"

configuration TransmitterC
{
}


implementation
{
	components MainC,
		LedsC;
	components TransmitterP as App;

	components CC2420ControlC;
	components CC2420PacketC;

	components UserButtonC;

	components ActiveMessageC;
	components new AMSenderC (AM_MOTE_CTRL_MSG) as AMTransmitterMoteCtrl;

	App.Boot->MainC.Boot;
	App.Leds->LedsC.Leds;

	App.InfoRadio->CC2420PacketC;
	App.CC2420Config->CC2420ControlC.CC2420Config;

	App.AMCtrlRadio->ActiveMessageC;
	App.AMPacket->AMTransmitterMoteCtrl.AMPacket;
	App.AMTransmitterMoteCtrl->AMTransmitterMoteCtrl;

	App.GetBS->UserButtonC.Get;
	App.NotifyBS->UserButtonC.Notify;
}
