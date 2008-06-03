
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




interface GpsParser
{
	/** 
	 * this event sends a pointer to the last GGA message parsed
	 * 
	 * @param msg GGA frame decoded 
	 * @return pointer to a free GGA message buffer
	 */  
	event GpsGGAMsg* GGAReceived(GpsGGAMsg *msg);

	/** 
	 * this event sends a pointer to the last VTG message parsed
	 * 
	 
	 * @param msg GGA frame decoded 
	 * @return pointer to a free VTG message buffer	
	 */   
	event GpsVTGMsg* VTGReceived(GpsVTGMsg *msg);
}
