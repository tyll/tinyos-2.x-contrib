#!/usr/bin/perl

#
# Copyright (c) 2007 University of Copenhagen
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# - Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the
#   distribution.
# - Neither the name of University of Copenhagen nor the names of
#   its contributors may be used to endorse or promote products derived
#   from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY
# OF COPENHAGEN OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.
#

#
# This script receives samples via the serial port and writes them to
# the fifos
#
# Author: Martin Leopold <leopold@diku.dk>
#

use FileHandle;

if ($#ARGV < 0) {
    print ("Syntax: \n ttxdemo.pl <serdev> <fifo1> <fifo2> .. <fifo n> \n");
    exit 1;
}

my $TTY = $fh = new FileHandle;

$TTY->open("< $ARGV[0]") || 
    die("Could not open $ARGV[0]\n");

my $FIFOs = [];
for (my $i=1 ; $i<=$#ARGV ; $i++ ) {

    $FIFOs[$i-1] = new FileHandle "$ARGV[$i]", "w" || # Append
	die("Could not open $ARGV[$i]\n");
    $FIFOs[$i-1]->autoflush(1);
    binmode($FIFOs[$i-1]);
}

my %seen_id = ();
my $no_lines = 0;
while ($line = readline($TTY)) {
    $no_lines++;
    if ($line =~ /(\w\w\w\w)(\w\w\w\w)(\w\w\w\w)(\w\w\w\w).*/) {
	my $id = oct("0x" . $1);
	my $x  = oct("0x" . $2);
	my $y  = oct("0x" . $3);
	my $z  = oct("0x" . $4);

	# If this is a new id enter it in the array as a new no.
	if (!defined($seen_id{$id})) {
	    $seen_id{$id} = @seen_id;
	}
	$node_no = $seen_id{$id};
	$first_fifo = $node_no*3;

	print "$no_lines - $id: $x $y $z \n";
		
	if ( $first_fifo+3 > @FIFOs) {
	    print ("No more fifos for id $id\n");
	} else {
	    $FIFOs[$first_fifo]->print(pack("d", $x));
#	    $FIFOs[$first_fifo+2]->print(pack("d", $y));
	    $FIFOs[$first_fifo+1]->print(pack("d", $y));
	    $FIFOs[$first_fifo+2]->print(pack("d", $z));
	}
    } else {
	print("Garbled line\n");
    }

#    my $fh = $FIFOs[0];
#    $fh->print(pack("d", $num));
}
