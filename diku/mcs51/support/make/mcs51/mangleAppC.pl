#
# Copyright (c) 2007 University of Copenhagen
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# - Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the
#   distribution.
# - Neither the name of University of Copenhagen nor the names of
#   its contributors may be used to endorse or promote products derived
#   from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY
# OF COPENHAGEN OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.

#
# Based on an idea for a similar script by 
#   Cory Sharp <cssharp@eecs.berkeley.edu>
#
# Later addtions by
#   Mads Bondo Dydensborg <madsdyd@diku.dk>
#
# Adopted for sdcc and mcs51 by
#   Martin Leopold <leopold@diku.dk>
#   Sidsel Jensen <purps@diku.dk>
#   Anders Egeskov <egeskov@diku.dk>
#

#
# This script accepts a C-file in GCC dialect with a bunch of wierd hints
# and translates them into a C-file in SDCC or Keil dialect
#

use strict;
use Getopt::Long;

my $KEIL = '';
my $SDCC = '';
my $IAR = '';
my $file = '';

my $comment_level = 0;
my $multi_match = 0;
my $memory_att_match = 0;
my $NUM_TASKS = 0;
my $empty_struct=0;
my $string_h_match = 0;
my $string_h_seen = 0;
my %enums = ();
my $typedef_struct = "";
my $typedef_struct_ident = "";     # Current typedef struct (if any) for error output
my %typedef_struct_ident_all = (); # Index of all typdef struct definition
my $typedef_struct_lines = 0;
my $typedef_struct_empty = 0;
my $typedef_struct_closed = 0;
my %typedef_struct_empty_ident = ();
my $line_no = 0;

GetOptions(
	'keil' => \$KEIL,
	'sdcc' => \$SDCC,
	'iar' => \$IAR,
	'file=s' => \$file,
);

if ( !( $KEIL || $SDCC || $IAR ) || ! $file) {
	die "Usage sdccMangleAppC.pl <compiler> -file \"<filename>\"\nwhere compiler is either --keil, --sdcc, --iar\n";
}

