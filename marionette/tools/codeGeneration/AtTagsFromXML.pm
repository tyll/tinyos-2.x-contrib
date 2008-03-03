
package AtTagsFromXML;

##############################
# Parse the nesc.xml file and generate a %reflections hash of hashrefs,
# where each hashref represents some reflection.
# 
# This takes three arguments: 
# $file is the nesc.xml file to be parsed
# $tagName is the name of the @tag
# %tagFields is a hash of the fieldnames of the @$tagName struct
#
# The function returns an arrayref of hashrefs, where each hashref
# represents the data about a different instance of an interface with
# that @tag
#
# example usage: AtTags::getTaggedInterfaces("../nesc.xml","attr",("attrName","attrNum");
# will return all interfaces in nesc.xml with @attr("name", 10) tags, if
# @attr is defined as struct {char* attrName; uint16_t attrNum;}
##############################

use FindBin;
use lib $FindBin::Bin;
use FindInclude;

my $tagName;
my @tagFields;

sub getTaggedInterfaces {

    @_ = &FindInclude::parse_include_opts( @_ ); #get rid of includes
    my $file = shift @_;
    ($tagName, @tagFields) = @_;

    #convert the tagFields array to a hashTable
    my %tagFields;
    for $t (@tagFields){
	$tagFields{"$t"} = 1;
    }

#load the xml file into memory
    open (NESCXML, $file) || die "couldn't open $file!";
    undef $/;
    my $xmlText = <NESCXML>;
    close(NESCXML);

#create a new xml parser
    my $xs1 = XML::Simple->new();

#the hash table of attributes
    my @interfaces = ();

#parsing the entire xml file is broken and slow anyway...
# ...let's manually find and parse only necessary pieces
    while ( $xmlText =~ m|(<interface .*?</interface>)|sg ){ 
	my $interfaceXML = $1;

	# find all interfaces that are tagged as "registry" entries
	
	if ( ( $interfaceXML =~ /<attribute-value>/ ) &&
	     ( $interfaceXML =~ /<attribute-ref name="$tagName"/ ) ) {

	    # parse the XML entry into a hashref

	    my $interfaceHash = $xs1->XMLin($interfaceXML, ForceArray=>['attribute-value','structured-element']);

	    #print Dumper($interfaceHash);

	    my %interface;

	    $interface{'componentName'} = $interfaceHash->{'component-ref'}->{'qname'};

	    $interface{'interfaceName'} = $interfaceHash->{'name'};

	    # find the @$tagName tag and store the params (may be multiple other tags)
	    foreach my $atTag (@{$interfaceHash->{'attribute-value'}}) {

		if ( $atTag->{'attribute-ref'}->{'name'} eq "$tagName" ) {
		    
		    
		    foreach my $param (@{$atTag->{'value-structured'}->{'structured-element'}}){
			
			if ($tagFields{$param->{'field'}}){
			    $interface{"$param->{'field'}"} = $param->{'value'}->{'cst'};
			    $interface{"$param->{'field'}"} =~ s/^\w://;
			}	    
			else{
			    die "ERROR: $tagName tag with undefined field $param->{'field'} at $interface{'componentName'}.$interface{'interfaceName'}.\n";
			}
		    }
		}
	    }

	    for $fieldName (keys %fieldNames){
		if (!$interface{"$fieldName"}) {
		    die "ERROR: @$tagName tag with no field $fieldName at $interface{'componentName'}.$interface{'interfaceName'}.\n";
		}
	    }
		
	    $interface{'interfaceType'} = $interfaceHash->{'instance'}->{'interfacedef-ref'}->{'qname'};
	    $interface{'provided'} = $interfaceHash->{'provided'};

	    # get the interface parameter (assume a single param of type typedef)

	    if ($interfaceHash->{'instance'}->{'arguments'}->{'type-int'}) {
		$interface{'param'} = $interfaceHash->{'instance'}->{'arguments'}->{'type-int'}->{'cname'};
	    } elsif ($interfaceHash->{'instance'}->{'arguments'}->{'type-tag'}) {
		$interface{'param'} = $interfaceHash->{'instance'}->{'arguments'}->{'type-tag'}->{'struct-ref'}->{'name'};
	    }
	    
	    #now add the properties of this interface to the attribute list
	    $interfaces[scalar @interfaces] = \%interface;

	}
    }
    return \@interfaces;

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

    my $interfaces = AtTags::getTaggedInterfaces (@_);

    my %tags;

# if this tagValue already exists, check for consistency with
# previous definition
    for my $interface (@$interfaces){
	
	#make the key a concatenated string of the param vals
	my $key = "";
	for my $field (@tagFields){
	    $key = sprintf "%s$interface->{$field}", $key;
	} 

	#if this $key already exists, check for disparities
	if ($tags{"$key"}){
	    my %prevDef = $tags{"$key"};

	    #make sure the types are the same
	    if ($interface->{'param'} ne $prevDef{'param'}){
		die "ERROR: Two components use the same \@$tagName tag with different types: $prevDef{'componentName'}.$prevDef{'interfaceName'} and $prevDef{'componentName'}.$prevDef{'interfaceName'}";
	    }

	    #if this tagValue is provided by some module, continue to use that
	    if ($prevDef{'provided'} == 1){
		if($interface->{'provided'} == 1){
		    die "ERROR: Only on component can provide the tag \@$tagName in: $prevDef{'componentName'}.$prevDef{'interfaceName'} and $prevDef{'componentName'}.$prevDef{'interfaceName'}";
		}
		else{
		    $interface->{'provided'} = 1;
		    $interface->{'componentName'} = $prevDef{'componentName'};
		}
	    }

	}

	#now add the properties of this interface to the tagValue list
	$tags{"$key"} = $interface;
    }
    return \%tags;
}


1;
