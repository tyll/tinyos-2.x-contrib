# This is the networking support module
my $codeconf = "";
my $codeuses = "";
my $codeimpl = "";

my $netconf = "";
my $netuses = "";
my $netimpl = "";

if($networkingsupport eq true) 
{

my $support = &promptUser("Do you want NETWORKING support (y/n) ?");
if($support eq "y"){
  $codeconf .= $netconf;
  $codeuses .= $netuses;
  $codeimpl .= $netimpl;

  while(&promptUser("Do you want to RECEIVE messages over the RADIO (y/n) ?") eq "y"){
    my $mnum = 1;
    foreach $m ( @msgtypes )
    {
      print $mnum."-".$m."\n";
      $mnum++;
    }    
    $mnum = &promptUser("Message Number ?");
    my $mname = $msgtypes[$mnum-1];
    print $mname."\n";
    $codeconf .= "  App.RadioReceive".$mname." -> ActiveMessageC.Receive[AM_".uc($mname)."MSG];\n";
    $codeuses .= "  uses interface Receive as RadioReceive".$mname.";\n";
    $codeimpl .= "  event message_t* RadioReceive".$mname.".receive(message_t* msg, void* payload, uint8_t len) {\n    //something to do with the message\n    return msg;\n  }\n\n";
  }

  while(&promptUser("Do you want to SEND messages over the RADIO (y/n) ?") eq "y"){
    my $mnum = 1;
    foreach $m ( @msgtypes )
    {
      print $mnum."-".$m."\n";
      $mnum++;
    }    
    $mnum = &promptUser("Message Number ?");
    my $mname = $msgtypes[$mnum-1];
    print $mname."\n";
    #REMEMBER TO ACTIVATE VARIABLES FOR SENDBUSY
    $globalvars .= "  bool sendRadioBusy".$mname." = FALSE;\n  message_t ".$mname."packet;\n";
    $codeconf .= "  App.RadioSend".$mname." -> ActiveMessageC.AMSend[AM_".uc($mname)."MSG];\n  App.RadioPacket".$mname." -> ActiveMessageC;";
    $codeuses .= "  uses interface AMSend as RadioSend".$mname.";\n  uses interface Packet as RadioPacket".$mname.";\n";
    $codeimpl .= "  void sendRadio".$mname."() {\n    ".$mname."Msg* msg = (".$mname."Msg*)call RadioSend".$mname.".getPayload(&".$mname."packet);\n    //you must fill the packet\n    if (call RadioSend".$mname.".send(AM_BROADCAST_ADDR, &".$mname."packet, sizeof(".$mname."Msg)) != SUCCESS)\n    {\n      //code for error\n    }\n    else\n      sendRadioBusy".$mname." = TRUE;\n  }\n\n";
    $codeimpl .= "  event void RadioSend".$mname.".sendDone(message_t* m, error_t err) {\n    if (err != SUCCESS)\n      //what to do if fails;\n    sendRadioBusy".$mname." = FALSE;\n}\n\n";
  }

  $cconf = $codeconf."\n";
  $cuses = $codeuses."\n";
  $cimpl = $codeimpl."\n";
}

}
1;
