T-Unit Properties Files
-------------------------------------------------------

DESCRIPTION
-------------------------------------------------------
T-Unit is run in many iterations through many different types of connected mote
configurations.  A single run may consist of running all tests that are 
compatible with running on a single tmote attached to the computer.  Other
tests may require multiple motes attached to the computer, possibly using
different types of motes (like a micaz talking to a tmote).

The tunit.xml file is in XML because the tests are hierarchical.
Each test defines several motes that are attached to the computer, how
to connect to them, and extra information on how to install to them.  XML only
needs to be written once to reflect the current status of motes connected to
the computer, and which test cases to run.  This is different than the 
suite.properties file, which have no hierarchy and may be written
multiple times - possibly once for each test.

On a given test run, each suite's properties are evaluated against the 
test's properties to determine if the suite is applicable to the test.
If it is, the suite is compiled, installed and the results are collected.



XML FORMAT AND KEYWORDS
-------------------------------------------------------
The format of a tunit.xml file is as follows:

<tunit>
  <testrun name="testrun_name_without_spaces">
    <mote target="tmote" motecom="serial@COM15:tmote" buildextras="" installextras="bsl,14">
    <mote target="tmote" motecom="serial@COM16:tmote" buildextras="" installextras="bsl,15">
  </testrun>
</tunit>

There can be multiple motes per test, and multiple testrun's per T-Unit.


IMPORTANT
The first mote defined in the test run is the default mote, which accepts
the run() command from TUnitRunner.  This mote is ALWAYS installed as address 0,
although it can be reconfigured in software.
