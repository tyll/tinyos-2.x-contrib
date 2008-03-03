#!/usr/bin/perl -w

package NescProgramFiles;

use strict;

use FindBin;
use lib $FindBin::Bin;
use FindInclude;
use SlurpFile;

my %Opts = ( verbose => 0 );
my %deps = ();
my $depnum = 1;

sub getProgramFiles{

    my $fileName = $_[0];
    my $file = &FindInclude::find_file( $fileName );
    $deps{$file} = $depnum++ if defined($file);

    my $text = "";

    my %unparsed = %deps;
    while( (keys %unparsed) > 0 ) {
	my @files = sort {$unparsed{$a} <=> $unparsed{$b}} keys %unparsed;
	%unparsed = ();
	for my $file (@files) {
	    my @ff = parse_file( $file );
	    map { $unparsed{$_} = $depnum++ } @ff;
	    $text .= join("\n", $file, grep {$_ ne $file} @ff) . "\n\n" if $Opts{verbose};
	}
	for my $dep (keys %deps) {
	    delete $unparsed{$dep};
	}
	for my $unp (keys %unparsed) {
	    $deps{$unp} = $unparsed{$unp};
	}
    }

    return %deps;

    #$text = join("\n",sort {$deps{$a} <=> $deps{$b}} keys %deps) . "\n" unless $Opts{verbose};
    #print $text;
}

sub parse_file {
  my $file = shift;
  my $text = &SlurpFile::scrub_c_comments( &SlurpFile::slurp_file( $file ) );
  my @files = ();

  while( $text =~ m/
      (?: \b interface \s+ (\w+) )               # $1 interface
    | (?: \b components \s+ ([^;]+) )            # $2 components
    | (?: \b includes \s+ (\w+) )                # $3 includes
    | (?: \b \#include \s+ [<"] ([^>"]+) [>"] )  # $4 #include
                  /xg ) {
    if( defined $1 ) {
      push( @files, "$1.nc" );
    } elsif( defined $2 ) {
      my $tt = $2;
      push( @files, map { "$_.nc" } ($tt =~ /(\w+)/g) );
    } elsif( defined $3 ) {
      push( @files, "$3.h" );
    } elsif( defined $4 ) {
      push( @files, $4 );
    }
  }

  my %once = ();

  return
    grep { defined $_ }
    map { &FindInclude::find_file($_) }
    grep { my $o=$once{$_}; $once{$_}=1; !$o }
    @files;
}

