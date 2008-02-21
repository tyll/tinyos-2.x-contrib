
sub createConfigurationHeader {
  my($appname) = @_;
  print "creating files for $appname\n";
  my $code;
  open(TMP, "modules/licenseconfiguration.txt");
  while($line = <TMP>){
    $code = $code.$line;
  }
  $code = $code."\n#include \"../".$projectname.".h\"\n\nconfiguration ".$appname."AppC { }\nimplementation\n{\n  components MainC, ".$appname."C as App;\n  App.Boot->MainC.Boot;\n\n";
  return $code;
}

sub createConfigurationFooter {
  my $code = "\n}\n";
  return $code;
}


sub createApplicationHeader {
  my($appname) = @_;
  print "creating files for $appname\n";
  my $code;
  open(TMP, "modules/licenseimplementation.txt");
  while($line = <TMP>){
    $code = $code.$line;
  }
  $code = $code."module ".$appname."C\n{\n  uses interface Boot;\n\n";
  return $code;
}

sub createApplicationMiddle {
  my($vars) = @_;
  my $code = "\n}\nimplementation\n{\n  /* variable declaration */\n";
  $code .= $vars."\n\n";
  $code .= "  event void Boot.booted() {\n    //code to start\n  }\n\n";
  return $code;
}

sub createApplicationFooter {
  my $code = "\n}\n";
  return $code;
}

sub createApplication {
 my($appname) = @_;
 my $bodycodeconf = "";
 my $bodycodeuses = "";
 my $bodycodeimpl = "";
 print "we are going to create $appname application\n";
 print "please aks questions\n";
 $globalvars = "";
 #PACKET GLOBAL VARS
 $networkingsupport = "";
 $radiosupport = "";

 my @supportmodules = glob("modules/support.*.pl");
  foreach (@supportmodules) {
  print "processing ".$_."\n";
  $cconf = "";
  $cuses = "";
  $cimpl = "";
  do $_;
  $bodycodeconf = $bodycodeconf.$cconf;
  $bodycodeuses = $bodycodeuses.$cuses;
  $bodycodeimpl = $bodycodeimpl.$cimpl;
 }

 system("mkdir $projectfolder/$appname");

 open(APPCONFIG, "> ".$projectfolder."/".$appname."/".$appname."AppC.nc") or die $!;
 print APPCONFIG &createConfigurationHeader($appname);
 print APPCONFIG $bodycodeconf;
 print APPCONFIG &createConfigurationFooter($appname);
 close APPCONFIG;

 open(APPCODE, "> ".$projectfolder."/".$appname."/".$appname."C.nc") or die $!;
 print APPCODE &createApplicationHeader($appname);
 print APPCODE $bodycodeuses;
 print APPCODE &createApplicationMiddle($globalvars);
 print APPCODE $bodycodeimpl;
 print APPCODE &createApplicationFooter($appname);
 close APPCODE;

 #creating application makefile
 my $mkcode;
 $mkcode .= "COMPONENT=".$appname."AppC\n";
 $mkcode .= "CFLAGS += \\\n";
 if($printfsupport eq true){
   $mkcode .= "     -I\$(TOSDIR)/lib/printf \\\n";
 }
 if($networkingsupport eq true){
   $mkcode .= "     -I\$(TOSDIR)/lib/net \\\n";
 }
 if($collectionsupport eq true){
   $mkcode .= "     -I\$(TOSDIR)/lib/net/le \\\n     -I\$(TOSDIR)/lib/net/ctp \\\n";
 }
 if($lowpowersupport eq true){
   $mkcode .= "     -I\$(TOSDIR)/chips/cc2420_lpl \\\n     -DLOW_POWER_LISTENING\n";
 }

 $mkcode .= "\n";

 $mkcode .= "include \$(MAKERULES)";

 open(APPMAKE, "> $projectfolder/$appname/Makefile") or die $!;
 print APPMAKE $mkcode;
 close APPMAKE;

 print "application $appname created\n";
}
1;
