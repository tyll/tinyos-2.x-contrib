#!/usr/bin/perl -w

use strict;

my $avr_vectors="--add_entry __vector_0 --add_entry __vector_1 --add_entry __vector_2 --add_entry __vector_3 --add_entry __vector_4 --add_entry __vector_5 --add_entry __vector_6 --add_entry __vector_7 --add_entry __vector_8 --add_entry __vector_9 --add_entry __vector_10 --add_entry __vector_11 --add_entry __vector_12 --add_entry __vector_13 --add_entry __vector_14 --add_entry __vector_15 --add_entry __vector_16 --add_entry __vector_17 --add_entry __vector_18 --add_entry __vector_19 --add_entry __vector_20 --add_entry __vector_21 --add_entry __vector_22 --add_entry __vector_23 --add_entry __vector_24 --add_entry __vector_25 --add_entry __vector_26 --add_entry __vector_27 --add_entry __vector_28 --add_entry __vector_29 --add_entry __vector_30 --add_entry __vector_31 --add_entry __vector_32 --add_entry __vector_33 --add_entry __vector_34 --add_entry __vector_35";

my $cc2430_vectors="--add_entry __vector_0 --add_entry __vector_1 --add_entry __vector_2 --add_entry __vector_3 --add_entry __vector_4 --add_entry __vector_5 --add_entry __vector_6 --add_entry __vector_7 --add_entry __vector_8 --add_entry __vector_9 --add_entry __vector_10 --add_entry __vector_11 --add_entry __vector_12 --add_entry __vector_13 --add_entry __vector_14 --add_entry __vector_15 --add_entry __vector_16 --add_entry __vector_17";

my $msp_vectors="--add_entry sig_DACDMA_VECTOR --add_entry sig_PORT2_VECTOR --add_entry sig_USART1TX_VECTOR --add_entry sig_USART1RX_VECTOR --add_entry sig_PORT1_VECTOR --add_entry sig_TIMERA1_VECTOR --add_entry sig_TIMERA0_VECTOR --add_entry sig_ADC_VECTOR --add_entry sig_USART0TX_VECTOR --add_entry sig_USART0RX_VECTOR --add_entry sig_WDT_VECTOR --add_entry sig_COMPARATORA_VECTOR --add_entry sig_TIMERB1_VECTOR --add_entry sig_TIMERB0_VECTOR --add_entry sig_NMI_VECTOR --add_entry sig_UART0RX_VECTOR --add_entry sig_UART0TX_VECTOR";

sub usage () {
  print "\nusage: utah-inliner [options] filename.c\n";
  print "\n";
  print "Options:\n";
  print "\n";
  print "  --linux (default)  Use the linux executable\n";
  print "  --cygwin           Use the cygwin executable\n";
  print "\n";
  print "  --avr (default)    Target an avr machine\n";
  print "  --msp              Target an msp machine\n";
  print "  --8051             Target an 8051 machine\n";
  print "  --native           Target an x86 machine\n";
  print "\n";
  print "  --auto (default)   Inline functions marked for inlining\n";
  print "  --smart            Use smart inlining heuristics\n";
  print "  --clean            Cleans file up during inlining\n";
  print "                     Cleaner assumes it can see the whole program\n";
  print "  --shorten          Shorten temporary variable names\n";
  print "\n";
  print "  --nolowerconst     Do not lower constants (such as sizeof)\n";
  print "  --noprintline      Do not print original locations in output\n";
  print "  --help             Print this help menu\n";
  print "\n";
  print "Inline a single file. Result is output to filename.inlined.c\n";
  print "This is a wrapper script for simplistic and easy use.\n";
  print "\n";
  die;
}

my $vectors = $avr_vectors;
my $type = "avr";
my $machine = "linux";

my $inlining = "--inline-auto";
my $clean = "";
my $shorten = "";

my $input;
my $output = "";
my $lines = "";
my $fold = "";
my $flag = 0;

my $path = "";

my $cilly_args = "";

foreach my $arg (@ARGV) {

  # executing machine #########################################################

  if ($arg eq "--linux") {
    $machine = "linux";
    next;
  }

  if ($arg eq "--cygwin") {
    $machine = "cygwin";
    next;
  }

  # destination type ##########################################################

  if ($arg eq "--msp") {
    $vectors = $msp_vectors;
    $type = "msp";
    next;
  }

  if ($arg eq "--avr") {
    $vectors = $avr_vectors;
    $type = "avr";
    next;
  }

  if ($arg eq "--8051") {
    $vectors = $cc2430_vectors;
    $type = "8051";
    next;
  }

  if ($arg eq "--native") {
    $vectors = "";
    $type = "native";
    next;
  }

  #############################################################################

  if ($arg eq "--auto") {
    $inlining = "--inline-auto";
    next;
  }

  if ($arg eq "--smart") {
    $inlining = "--inline-smart";
    next;
  }

  if ($arg eq "--clean") {
    $clean = "--inline-cleanup";
    next;
  }

  if ($arg eq "--shorten") {
    $shorten = "--inline-shorten";
    next;
  }

  #############################################################################

  if ($arg eq "--nolowerconst") {
    $fold = "--noLowerConstants";
    next;
  }

  if ($arg eq "--noprintline") {
    $lines = "--noPrintLn";
    next;
  }

  if ($arg =~ m/^(([^-]+.*)(\.\S))$/) {
    $input = $1;
    if ($output eq "") { 
	$output = $2 . ".inlined.c";
    }
    next;
  }

  if ($arg =~ /--out=(.*)/) {
      $output = $1;
      next;
  }

  if ($arg =~ /--cilly-path=(.*)/) {
    $path = $1;
    next;
  }

  if ($arg eq "--help") {
    usage ();
  }

  $cilly_args = $cilly_args . " " . $arg
}

usage() if (!defined($input));

if (!($path =~ /.*\/$/)) {
    $path = $path . "/";
}
#--forceRLArgEval
my $command =
  $path . "cilly.utah.${machine}.${type}.valueset.may.exe" ." ".
  "${fold} ${lines} --out ${output} " . " " .
  "--doinliner ${inlining} ${clean} ${shorten}" . " " .
  "${vectors} $cilly_args ${input}";

print "\nActual command executed: ${command}\n\n";

system $command;
