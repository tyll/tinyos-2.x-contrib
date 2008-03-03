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


package AtTags;

use FindBin;
use lib $FindBin::Bin;
use SlurpFile;
use NescProgramFiles;
use FindInclude;
use NescParser;

my $tagName;
my @tagFields;

##############################
# Parse the program files and generate a @interfaces array of hashrefs,
# where each hashref represents some tagged interface.
# 
# This takes four arguments: 
# $includes are the set of compiler include directives
# $file is the top-level nesC application file 
# $tagName is the name of the @tag
# @tagFields is an array of the fieldnames of the @$tagName struct
#
# The function returns an arrayref of hashrefs, where each hashref
# represents the data about a different instance of an interface with
# that @tag
#
# example usage:
#AtTags::getTaggedInterfaces("-I../contrib/hood/tos/lib/Registry", "TestRegistryC.nc", "attr",("attrName","attrNum");
# will return all interfaces in the "TestRegistryC" app, including
#files in contrib/hood/tos/lib/Registry, with @attr("name", 10) tags,
#if @attr is defined as struct {char* attrName; uint16_t attrNum;}
##############################

sub getTaggedInterfaces {

##############################
# The return type of this function is an array of hashrefs:
# (We also return a list of files included where interfaces were tagged)
#
# @interfaces--->%interface1--->componentName
#                            |->interfaceType eg. the name declared in interfaceType.nc
#                            |->interfaceName eg. the alias " as interfaceName"
#                            |->@gparams 
#                            |->provided (==1 if provided, 0 if used)
#                            |->tagField1 (the name/values of the tag params)
#                            |->tagField2
##############################

    @_ = &FindInclude::parse_include_opts( @_ ); #get rid of includes
    my $file = shift @_;
    ($tagName, @tagFields) = @_;

    #convert the tagFields array to a hashTable
    my %tagFields;
    for $t (@tagFields){
	$tagFields{"$t"} = 1;
    }

    #get names of all application files in include path
    my %files = NescProgramFiles::getProgramFiles($file);


    #the hash table of interfaces
    my @interfaces = ();
    
    #the hash table of include files
    my %includeFiles = ();
    
    #go through each application file and find the desired @tags and
    #parse the line
    for $file (keys %files){
	($component) = ($file =~ m|/(\w+?)\.nc$|);
	my $text = &SlurpFile::scrub_c_comments( &SlurpFile::slurp_file( $file ) );
	my @includes = $text =~ m/^\s*(includes\s+\w+;)/mg;
	while ( $text =~
		   m/interface\s+(\w+)(?:<(\w+)>)?(?:\s+as\s+(\w+))?\s+\@$tagName\((.*?)\)/sg
		   ) {
	    $prelude = $`;

	    #define an interface with these properties
	    my %interface;
	    $interface{'componentName'} = $component;
	    $interface{'interfaceType'} = $1;
	    if ($3) {
		$interface{'interfaceName'} = $3;
	    }
	    else{
		$interface{'interfaceName'} = $1;
	    }
	    $gparamStr = "";
	    if ($2){
		$gparamStr = $2.",";
	    }
	    $tagFieldValues = $4;

	    #parse the abstract interface gparams:
	    my @gparams = ();
	    while ( $gparamStr =~ m/\s*(\w+)\s*,/g ) {
		push(@gparams, $1);
	    }
	    $interface{'gparams'} = \@gparams;
	    
	    #parse the @tags args:
	    $tagFieldValues =~ s/"//g; #get rid of "
	    $tagField = 0;
	    while ($tagFieldValues =~ m/\s*([^,\s]+)/g) {
#		print $tagFieldValues.",".scalar @tagFields.",".$tagField;
		if (scalar @tagFields > $tagField){
		    $interface{$tagFields[$tagField++]} = $1;
		}
		else{
		    die ("Error: too many arguments to \@$tagName in $interface{'componentName'}.\n");
		}
	    }
#	    if (scalar @tagFields != $tagField){
#		die ("Error: not enough arguments to \@$tagName in  $interface{'componentName'}.\n");
#	    }		

	    #figure out if this was used or provided
	    while ($prelude =~ m/(uses|provides)/sg ) {
		if ($1 eq "provides") {
		    $interface{'provided'} = 1;
		}
		else{
		    $interface{'provided'} = 0;
		}
	    }
	    
	    #now add the properties of this interface to the attribute list
	    $interfaces[scalar @interfaces] = \%interface;	    
	    #and add any includes in this $text to the includeFiles
	    for my $include (@includes) {
		$includeFiles{$include} = 1;
	    }
	}
    }
    return (\@interfaces, \%includeFiles);

}

##############################
# Parse the program files and generate a @functions array of hashrefs,
# where each hashref represents some tagged functions.
# 
# This takes four arguments: 
# $includes are the set of compiler include directives
# $file is the top-level nesC application file 
# $tagName is the name of the @tag
# @tagFields is an array of the fieldnames of the @$tagName struct
#
# The function returns an arrayref of hashrefs, where each hashref
# represents the data about a different instance of a functions with
# that @tag
#
# example usage:
#AtTags::getTaggedFunctions("-I../contrib/hood/tos/lib/Registry", "TestRegistryC.nc", "rpc",("rpcArgs");
# will return all interfaces in the "TestRegistryC" app, including
#files in contrib/hood/tos/lib/Registry, with @rpc("arg") tags,
#if @rpc is defined as struct {char* rpcArgs;}
##############################

sub getTaggedFunctions {

##############################
# The return type of this function is an array of hashrefs:
#
# @functions--->%function1--->componentName
#                            |->functionName
#                            |->functionType eg (command|event)
#                            |->returnType 
#                            |->%paramNum--->name
#                                         |->type
#                                         |->size
#                            |->provided (==1 if provided, 0 if used)
#                            |->tagField1 (the name/values of the tag params)
#                            |->tagField2
##############################

    @_ = &FindInclude::parse_include_opts( @_ ); #get rid of includes
    my $file = shift @_;
    ($tagName, @tagFields) = @_;

    #convert the tagFields array to a hashTable
    my %tagFields;
    for $t (@tagFields){
	$tagFields{"$t"} = 1;
    }

    #get names of all application files in include path
    my %files = NescProgramFiles::getProgramFiles($file);

    #the hash table of attributes
    my @functions = ();
    #the hash table of include files
    my %includeFiles = ();

    #go through each application file and find the desired @tags and
    #parse the line
    for $file (keys %files){
	($component) = ($file =~ m|/(\w+?)\.nc$|);
	my $text = &SlurpFile::scrub_c_comments( &SlurpFile::slurp_file( $file ) );
	my @includes = $text =~ m/^\s*(includes\s+\w+;)/mg;
	while ( $text =~
		   m/(command|event)\s+([\w\s]+?\*?\s+\*?)(\w+)(\(.*?\))\s+\@$tagName\((.*?)\)/sg
		   ) {
	    $prelude = $`;

	    #define a function with these properties
	    my %function;
	    my $type = &NescParser::parseType($2);
	    $function{'componentName'} = $component;
	    $function{'functionType'} = $1;
	    $function{'returnType'} = $type;
	    $function{'functionName'} = $3;
	    
	    #parse the arguments
	    my $args = $4;
	    my %params = ();
	    my $paramNum = 0;
	    while ( $args =~ m/[\(,]\s*([\w\s]+?\*?\s+\*?)(\w+)\s*(?=[,\)])/g ) {
		my %param;
		my $type = &NescParser::parseType($1);
		$param{'name'} = $2;
		$param{'type'} = $type;
		$params{"param".$paramNum++} = \%param;
	    }
	    $function{'params'} = \%params;
	    $function{'numParams'} = $paramNum;
		
	    #parse the @tags args:
	    $tagFieldValues = $5;
	    $tagFieldValues =~ s/"//g; #get rid of "
	    $tagField = 0;
	    while ($tagFieldValues =~ m/\s*([^,\s]+)/g) {
#		print $tagFieldValues.",".scalar @tagFields.",".$tagField;
		if (scalar @tagFields > $tagField){
		    $function{$tagFields[$tagField++]} = $1;
		}
		else{
		    die ("Error: too many arguments to \@$tagName in $function{'componentName'}.\n");
		}
	    }
#	    if (scalar @tagFields != $tagField){
#		die ("Error: not enough arguments to \@$tagName in  $function{'componentName'}.\n");
#	    }		

	    #figure out if this was used or provided
	    while ($prelude =~ m/(uses|provides)/sg ) {
		if ($1 eq "provides") {
		    $function{'provided'} = 1;
		}
		else{
		    $function{'provided'} = 0;
		}
	    }
	    
	    #now add the properties of this interface to the attribute list
	    $functions[scalar @functions] = \%function;	    
	    #and add any includes in this $text to the includeFiles
	    for my $include (@includes) {
		$includeFiles{$include} = 1;
	    }
	}
    }
    return (\@functions, \%includeFiles);

}


