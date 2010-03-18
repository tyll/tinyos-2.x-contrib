# This is the Radio support module
my $codeconfiguration = "  //Radio support\n  components ActiveMessageC;\n  App.RadioControl -> ActiveMessageC;\n\n";
my $codeuses = "  //Radio support\n  uses interface SplitControl as RadioControl;\n\n";
my $codeimplementation = "  //Radio support\n  event void RadioControl.startDone(error_t err) {\n    if (err != SUCCESS)\n      call RadioControl.start();\n    else {\n      //something to do\n    }\n  }\n\n  event void RadioControl.stopDone(error_t err) {}\n\n";

my $support = &promptUser("Do you want RADIO support (y/n) ?");
if($support eq "y"){
  $cconf = $codeconfiguration;
  $cuses = $codeuses;
  $cimpl = $codeimplementation;
  $networkingsupport = true;
  $radiosupport = true;
}
1;
