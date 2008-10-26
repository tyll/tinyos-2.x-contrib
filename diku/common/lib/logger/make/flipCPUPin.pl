#!/usr/bin/perl -w
#
#   Copyright (c) 2007 University of Copenhagen
#   All rights reserved.
#  
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions
#   are met:
#   - Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#   - Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the
#     distribution.
#   - Neither the name of University of Copenhagen nor the names of
#     its contributors may be used to endorse or promote products derived
#     from this software without specific prior written permission.
#  
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#   ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
#   FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY
#   OF COPENHAGEN OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
#   INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#   (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
#   SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
#   HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
#   STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
#   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
#   OF THE POSSIBILITY OF SUCH DAMAGE.
#  
#
#

#
# This script inserts a new scheduler that flips external pins based
# on availability of tasks and inserts pin-flipping at the beginning
# of interrupt handlers.
#
# It assumes the input code is a TinyOS program produced by Nesc
# version 1.2.8a using the standard scheduler. Further more the
# general platform assumes that the McuSleep actually puts the MCU to
# sleep - otherwise far to much activity will be generated on the
# external pins.
#
# Author: Martin Leopold <leopold@diku.dk>
#

use strict;
use Getopt::Long;

my $file = '';
my $in_plat = '';

GetOptions(
	'file=s' => \$file,
	'platform=s' => \$in_plat,
);

my $in_handler = 0;
my $in_scheduler = 0;
my $replace_me = 0;
my $found_spot;
my $bracket_level = 0;
my $insert_done = 0;

my $PLATFORM=2;

# Platforms:
# 0: Micro4
# 1: CC2430
# 2: General


my @set_cpu_pin = (
    "P4OUT |= 1;\n",
    "P0_5 = 1;\n",
    "LoggerP\$Mcu\$set();\n"
);

my @clr_cpu_pin = (
    "P4OUT &= ~1;\n",
    "P0_5 = 0;\n",
    "LoggerP\$Mcu\$clr();\n"
);

my @toggle_trigger = (
    "if(P4OUT&(1<<6)){P4OUT&=~(1<<6);}else{P4OUT|=1<<6;};\n",
    "P2_0 = ~P2_0;\n",
    "LoggerP\$Trigger\$toggle();\n"
);

my @schedule_insert = (
   "while ( (nextTask = SchedulerBasicP\$popTask()) == SchedulerBasicP\$NO_TASK)            {
           if(P4OUT&(1<<6)){P4OUT&=~(1<<6);}else{P4OUT|=1<<6;};
           P4OUT &= ~0x01;
           SchedulerBasicP\$McuSleep\$sleep();
   }",
   "while ( (nextTask = SchedulerBasicP\$popTask()) == SchedulerBasicP\$NO_TASK)            {
           if (P0_5) { // Task done or activated by interrupt
               P2_0 = ~P2_0;
               P0_5 = 0;
           }
           SchedulerBasicP\$McuSleep\$sleep();
   }",
   "while ( (nextTask = SchedulerBasicP\$popTask()) == SchedulerBasicP\$NO_TASK)            {
           LoggerP\$Trigger\$toggle();
           LoggerP\$Mcu\$clr();
           SchedulerBasicP\$McuSleep\$sleep();
   }");

if ( ! $file) {
	die "Usage flipCPUPin.pl -file \"filename\" <-platform platform_no>\n";
}

if ( ! ($in_plat eq '') ) {
    $PLATFORM = $in_plat;
} else {
    $PLATFORM = 2;
}


open(FILE,"<$file") or die "no such file $file\n";
while(<FILE>) {

#####
# Clr CPU pin prior to sleep

    if((m{\;} == 0) &&
       m{static inline  void SchedulerBasicP\$Scheduler\$taskLoop\(void\)}){
	$in_scheduler = 1;
    }
    if ($in_scheduler==1 &&
	m{__nesc_atomic_t __nesc_atomic = __nesc_atomic_start}) {
	$_ = $_ . $schedule_insert[$PLATFORM];
	$replace_me=1;
	print $_;
	next;
    }
    if ($in_scheduler==1 &&
	m{__nesc_atomic_end\(__nesc_atomic\)}) {
	$replace_me = 0;
	$in_scheduler = 0;
    }

#####
# Set CPU pin at beginning of interrupt handler
#  Create new scope to avoid confusing variables at the top of the interrupt handler
#  Keil is annoying so the pin flipping is in the default scope and the rest gets a
#  new scope
#
# Hack: skip the timer interrupts, the timer maintenaince throws the
# slow logger waay off
#

#void sig_PORT1_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(8))) ;
#  __attribute((interrupt)) void __vector_2(void)
    if($in_handler == 0 &&
       (m{\;} == 0) &&
       ($PLATFORM!=1 || 0==m{__vector_9}) && # Not for timer interrupt on CC2430
       ($PLATFORM!=0 || 0==m{sig_TIMER\w\d_VECTOR}) && # Not for timer interrupt on micro4
       m{__attribute(?:__)?\(\((?:__)?interrupt(?:\(\d+\))?(?:__)?\)\)}) {
	$in_handler=1;
    }

    # Instead of using the timer interrup use the timer fired event!
    if($in_handler == 0 &&
       ($PLATFORM==0 || $PLATFORM==1) && 
       m{inline\s+static\s+void.*VirtualizeTimerC\$0\$Timer\$fired\(.*\)\{}) {
	$in_handler=1;
    }

    if($in_handler == 1) {
	$bracket_level += m{\{};
	$bracket_level -= m{\}};
    }
    if($in_handler == 1 && $insert_done != 1) {
	if (m{\{}) {
	    $_ = $_ . $toggle_trigger[$PLATFORM] . $set_cpu_pin[$PLATFORM] . "\n{\n";
	    $insert_done=1;
	}
    }
    if ($insert_done==1 && $in_handler == 1 && $bracket_level == 0) {
	$_ = $_ . "\n}\n";
	$insert_done=0;
	$in_handler=0;
    }

## static inline  void SchedulerBasicP$Scheduler$taskLoop(void)

  print $_ unless($replace_me==1);
}
