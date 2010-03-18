sub createHeaderFile {

  my $code;
  open(TMP, "modules/licenseheader.txt");
  while($line = <TMP>){
    $code = $code.$line;
  }

  foreach $m ( @msgtypes )
  {
    $code .= "typedef nx_struct ".ucfirst($m)."Msg {\n  nx_uint16_t attr1;\n  nx_uint16_t attr2;\n} ".ucfirst($m)."Msg;\n\n";
  }

  return $code;
}
1;
