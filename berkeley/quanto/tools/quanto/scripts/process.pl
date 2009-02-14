#!/usr/bin/perl -w
use strict;
use Getopt::Std;

# Script to parse and plot the execution log of context traced
# applications.  It will fix the wrapping of time, and create line
# segments for the different resources as they are used.

# It is to be used with the output of read_log.py

# Input format:
# <type> <subtype> <resource_name> t(us): <time> icount: <icount> arg:|ctx: <arg|ctx>

my $I_COUNT_THRESH = 2;

my %opts;
my ($logtime, $last_conv_time, $conv_time, $last_time, $delta_time, $ldt);
my (%acc_log_recs, $last_cpu_act);

getopts("f:l",\%opts);

my $resource_index = 1;
my %seen_resource;

my $usage  = "$0 -f <file_name> [-l]\n";
   $usage .= "   -f       file produced by read_log.py\n";
   $usage .= "   -l       whether to log-scale time intervals\n";

die $usage unless defined $opts{'f'};

my $fin = $opts{'f'};
$logtime = defined($opts{l});

open FIN, $fin or die "Cannot open $fin\n";
my %log;
my ($resource,$subtype,$to_ctx,$time,$type,$arg,$E);
my ($first, $last, $offset );
my (%seen_ctx);
my $msg;
my @elog;
while(<FIN>) {
    chomp;
    $msg = "";
    $to_ctx = undef;
    ($type, $subtype, $resource, $time, $E, $arg) = 
        $_ =~ /(\w+) ([^\s]+) (\w+) time: ([\d\.]+) icount: (\d+) \w+: ([^\s]+)/;
    print "$_\n" unless $type;
    if (!defined $first) {
        $first = $time;
    }
    # Log number of log statements per cpu activity
    if (defined $last_cpu_act) {
        $acc_log_recs{$last_cpu_act}++;
    }
    if ($type eq 'single_chg' && $resource eq 'cpu') {
        $last_cpu_act = $arg;
    }


    if ($type eq 'single_chg' or $type eq 'multi_chg') {
        $to_ctx = $arg;
    } else {
        next;
    }
    $seen_ctx{$to_ctx} = 1;
    if (!defined $seen_resource{$resource}) {
        $seen_resource{$resource} = $resource_index++;
    }
    #print "$_\n";
    #if (!defined $log{$resource}) {
    #    push @{$log{$resource}},[0,0,$from_ctx,'normal'];
    #}
    if ($logtime) {
       if (defined $last_time) {
          $delta_time = $time - $last_time;
          $last_time = $time;
          $ldt = log($delta_time);
          $conv_time = $last_conv_time + $ldt; 
          $last_conv_time = $conv_time;
       } else {
          $conv_time = $time;
          $last_time = $time;
          $last_conv_time = $time;
       }
    } else {
        $conv_time = $time;
    }
    push @{$log{$resource}},[$time, $conv_time,$to_ctx,$type];
 
    if (! scalar @elog || $E - $elog[-1][2] > $I_COUNT_THRESH) {
        push @elog, [$time, $conv_time, $E];
    }
   
    #if ($type eq 'normal' && $from_ctx =~ /^int_/) {
        #$msg = "[should be a bind, or PXY context leaked to tasks]";
    #} els
    if ($subtype eq 'normal' && $to_ctx =~ /^int_/) {
        $msg = "[PXY context leaked to tasks]";
    }
    #print "entry $time res $resource ctx_change  $to_ctx $type $msg\n"; 
}
close FIN;

######################################
# Done reading, do some counting

#my ($last_time, $last_ctx);
my ($last_ctx);
undef $last_time;
undef $last_conv_time;

my %lines;
my %boxes;
my %acc;
my %total_acc;

for my $resource (keys %log) {
    undef $last_time;
    for my $entry (@{$log{$resource}}) {
        ($time,$conv_time,$to_ctx,$type) = @{$entry};
        if (defined $last_time) {
            #for stats, use real time
            $acc{$resource}{$last_ctx} += ($time - $last_time);
            $total_acc{$resource} += ($time - $last_time);
            #for plotting, use conv_time
            push @{$boxes{$resource}{$last_ctx}},
                [($last_conv_time+$conv_time)/2, $seen_resource{$resource}, $conv_time-$last_conv_time];
            push @{$lines{$last_ctx}},[$last_conv_time, $conv_time, $seen_resource{$resource}];
            #if ($type ne 'add' && $type ne 'remove' && $from_ctx ne $last_ctx) {
                #print STDERR "entry cur ctx ($from_ctx) != last ($last_ctx)\n";
            #}
        }
        $last_time = $time;
        $last_conv_time = $conv_time;
        $last_ctx = $to_ctx;
    }
}

