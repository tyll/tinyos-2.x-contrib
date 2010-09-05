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
 * Header file.
 *
 * @date 30/09/2010 10:59
 * @author Filippo Zanella <filippo.zanella@dei.unipd.it>
 * @version $Revision$
 */ 
	

#ifndef TMOTECOMM_H
#define TMOTECOMM_H

typedef nx_struct mote_ctrl_msg 
{
	nx_uint8_t work;
} mote_ctrl_msg;


typedef enum 
{ 
	START = 0xA,	// Start of receiver activity
	STOP = 0xB,		// Stop of receiver activity
} cmd_t;


typedef enum 
{ 
	IDLE, 
	ACTIVE, 
} state_t;


enum 
{ 
	CHANNEL_RADIO = 4,			// Selected radio channel
	POWER_RADIO = 31,			// Power of radio CC2420 [dBm]
	
	AM_MOTE_CTRL_MSG = 86,		// ID of mote_ctrl_msg
	
	ZERO = 0, 
};

#endif
