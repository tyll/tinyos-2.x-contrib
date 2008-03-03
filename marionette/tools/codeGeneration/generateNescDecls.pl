#!/usr/bin/perl -w

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
# this file creates an xml file with all of an applications enums and
# structs. Usage:
#
#   generateNescDecls -d build/platform build/platform/app.c build/platform/nesc.xml

use XML::Simple;
use strict;
use FindBin;
use lib $FindBin::Bin;
use AtTags;
use NescParser;

my $DestDir = "";

my $mainExe = pop(@ARGV);
my $nescXml = pop(@ARGV);
my $appC = pop(@ARGV);

#get rid of extraneous arguments
my @args = @ARGV;
@ARGV = ();
while (@args){
    my $arg = shift @args;
    if ($arg eq "-d") {
        $DestDir = shift @args;
        $DestDir .= "/" unless $arg =~ m|/$|; 
    }
}

#make sure the user knows what's going on:
my $s = "generateNescDecls.pl -d $DestDir $appC $nescXml $mainExe";
for my $arg (@ARGV) {
    $s = sprintf "%s %s", $s, $arg;
}
print $s, "\n";


##############################
# load the struct definitions 
##############################

#my $structs;
my $structs = NescParser::getStructs($nescXml);
#print "there are %d structs\n\n",scalar keys %$structs;

##############################
# load the enums 
##############################

#load the app.c file into memory
open (APPC, $appC) || die "couldn't open $appC!";
undef $/;
my $appText = <APPC>;
close(APPC);

my %enums = ();
my @enumArray = ();
my @namedEnums = ();

#first, find each enum declaration
while ( $appText =~ m|enum\s+(\w+)\s+{(.+?)}|sg ){ #} 
    my $enumName = $1;
    my $enumDecls = $2.",";
    my @newEnums = ();
    #print "found enum $enumName: $enumDecls\n";
    #then, find each enum within that declaration
    while ( $enumDecls =~ m|([^,]+),|g ) {
	my $enumStr = $1;
	#print "parsing $enumStr\n";
	#choose only those that have an assigned value and have valid names
	if ($enumStr =~ m/\s*(\w+)\s*=\s*(.+?)(\s*)$/){
	    my %enumHash = ();
	    $enumHash{name} = $1;
	    $enumHash{value} = $2;
	    #be consistent with nesc generator and print I: before ints
	    if ( $enumHash{value} =~ m/^\d+$/ ){
		$enumHash{value} = "I:".$enumHash{value};
	    }
	    #print "adding $enumHash{name} = $enumHash{value}\n";
	    push(@newEnums, \%enumHash);
	}
    }
    #add these enums to the global list
    for my $e (@newEnums) {
	push(@enumArray, $e);
    }
    #if this is a named enum, also add it as such
    if ( ($enumName !~ m/__nesc_unnamed/) && (scalar @newEnums > 0) ) {
	#print "adding named enum: $enumName\n";
	my %tmpHash = ();
	$tmpHash{name} = $enumName;
	$tmpHash{enum} = \@newEnums;
	push(@namedEnums, \%tmpHash);
    }    
}

$enums{enum} =\@enumArray;
$enums{namedEnum} =\@namedEnums;

##############################
# load the typedefs 
##############################

my %typedefs = ();
my @typedefArray = ();

#find all single line typedefs
while ( $appText =~ m|typedef\s+([\w\s]*?)\s+(\w+)\s*;|g ) {
    my %typedef;
    $typedef{name} = $2;
    $typedef{value} = $1;
    if ( $typedef{value} !~ m/__nesc_unnamed/){
	push(@typedefArray, \%typedef);
    }
}
#find all struct typedefs
while ( $appText =~ m|typedef\s+struct\s+(\w+)\s+{.*?}[^;]*?(\w+);|sg ){
    my %typedef;
    $typedef{name} = $2;
    $typedef{value} = $1;
    if ( $typedef{value} !~ m/__nesc_unnamed/){
	push(@typedefArray, \%typedef);
    }
}
$typedefs{typedef} =\@typedefArray;


##############################
# load the ram symbols 
##############################

my %ramsymbols = ();
my @ramsymbolArray = ();

#make this a little faster by reducing the size of app.c
my $brief = '';
my @lines = $appText =~ m|^\s*(\w[\w\s\$]+?\*?\s+\*?[\w\$]+(\[.*?\])?(?:\s*=.*?)?;)\s*$|mg;
for my $line (@lines) {
    if (!$line || $line =~ m/^\s*return\s+/){
	next;
    }
    $brief .= sprintf("%s\n",$line);
}

my $objdump = "avr-objdump";
my $symtab = `$objdump -t $mainExe`;
if ($? == 0) {
    while ($symtab =~ m/^\s*(\S+)\s+[\w\s]+\s+\.(?:data|bss)\s+(\S+)\s+(\S+)\s*$/mg ) {
	my ($addr,$size,$sym) = ($1,$2,$3);
	my $name = $sym;
	if (hex($size) > 0){
	    my $nameRegexp = $name;
	    $nameRegexp =~ s/\$/\\\$/;
	    if ( $brief =~ m|^\s*(\w[\w\s\$]+?\*?\s+\*?)$nameRegexp(\[.*?\])?(?:\s*=.*?)?;\s*$|m){
		my $arraySize = $2;
		my $type = $1;
		if ($type =~ m/static/ || $type =~ m/const /) {
		    next;
		}
		$type =~ s/volatile //;
		if ($type){
		    $type = &NescParser::parseType($type);
		    $name =~ s/\$/./;
		    my %ramsymbol = ();
		    $addr =~ s/^00800/00000/;
		    $ramsymbol{'name'} = $name;
		    $ramsymbol{'address'} = hex($addr);
		    $ramsymbol{'length'} = hex($size);
		    $ramsymbol{'type'} = $type;
		    if ($arraySize) {
			$ramsymbol{'array'} = "true";
		    }
		    push(@ramsymbolArray, \%ramsymbol);
		}
	    }
	}
    }
}
$ramsymbols{ramSymbol} =\@ramsymbolArray;


##############################
# print out in XML format for the PC-side tools
##############################

open(SCHEMA, ">${DestDir}nescDecls.xml");

my $xs1 = XML::Simple->new();

my %xmlOutHash = ();
my %tmpHash = ();
$tmpHash{'struct'} = $structs;
$xmlOutHash{'structs'} = \%tmpHash;
$xmlOutHash{'enums'} = \%enums;
$xmlOutHash{'typedefs'} = \%typedefs;
$xmlOutHash{'ramSymbols'} = \%ramsymbols;

my $str = $xs1->XMLout(\%xmlOutHash, RootName=>"nescDecls", KeyAttr=>{'attribute'=>'name', 'event'=>'name', 'symbol'=>'name'}, XMLDecl=>1);

print SCHEMA $str;

close(SCHEMA);
