#!/usr/bin/perl
# unfinished script to plot using boxes. Will be more useful when we have energy 

my (%res_name, %ctx_name);
$res_name{0x9} = "CPU";
$res_name{0x50} = "LED0";
$res_name{0x51} = "LED1";
$res_name{0x52} = "LED2";

$ctx_name{0} = "IDLE";
$ctx_name{1} = "Main";
$ctx_name{2} = "Activity A";
$ctx_name{3}= "Activity B";
$ctx_name{65} = "Timer";

my $first = undef;
my $last = 0;
my $offset = 0;

while(<>) {
    chomp;
    my ($idx,$res,$from_ctx,$to_ctx,$time);
    next unless /->/;
    ($idx,$res,$from_ctx,$to_ctx,$time) = 
      $_ =~ /Received message: (\d+):(\d+) (\d+)->(\d+) (\d+)\s+$/;
    if (!defined $first) {
        $first = $time;
    }
    if ($last > $time) {
        $offset += 0x10000;
    }
    $last = $time;
    $time += $offset - $start;
    #print "$_\n";
    if (!defined $log{$res}) {
        push @{$log{$res}},[$idx,0,0,$from_ctx];
    }
    push @{$log{$res}},[$idx,$time,$from_ctx,$to_ctx];
    print "entry [$idx] $time res $res_name{$res} ctx_change $ctx_name{$from_ctx} -> $ctx_name{$to_ctx}\n"; 
}

my $index = 0;
for $res (keys %log) {
    undef %boxes;
    for $entry (@{$log{$res}}) {
        ($idx,$time,$from_ctx,$to_ctx) = @{$entry};
        if (defined $last_time) {
            push @{$boxes{$from_ctx}},[($time + $last_time)/2, ($time - $last_time)];
            print STDERR "entry $idx: cur ctx ($from_ctx) != last ($last_ctx)\n";
        }
        $last_time = $time;
        $last_ctx = $to_ctx;
    }
    for $ctx (keys %boxes) {
        print "#index $index res $res ($res_name{$res}) ctx $ctx ($ctx_name{$ctx})\n";
        for $box (@{$boxes{$ctx}}) {
            print "$ctx $box->[0] 1 $box->[1]\n";
        }
    }
}
