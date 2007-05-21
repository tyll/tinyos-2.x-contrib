/**
 * @author David Moss (dmm@rincon.com)
 * @author Kevin Klues (klues@tkn.tu-berlin.de)
 */

This library allows a system to add and remove elements from a structure at compile time, and
access those elements through a simple interface: store(..) and load(..)

The original motivation was to better modularize additions and layers into radio stacks.
For example, adding in low power listening or a reliable transport mechanism meant explicitly
adding bytes to the metadata of the particular radio.  If the developer didn't want low power
listening or a reliable transport layer built into the stack, the extra bytes of metadata 
dedicated to serving those functions went to waste everytime a message_t was used in the
system.  Explicitly adding these bytes into the radio stack made it difficult or impossible
to completely modularize added functionality.

The solution is to modify the metadata (or platform_message) one time to add a placeholder
to store extra bytes.  The size of the storage at this placeholder grows or shrinks depending 
on which modules are actually compiled into the system.  This solution also supports extending
multiple structures in a single application, allowing each module to connect into the correct
structure using a unique identifier defined for that structure.

To specify adding a byte or two bytes (word), simply connect the module that requires the
extra data into its corresponding configuration:  ExtendedByteC, or ExtendedWordC.  
By passing in the unique identifier for the structure of interest, the extended storage
library will keep track of A) how many bytes to add to the structure at compile time, 
and B) the location of each parameterized interface's byte or word.

When your external module needs to access bytes that are part of the extended data area of
a struct, it can just call its ParameterStorage interface's store(..) and load(..) commands,
passing in a pointer to the struct of interest.

More information can be found in the readme.txt in
apps/tests/TestParameterStorage
