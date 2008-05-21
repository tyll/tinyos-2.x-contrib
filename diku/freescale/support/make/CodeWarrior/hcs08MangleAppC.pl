#!/usr/bin/perl -w
#$Id$
# @author Cory Sharp <cssharp@eecs.berkeley.edu>
# Modified by Mads Bondo Dydensborg <madsdyd@diku.dk>
# Modified by Tor Petterson <motor@diku.dk>

use strict;

my $absolute_address = undef;
my $absolute_address_count = 0;
my $struct = 0;
my $typedefstruct = 0;
my $typedefnxstruct = 0;

my $sourceCode = "";

while(<>) {
	# If on the first line, print some header.  It's in the while loop so if
	# this script is invoked with -i, the correct things still happen.
	# NOTE: This was broken by SMAC!
	if( $. == 1 ) {
		print "#define MANGLED_NESC_APP_C\n";
		print "#pragma MESSAGE DISABLE C1106  // disable bitfield warnings\n";
		print "#pragma MESSAGE DISABLE C1420  // Result of function-call is ignored\n";
		print "#pragma MESSAGE DISABLE C4002  // Result not used\n";
		print "#pragma MESSAGE DISABLE C4301  // Inline expansion done for function call\n";
		print "#include \"hcs08gt60_interrupts.h\"\n";
	}
	
	# disable file and line number preprocessor commands
	s{^(# \d+|#line)}{//$1};

	# replace inline keywords with inline pragmas
	s{^(.*\binline\b.*)}{ (my $t=$1) =~ s/\b(inline)\b/\/*$1*\//; "#pragma INLINE\n$t" }e;

	# MBD: Seems gcc sometimes do a __inline - no idea if it is the same!
	s{^(.*\b__inline\b.*)}{ (my $t=$1) =~ s/\b(__inline)\b/\/*$1*\//; "#pragma INLINE\n$t" }e;

	# replace $ in symbols with __
	s{([\w\$]+)}{ (my $t=$1) =~ s/\$/__/g; $t }ge if /\$/;

	# hide debug enums that are out of range
	s{^(.* 1ULL << (\d+).*)}{ ($2>=15) ? "//$1" : "$1" }e;
	
	# map gcc interrupts back to hcs08 macro interrupts
	s{^void\s*__attribute\(\(interrupt\)\)\s+signal_(\w+)\(void\)}{HCS08_SIGNAL($1)};

	# It seems that the format of the gcc interrupts changed
	# this seems to work with the new format 
	s{^void\s+signal_(\w+)\(void\)\s*__attribute\(\(interrupt\)\)}{HCS08_SIGNAL($1)};
	s{__attribute\(\(interrupt\)\) void\s+signal_(\w+)\(void\)}{HCS08_SIGNAL($1)};
	
	# map gcc noinline attribute to hcs08 noinline pragma
	s{^(.*)(__attribute\(\(noinline\)\))(.*)}{#pragma NO_INLINE\n$1/*$2*/$3};

	# MBD: Fix packet attribute. I do not think there is a CW equiv?
	s{^(.*)(__attribute\(\(packed\)\))(.*)}{$1/*$2*/$3};
	s{^(.*)(__attribute__\(\(packed\)\))(.*)}{$1/*$2*/$3};

	# TP nesc creates empty structs which Codewarior doesn't like
	if($struct == 1){
	  $struct = 0;
	  if(/^(s*)}/){
	    $sourceCode .= "int foo; };\n";
	    next;
	  }
	}

	if( /^struct(.+){/){ 
	  $struct = 1;
	}

	# TP this time for empty typedef struct
	if($typedefstruct == 1){
	  $typedefstruct = 0;
	  if(/^(s*)}/){
	    $sourceCode .= "int foo; }\n";
	    next;
	  }
	}

	if( /^(s*)typedef struct(.+){/){ 
	  $typedefstruct = 1;
	}
	
		# TP and for empty typedef nx_struct
	if($typedefnxstruct == 1){
	  $typedefnxstruct = 0;
	  if(/^(s*)}/){
	    $sourceCode .= "int foo; }\n";
	    next;
	  }
	}

	if( /^(s*)typedef nx_struct(.+){/){ 
	  $typedefnxstruct = 1;
	}

	# MBD: Fix empty struct in OscopeMsg.h - this sucks bigtime.
	#s/struct\s+OscopeResetMsg\s*\{/struct OscopeResetMsg{ int foo\;/;
	
	# TP: More empty struct have been introduced
	#s/struct\s+__nesc_attr_atmostonce\s*\{/struct __nesc_attr_atmostonce{ int foo\;/;
	#s/struct\s+__nesc_attr_atleastonce\s*\{/struct __nesc_attr_atleastonce{ int foo\;/;
	#s/struct\s+__nesc_attr_exactlyonce\s*\{/struct __nesc_attr_exactlyonce{ int foo\;/;
	
	s/\bstatic\s*inline\b/inline static/;

	# unmangled names with absolute addresses to HCS08 compiler directives
	if( /^struct __hcs08_absolute_address__(\S+)/ ) {
		$absolute_address = $1;
		$absolute_address_count = 4;
	}
	if( $absolute_address_count > 0 ) {
		if( $absolute_address_count == 1 ) {
			s/^(volatile) (\w+) (\w+);$/$1 $2 $3 \@$absolute_address;/;
		} else {
			s/^/\/\// unless /^\/\//;
		}
		$absolute_address_count--;
	}
	
	$sourceCode .= $_;
}

# Do global multiline substitutions here if any.
#$sourceCode =~ s/^(.*)\binline\b(.*\((?:(.*,\s*)|(.*))*\);)/$1$2/img;

print $sourceCode;


if (defined $ENV{"ENVIRONMENT"}) {
#	if ("FFD" eq $ENV{"ENVIRONMENT"} ||
#	    "FFDNB" eq $ENV{"ENVIRONMENT"} ||
#	    "FFDNBNS" eq $ENV{"ENVIRONMENT"} ||
#	    "FFDNGTS" eq $ENV{"ENVIRONMENT"} ||
#	    "RFD" eq $ENV{"ENVIRONMENT"} ||
#	    "RFDNB" eq $ENV{"ENVIRONMENT"} ||
#	    "RFDNBNS" eq $ENV{"ENVIRONMENT"}) {

#		print "// #pragma DATA_SEG NV_RAM_POINTER\n";
#		print "// NB: You are _NOT_ to move this somewhere else.\n";
#		print "// The freescale 802.15.4 libraries expect it to be there\n";
#		print "volatile NV_RAM_Struct_t * NV_RAM_ptr \@0x0000107E;\n";
#		print "// #pragma DATA_SEG default\n";

#	}
	if ($ENV{"ENVIRONMENT"} eq "SimpleMac") {
		print "/* ********************************************************************** */\n";
		print "/* Definitions needed by SMAC during linking, we place them last to\n";
		print "   make sure that the types are defined. This is hackish, kids! */\n";
		print "\n";
		print "/* Interrupt vector irq_isr at 0xFFFA. SMAC needs this. We hack it in. */\n";
		print "typedef void(*tIsrFunc)(void);\n";
		print "void irq_isr(); // defined in smac library\n";
		print "const tIsrFunc _vect[] \@0xFFFA = {\n";
		print "    irq_isr\n";
		print "};\n";
		print "\n";
		print "#ifndef byte\n";
		print "#define byte uint8_t\n";
		print "#endif\n";
		print "\n";
		print "#ifndef word\n";
		print "#define word uint16_t\n";
		print "#endif\n";
		print "\n";
		print "/*** IRQSC - Interrupt Request Status and Control Register; 0x00000014 ***/\n";
		print "volatile byte _IRQSC \@0x00000014;\n";
		print "\n";
		print "/*** SPI1S - SPI1 Status Register; 0x0000002B ***/\n";
		print "volatile byte _SPI1S \@0x0000002B;\n";
		print "\n";
		print "/*** SPI1D - SPI1 Data Register; 0x0000002D ***/\n";
		print "volatile byte _SPI1D \@0x0000002D;\n";
		print "\n";
		print "/*** PTBD - Port B Data Register; 0x00000004 ***/\n";
		print "volatile byte _PTBD \@0x00000004;\n";
		print "\n";
		print "/*** PTCD - Port C Data Register; 0x00000008 ***/\n";
		print "volatile byte _PTCD \@0x00000008;\n";
		print "\n";
		print "/*** PTED - Port E Data Register; 0x00000010 ***/\n";
		print "volatile byte _PTED \@0x00000010;\n";
		print "\n";
		print "// Stuff from mcu_init and MC13192_init\n";
		print "\n";
		print "/*** SOPT - System Options Register; 0x00001802 ***/\n";
		print "volatile byte _SOPT \@0x00001802;\n";
		print "\n";
		print "/*** TPM1SC - TPM 1 Status and Control Register; 0x00000030 ***/\n";
		print "volatile byte _TPM1SC \@0x00000030;\n";
		print "\n";
		print "// NB: WORD!\n";
		print "/*** TPM1CNT - TPM 1 Counter Register; 0x00000031 ***/\n";
		print "volatile word _TPM1CNT \@0x00000031;\n";
		print "\n";
		print "/*** PTBDD - Data Direction Register B; 0x00000007 ***/\n";
		print "volatile byte _PTBDD \@0x00000007;\n";
		print "\n";
		print "/*** PTCDD - Data Direction Register C; 0x0000000B ***/\n";
		print "volatile byte _PTCDD \@0x0000000B;\n";
		print "\n";
		print "/*** PTCPE - Pullup Enable for Port C; 0x00000009 ***/\n";
		print "volatile byte _PTCPE \@0x00000009;\n";
		print "\n";
		print "/*** PTEDD - Data Direction Register E; 0x00000013 ***/\n";
		print "volatile byte _PTEDD \@0x00000013;\n";
		print "\n";
		print "/*** SPI1C1 - SPI1 Control Register 1; 0x00000028 ***/\n";
		print "volatile byte _SPI1C1 \@0x00000028;\n";
		print "\n";
		print "/*** SPI1C2 - SPI1 Control Register 2; 0x00000029 ***/\n";
		print "volatile byte _SPI1C2 \@0x00000029;\n";
		print "\n";
		print "/*** SPI1BR - SPI1 Baud Rate Register; 0x0000002A ***/\n";
		print "volatile byte _SPI1BR \@0x0000002A;\n";
		print "\n";
		print "// Used by use_external_clock\n";
		print "\n";
		print "/*** ICGC1 - ICG Control Register 1; 0x00000048 ***/\n";
		print "volatile byte _ICGC1 \@0x00000048;\n";
		print "\n";
		print "/*** ICGS1 - ICG Status Register 1; 0x0000004A ***/\n";
		print "volatile byte _ICGS1 \@0x0000004A;\n";
		print "\n";
		print "/*** ICGC2 - ICG Control Register 2; 0x00000049 ***/\n";
		print "volatile byte _ICGC2 \@0x00000049;\n";
		print "\n";
		print "/* End SMAC required but undocumented definitions. */\n";
		print "/* ********************************************************************** */\n";
	}
}
