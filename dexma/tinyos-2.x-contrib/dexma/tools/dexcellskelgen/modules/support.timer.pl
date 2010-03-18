# This is the Timer support module
my $codeconf = "";
my $codeuses = "";
my $codeimpl = "";

my $support = &promptUser("Do you want TIMER support (y/n) ?");
if($support eq "y"){
  #creating timers 
  while(&promptUser("Create Timer (y/n)", "y") eq "y"){
    my $timername = &promptUser("Timer name?");
    my $timerdeclaration ="  //Timer".$timername." Support\n  components new TimerMilliC() as Timer".$timername.";\n  App.Timer".$timername." -> Timer".$timername.";\n\n";
    my $timeruses = "  //Timer".$timername." support\n  uses interface Timer<TMilli> as Timer".$timername.";\n\n";
    my $timercode = "  //Timer".$timername." support\n  event void Timer".$timername.".fired() {\n    //Timer".$timername." action\n  }\n\n";
    $codeconf .= $timerdeclaration;
    $codeuses .= $timeruses;
    $codeimpl .= $timercode;    
  }
  $cconf = $codeconf;
  $cuses = $codeuses;
  $cimpl = $codeimpl;
}
1;
