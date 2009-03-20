
sub min {
    my $a = shift; my $b = shift;
    return ($a > $b) ? $b : $a;
}
sub max {
    my $a = shift; my $b = shift;
    return ($a <= $b) ? $b : $a;
}

$ARGV[0] =~ m/flows-(\d+)-/;
my $nflows = $1;

open(FP, "sh proc_flow.sh $ARGV[0] | perl proc_flow.pl |") || die($!);
my $success_flows = 0;
my $total_flows = 0;
my $total_tx;

my %uniq_flows;

while (<FP>) {
    my @a = split /\t/;

    $total_flows ++;
    $success_flows += $a[0];
    $total_tx += $a[3]; # if ($a[0]);

    my $key = min($a[1], $a[2]) . "-" . max($a[1], $a[2]);
    $uniq_flows{$key}->{$a[4]} = 1;
}

for $i (keys(%uniq_flows)) {
    #print $i . "\t";
    $fc = 0;
    for $j (keys(%{$uniq_flows{$i}})) {
        $fc++;
    }
    #qprint "$fc\n";
}

print keys(%uniq_flows) . "\t";
print ($total_tx / $total_flows);
print "\t";
print ($success_flows / $total_flows);
print "\n";