open STAT, ">$fin.times" or die "Can't create $fin.times\n";
for my $resource (keys %acc) {
    print STAT "Total times for $resource\n========================\n";
    for my $ctx (sort {$acc{$resource}{$b} <=> $acc{$resource}{$a}} keys %{$acc{$resource}}) {
        print STAT " $ctx $acc{$resource}{$ctx} " .  ($acc{$resource}{$ctx}/$total_acc{$resource});
        if ($resource eq 'cpu') {
            print STAT " $acc_log_recs{$ctx}";
        }
        print STAT "\n";

    }
    print STAT "\n";
}
close STAT;

my (@plots);
my $index = 0;

########################
# Create the dat file
my $foutname = "$fin" . (($logtime)?"-logtime":"");

open DAT, ">$foutname.dat" or die "Can't create $foutname.dat\n";
  for my $res (sort {$seen_resource{$b} <=> $seen_resource{$a}} keys %seen_resource) {
    for my $ctx (grep {defined $boxes{$res}{$_}} keys %seen_ctx) {
        print DAT "#index $index res $res ctx $ctx\n";
        push @plots, [$res,$ctx];
        for my $box (@{$boxes{$res}{$ctx}}) {
            print DAT "$ctx $box->[0] $box->[1] $box->[2]\n";
        }
        print DAT "\n\n";
        $index++;
    }
  }
  # Record the delta icount values: conv_time, last_time, time, last_icount, icount
  # This prints the raw envelope of iCount readings
  print DAT "#index $index icount values (conv_time, last_time, time, last_icount, icount)\n";
  for (my $i = 1; $i < scalar(@elog); $i++) {
    printf DAT "%f %f %f %d %d\n", $elog[$i][1], $elog[$i-1][0], $elog[$i][0], $elog[$i-1][2], $elog[$i][2];
  }
close DAT;

########################
# Create gnuplot file
open GP, ">$foutname.gp" or die "Can't create $foutname.gp\n";

print GP "set term pdf\n";
print GP "set output '$foutname.pdf'\n";
print GP "set xlabel 'Time(ms)'\nset ylabel 'Resources'\n";
print GP "set key center tmargin horizontal\n";
if ($logtime) {
    print GP "us2ms(x) = x\n";
} else {
    print GP "us2ms(x) = x/1000.0\n";
}
#setup y axis
print GP "set ytics (";
$first = 1;
for my $resource (sort {$seen_resource{$b} <=> $seen_resource{$a}} keys %seen_resource) {
    if (!$first) {
       print GP ","; 
    } else {
        $first = 0;
    }
    print GP "\"$resource\" ". ($seen_resource{$resource}-0.5);
}
print GP ")\n";
print GP "w = 0.005\n";
#The first context plotted is also the idle one
my (%lt,$lt,$title,$last_height);
$lt = 1;
if ($plots[0][1] =~ /idle/) {
    $lt{$plots[0][1]} = "rgbcolor 'white'";
} else {
     $lt{$plots[0][1]} = $lt++;
}
print GP "plot [0:][0:5] \\\n";
print GP "h=". $seen_resource{$plots[0][0]} .", h+w w boxes fs solid lt -1 t '',\\\n";
print GP "       h-w w boxes fs solid lt rgbcolor 'white' t '',\\\n";
$last_height = $seen_resource{$plots[0][0]};
print GP "'$foutname.dat' index 0 u (us2ms(\$2)):(h-w):(us2ms(\$4)) w boxes fs solid lt $lt{$plots[0][1]} t '$plots[0][1]'";

for (my $i = 1; $i < scalar @plots; $i++) {
    if (!exists $lt{$plots[$i][1]}) {
        if ($plots[$i][1] =~ /idle/) {
            $lt{$plots[$i][1]} = "rgbcolor 'white'";
        } else {
            $lt{$plots[$i][1]} = $lt++;
        }
        $title = $plots[$i][1];
    } else {
        $title = "";
    }
    if ($seen_resource{$plots[$i][0]} != $last_height) {
       $last_height = $seen_resource{$plots[$i][0]};
       print GP ",\\\n h=$last_height, h+w w boxes fs solid lt -1 t ''";
       print GP ",\\\n       h-w w boxes fs solid lt rgbcolor 'white' t ''";
    }
    print GP ",\\\n       ''index $i u (us2ms(\$2)):(h-w):(us2ms(\$4)) w boxes fs solid lt $lt{$plots[$i][1]} t '$title'";
}

print GP "\n";
close GP;

`gnuplot $foutname.gp`;


