Test Suite Properties Files
-------------------------------------------------------

DESCRIPTION
-------------------------------------------------------
Individual test suites can define how many motes the test should run on, what 
types of motes not to run the test on, authors, descriptions, test names, 
build extras, etc. 

Information is stored in each test directory in a file called suite.properties.
If a higher level directory defines a suite.properties file, the current
directory takes on those properties plus any extra suite.properties it may locally
define.

The layout of a suite.properties file is different than the tunit.xml
file because suite properties do not need hierarchy.  Laying them out with 
@keyword information is much faster and easier to type than writing out
valid XML.


KEYWORDS
-------------------------------------------------------
Each keyword must be located at the beginning of the line in the file.

@author <optional author(s)>
 - Any text after the @author keyword is considered an author
 - There may be more than one @author keyword

@testname <optional testname>
 - Only a single @testname may be defined
 
@description <optional description>
 - A description can span one or multiple lines.
 - If you start a @description keyword, all text after it up until the next
   keyword is considered part of the description
 - Multiple @description keywords are allowed
   
@extra <extras>
 - Any make extra's required to compile
 - Multiple @extra keywords are allowed.  They are separated with " "'s in the
   make line
 - Reference .extra files here.

@cflag OR @cflags <CFLAGS+=>[compile flags]
  Examples:
    @cflags -I../../Mydirectory
    @cflag -DPACKET_LINK
    @cflags -DPACKET_LINK
    @cflag CFLAGS+=-DPACKET_LINK
    @cflags CFLAGS+=-DPACKET_LINK
  
@assertions <#>
 - If you have a single test that will make more than 5 assertions in a row, 
   use this option to bump up the default number of message_t's used by
   the embedded TUnit library so it can buffer up all those assertions.
   Don't set it too high or you might run out of RAM on some platforms.
   
@ignore <target>
 - Do not run this test suite on a test run that includes the given target
 - Only list one target per @ignore
 - Multiple @ignore's may be used
 
@minnodes <#>
 - The minimum number of nodes required to run this suite
 
@maxnodes <#>
 - Do not run this suite on a test run that has more than the maximum number of
   nodes.
   
@exactnodes <#>
 - Only run this suite on a test run that has the given number of nodes.
 
@mintargets <#>
 - Run this suite on a test run that has at least the given number of unique 
   targets
   
@only <target>
 - Only run this test on the given target
 - One target per @only keyword
 - Multiple @only keywords can be given

@skip
 - Skip this entire suite
 
@compile <option>
 - always : Default usage. Always compiles the test at least once per test run.
 - once : If a build already exists, use it. Otherwise, compile one time.
 - never : Never let TUnit compile the test. This requires you to compile
       manually.

@cmd [start|run|finish] [commandline]
  - start : runs the given command line argument before the test begins. Blocks.
  - run : runs the given command line argument during the test. This gets 
        destroyed when the test completes if not before. Does not block.
  - stop : runs the given command line argument after the test ends. Blocks.
  You must run TUnit with the -enablecmd option to allow command line arguments
  to execute.
  

EXAMPLES
-------------------------------------------------------
1. Run a test on a single mote, we don't care what that mote is:
  @exactnodes 1
  
2. Run this suite on any mote that is not a mica2 or mica2dot, no matter how
   many motes there are attached.  Define a bunch more information that applies 
   to this test for the final test report:
  @ignore mica2
  @ignore mica2dot
  @description we're running this test on any standard mote
      that doesn't have a CC1000 radio.
  @testname CC2420 test
  @extra lpl
  @extra link my_cc2420_layer_extra
  @author David Moss
  
3. Run a test on at least two motes, we don't care what they are:
  @exactnodes 2
  
4. Run a test on at least two micaz's, but not a tmote or telosb target:
  @minnodes 2
  @ignore tmote
  @ignore telosb
  
5. Run a test on one micaz and one telosb, but not a mica2 or mica2dot
  @ignore mica2
  @ignore mica2dot
  @minnodes 2
  @mintargets 2
  
6. Run this test on test runs that support up to 5 different non-micaz, 
   non-telosb motes:
  @maxnodes 5
  @ignore micaz
  @ignore telosb
  @ignore tmote

7. Run this test on at least 2 mica2's and mica2dot's:
  @minnodes 2
  @only mica2
  @only mica2dot
 
8. Skip this test
  @skip
   
9. Make the properties parser get angry and explode
  @only tmote
  @ignore tmote

  