open(FILE,"<$file") or die "no such file $file\n";
while(<FILE>) {
  $line_no++;

  # If on the first line, print some header.  It's in the while loop so if
  # this script is invoked with -i, the correct things still happen.
  # NOTE: This was broken by SMAC!
  if( $. == 1 ) {
    print <<"EOF";

#define MANGLED_NESC_APP_C
EOF
  }

#
# Skip lines that start with // and lines that are within a comment
#

  if ($_ =~ /^\/\//) { print $_; next;}

  if ($_ =~ /\*\//) { $comment_level--; }
  if ($comment_level > 0) { print $_; next; }
  if ($_ =~ /\/\*/) { $comment_level++; }

#
#  replace $ in symbols with __ (dollar in identifiers)
# 
  s{([\w\$]+)}{ (my $t=$1) =~ s/\$/__/g; $t }ge if /\$/;

#
# Abort if app has no tasks
#

  if(m{SchedulerBasicP__NUM_TASKS = 0U,}){
      print STDERR "The TinyOS 8051wg port does not allow applications without tasks. Add at least one task to your app.\n";
      exit 1;
  }

#
# Replace sfr related definitions with non ANSI-C dialekts
#
 # Kill the dummy typedef's
  # REPLACED!
  # s{^(typedef uint8_t sfr;)}{//$1};
  # s{^(typedef uint16_t sfr16;)}{//$1};
  # s{^(typedef uint8_t sbit;)}{//$1};
 # Should these be replaced to please CIL?
 s{^(typedef uint8_t uint8_t_xdata;)}{//$1};
 s{^(typedef uint16_t uint16_t_xdata;)}{//$1};
 s{^(typedef uint8_t uint8_t_code;)}{//$1};
 s{^(typedef uint16_t uint16_t_code;)}{//$1};

 # Replace 
 #   uint8_t volatile P0 __attribute((sfrAT0x86))
 # with
 #   sfr P0 at 0x86

if(m{uint(\d+)_t\s+volatile\s+(.*)\s+__attribute(?:__)?\(\((?:__)?(sfr|sbit|sfr16)AT(.{4})(?:__)?\)\).*;}) {
     my $width=$1; my $ident=$2;  my $type=$3; my $addr=$4;
     if($width==16 && $type ne "sfr16") {
	 printf "SFR width error line $line_no, width=$width $type";
	 exit;
     }
     if ( $KEIL ) {$_ = "$type $ident = $addr;\n"; }
     if ( $SDCC ) {$_ = "__$type __at ($addr) $ident;\n"; }

     # IAR uses a slightly different way to define the
     # sbit:  __bit __no_init volatile bool name @ (addr+bit)
     # sfr:   __sfr __no_init volatile unsigned char name @ addr
     # sfr16: __sfr __no_init volatile unsigned int  name @ addr
     # sfr32: __sfr __no_init volatile unsigned long name @ addr
     if ( $IAR )  {
	 if ($type eq "sfr")   {
             $_ = "__sfr __no_init volatile unsigned char $ident @ $addr;\n";
         }
	 if ($type eq "sfr16") {
             $_ = "__sfr __no_init volatile unsigned int $ident @ $addr;\n";
         }
	 if ($type eq "sbit")  {
             $_ = "__bit  __no_init bool $ident @ $addr;\n";
         }
     }

 }

  if ($IAR && m(typedef uint8_t bool.*;) ) {
      $_ = "//" . $_;
      $_ = $_ . "#include \"stdbool.h\"\n";
  }

  # Replace dummy code types with type and storrage class specifier
  s{uint(8|16)_t_code}{uint$1_t code}g;
#
#  Remove string.h definitions (memset, memcpy, strnlen, ..). Get Keil versions from string.h
# 

 # Replaced by custom string.h
 #
 #  if( $string_h_match==1  ||
 #      /^.*extern size_t strlen\(/  ||
 #      /^.*extern void \*memset\(/  ||
 #      /^.*extern void \*memcpy\(/
 #      ) {
 #      $_ = "//" . $_;
 #      $string_h_match=1;
 #      if ($string_h_seen == 0) {
 #	  $string_h_seen = 1;
 #	  $_ = $_ . "#include <string.h>\n" ;
 #      }
 #  }
 #  # look for the ")" and ";" of the function
 #  if ($string_h_match==1 && /^.*\).*;.*/) {
 #      $string_h_match=0;
 #  }
 #  


# Replace uint8_t_xdata types with real types these are used to
# on-the-fly access to specific memory locations in name memory
# areas. This is usefull to address registers in say xdata memory in a
# way that looks slightly like ansi-C.
#
#  (*(uint16_t_xdata*)) = ?
#
# As an alternative you could imagine defining these as variables
# with absolute locations:
#   uint8_t xdata MDMCTRL0H_VAR at addr;
#
# However mangling this in a compiler agnostic way is probaby more
# difficult than stickting to something that looks like ANSI-C
#
#

  $memory_att_match = 0;

  # Replace dummy xdata types with type and storrage class specifier
  if ($KEIL && s{uint(8|16)_t_xdata}{uint$1_t xdata}g) {
      $memory_att_match = 1;  # Don't replace data with _data
  }
  if (($IAR || $SDCC) &&
      s{uint(8|16)_t_xdata}{uint$1_t __xdata}g) {
      $memory_att_match = 1;  # Don't replace data with _data
  }

#
# Replace attribute definition corresponding to memory segments (storrage class)
#   For Keil the small memory model puts all variables in data
#   the large model all goes in xdata
#
# Replace uint8_t j __attribute((xdata)); with
#   Keil, SDCC: uint8_t xdata j;
#   IAR       : uint8_t __xdata j;


  if( ($KEIL ) &&
      s{\s+((?:\w)+(?:\[(?:.*)\])?)\s+__attribute(?:__)?\(\((?:__)?((?:x|p)?data|code)(?:__)?\)\)}
      { $2 $1} ) {
      $memory_att_match = 1;  # Dont replace with _data later on
  }

  if( ( $IAR || $SDCC) &&
      s{\s+(.*)\s+__attribute(?:__)?\(\((?:__)?((?:x|p)?data|code)(?:__)?\)\)}
      { __$2 $1} ) { # Drop types and rely on default for now..
      $memory_att_match = 1;  # Dont replace with _data later on
  }

#
# Replace interrupt declarations
#

  # gcc interrupt declatation to sdcc declaration
  #   From: __attribute((interrupt)) void  __vector_5(void)
  #   To:   void __vector_5(void) interrupt 5
  # CIL outputs interrupts in a different manner:
  #         void __attribute__((__interrupt__))  __vector_2(void) 
  #  http://www.keil.com/support/man/docs/c51/c51_le_interruptfuncs.htm
  # SDCC:
  #  http://sdcc.sourceforge.net/doc/sdccman.html/node64.html
  # void timer_isr (void) __interrupt (1) __using (1)  
  if(m{^\s*(?:void\s+)?__attribute(?:__)?\(\((?:__)?interrupt(?:__)?\)\)\s+(?:void\s+)?([_[:alpha:]]+)(\d+)\s*\(\s*void\s*\)}&&
     $_ !~ m{;}) {
      my $int_no=$2; my $func_name=$1;
      if ( $KEIL ) {$_ = "void $func_name$int_no(void) interrupt $int_no\n"; }
      if ( $SDCC ) {$_ = "void $func_name$int_no(void) __interrupt ($int_no)\n"; }
  }

  # Remove function prototypes
  # (for some reason nesc doesn't produce prototypes and function defs the same way..
  s{^(\s*void\s+__vector_\d+\s*\(void\)\s+__attribute(?:__)?\(\((?:__)?interrupt(?:__)?\)\)\s+\;)}{/*$1*/};

#
# Remove any remaining gcc style attributes
#

  # The remaining attributes at this point don't have SDCC/Keil equivalents
  # This includes:
  #  __attribute__((packed))
  #  __attribute((__nothrow__)) 
  #  __mode__((__QI__))      - from sys/types.h
  #  __mode__((__HI__))      - from sys/types.h
  #  __mode__((__SI__))      - from sys/types.h
  #  __mode__((__word__))    - from sys/types.h
  #
  # First check if the line has been uncommmented sinces comments in comments
  # are a nono...

  if (! (m{^.*/\*} || # /* style comment
	 m{^.*//})){  # // style comment
      #s{(__attribute__\s*\(\(.*\)\))}{/*$1*/};
      #s{(__attribute\s*\(\(.*\)\))}{/*$1*/};
      s{(__attribute(?:__)?\s*\(\(.*\)\))}{/*$1*/};
  }

#
# Struct variable initializers
#

  # Keil cannot handle an initializer of a struct variable in the same line
  # as the variable definition, e.g.
  #   my_struct s = prev_struct;
  #
  # On the other hand it handles the following
  #   my_struct s;
  #   s = prev_struct;

  # Cascade typedef'ed versions
  if($KEIL && m{typedef\s*(?:\/\*.*\*\/)?\s*(\w+)\s*(?:\/\*.*\*\/)?\s*(\w+)\s*;}){
      my $from = $1;
      my $to   = $2;
      if(defined($typedef_struct_ident_all{$from})) {
          $typedef_struct_ident_all{$to} = 1;
      }
  }

  if($KEIL && m{(\w+)\s+(\w+)\s+=\s+(.+)}) {
      my $type = $1;
      my $ident = $2;
      my $initializer = $3;

      if(defined($typedef_struct_ident_all{$type})){
          $_ = "$type $ident;" . 
              "$ident = $initializer";
      }
  }

#
# Mangle wierdness of empty array/typedef defitions..
#

  # keil seems to throw up over C99 autolength array definitions
  #
  # Look for the actual definition of the array length an mangle if 0
  #
  # The following fail if the enums are 0 (in Keil)
  #  volatile uint8_t SchedulerBasicP$m_next[SchedulerBasicP$NUM_TASKS];
  #  typedef int BlinkNoTimerTaskC$__nesc_sillytask_toggle[BlinkNoTimerTaskC$toggle];
  #
  # Turns out nescc produces a lot of these based on enums. So we need
  # to look them up and replace the ones that are 0 (sigh)

  if (($KEIL || $IAR) && m{((?:\w|\$)+) = (\d+)U?}){
      $enums{$1} = $2;
  }
  if (($KEIL || $IAR) && m{^\s*(typedef|volatile)\s+(\w+)\s+(\w+)\[(\w+)\];}) {
      my $type=$1; my $target_type = $2; my $identifier = $3; my $enum = $4;
      if ( defined($enums{$enum}) && ($enums{$enum} == 0) ) {
	  $_ = "$type $target_type $identifier\[\];\n";
      }
  }

  #
  # Array definitions without length are not allowed within typedef
  # struct (C99 automatic array length)
  # 

  if( ($KEIL || $IAR) && $typedef_struct_lines ) {

     # [] and * are _NOT_ the same inside a struct definition!!
     # [] means an array with a length that is up to the compiler to calculate
     #    != * which is a regular pointer!
      my $quit = 0;
      if (m/\[\].*;/) {
	  print STDERR "Structs with C99 array auto-lenght (non-fixed length) is not allowed in Keil\n";
	  $quit = 1; 
      }
      if (m/struct.*{/) {
	  print STDERR "You are not allowed to declare a struct inside a struct in Keil. Move it outside and give it a name.\n";
	  $quit = 1; 
      }
      if ($quit) {
	  print STDERR "Structure $typedef_struct_ident in $file line $line_no\n";
	  exit $quit;
      }
  }

#
#  Kill size_t (why???)
#
# s{^\s*(typedef unsigned int size_t;)}{//$1};

#
#  Remove variable number of arguments for dbg_* functions
# 
if ( $KEIL ) {
  s{#define dbg\(mode, format, ...\) \(\(void\)0\)}{#define dbg(mode, format) ((void)0)};
  s{#define dbg_clear\(mode, format, ...\) \(\(void\)0\)}{#define dbg_clear(mode, format) ((void)0)};
}

if ( $KEIL ) {
  # hide debug enums that are out of range
  # s{^(.* 1ULL << (\d+).*)}{ ($2>=15) ? "//$1" : "$1" }e;

  # Hide all debug enums as 1ULL and 0ULL are unavailable in Keil
  # Alternatively this could be solved by including a new dbg_modes.h
  s{^(.*=.*\dULL.*)}{//$1};
  s{^(.*DBG_DEFAULT.*=.*)}{//$1};
   
}

#
# Replace keyword "data" with "_data" (and atad for IAR)
#
  # replace keyword data with something else
  # Don't match xdata and __attribute((xdata))
  if ($memory_att_match == 0) {
      if($IAR) {
	  s/(?!x)(.)data/$1atad/g;
      } else {
	  s/(?!x)(.)data/$1_data/g;
      }
  }
  $memory_att_match=0; # One line at a time...

#
# disable file and line number preprocessor commands (sdcc/cw doesn't support it)
#
  s{^(# \d+|#line)}{//$1};


#
# Remove inline keywords (could be replaced by pragma on some compilers
# (eg. cw, SDCC)
#

  # MBD: Seems gcc sometimes do a __inline - no idea if it is the same!
  # ML: Let's stick to one syntax! SDCC does not seem to support __inline
  s{\b__inline\b}{ inline };
      #s{^(.*\binline\b.*)}{ (my $t=$1) =~ s/\b(inline)\b/\/*$1*\//; "$t" }e;
      #s{^(.*\b__inline\b.*)}{ (my $t=$1) =~ s/\b(__inline)\b/\/*$1*\//; "$t" }e;

  # Keil does not support inline
  # SDCC > 2.7.0 w. --std-sdcc99 should but it does not seem to work for me!
  if ( $KEIL || $SDCC || $IAR) {
      s{\b((?:__)?inline)\b}{ /*$1*/ }
  }

    
########################################################################
# Convert datatypes                                                    #
########################################################################

#
# 64 bit integers are not implemented, so we remove them.
# Any program requiring them will fail
#  

  s{(__extension__)}{/*$1*/};

  # Remove typedefs ralating to 64 bit integers, e.g.
  #    typedef unsigned long long uint64_t
  #
  # Replace the type of any long long variables to something that will
  # hopefully lead to a bizzare type error - if they are ever used
  # (the cant be removed entierly, since this seems to lead to empty
  # structures - which again is a nono in Keil). eg.
  #    unsigned long long myvar;

  s{(typedef __builtin_va_list __gnuc_va_list;)}{/*$1*/};

  s{(typedef u?int64_t __nesc_nxbase_nx(?:le)?_u?int64_t\s*;)}{/*$1*/};
#  if ($comment_level==0 &  !s{(typedef\s*(?:unsigned)?\s*long\s*long\s*(?:int)?\s*\w+;)}{/*$1*/}) {
  if (!s{(typedef (?:\w|\s)+ _*u?int64_t\s*;)}{/*$1*/}) {
      s{((?:unsigned)?\s*long\s*long\s*(?:int)?\s*)(\w+;)}{
         float* $2
      };
  }

#
# Double is not supported, abort if a variable is declared double
#
  if (/^\s+double\s+\w+;/) {
      print STDERR "Detected the use of a variable of type \"double\" in $file line $line_no\nThis is not supported in SDCC or Keil. Aborting.\n";
      exit -1;
  }

#
# Drop empty structures (Keil doesn't seem to like that)
# 

#
# While dropping internal nesc structures such as the attribute tags
# dropping the timer tags will never work. They are used to cascade a
# bunch other types that will eventually fail =[..
#

  # It is important that these are run last - after any other
  # modyfications to the lines if no we might risk missing other
  # things that need to go - eg. #line
  #
  # Timer precision tags generates an empty typedef struct which are
  # bad, mkay. All typedefs are not generated the same way - some are
  # only one line, some have the identifier right after the ; some
  # don't.
  #
  # Unfortunately we can't match the offending structs based on the
  # name (nesc generates those) - we have to wait for the end and see
  # if this was an empty structure. It seems that all the empty
  # structures look a bit similar. So what we are looking for is this:
  #
  # The Timer precision tags (that we are looking for) look something like this
  # (when they get through nesC at least):
  #   typedef sdf {
  #   }
  #   name;

  if ($typedef_struct_lines) {
      # Reached last line i typedef
      # The ; might not be on the same line as the }

      if (m{.*\}.*}) { # Found the end } of the typedef
	  $typedef_struct_closed = 1;
	  if ( $typedef_struct_lines == 1) {
	      $typedef_struct_empty = 1;
	  }
      }
      $typedef_struct_lines++;
      $typedef_struct = $typedef_struct . $_;

      # look for ";"
      if ($typedef_struct_closed==1 && m{(^.*\s+(\w+))?;} ) {
	  my $identifyer = "";
	  # This fails if the identifier is right after ; fortunately it isn't
	  # for our lines  
	  if (defined($1) &&
	      $1 ne "") {
	      $identifyer = $1;
	  }

	  # Remember the name of the empty struct - we need this to 
          # kill more lines that use this name later...
          $typedef_struct_ident_all{$identifyer} = 1;

	  # Remove the empty struct
	  if ($typedef_struct_empty){
	      $typedef_struct_empty_ident{$identifyer} = 1;

	      my @list = split(/\n/, $typedef_struct);
	      $_ = "";
	      # Comments in comments are bad mkay
	      $_ = $_ . "/* Empty struct $identifyer removed \n*/";
	      foreach my $line (@list) {
		  if ($line =~ /\/\/.*/) {
		      $_ = $_ . $line;
		  } else {
		      $_ = $_ . "//" . $line . "\n";
		  }
	      }
	  } else { # The struct was not empty...
	      $_ = $typedef_struct;
	  }
          $_ = $_ . "/*YYYYY $identifyer*/";

          #if ($identifyer eq "in_queue_item_t") {
          #    $_ = $_ . "//HIHI";
          #}
          #if ($identifyer eq "__nesc_unnamed4275") {
          #    $_ = $_ . "//HOHO";
          #}
          
	  $typedef_struct_closed = 0;
	  $typedef_struct_lines = 0;
	  $typedef_struct_empty = 0;
          # we are done - don't match any more!
          print $_; 
	  next; 
      } else { # Output the whole structure at once!
	  $_ = "";
#	  $_ = "$typedef_struct_empty $typedef_struct_closed $typedef_struct_lines" . $_;
      }
  } 
  # Match beginning of a "typedef struct"
  if( /^\s*(?:typedef\s+)(?:nx_)?struct ((?:\w|_)+) {/) {
      # we are not looking for one line typedef struct
      if (/\}.*;/) {
      } else {
          $typedef_struct = $_;
          $typedef_struct_ident = $1;
	  $_ = "";
	  $typedef_struct_lines = 1;
      }
  }

  # After tossing the empty timer typedef stucts we need to toss these typedefs
  # as well:
  #   typedef TMilli TimerTesterP$Timer$precision_tag;
  if (/^typedef\s+(\w+)\s+(.)+;.*/) {
     my $identifyer = $1;
     if (defined($typedef_struct_empty_ident{$identifyer})) {
     $_ = "//" . $_;
     }
  }

  # In addition to the empty "typedef struct" nescc creates some empty "structs"
  if( /^struct __nesc_attr_\w+ {/ ) {
      $empty_struct=1;
      $_ = "/*" . $_;
  }
  if ($empty_struct && /\}\s*\;/) {
      $empty_struct = 0;
      chomp($_);
      $_ = $_ . "*/\n";
  }
 
  print;

}
				       
close(FILE);
