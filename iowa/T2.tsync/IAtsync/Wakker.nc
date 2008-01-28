/*
* Copyright (c) 2007 University of Iowa 
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* - Redistributions of source code must retain the above copyright
*   notice, this list of conditions and the following disclaimer.
* - Redistributions in binary form must reproduce the above copyright
*   notice, this list of conditions and the following disclaimer in the
*   documentation and/or other materials provided with the
*   distribution.
* - Neither the name of The University of Iowa  nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 * Timesync suite of interfaces, components, testing tools, and documents.
 * @author Ted Herman
 * Development supported in part by NSF award 0519907. 
 */
//--EOCpr712 (do not remove this line, which terminates copyright include)

/**
 * This interface provides a generic wakeup service that generates
 * events at specified times or after specified delays.
 */
#include "Wakker.h"

interface Wakker {
  /**
   * Schedule a wakeup at a specified Wakker time (where Wakker time
   * is approximately the number of 1/8 seconds since the Wakker component
   * was first started using StdControl.start).
   * @param indx A user-defined index, handy for bookkeeping in
   *             your application, so when a wakeup fires, you can
   *             easily see which scheduled wakeup this one is. 
   * @param wake_time Specifies the Wakker time for the wakeup.  If
   *             multiple wakeups are scheduled for the same time,
   *             then Wakker will try to fire them at about the same
   *             time. If you are crazy enough
   *             to schedule a wakeup for the "past", ie a value less
   *             than the current Wakker time, that will work.  The
   *             wakeups are processed in order, from earliest up to
   *             the current time. 
   * @return Returns SUCCESS if the alarm could be scheduled.  But
   *             the implementation uses a finite table (see Wakker.h 
   *             for sched_list_size), and if the table is full, then
   *             schedule Returns FAIL.
   * @author herman@cs.uiowa.edu
   */
  command error_t schedule(uint8_t indx, uint32_t wake_time);

  /**
   * Same as schedule, but overrides previous setting of same index
   */
  command error_t soleSchedule(uint8_t indx, uint32_t wake_time);

  /**
   * Schedule a wakeup for a specified delay, in 1/8 seconds, following the
   * current Wakker time (where Wakker time is approximately the number 
   * of seconds since the Wakker component was first started using 
   * StdControl.start).
   * @param indx A user-defined index, handy for bookkeeping in
   *             your application, so when a wakeup fires, you can
   *             easily see which scheduled wakeup this one is. 
   * @param delay_time Specifies the delay for the wakeup.  If
   *             multiple wakeups are scheduled for the same time,
   *             then Wakker will try to fire them at about the same
   *             time.
   * @return Returns SUCCESS if the alarm could be scheduled.  But
   *             the implementation uses a finite table (see Wakker.h 
   *             for sched_list_size), and if the table is full, then
   *             schedule Returns FAIL.
   * @author herman@cs.uiowa.edu
   */
  command error_t set(uint8_t indx, uint32_t delay_time);

  /**
   * Same as set, but overrides previous setting of same index
   */
  command error_t soleSet(uint8_t indx, uint32_t delay_time);

  /**
   * Init (same idea as Boot, but as synchronous command)
   */
  command void init();

  /**
   * Clear all scheduled wakeups.  Mainly intended for a failure/restart
   * purpose, this is a less drastic measure than "StdControl.stop(); 
   * StdControl.start()".  Why?  Because only the wakeups associated
   * with the id of the calling component are cleared (keep in mind that
   * the Wakker interface is parametrized). 
   * @return Returns SUCCESS.
   * @author herman@cs.uiowa.edu
   */
  command void clear();

  /**
   * Cancel all wakeups of a specified index (more selective than
   * the clear operation).
   */
  command void cancel(uint8_t indx);

  /**
   * Read the current Wakker time, where Wakker time is approximately 
   * the number of 1/8 seconds since the Wakker component was first 
   * started using StdControl.start).
   * @return Returns alarm time.
   * @author herman@cs.uiowa.edu
   */
  command uint32_t clock();

  /**
   * Set Wakker/Timer alignment to global time 
   * (after this, the Wakker's time counter should be
   * approximately equal to the global clock).
   */
  command void setSync( );

  /**
   * Rewinds the current Wakker "clock".
   */
  command void rewind( );

  /**
   * Report # of slots available 
   */
  command uint8_t slotsAvailable( );

  /**
   * Wakeup event.  It is signalled by Wakker to notify the application
   * of a previously scheduled alarm.  It provides the application the
   * user-defined index of the wakeup.
   * @see  Wakker.set and Wakker.schedule
   * @param indx A user-defined index, handy for bookkeeping in
   *             your application, so when a wakeup fires, you can
   *             easily see which scheduled wakeup this one is. 
   * @param wake_time This is the Wakker time at the instant of signalling, 
   *             which could actually be later than the scheduled time.
   * @author herman@cs.uiowa.edu
   */
  event error_t wakeup(uint8_t indx, uint32_t wake_time);
  }
