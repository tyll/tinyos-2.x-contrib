#!/usr/bin/perl

# Arg1 is the tty device
# Arg2 is the base filename

open (FILE, "+<" . $ARGV[0]) or die("Grrr");

open (OUTFILEP, ">" . $ARGV[1] . ".txt") or die("Wruuf");

open (OUTFILEb, ">" . $ARGV[1] . "-buckets.txt") or die("Wruuf");

print FILE "P";
while ( $line = <FILE> ) {
    $line =~ s/\r//;
    print OUTFILEP $line;
    if ($line =~ /^\s*$/) {
	last;
    }
}

close(OUTFILEP);

# removes junk at end of trace
close(FILE);
open (FILE, "+<" . $ARGV[0]) or die("Grrr");

print FILE "b";
while ( $line = <FILE> ) {
    $line =~ s/\r//;
    print OUTFILEb $line;
    if ($line =~ /^\s*$/) {
	last;
    }
}

close(OUTFILEp);

# removes junk at end of trace
close(FILE);
open (FILE, "+<" . $ARGV[0]) or die("Grrr");

# If reset fails to return this will hang..

print "Resetting for next run (hangs here if it fails)\n";
print FILE "r";
while ( $line = <FILE> ) {
    if ($line =~ /Reset/) {
	last;
    }
}

close(FILE);
