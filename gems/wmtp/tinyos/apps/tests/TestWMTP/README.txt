README for TestWmtp


Description:
This application offers 10 test cases that can be used to
test WMTP's functionality. The test cases are selected by 
defining TEST_CASE in TestWmtpC.nc to point to the desired
test case.

For testing and evaluating performance metrics using WMTP in
a 6 node scenario (test case 9) it's possible to enable a 
data reporter if you're planning on using TOSSIM or a data
logger in case you choose for a mote deployment.
For convenience there are two bash scripts available that 
will collect and save the output data to a .csv.