#!/usr/bin/perl
#This requires a hacked up version of the logger that stores the
#count of messages on the icount field of the message.
while (<>) {
    chomp;
    @F = split;
    ($time, $count) = ( hex($F[2].$F[3].$F[4].$F[5]), hex($F[6].$F[7].$F[8].$F[9]) );
    if (!defined $first_time) {
        $first_time = $time;
        $first_count = $count;
    }
    $total_logged = $count - $first_count + 1;
    $total_registered++;
    $total_missed = $total_logged - $total_registered;
    if (defined $last_count) {
        $missed = $count - $last_count - 1;
    }
    $last_count = $count;

    print "$time $count $total_logged $total_registered $total_missed ".($total_missed/(1.0*$total_logged))."\n";
}
