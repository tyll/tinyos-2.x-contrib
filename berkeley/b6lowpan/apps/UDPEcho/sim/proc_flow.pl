

my $str_len = 0, my $fl_start = 0, my $fl_end = 0, my $rx = 0;
my @a, my @ap;

while (<STDIN>) {
    strip;
    @a = split /[ \t\n]+/;
    if ($a[0] == $ap[0] &&
        $a[1] == $ap[1] &&
        $a[2] == $ap[2] && 
        $a[4] >= 0) {
        # within a single packet stream
        $str_len ++;
        $fl_start = $a[0];
        $fl_end = $a[1];
        $fl_seq = $a[2];

        $fl_prot = $a[4];
        if (@a == 7) {
            if ($fl_end == $a[6]) {
                $rx = 1;
            }
        } else {
            if ($fl_end == $a[5]) {
                $rx = 1;
            }
        }
    } else {
        if ($str_len > 0 && $fl_end != 100) {
            printf("$rx\t$fl_start\t$fl_end\t$str_len\t$fl_seq\n");
        }
        $str_len = 0;
        $fl_end = 0;
        $rx = 0;
    }
    @ap = @a;
}
