#!/usr/bin/perl

system("clear");

sub promptUser {
   local($promptString,$defaultValue) = @_;
   if ($defaultValue) {
      print $promptString, "[", $defaultValue, "]: ";
   } else {
      print $promptString, ": ";
   }
   $| = 1;               # force a flush after our print
   $_ = <STDIN>;         # get the input from STDIN (presumably the keyboard)
   chomp;
   if ("$defaultValue") {
      return $_ ? $_ : $defaultValue;    # return $_ if it has a value
   } else {
      return $_;
   }
}

require 'modules/createApplication.pl';

print "\n\n";
print "        ###################################################\n";
print "        #                                                 #\n";
print "        #                 Welcome to dexCell              #\n";
print "        #                                                 #\n";
print "        #      a rapid development TinyOS framework       #\n";
print "        #                                                 #\n";
print "        #                  by DEXMA SENSORS               #\n";
print "        #                                                 #\n";
print "        ###################################################\n\n\n";

#$cosarara = "hola hola";

#require 'base/extfile1.pl';
#&print_header();
#print $cosaxunga;


$projectname = &promptUser("Name of the project?", "SampleProject");
$projectfolder = &promptUser("Folder?", "/opt/dexma/provesdexcell");


print "\n$projectname will be created in $projectfolder\n";

$projectfolder .= "/".$projectname;

system("mkdir $projectfolder");

#creating msgtypes and constants
require 'modules/createHeaderFile.pl';

my $header = &createHeaderFile();
open(HEADERFILE, "> $projectfolder/$projectname.h") or die $!;
print HEADERFILE $header;
close HEADERFILE;


#creating applications
while(&promptUser("Create Applications (y/n)", "y") eq "y"){
 $name = &promptUser("Application name?");
 &createApplication($name);
}

#create master makefile

