
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


/* interface for the hardware switch i.e. on mts4X0XX sensor board */
interface Switch
{
  /**
   * get request the status of the switch
   *
   *
   * @return
   */
  command error_t get();

  /**
   * TODO
   *
   * @param position
   * @param value
   *
   * @return
   */
  command error_t set(uint8_t position, uint8_t value);
  command error_t setAll(uint8_t value);

  /**
   * Update the switches values with on/off masks
   *
   * @param onMask  bits to be set to 1
   * @param offMask bits to be set to 0
   *
   * @return FAIL if internal state != IDLE
   */
  command error_t mask(uint8_t onMask, uint8_t offMask);

  /**
   * Signal completion of the set command
   *
   * @param error status  FAIL or SUCCESS
   */
  event void setDone(error_t error);

  /**
   * Singals the completion of setAll command
   *
   * @param error FAIL or SUCCESS
   */
  event void setAllDone(error_t error);

  /**
   * Singals the cocmpletion of the mask command
   *
   * @param error FAIL or SUCCESS
   */
  event void maskDone(error_t error);

  /**
   * signals the availability of the requested status of switch
   *
   * @param error FAIL or SUCCESS
   * @param value the read state of the switch
   *
   */
    event void getDone(error_t error, uint8_t value);

}

