
$ndist = 0;
$tdist = 0;
while (<STDIN>) {
    my @a = split;
    my $n1 = $a[0]; my $n2 = $a[1];
    $n1 = 0 if ($n1 == 225);
    $n2 = 0 if ($n2 == 225);

    $x1 = $n1 % 15;
    $x2 = $n2 % 15;

    $y1 = int($n1 / 15);
    $y2 = int($n2 / 15);

    $dist = sqrt(($x2 - $x1) ** 2 + ($y2 - $y1) ** 2);
    $tdist += $dist;
    $ndist ++;

    print "$n1 ($x1, $y1), $n2 ($x2, $y2), $dist\n";
}

print $ndist;
print "\t";
print ($tdist / $ndist);
print "\n";
