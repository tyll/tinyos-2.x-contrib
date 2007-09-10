
To get these tests to run, you must have the tmoteblaze.target in your
tinyos-2.x/support/make directory. 

The suite.properties files in each test will pull out the platform directory 
from tinyos-2.x-contrib/blaze/tos/platforms/tmoteblaze, which is referenced
relative to the test being compiled (as you can see from the 9 or 10 ../'s in
those suite.properties files!)

This allows us to update the platform code (especially the hardware presentation
layer) in tinyos-2.x-contrib while keeping it separate from tinyos-2.x baseline.

This directory layout is a good example of how to unit test your code 
contributed to tinyos-2.x-contrib in an automated testing system.