##############################
# Go through all interfaces that provide the $tagName @tag and find
# all unique sets of values.
# Assume no module or only a single module may provide such an
# interface, and if a module does provide the interface, return the
# component name with the interface.
#
# example usage:
#    AtTags::getUniqueTags("../nesc.xml","attr",("attrName","attrNum"));
#
# will return 3 values if there are 5  interfaces in nesc.xml with
# @attr("name", 10) tags, but only 3 of them have unique params.  If any
# modules provide those interfaces, those providing modules will be
# listed as "componentName".  Otherwise, the component name will be arbitrary.
##############################

sub getUniqueTags{

##############################
# The return type of this function is a hash of hashrefs, where the
#keys of the first hash is a concatenation of all tagField values.
#Thus, this return type is the same as the two above, except that all
#tagfield values are unique.
#
# %object--->tagField1tagField2--->componentName
#                               |->functionName
#                               |->provided (==1 if provided, 0 if used)
#                               |->tagField1 (the name/values of the tag params)
#                               |->tagField2
##############################

    my ($interfaces, $includes) = AtTags::getTaggedInterfaces (@_);

    my %tags;

# if this tagValue already exists, check for consistency with
# previous definition
    for my $interface (@$interfaces){
	
	#make the key a concatenated string of the param vals
	my $key = "";
	for my $field (@tagFields){
	    if ($interface->{$field}){
		$key = sprintf "%s$interface->{$field}", $key;
	    }
	} 

	#if this $key already exists, check for disparities
	if ($tags{"$key"}){
	    my $prevDef = $tags{"$key"};

	    #make sure the types are the same
	    my $oops = 0;
	    if (scalar @{$interface->{'gparams'}} ne scalar @{$prevDef->{'gparams'}}){
		$oops = 1;
	    }
	    my $i = 0;
	    while ($i < scalar @{$interface->{'gparams'}} ) {
		if ($interface->{'gparams'}->[$i] ne $prevDef->{'gparams'}->[$i] || ($oops==1) ){
		    die "ERROR: Two components use the same \@$tagName tag with different types: $prevDef->{'componentName'}.$prevDef->{'interfaceName'} and $interface{'componentName'}.$interface{'interfaceName'}";
		}
		$i++;
	    }

	    #if this tagValue is provided by some module, continue to use that
	    if ($prevDef->{'provided'} == 1){
		if($interface->{'provided'} == 1){
		    die "ERROR: Only one component can provide the tag \@$tagName in: $prevDef->{'componentName'}.$prevDef->{'interfaceName'} and $interface{'componentName'}.$interface{'interfaceName'}";
		}
		else{
		    $interface->{'provided'} = 1;
		    $interface->{'componentName'} = $prevDef->{'componentName'};
		}
	    }

	}

	#now add the properties of this interface to the tagValue list
	$tags{"$key"} = $interface;
    }
    return (\%tags, $includes);
}


1;
