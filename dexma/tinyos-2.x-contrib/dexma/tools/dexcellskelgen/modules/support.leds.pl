# This is the Leds support module
my $codeconf = "  //leds support;\n  components LedsC;\n  App.Leds -> LedsC;\n\n";
my $codeuses = "  //Leds support\n  uses interface Leds;\n\n";
my $codeimpl = "";

my $support = &promptUser("Do you want LEDS support (y/n) ?");
if($support eq "y"){
  $cconf = $codeconf;
  $cuses = $codeuses;
  $cimpl = $codeimpl;
}
1;
