/*
 * "Copyright (c) 2007 Washington University in St. Louis.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL WASHINGTON UNIVERSITY IN ST. LOUIS BE LIABLE TO ANY PARTY
 * FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING
 * OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF WASHINGTON
 * UNIVERSITY IN ST. LOUIS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * WASHINGTON UNIVERSITY IN ST. LOUIS SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND WASHINGTON UNIVERSITY IN ST. LOUIS HAS NO
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS."
 */
 
#include "AlarmConstants.h"

/**
 * Provides a 32 Khz, 16-bit Alarm.  All instances of this component share
 * a single underlying Alarm32Khz16C, so that you can instantiate as you need
 * without running out of hardware timers.
 *
 * @author Greg Hackmann <ghackmann@wustl.edu>
 * @see Please refer to TEP 102 for more information about this component and
 * its intended use.
 */
generic configuration VirtualizedAlarm32khz16C()
{
	provides interface Alarm<T32Khz, uint16_t>;
}
implementation
{
	enum
	{
		ID = unique(UQ_VIRTUALIZED_ALARM_32KHZ_16),
	};
	
	components Alarm32khz16VirtualizerP as Alarms;
	Alarm = Alarms.Alarm[ID];
}
