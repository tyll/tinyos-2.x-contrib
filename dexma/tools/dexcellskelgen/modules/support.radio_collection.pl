# This is the collection support module
my $codeconf = "";
my $codeuses = "";
my $codeimpl = "";

my $collectconf = "  //Collection support\n";
my $collectuses = "  //Collection support\n";
my $collectimpl = "  //Collection support\n";

if($networkingsupport eq true) 
{

my $support = &promptUser("Do you want COLLECTION support (y/n) ?");
if($support eq "y"){
  $codeconf .= $collectconf;
  $codeuses .= $collectuses;
  $codeimpl .= $collectimpl;
  $collectionsupport = true;

  foreach $m ( @msgtypes )
  {
    if(&promptUser("Do you want to COLLECTION SUPPORT FOR ".$m."(y/n) ?") eq "y")
    {
      $codeconf .= "  components CollectionC as Collector".$m.";\n  components new CollectionSenderC(AM_".uc($m)."MSG) as CollectionSender".$m.";\n  App.RoutingControl".$m." -> Collector".$m.";\n";
      $codeuses .= "  uses interface StdControl as RoutingControl".$m.";\n";
      if(&promptUser("Do you want to SEND ".$m." messages over Collection protocol(y/n) ?") eq "y")
      {
        $globalvars .= "  bool sendCollectionBusy".$m." = FALSE;\n  message_t ".$m."packet;\n";
        $codeconf .= "  App.CollectionSend".$m." -> CollectionSender".$m.";\n";
        $codeuses .= "  uses interface Send as CollectionSend".$m.";\n\n";
        $codeimpl .= "  void sendCollection".$m."() {\n    ".$m."Msg* msg = (".$m."Msg*)call CollectionSend".$m.".getPayload(&".$m."packet);
    //you must fill the packet\n    if (call CollectionSend".$m.".send(&".$m."packet, sizeof(".$m."Msg)) != SUCCESS)\n    {\n      //code for error\n    }\n    else\n      sendCollectionBusy".$m." = TRUE;\n  }\n\n";
        $codeimpl .= "  event void CollectionSend".$m.".sendDone(message_t* m, error_t err) {\n    if (err != SUCCESS)\n      //what to do in case of error\n    sendCollectionBusy".$m." = FALSE;\n  }\n\n";
      }
      if(&promptUser("Do you want to RECEIVE ".$m." messages over Collection protocol(y/n) ?") eq "y")
      {
        $codeconf .= "  App.RootControl".$m." -> Collector".$m.";\n  App.CollectionReceive".$m." -> Collector".$m.".Receive[AM_".uc($m)."MSG];\n\n";
        $codeuses .= "  uses interface RootControl as RootControl".$m.";\n  uses interface Receive as CollectionReceive".$m.";\n\n";
        $codeimpl .= "  event message_t* CollectionReceive".$m.".receive(message_t* msg, void* payload, uint8_t len) {\n    //something to do with the message\n    return msg;\n  }\n\n";
      }
    }
  }    

  $cconf = $codeconf."\n";
  $cuses = $codeuses."\n";
  $cimpl = $codeimpl."\n";
}

}
1;
