#!/usr/bin/perl

$|=1;

# 00 FF FF 00 01 06 00 08 00 00 00 00 00 05

$offset = 0;
$error = 1;

while (<STDIN>) {
  chomp;
  @line = split(/\s/);

#  print @line;
#  print "\n";

@time = localtime(time);

  $size = @line;
  if (/^00/ && ($size==14) && (@line[7]=='08')) {

	$id = hex(@line[4]);
    $power = hex(@line[13])+hex(@line[12])*(2**8)+hex(@line[11])*(2**16);

    $newpower = $power-$offset;
    if (abs($newpower) <= $error) {
      $newpower = 0;
    }

    
    $newpower = $newpower/23.2;
# $newpower = $power;

#	print "Old power = ";
#print $power;
#print "\n";
#    print "Power = ";
print "@time[3] ";
print "@time[2] ";
print "@time[1] ";
print "@time[0] ";
print " ";

print $id;
print " ";
print $power;
print " ";
print $newpower;
print "\n";
  }
}
