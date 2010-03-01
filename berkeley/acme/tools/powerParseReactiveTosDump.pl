#!/usr/bin/perl

$|=1;

# 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 39, 0, 0, 0, 0
# src | energy    | laenergy  | lvaenergy   | lvarenergy

$offset = 0;
$error = 1;


# Declare the subroutines
sub trim($);
sub ltrim($);
sub rtrim($);


while (<STDIN>) {
	chomp;
	
	if (/\[(.*)\]/) {
#		print "$1\n";
		@line = split(/[, ]+/,$1);
		$energy = trim(@line[2])*(2**24)+trim(@line[3])*(2**16)+trim(@line[4])*(2**8)+trim(@line[5]);
		$laenergy = trim(@line[6])*(2**24)+trim(@line[7])*(2**16)+trim(@line[8])*(2**8)+trim(@line[9]);
		$lvaenergy = trim(@line[10])*(2**24)+trim(@line[11])*(2**16)+trim(@line[12])*(2**8)+trim(@line[13]);
		$lvarenergy = trim(@line[14])*(2**24)+trim(@line[15])*(2**16)+trim(@line[16])*(2**8)+trim(@line[17]);
		$eui = join(":", @line[18..25]);
		# $energy = $energy/33;
		# $lvaenergy = $lvaenergy/28;

		# if ($energy > $lvaenergy) {
		# 	$lvaenergy = $energy;
		# }
		# 
		# if ($lvaenergy != 0) {
		# 	$PF = $energy/$lvaenergy;
		# } else {
		# 	$PF = 0;
		# }
		#print "$energy\t$laenergy\t$lvaenergy\t$lvarenergy\t$PF\n";
		
		$PF = 0;
		print "$energy\t$lvaenergy\t$PF\t$eui\n";
	}
}


# Perl trim function to remove whitespace from the start and end of the string
sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}
# Left trim function to remove leading whitespace
sub ltrim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	return $string;
}
# Right trim function to remove trailing whitespace
sub rtrim($)
{
	my $string = shift;
	$string =~ s/\s+$//;
	return $string;
}
