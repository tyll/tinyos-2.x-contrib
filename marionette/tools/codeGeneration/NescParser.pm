# "Copyright (c) 2000-2003 The Regents of the University of California.  
# All rights reserved.
#
# Permission to use, copy, modify, and distribute this software and its
# documentation for any purpose, without fee, and without written agreement
# is hereby granted, provided that the above copyright notice, the following
# two paragraphs and the author appear in all copies of this software.
# 
# IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
# DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
# OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
# OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
# ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
# PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
#
# @author Kamin Whitehouse 
#

package NescParser;

use FindBin;
use lib $FindBin::Bin;
use SlurpFile;
use NescProgramFiles;
use FindInclude;
use XML::Simple;
use Data::Dumper;

##############################
#
##############################

sub getStructs {

##############################
# The return type of this function is an hashref of hashrefs:
#
# @structs--->
#
##############################

    my $nescXml = shift @_;
    if (scalar @_) {
	die "ERROR: too many arguments to NescParse::getStructs";
    }

    #load the xml file into memory
    open (NESCXML, $nescXml) || die "couldn't open $file!";
    undef $/;
    my $xmlText = <NESCXML>;
    close(NESCXML);

    #create a new xml parser
    my $xs1 = XML::Simple->new();

    #create the array of structs
    my @structs = ();

    #parsing the entire xml file is broken and slow anyway...
    # ...let's manually find and parse only necessary pieces
    while ( $xmlText =~ m|<struct .*?</struct>|sg ){ 
	my $structXML = $&;

        # hack, remove nesc mangling prefixing
        $structXML =~ s/__nesc_keyword_//g;

	my $struct = $xs1->XMLin($structXML, KeyAttr=>['key','id'], ForceArray=>['attribute-value','structured-element','function']);
	
	if ( (exists($struct->{'name'})) && (exists($struct->{'size'})) && ($struct->{'size'} =~ m/^\w:\d+$/ )) {
	    push(@structs, $struct);
	}
    }
#    print "there are %d structs\n\n",scalar @structs;
    return \@structs;
}


##############################
# The following functions parse the nesc.xml and program files and generate arrays
# that represent nesC interfaces, modules, and configurations.  Each
#such object is stored in a hashref.
#
# This code needs to use both the nesc.xml file and parse the actual
#program files because nesc.xml is yet incomplete: it does not provide
#function argument names, nor does it describe provided or used functions.
# example usage:
# NescParser::getInterfaces("-I../contrib/hood/tos/lib/Registry", "TestRegistryC.nc");
##############################

sub getInterfaces {

##############################
# The return type of this function is an array of hashrefs:
#
# %interfaces--->interfaceName--->interfaceName
#                              |->abstract
#                              |->@gparams
#                              |->functions--->function1Name--->functionType
#                                           |                |->returnType
#                                           |                |->functionName
#                                           |                |->async
#                                           |                |->%paramNum
#                                           |                        |->name
#                                           |                        |->type
#                                           |                        |->size
#                                           |                
#                                           -->function2Name...
#
##############################

    my $nescXml = shift @_;
    if (scalar @_) {
	die "ERROR: too many arguments to NescParse::getInterfaces";
    }

    #load the xml file into memory
    open (NESCXML, $nescXml) || die "couldn't open $file!";
    undef $/;
    my $xmlText = <NESCXML>;
    close(NESCXML);

    #create a new xml parser
    my $xs1 = XML::Simple->new();

    #create the array of interfaces
    my %interfaces = ();

    #parsing the entire xml file is broken and slow anyway...
    # ...let's manually find and parse only necessary pieces
    while ( $xmlText =~ m|<interfacedef .*?</interfacedef>|sg ){ 
	my $interfaceXML = $&;
	
	my $interfaceHash = $xs1->XMLin($interfaceXML, ForceArray=>['attribute-value','structured-element','function']);
	
	#print Dumper($interfaceHash);
	
	#now add the parsed data to the interface 
	my %interface;
	
	$interface{'interfaceName'} = $interfaceHash->{'qname'};
#	print "parsing interface: $interface{'interfaceName'}\n";

	#get the entire text of the file into memory
	my $fileLocation = $interfaceHash->{'loc'};
	$fileLocation =~ s/^.*?://;
	my $text = &SlurpFile::scrub_c_comments( &SlurpFile::slurp_file( $fileLocation ) );
	if ( $text !~ m/interface $interface{'interfaceName'}(\s)*(<.*?>)?\s*{[^}]/ ){ 
            #the last [^}] is there for emacs tabbing purposes
	    print $text;
	    die "ERROR: NescParser.pm found interface $interface{'interfaceName'} in xml file with no .nc file.";
	}
	
	#determine whether this is abstract and what the type param is
	if ($1){
	    $interface{'abstract'} = 1;
	    my @gparams = ();
	    my $gparamStr = $1;
	    $gparamStr =~ s/<//;
	    $gparamStr =~ s/>/,/;
	    while ( $gparamStr =~ m/\s*(\w+)\s*,/g ) {
		push(@gparams, $1);
	    }
	    $interface{'gparams'} = \@gparams;
	}
	else{
	    $interface{'abstract'} = 0;
	}
	my %functions;
	while ( my ($functionName, $functionXML) = each (%{$interfaceHash->{'function'}})){
	    my %function;
	    if ($text =~ /\s*async\s+/ )
	    {
		$function{'async'} = 1;
	    }
	    else
	    {
		$function{'async'} = 0;
	    }

	    if ($text =~ m/(command|event)\s+([^();,]+\s+\*?)$functionName\s*(\(.*?\));/s ) {
		$functionText = $&;
	    }
	    else{
		print $text;
		die "ERROR: found function $interface{'interfaceName'}.$functionName in .nc file that is not in xml file.";
	    }
	    
	    $function{'functionName'} = $functionName;
#	    print "parsing function: $interface{'interfaceName'}.$functionName\n";

	    #determine the function type (command|event)
	    $function{'functionType'} = $1;
	    
	    #determine the return value
 	    my $returnType = parseType($2);
 	    $function{'returnType'} = $returnType;
# 	    my $returnType = parseXmlType($functionXML->{'type-function'});
# 	    my $returnDecl = $2;
# 	    if ( $3 eq "*" or $4 eq "*" ) {
# 		$returnDecl = $returnDecl.'*';
# 	    }
# 	    $returnType->{'typeDecl'} = $returnDecl;
# 	    $function{'returnType'} = $returnType;
	    
	    
	    #parse the arguments
	    my $args = $3;
	    my %params = ();
	    my $paramNum=0;
	    while ( $args =~ m/[\(,]\s*([\w\s]+?\*?\s+\*?)(\w+)\s*(?=[,\)])/g ) {
		my %param;
		my $type = parseType ($1);
		$param{'type'} = $type;
		$param{'name'} = $2;
		$params{"param".$paramNum++} = \%param;
	    }
	    $function{'params'} = \%params;
	    $function{'numParams'} = $paramNum;

	    #add the function to the function hash
	    $functions{$functionName} = \%function;
	}
	#add the function hash to the interface
	$interface{'functions'} = \%functions;

	#now add this interface to the interface list
	$interfaces{$interface{'interfaceName'}} = \%interface;	    	
    }
    
    return \%interfaces;
}

