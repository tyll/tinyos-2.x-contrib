
/***********************************************************************/
/* This program is free software; you can redistribute it and/or       */
/* modify it under the terms of the GNU General Public License as      */
/* published by the Free Software Foundation; either version 2 of the  */
/* License, or (at your option) any later version.                     */
/*                                                                     */
/* This program is distributed in the hope that it will be useful, but */
/* WITHOUT ANY WARRANTY; without even the implied warranty of          */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU   */
/* General Public License for more details.                            */
/*                                                                     */
/* Written and (c) by INRIA, Christophe Braillon                       */
/*                           Aurelien Francillon                       */
/* Contact <aurelien.francillon@inrialpes.fr> for comment, bug reports */
/* and possible alternative licensing of this program                  */
/***********************************************************************/
#include <I2C.h>
#include "mts400.h"

//#define HPLADG715C_DEBUG

#ifdef HPLADG715C_DEBUG
#include "printf.h"
#endif

// Address is the complete I2C address however only the two lower bits
// are configurable bits the 5 high wgeight bits are fixed

// TODO implement switch reads

generic module HplAdg715C(uint16_t I2Caddress)
{
	provides
	{
		interface Switch;
	}

	uses
	{
		interface I2CPacket<TI2CBasicAddr>  as I2C;
		interface Resource as I2CResource;
	}
}

