#!/usr/bin/perl

use FileHandle;
use IPC::Open2;

my $alpha = "abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ";
$testbuf = "";
while (length($testbuf) < 1280 - 40 - 8) {
    $testbuf .= $alpha;
}
$pid = open2(*reader, *writer, "nc6 -u 2001:470:1f04:56d::16 7");


my $trials = 0;
while (1) {
    $len = int(rand(1280 - 40 - 8 ));
    print $len . "\n";
    print writer substr($testbuf, 0, $len) . "\n";

    $found = select(fileno(reader), undef, undef, 6);
    if ($found == 1) {
        sysread reader, $foo, 1280;
    } else {
        print "FAILURE: len: $len\n";
    }

    $trials++;
    print "TRIAL: $trials\n";
    sleep(.05);
}
# need to kill off the nc6 process
print writer eof;

