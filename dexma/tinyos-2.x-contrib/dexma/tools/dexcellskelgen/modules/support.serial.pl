# This is the Serial support module
my $codeconf = "";
my $codeuses = "";
my $codeimpl = "";

my $serialconf = "  //Serial support\n  components SerialActiveMessageC;\n  App.SerialControl -> SerialActiveMessageC;\n";
my $serialuses = "  //Serial support\n  uses interface SplitControl as SerialControl;\n";
my $serialimpl = "  event void SerialControl.startDone(error_t err) {\n    if (err != SUCCESS)\n      call SerialControl.start();\n    else {\n      //something to do\n    }\n  }\n\n  event void SerialControl.stopDone(error_t err) {}\n\n";


my $support = &promptUser("Do you want SERIAL support (y/n) ?");
if($support eq "y"){
  $codeconf .= $serialconf;
  $codeuses .= $serialuses;
  $codeimpl .= $serialimpl;

  while(&promptUser("Do you want to RECEIVE messages over the SERIAL (y/n) ?") eq "y"){
    my $mnum = 1;
    foreach $m ( @msgtypes )
    {
      print $mnum."-".$m."\n";
      $mnum++;
    }    
    $mnum = &promptUser("Message Number ?");
    my $mname = $msgtypes[$mnum-1];
    print $mname."\n";
    $codeconf .= "  App.SerialReceive".$mname." -> SerialActiveMessageC.Receive[AM_".uc($mname)."MSG];\n";
    $codeuses .= "  uses interface Receive as SerialReceive".$mname.";\n";
    $codeimpl .= "  event message_t* SerialReceive".$mname.".receive(message_t* msg, void* payload, uint8_t len) {\n    //something to do with the message\n    return msg;\n  }\n\n";
  }

  while(&promptUser("Do you want to SEND messages over the SERIAL (y/n) ?") eq "y"){
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
    $globalvars .= "  bool sendSerialBusy".$mname." = FALSE;\n";
    $codeconf .= "  App.SerialSend".$mname." -> SerialActiveMessageC.AMSend[AM_".uc($mname)."MSG];\n  App.SerialPacket".$mname." -> SerialActiveMessageC;\n";
    $codeuses .= "  uses interface AMSend as SerialSend".$mname.";\n  uses interface Packet as SerialPacket".$mname.";\n";
    $codeimpl .= "  void sendSerial".$mname."() {\n    ".$mname."Msg* msg = (".$mname."Msg*)call SerialSend".$mname.".getPayload(&packet);\n    //you must fill the packet\n    if (call SerialSend".$mname.".send(AM_BROADCAST_ADDR, &packet, sizeof(".$mname."Msg)) != SUCCESS)\n    {\n      //code for error\n    }\n    else\n      sendSerialBusy".$mname." = TRUE;\n  }\n\n";
    $codeimpl .= "  event void SerialSend".$mname.".sendDone(message_t* m, error_t err) {\n    if (err != SUCCESS)\n      //what to do if fails;\n    sendSerialBusy".$mname." = FALSE;\n  }\n\n";
  }

  $cconf = $codeconf."\n";
  $cuses = $codeuses."\n";
  $cimpl = $codeimpl."\n";
}
1;
