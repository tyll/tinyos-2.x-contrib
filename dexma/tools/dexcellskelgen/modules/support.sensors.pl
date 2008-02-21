# This is the Leds support module
my $codeconf = "";
my $codeuses = "";
my $codeimpl = "";

my $sensorssupport = "  //Sensing support\n";
my $sensirionconf = "  components new SensirionSht11C() as TemperatureSensor;\n";
my $tempconf = "  App.Temperature -> TemperatureSensor.Temperature;\n";
my $tempuses = "  uses interface Read<uint16_t> as Temperature;\n";
my $tempcode = "  event void Temperature.readDone(error_t result, uint16_t data)\n  {\n    if (result == SUCCESS){\n      //something to do with data\n    }\n    else { call Temperature.read(); }\n  }\n";

my $humiconf = "  App.Humidity -> TemperatureSensor.Humidity;\n";
my $humiuses = "  uses interface Read<uint16_t> as Humidity;\n";
my $humicode = "  event void Humidity.readDone(error_t result, uint16_t data)\n  {\n    if (result == SUCCESS){\n      //something to do with data\n    }\n    else { call Humidity.read(); }\n  }\n";

my $ivolconf = "  components new Msp430InternalVoltageC() as InternalVoltageSensor;\n  App.InternalVoltage -> InternalVoltageSensor;\n";
my $ivoluses = "  uses interface Read<uint16_t> as InternalVoltage;\n";
my $ivolcode = "  event void InternalVoltage.readDone(error_t result, uint16_t data)\n  {\n    if (result == SUCCESS){\n      //something to do with data\n    }\n    else { call InternalVoltage.read(); }\n  }\n";

my $itempconf = "  components new Msp430InternalTemperatureC() as InternalTemperatureSensor;\n  App.InternalTemperature -> InternalTemperatureSensor;\n";
my $itempuses = "  uses interface Read<uint16_t> as InternalTemperature;\n";
my $itempcode = "  event void InternalTemperature.readDone(error_t result, uint16_t data)\n  {\n    if (result == SUCCESS){\n      //something to do with data\n    }\n    else { call InternalTemperature.read(); }\n  }\n";

my $support = &promptUser("Do you want SENSOR support (y/n) ?");
if($support eq "y"){
  my $sensirionsupport = false;

  $codeconf .= $sensorssupport;
  $codeuses .= $sensorssupport;
  $codeimpl .= $sensorssupport;

  #temperature support
  if(&promptUser("Do you want TEMPERATURE SENSING support (y/n) ?") eq "y"){
    $sensirionsupport = true;
    $codeconf .= $sensirionconf.$tempconf;
    $codeuses .= $tempuses;
    $codeimpl .= $tempcode;
  }

  #humidity support
  if(&promptUser("Do you want HUMIDITY SENSING support (y/n) ?") eq "y"){
    if($sensirionsupport eq false) { $codeconf .= $sensirionconf.$humiconf; }
    else { $codeconf .= $humiconf; }
    $codeuses .= $humiuses;
    $codeimpl .= $humicode;
  }

  #internal temperature support
  if(&promptUser("Do you want INTERNAL TEMPERATURE SENSING support (y/n) ?") eq "y"){
    $codeconf .= $itempconf;
    $codeuses .= $itempuses;
    $codeimpl .= $itempcode;
  }

  #internal voltage support
  if(&promptUser("Do you want INTERNAL VOLTAGE SENSING support (y/n) ?") eq "y"){
    $codeconf .= $ivolconf;
    $codeuses .= $ivoluses;
    $codeimpl .= $ivolcode;
  }

  $cconf = $codeconf."\n";
  $cuses = $codeuses."\n";
  $cimpl = $codeimpl."\n";

}
1;