sub getConfigurations {
    %configurations = ();
    return \%configurations;
}

sub getModules{
    %modules = ();
    return \%modules;
}



sub parseType{
###########
# this function should no be used, except that nesc.xml does not
# generate the right kind of information yet, ie this is temporary code.
#
# this function returns a hashref with four keys:
#   typeClass, eg. int, pointer, struct, etc
#   typeName, eg. unsigned char, TOS_Msg, etc.
#   typeDecl, eg. result_t*, etc
#   size
###########
    $text = shift(@_);
    my %type;

    if ($text =~ m/^(\w+(?:\s+\w+)?)/ ){
	$type{'typeName'} = $1;
    }
    else{
	die "unable to parse type: $text\n";
    }
    if ($text =~ m/\*/ ){
	$type{'typeClass'} = 'pointer';
	$type{'typeDecl'} = $type{'typeName'}."*";
    }
    else{
	$type{'typeClass'} = "unknown";
	$type{'typeDecl'} = $type{'typeName'};
    }
    return \%type;
}


sub parseXmlType{
###########
# this function returns a hashref with three keys:
#   typeClass, eg. int, pointer, struct, etc
#   typeName, eg. unsigned char, TOS_Msg, etc.
#   typeDecl, eg. result_t*, etc
#   size
###########
    $hash = shift(@_);
    my %type;

    ##void type
    if ( $hash->{'type-void'} ){
	$type{'typeClass'} = 'void';
	$type{'typeName'} = 'void';
	$type{'size'} = 0;
    }
    ##simple type
    elsif ( $hash->{'type-int'} ){
	$type{'typeClass'} = 'int';
	$type{'typeName'} = $hash->{'type-int'}->{'cname'};
	$type{'size'} = $hash->{'type-int'}->{'size'};
    }
    ##float type
    elsif ( $hash->{'type-float'} ){
	$type{'typeClass'} = 'float';
	$type{'typeName'} = $hash->{'type-float'}->{'cname'};
	$type{'size'} = $hash->{'type-float'}->{'size'};
    }
    ##struct type
    elsif( $hash->{'type-tag'}->{'struct-ref'}){
	$type{'typeClass'} = 'struct';
	$type{'typeName'} = $hash->{'type-tag'}->{'struct-ref'}->{'name'};
	$type{'size'} = $hash->{'type-tag'}->{'size'};
    }
    ##pointer type
    elsif( $hash->{'type-pointer'}){
	$type{'typeClass'} = 'pointer';
	##pointer to simple
	if( $hash->{'type-pointer'}->{'type-int'}){
	    $type{'typeName'} = $hash->{'type-pointer'}->{'type-int'}->{'cname'};
	    $type{'size'} = $hash->{'type-pointer'}->{'struct-int'}->{'size'}; 
	}
	##pointer to struct
	elsif( $hash->{'type-pointer'}->{'type-tag'}){
	    $type{'typeName'} = $hash->{'type-pointer'}->{'type-tag'}->{'struct-ref'}->{'name'};
	    $type{'size'} = $hash->{'type-pointer'}->{'type-tag'}->{'size'}; 
	}
	##pointer to void
	elsif( $hash->{'type-pointer'}->{'type-void'}){
	    $type{'typeName'} = 'void';
	    $type{'size'} = 0;
	}
    }
    if (! exists $type{'typeName'}){
	print "ERROR did not properly parse the type of this hashref:\n";
	while ( my ($key,$val) = each (%$hash) ) { print " $key => $val\n"; }
	die;
    }
    $type{'size'} =~ s/^.://;
    return \%type;
}

1;
