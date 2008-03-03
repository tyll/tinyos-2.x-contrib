package SlurpFile;

sub slurp_file {
  my ($file) = @_;
  return "" unless defined $file;
  my $fh;
  open $fh, "< $file" or die "ERROR, module file $file, $!, aborting.\n";
  my $text = do { local $/; <$fh> };
  close $fh;
  return $text;
}


sub dump_file {
  my ($file,$text) = @_;
  my $fh;
  open $fh, "> $file" or die "ERROR, writing file $file, $!, aborting.\n";
  print $fh $text;
  close $fh;
  1;
}

sub scrub_c_comments {
  my $text = shift;
  $text =~ s{/\*.*?\*/}{}gs;
  $text =~ s{//.*?\n}{}g;
  return $text;
}

1;


