# This is the dissemination support module
my $codeconf = "";
my $codeuses = "";
my $codeimpl = "";

my $collectconf = "  //Dissemination support\n  components DisseminationC;\n  App.DisseminationControl -> DisseminationC;\n\n";
my $collectuses = "  //Dissemination support\n  uses interface StdControl as DisseminationControl;\n\n";
my $collectimpl = "  //Dissemination support\n";

if($networkingsupport eq true) 
{

my $support = &promptUser("Do you want DISSEMINATION support (y/n) ?");
if($support eq "y"){
  $codeconf .= $collectconf;
  $codeuses .= $collectuses;
  $codeimpl .= $collectimpl;

  foreach $value ( @disvalues )
  {
    if(&promptUser("Do you want to DISSEMINATION SUPPORT FOR ".$value."(y/n) ?") eq "y")
    {
      $codeconf .= "  components new DisseminatorC(uint16_t, DISSEMINATIONVALUE".uc($value).") as DisseminationValue".$value.";\n";
      if(&promptUser("Do you want to UPDATE Disseminated value ".$value." messages over Dissemination protocol(y/n) ?") eq "y")
      {
        $codeconf .= "  App.UpdateDisseminationValue".$value." -> DisseminationValue".$value.";\n";
	$codeuses .= "  uses interface DisseminationUpdate<uint16_t> as UpdateDisseminationValue".$value.";\n";
      }
      if(&promptUser("Do you want to RECEIVE Disseminated value ".$value." messages over Dissemination protocol(y/n) ?") eq "y")
      {
        $codeconf .= "  App.ValueDisseminationValue".$value." -> DisseminationValue".$value."\n";
	$codeuses .= "  uses interface DisseminationValue<uint16_t> as ValueDisseminationValue".$value.";\n";
        $codeimpl .= "  event void ValueDisseminationValue".$value.".changed() {\n    const uint16_t* newVal = call ValueDisseminationValue".$value.".get();\n    //what to do\n  }\n\n";
      }
    }
  }    

  $cconf = $codeconf."\n";
  $cuses = $codeuses."\n";
  $cimpl = $codeimpl."\n";
}

}
1;