implementation
{

#ifdef HPLADG715C_DEBUG
#define DBGPrintf(fmt,args ...) do { printf(fmt,args);} while(0)
#else
#define DBGPrintf(fmt,args ...) do { } while(0)
#endif

	enum {
		GET_SWITCH,
		SET_SWITCH,
		SET_SWITCH_ALL,
		MASK_SWITCH,
		IDLE
	};

	uint8_t writeBuf[1];
	uint8_t sw_state = 0;
	uint8_t state = IDLE;

	error_t post_error;
  const char* errorString(error_t error){

		switch(error){
		case SUCCESS:
			return "SUCCESS";
		case EALREADY:
			return "EALREADY";
		case EBUSY:
			return "EBUSY";
		case FAIL:
			return "FAIL";
		default :
			//call DBGPrintfFlush.flush();
			//printf("\nUnknown error  %d \n",error);
			//call PrintfFlush.flush();
/*  			sprintf(tmp_string, "Unkown error status %d ",error);  */
/* 			return tmp_string;// tmp_string; */
			return "UNKNOWN";

		}

	}

  void DBGI2COwner(char *environment){
    if(call I2CResource.isOwner())
      DBGPrintf("  %s I2CResource(%d).isOwner TRUE\n",environment,I2Caddress);
    else
      DBGPrintf("  %s I2CResource(%d).isOwner FALSE\n",environment,I2Caddress);
  }


	/**
	 * get the switch state
	 * ! this is the state in cache not always coherent with real state...
	 *
	 * @return switch state
	 */
	command error_t Switch.get()
	{
		atomic {
			if (state == IDLE) {
        error_t err;
				state = GET_SWITCH;
        err=call I2CResource.request();
        DBGPrintf("  %s Switch.get I2CResource(%d).request  %s\n",errorString(err),I2Caddress);
				return err;
			}else
				return FAIL;
		}
	}


	// ! sw_state isn't always coherent with hw ...
	command error_t Switch.set(uint8_t l_position, uint8_t l_value)
	{
		atomic
		{
			if (state == IDLE)
			{
        error_t err;
				state = SET_SWITCH;

				// clear bit
				sw_state &= ~(1 << l_position);
				// set bit
				sw_state |= (l_value << l_position);

        err=call I2CResource.request();
        DBGPrintf("  %s Switch.set I2CResource(%d).request  %s\n",errorString(err),I2Caddress);
				return err;
			}
			// ??? not so confident on this one
			// calling twice Ewitch set/get will set state to IDLE while
			// I2C write/read  done will be signled
			state = IDLE;
		}
		return FAIL;
	}


	command error_t Switch.setAll(uint8_t l_value)
	{
		atomic
		{
			if (state == IDLE)
			{
				error_t err;
				state = SET_SWITCH_ALL;
				sw_state = l_value;
        DBGI2COwner("Switch.setAll");
				err= call I2CResource.request();
				DBGPrintf("  %s <-()Switch.setAll I2CResource(%d).request \n",errorString(err),I2Caddress);
				return err;
			}
			state = IDLE;
		}
		return FAIL;
	}

	command error_t Switch.mask(uint8_t onMask, uint8_t offMask)
	{
		atomic
		{
			if (state == IDLE)
			{
				error_t err;
				state = MASK_SWITCH;

				sw_state &= ~(offMask);
				sw_state |= onMask;

				err= call I2CResource.request();
				DBGPrintf("  %s <-()Switch.setAll I2CResource(%d).request \n",errorString(err),I2Caddress);
				return err;
			}
			state = IDLE;
		}
		return FAIL;
	}

	/**
	 * Acces to I2C bus is granted we can send the command
	 *
	 */
	event void I2CResource.granted()
	{
    atomic DBGI2COwner("I2CResource.granted");

		if (state==GET_SWITCH){
			call I2C.read(I2C_START | I2C_STOP, I2Caddress, 1, writeBuf);
		}	else{ // this is a write
			writeBuf[0] = (uint8_t)sw_state;
			call I2C.write(I2C_START | I2C_STOP, I2Caddress, 1, writeBuf);
		}
	}

	task void doDone()
	{
		uint8_t postedError;
		atomic{
			postedError=post_error;
		}
		//DBGPrintf("%s postedError <-doDone() \n",errorString(postedError));
/* 		DBGPrintf("%d post_error  <-dodone() \n",post_error); 		 */

		switch(state) {
		case SET_SWITCH:
			state = IDLE;
				signal Switch.setDone(postedError);
			break;

		case GET_SWITCH:
			state = IDLE;
			if(postedError==SUCCESS)
				sw_state=writeBuf[0];
			signal Switch.getDone(postedError,sw_state);
			break;

		case SET_SWITCH_ALL:
			state = IDLE;
			signal Switch.setAllDone(postedError);
			break;

		case MASK_SWITCH:
			state = IDLE;
			signal Switch.maskDone(postedError);
			break;
		}
	}

	async event void I2C.writeDone(error_t error, uint16_t addr, uint8_t length, uint8_t *data)
	{
    error_t err;
    DBGPrintf("  %s I2C(%d).writeDone \n",errorString(error),I2Caddress);
    atomic{
      DBGPrintf("I2CResource(%d).Release ->\n",I2Caddress);
      DBGI2COwner("I2C.writeDone");
      err=call I2CResource.release();
      DBGI2COwner("I2C.writeDone");
      DBGPrintf("  %s I2C.writeDone I2CResource(%d).Release\n",errorString(err),I2Caddress);
    }
		// can't pass a parameter to a task ...
		atomic post_error=error;
		//DBGPrintf("%s <- HplAdg715C I2C.writeDone() \n",errorString(error));
		post doDone();
	}

	async event void I2C.readDone(error_t error, uint16_t addr, uint8_t length, uint8_t *data)
	{
    error_t err;
    DBGPrintf("  %s I2C(%d).readDone \n",errorString(error),I2Caddress);
    DBGPrintf("I2CResource(%d).Release ->\n",I2Caddress);
    DBGI2COwner("I2CResource.readDone");
		err=call I2CResource.release();
    DBGI2COwner("I2CResource.readDone");
    DBGPrintf("  %s I2C.readDone I2CResource(%d).Release\n",errorString(err),I2Caddress);
		atomic post_error=error;
		//		DBGPrintf("%s <- HplAdg715C I2C.readDone() \n",errorString(error));
		post doDone();
	}
}
