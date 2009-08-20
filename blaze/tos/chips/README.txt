ccxx00 was the original multi-radio CC1101/CC2500 radio stack.  It is now considered
deprecated.

___________________________________________

ccxx00_single is the latest stack.  Pull in the main sub-directories
from this stack into your .platform file.  Some directories have multiple implementations
for a given layer to choose from, such as acks, csma, lpl, etc.  
You should select one implementation by referencing its directory from your 
.platform file.

If you want software support for multiple radios, you should reference the
directories in ccxx00_multiple ahead of the ccxx00_single in your .platform file so
they take priority and override ccxx00_single files during compile time.

The ccxx00_addons directory contains functionality that interacts with parts
of the radio stack, but doesn't need to be compiled in for the stack to operate.

