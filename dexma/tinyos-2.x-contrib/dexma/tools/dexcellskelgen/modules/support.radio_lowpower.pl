# This is the Radio support module
my $codeconfiguration = "  //LowPowerRadio support\n  components CC2420ActiveMessageC as LplRadio;\n  App.LowPowerListening -> LplRadio;\n\n";
my $codeuses = "  //LowPowerRadio support\n  uses interface LowPowerListening;\n\n";
my $codeimplementation = "";

if($networkingsupport eq true){
  my $support = &promptUser("Do you want LOW POWER RADIO support (y/n) ?");
  if($support eq "y"){
    $cconf = $codeconfiguration;
    $cuses = $codeuses;
    $cimpl = $codeimplementation;
    $lowpowersupport = true;
  }
}
1;
