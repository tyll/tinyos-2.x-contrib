
/***********************************************************************/
/* This program is free software; you can redistribute it and/or			 */
/* modify it under the terms of the GNU General Public License as			 */
/* published by the Free Software Foundation; either version 2 of the	 */
/* License, or (at your option) any later version.										 */
/* 																																		 */
/* This program is distributed in the hope that it will be useful, but */
/* WITHOUT ANY WARRANTY; without even the implied warranty of					 */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU	 */
/* General Public License for more details.														 */
/* 																																		 */
/* Written and (c) by INRIA, Aurelien Francillon											 */
/* Contact <aurelien.francillon@inrialpes.fr> for comment, bug reports */
/* and possible alternative licensing of this program									 */
/***********************************************************************/
/**
 * @file   GPSP.nc
 * @author Aurelien Francillon
 * @date   Sun May 25 19:16:09 2008
 *
 * @brief The implementation of high level Gps device access for the mts420 borad
 *
 * @todo finish implementation to stop correctly
 */


module GPSP{
	provides {
		// control : set up power and data connection
		interface SplitControl as GPSControl;
	}

	uses {
		interface SplitControl as Mts400Init;
		// Switches to power up the GPS device and connect it
		interface SplitControl as GPSPower;
		interface SplitControl as GPSConnect;
	}
}

implementation
{

	// start is :
	// - setup power
	// - when power is up (GPSPower.startDone) connect
	// when connect is done we are done

	command error_t GPSControl.start()
	{
    error_t err;
    err=call Mts400Init.start();

    switch(err){

      //  already initialized continue with gps power on
    case EALREADY:
      return  call GPSPower.start();

    case SUCCESS:
    case FAIL:
    case EBUSY:
    default:
      return err;
    }
  }

  //TODO
  event void Mts400Init.stopDone(error_t error){}

  event void Mts400Init.startDone(error_t error){
    error_t err;
    // error starting the Mts400Init signal failure
    if(error!=SUCCESS)
      signal GPSControl.startDone(error);
    // ok try to power up the gps device
    err=call GPSPower.start();
    switch (err){
    case SUCCESS:
      // OK wait GPSPower.startDone
      return;

    case EALREADY:{
      error_t Connecterr=call GPSConnect.start();
      switch(Connecterr){
      case FAIL:
      case EBUSY:
        signal GPSControl.startDone(FAIL);
        return;
      case EALREADY:
        signal GPSControl.startDone(SUCCESS);

      case SUCCESS:
        // a Connect.startDone is pending
      default:
        return;
      }
    }
    case EBUSY:
    case FAIL:
      signal GPSControl.startDone(FAIL);
    }

  }

	event void GPSPower.startDone(error_t error){
		error_t err=call GPSConnect.start();
		// can't handle connection
		switch(err){
		case FAIL:
		case EBUSY:
			signal GPSControl.startDone(FAIL);
			return;
		case EALREADY:
			signal GPSControl.startDone(SUCCESS);

		case SUCCESS:
			// a Connect.startDone is pending
		default:
			return;
		}

	}

	event void GPSConnect.startDone(error_t error){
    signal GPSControl.startDone(error);
	}

	// Stop is :
	// - disconnect
	// - when gps is disconnected put down power
	// - when power is down we are done ...

	command error_t GPSControl.stop(){
		return call GPSConnect.stop();
	}

	event void GPSConnect.stopDone(error_t error) {
		error_t powererr;

		if (error==FAIL){
			signal GPSControl.stopDone(FAIL);
			return;
		}

		powererr= call GPSPower.stop();

		// can't handle connection
		switch(powererr){
		case FAIL:
		case EBUSY:
			signal GPSControl.stopDone(FAIL);
			return;
		case EALREADY:
			signal GPSControl.stopDone(SUCCESS);

		case SUCCESS:
			// a send done is pending
		default:
			return;
		}
	}

	event void GPSPower.stopDone(error_t error){
    signal GPSControl.stopDone(error);
	}
}
