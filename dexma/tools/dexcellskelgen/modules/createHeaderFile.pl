sub createHeaderFile {

  #creating msg types
  @msgtypes = ();
  while(&promptUser("Create Msg types? (y/n)", "y") eq "y"){
    push(@msgtypes, ucfirst(&promptUser("Msg name?")));
    $i++;
  }

  #creating constants
  my %constants = ();
  while(&promptUser("Create Constants (y/n)", "y") eq "y"){
    $name = &promptUser("Constant name?");
    $value = &promptUser("Constant value?");
    $constants{$name} = $value;
  }

  #creating disseminated values
  @disvalues = ();
  while(&promptUser("Create Values to be Disseminated? (y/n)", "y") eq "y"){
    push(@disvalues, ucfirst(&promptUser("Value name?")));
  }
  

  my $code;
  open(TMP, "modules/licenseheader.txt");
  while($line = <TMP>){
    $code = $code.$line;
  }

  $code .= "#ifndef ".uc($projectname)."_H\n#define ".uc($projectname)."_H\n\n";

  foreach $m ( @msgtypes )
  {
    $code .= "typedef nx_struct ".ucfirst($m)."Msg {\n  nx_uint16_t attr1;\n  nx_uint16_t attr2;\n} ".ucfirst($m)."Msg;\n\n";
  }

  $code .= "enum {\n";

  my $msgnumber = 100;
  foreach $m ( @msgtypes )
  {
    $code .= "  AM_".uc($m)."MSG = ".$msgnumber.",\n";
    $msgnumber++;
  }

  my $disvaluenumber = 0x1000;
  foreach $m ( @disvalues )
  {
    $code .= "  DISSEMINATIONVALUE".uc($m)." = ".$disvaluenumber.",\n";
    $disvaluenumber++;
  }


  foreach $k (keys (%constants))
  {
    $code .= "  ".uc($k)." = ".$constants{$k}.",\n";
  }

  $code .= "};\n\n#endif\n";

  return $code;
}
1;
