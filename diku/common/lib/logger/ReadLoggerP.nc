/*
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

generic module ReadLoggerP(typedef width_t) {
    provides interface Read<width_t> as ReadOut;
    provides interface ReadStream<width_t> as ReadStreamOut;
    uses interface Read<width_t> as ReadIn;
    uses interface ReadStream<width_t> as ReadStreamIn;
    uses interface GeneralIO;
}

implementation {


    /*************************************************************************/
    command error_t ReadStreamOut.postBuffer(width_t * buf, uint16_t count) {
        call GeneralIO.set();
        return call ReadStreamIn.postBuffer(buf, count);
    }
    
    command error_t ReadStreamOut.read(uint32_t usPeriod) {
        call GeneralIO.set();
        return call ReadStreamIn.read(usPeriod);
    }

    event void ReadStreamIn.bufferDone(error_t result, width_t * buf, uint16_t count) {
        call GeneralIO.clr();
        signal ReadStreamOut.bufferDone(result, buf, count);
    }
    
    event void ReadStreamIn.readDone(error_t result, uint32_t usActualPeriod) {
        call GeneralIO.clr();
        signal ReadStreamOut.readDone(result, usActualPeriod);
    }

    /*************************************************************************/
    command error_t ReadOut.read() {
        call GeneralIO.set();
        return call ReadIn.read();
    }
    
    event void ReadIn.readDone( error_t result, width_t val ) {
        call GeneralIO.clr();
        signal ReadOut.readDone(result, val);
    }



}
