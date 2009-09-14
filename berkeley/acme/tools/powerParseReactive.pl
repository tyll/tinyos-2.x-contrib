#!/usr/bin/perl

$|=1;

# 00 FF FF 00 01 06 00 08 00 00 00 00 00 05
# 00 FF FF 00 05 0A 00 08 00 00 00 00 03 5B 00 00 03 67
# 00 FF FF 01 55 12 00 08 00 00 00 00 00 8E 00 00 00 05 00 00 00 05 00 00 00 01

$offset = 0;
$error = 1;

while (<STDIN>) {
  chomp;
  @line = split(/\s/);

#  print @line;
#  print "\n";

@time = localtime(time);

  $size = @line;
  if (/^00/ && ($size==26) && (@line[7]=='08')) {

	$id = hex(@line[4]);
    $power = hex(@line[13])+hex(@line[12])*(2**8)+hex(@line[11])*(2**16);
    $apower = hex(@line[17])+hex(@line[16])*(2**8)+hex(@line[15])*(2**16);
    $vapower = hex(@line[21])+hex(@line[20])*(2**8)+hex(@line[19])*(2**16);
    $varpower = hex(@line[25])+hex(@line[24])*(2**8)+hex(@line[23])*(2**16);

    $newpower = $power-$offset;
	$newapower = $apower-$offset;
	$newvapower = $vapower-$offset;
	$newvarpower = $varpower-$offset;
	
   # if (abs($newpower) <= $error) {
   #   $newpower = 0;
   # }
   # 
   # if (abs($newrpower) <= $error) {
   #   $newrpower = 0;
   # }
    
    $newpower = $newpower/22.84;
	# $newrpower = $newrpower/23.2;
	$pf = $newapower/$newvapower;
	
# $newpower = $power;

#	print "Old power = ";
#print $power;
#print "\n";
#    print "Power = ";


# print "@time[3] ";
# print "@time[2] ";
# print "@time[1] ";
# print "@time[0] ";
# print " ";

print $id;
# print " ";
# print $power;
print " ";
print $newpower;
# print " ";
# print $newrpower;
print " ";
print $pf;
print "\n";
  }
}
